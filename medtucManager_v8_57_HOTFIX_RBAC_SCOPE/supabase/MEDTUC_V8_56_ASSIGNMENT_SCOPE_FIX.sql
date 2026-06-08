-- MEDTUC v8.56 - Assignment scope, role normalization and missing notifications
-- Run this after MEDTUC_V8_54_CLEAN_SECURITY_REALTIME.sql.
-- Safe to run more than once.

begin;

create or replace function public.medtuc_norm_text(v text)
returns text
language sql
immutable
as $$
  select trim(regexp_replace(
    regexp_replace(
      translate(
        lower(coalesce(v,'')),
        chr(225)||chr(224)||chr(228)||chr(226)||
        chr(233)||chr(232)||chr(235)||chr(234)||
        chr(237)||chr(236)||chr(239)||chr(238)||
        chr(243)||chr(242)||chr(246)||chr(244)||
        chr(250)||chr(249)||chr(252)||chr(251)||
        chr(241)||chr(231),
        'aaaaeeeeiiiioooouuuunc'
      ),
      '\m(ing|lic|dr|dra|cp|prof|profesional|tecnico|tecnica)\M',
      ' ',
      'g'
    ),
    '[^a-z0-9]+',
    ' ',
    'g'
  ));
$$;

update public.profiles
set role_name = 'Tecnico',
    updated_at = now()
where public.medtuc_norm_text(role_name) in ('tecnico','tecnicos','tecnica','tecnicas','profesional tecnico');

update public.profiles
set role_name = 'Referente',
    updated_at = now()
where public.medtuc_norm_text(role_name) in ('referente','referentes');

update public.profiles
set role_name = 'SuperAdmin',
    updated_at = now()
where public.medtuc_norm_text(role_name) in ('superadmin','super admin','superuser','super user');

-- Link support tickets and service orders both ways when either side has the relation.
update public.support_tickets st
set service_order_id = so.id,
    updated_at = coalesce(st.updated_at, now())
from public.service_orders so
where st.service_order_id is null
  and so.origin_ticket_id = st.id;

update public.service_orders so
set origin_ticket_id = st.id,
    updated_at = coalesce(so.updated_at, now())
from public.support_tickets st
where so.origin_ticket_id is null
  and st.service_order_id = so.id;

-- Backfill technician UUIDs in service orders from historical technician names.
with techs as (
  select id, full_name, email, public.medtuc_norm_text(full_name) as n
  from public.profiles
  where is_active is distinct from false
    and public.medtuc_norm_text(role_name) = 'tecnico'
),
matches as (
  select distinct on (so.id)
    so.id as order_id,
    t.id as tech_id,
    t.full_name as tech_name
  from public.service_orders so
  join techs t on (
    public.medtuc_norm_text(coalesce(so.professional_technician, so.technician_name, '')) = t.n
    or public.medtuc_norm_text(coalesce(so.professional_technician, so.technician_name, '')) like '%' || t.n || '%'
    or t.n like '%' || public.medtuc_norm_text(coalesce(so.professional_technician, so.technician_name, '')) || '%'
  )
  where public.medtuc_norm_text(coalesce(so.professional_technician, so.technician_name, '')) <> ''
  order by so.id, length(t.n) desc
)
update public.service_orders so
set technician_user_id = coalesce(so.technician_user_id, m.tech_id),
    assigned_to = coalesce(so.assigned_to, m.tech_id),
    professional_technician = coalesce(nullif(so.professional_technician,''), m.tech_name),
    technician_name = coalesce(nullif(so.technician_name,''), m.tech_name),
    updated_at = coalesce(so.updated_at, now())
from matches m
where so.id = m.order_id
  and (so.technician_user_id is null or so.assigned_to is null or so.professional_technician is null or so.technician_name is null);

-- Backfill tickets from their linked service order.
update public.support_tickets st
set assigned_to = coalesce(st.assigned_to, so.assigned_to, so.technician_user_id),
    technician_user_id = coalesce(st.technician_user_id, so.technician_user_id, so.assigned_to),
    collaborator_assigned_to = coalesce(st.collaborator_assigned_to, so.collaborator_assigned_to),
    updated_at = coalesce(st.updated_at, now())
from public.service_orders so
where (st.service_order_id = so.id or so.origin_ticket_id = st.id)
  and (st.assigned_to is null or st.technician_user_id is null or st.collaborator_assigned_to is null);

create index if not exists idx_service_orders_technician_user_id on public.service_orders(technician_user_id);
create index if not exists idx_service_orders_assigned_to on public.service_orders(assigned_to);
create index if not exists idx_service_orders_origin_ticket_id on public.service_orders(origin_ticket_id);
create index if not exists idx_support_tickets_technician_user_id on public.support_tickets(technician_user_id);
create index if not exists idx_support_tickets_assigned_to on public.support_tickets(assigned_to);
create index if not exists idx_support_tickets_service_order_id on public.support_tickets(service_order_id);
create index if not exists idx_notifications_target_user on public.notifications(target_user);
create index if not exists idx_notifications_module_entity on public.notifications(module, entity_id);

-- Create missing assignment notifications for technicians.
insert into public.notifications(title, body, module, entity_id, target_user, target_role, created_by, is_read, created_at)
select
  'Orden de Servicio asignada',
  'Orden Nro. ' || coalesce(so.order_number::text, so.satmanager_order::text, so.id::text) ||
  ' asignada a ' || coalesce(so.professional_technician, p.full_name, 'tecnico') ||
  coalesce(' - Oficina: ' || nullif(so.office,''), ''),
  'orders',
  so.id,
  coalesce(so.technician_user_id, so.assigned_to),
  'Tecnico',
  so.created_by,
  false,
  coalesce(so.created_at, now())
from public.service_orders so
left join public.profiles p on p.id = coalesce(so.technician_user_id, so.assigned_to)
where coalesce(so.technician_user_id, so.assigned_to) is not null
  and not exists (
    select 1
    from public.notifications n
    where n.module = 'orders'
      and n.entity_id = so.id
      and n.target_user = coalesce(so.technician_user_id, so.assigned_to)
  );

-- Ensure generated tickets have a notification for their creator/requester when possible.
insert into public.notifications(title, body, module, entity_id, target_user, target_role, created_by, is_read, created_at)
select
  'Ticket registrado',
  'Ticket ' || coalesce(st.ticket_number::text, st.id::text) || coalesce(' - ' || nullif(st.subject,''), ''),
  'tickets',
  st.id,
  st.created_by,
  'Referente',
  st.created_by,
  false,
  coalesce(st.created_at, now())
from public.support_tickets st
where st.created_by is not null
  and not exists (
    select 1
    from public.notifications n
    where n.module = 'tickets'
      and n.entity_id = st.id
      and n.target_user = st.created_by
  );

commit;
