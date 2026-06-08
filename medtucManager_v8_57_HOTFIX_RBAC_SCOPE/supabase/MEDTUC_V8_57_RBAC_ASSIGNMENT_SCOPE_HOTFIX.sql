-- MEDTUC v8.57 - HOTFIX RBAC + alcance estricto de órdenes por técnico
-- Ejecutar DESPUÉS de MEDTUC_V8_54_CLEAN_SECURITY_REALTIME.sql y de cualquier script v8.56.
-- Idempotente: se puede correr más de una vez.

begin;

create or replace function public.medtuc_norm_text(v text)
returns text
language sql
immutable
as $$
  select trim(regexp_replace(
    regexp_replace(
      translate(lower(coalesce(v,'')),
        chr(225)||chr(224)||chr(228)||chr(226)||chr(227)||
        chr(233)||chr(232)||chr(235)||chr(234)||
        chr(237)||chr(236)||chr(239)||chr(238)||
        chr(243)||chr(242)||chr(246)||chr(244)||chr(245)||
        chr(250)||chr(249)||chr(252)||chr(251)||
        chr(241)||chr(231),
        'aaaaaeeeeiiiiooooouuuunc'
      ),
      '\m(ing|lic|dr|dra|cp|prof|profesional|tecnico|tecnica)\M',' ','g'
    ),
    '[^a-z0-9]+',' ','g'
  ));
$$;

create or replace function public.medtuc_current_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select p.role_name from public.profiles p where p.id = auth.uid()), 'Usuarios');
$$;

create or replace function public.medtuc_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.medtuc_norm_text(public.medtuc_current_role()) in ('superadmin','super admin','admin','administrador');
$$;

create or replace function public.medtuc_is_tech()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.medtuc_norm_text(public.medtuc_current_role()) in ('tecnico','tecnicos','tecnica','tecnicas','profesional tecnico');
$$;

create or replace function public.medtuc_is_referente()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.medtuc_norm_text(public.medtuc_current_role()) in ('referente','referentes','usuario','usuarios');
$$;

-- Normalización de roles que causaban ocultamiento del menú.
update public.profiles
set role_name = 'Tecnico', updated_at = now()
where public.medtuc_norm_text(role_name) in ('tecnico','tecnicos','tecnica','tecnicas','profesional tecnico');

update public.profiles
set role_name = 'SuperAdmin', updated_at = now()
where public.medtuc_norm_text(role_name) in ('superadmin','super admin','superuser','super user');

update public.profiles
set role_name = 'Admin', updated_at = now()
where public.medtuc_norm_text(role_name) in ('admin','administrador');

update public.profiles
set role_name = 'Referente', updated_at = now()
where public.medtuc_norm_text(role_name) in ('referente','referentes');

insert into public.roles(name, description, is_system)
values
 ('SuperAdmin','Acceso total al sistema',true),
 ('Admin','Administración operativa',true),
 ('Tecnico','Profesional técnico: ve solo órdenes/tickets asignados a su usuario',true),
 ('Referente','Usuario referente: carga y consulta tickets propios',true),
 ('Usuarios','Usuario base',true)
on conflict (name) do update set description = excluded.description, is_system = excluded.is_system, updated_at = now();

-- Matriz de módulos para que Órdenes aparezca en el menú del Profesional Técnico.
insert into public.role_module_permissions(role_name,module_key,can_view,can_create,can_edit,can_delete,can_import,can_export)
values
 ('Tecnico','dashboard',true,false,false,false,false,false),
 ('Tecnico','orders',true,false,false,false,false,true),
 ('Tecnico','tickets',true,false,false,false,false,true),
 ('Tecnico','notifications',true,false,false,false,false,false),
 ('Tecnico','profile',true,false,true,false,false,false),
 ('Referente','dashboard',true,false,false,false,false,false),
 ('Referente','orders',true,false,false,false,false,true),
 ('Referente','tickets',true,true,false,false,false,true),
 ('Referente','notifications',true,false,false,false,false,false),
 ('Referente','profile',true,false,true,false,false,false),
 ('Admin','dashboard',true,true,true,true,true,true),
 ('Admin','orders',true,true,true,true,true,true),
 ('Admin','tickets',true,true,true,true,true,true),
 ('Admin','inventory',true,true,true,true,true,true),
 ('Admin','notifications',true,true,true,true,true,true),
 ('SuperAdmin','dashboard',true,true,true,true,true,true),
 ('SuperAdmin','orders',true,true,true,true,true,true),
 ('SuperAdmin','tickets',true,true,true,true,true,true),
 ('SuperAdmin','inventory',true,true,true,true,true,true),
 ('SuperAdmin','users',true,true,true,true,true,true),
 ('SuperAdmin','roles',true,true,true,true,true,true),
 ('SuperAdmin','offices',true,true,true,true,true,true),
 ('SuperAdmin','loans',true,true,true,true,true,true),
 ('SuperAdmin','notifications',true,true,true,true,true,true),
 ('SuperAdmin','settings',true,true,true,true,true,true)
on conflict do nothing;

-- Sincroniza tickets y órdenes relacionadas.
update public.support_tickets st
set service_order_id = so.id,
    updated_at = now()
from public.service_orders so
where st.service_order_id is null
  and so.origin_ticket_id = st.id;

update public.service_orders so
set origin_ticket_id = st.id,
    updated_at = now()
from public.support_tickets st
where so.origin_ticket_id is null
  and st.service_order_id = so.id;

-- Backfill de técnico por nombre histórico. NO usa attended_by_name porque esa columna no existe en su esquema.
with techs as (
  select id, full_name, email, public.medtuc_norm_text(full_name) n
  from public.profiles
  where is_active is distinct from false
    and public.medtuc_norm_text(role_name) = 'tecnico'
), order_names as (
  select so.id,
         public.medtuc_norm_text(coalesce(so.professional_technician, so.technician_name, '')) n
  from public.service_orders so
), matches as (
  select distinct on (o.id) o.id order_id, t.id tech_id, t.full_name tech_name
  from order_names o
  join techs t on o.n <> '' and (o.n = t.n or o.n like '%' || t.n || '%' or t.n like '%' || o.n || '%')
  order by o.id, length(t.n) desc
)
update public.service_orders so
set technician_user_id = coalesce(so.technician_user_id, m.tech_id),
    assigned_to = coalesce(so.assigned_to, m.tech_id),
    professional_technician = coalesce(nullif(so.professional_technician,''), m.tech_name),
    technician_name = coalesce(nullif(so.technician_name,''), m.tech_name),
    updated_at = now()
from matches m
where so.id = m.order_id;

update public.support_tickets st
set assigned_to = coalesce(st.assigned_to, so.assigned_to, so.technician_user_id),
    technician_user_id = coalesce(st.technician_user_id, so.technician_user_id, so.assigned_to),
    collaborator_assigned_to = coalesce(st.collaborator_assigned_to, so.collaborator_assigned_to),
    updated_at = now()
from public.service_orders so
where (st.service_order_id = so.id or so.origin_ticket_id = st.id);

create index if not exists idx_service_orders_scope_assigned_to on public.service_orders(assigned_to);
create index if not exists idx_service_orders_scope_technician_user_id on public.service_orders(technician_user_id);
create index if not exists idx_service_orders_scope_collaborator on public.service_orders(collaborator_assigned_to);
create index if not exists idx_service_orders_scope_attended_by on public.service_orders(attended_by);
create index if not exists idx_support_tickets_scope_assigned_to on public.support_tickets(assigned_to);
create index if not exists idx_support_tickets_scope_technician_user_id on public.support_tickets(technician_user_id);
create index if not exists idx_support_tickets_scope_collaborator on public.support_tickets(collaborator_assigned_to);
create index if not exists idx_support_tickets_scope_service_order on public.support_tickets(service_order_id);

-- RLS defensivo: el backend también limita lo que puede leer un técnico.
alter table public.service_orders enable row level security;
alter table public.support_tickets enable row level security;
alter table public.notifications enable row level security;

drop policy if exists service_orders_v857_select_scope on public.service_orders;
create policy service_orders_v857_select_scope
on public.service_orders
for select
to authenticated
using (
  public.medtuc_is_admin()
  or assigned_to = auth.uid()
  or technician_user_id = auth.uid()
  or collaborator_assigned_to = auth.uid()
  or attended_by = auth.uid()
  or created_by = auth.uid()
  or requester_email = (select email from auth.users where id = auth.uid())
);

drop policy if exists service_orders_v857_write_admin on public.service_orders;
create policy service_orders_v857_write_admin
on public.service_orders
for all
to authenticated
using (public.medtuc_is_admin())
with check (public.medtuc_is_admin());

drop policy if exists support_tickets_v857_select_scope on public.support_tickets;
create policy support_tickets_v857_select_scope
on public.support_tickets
for select
to authenticated
using (
  public.medtuc_is_admin()
  or assigned_to = auth.uid()
  or technician_user_id = auth.uid()
  or collaborator_assigned_to = auth.uid()
  or attended_by = auth.uid()
  or created_by = auth.uid()
  or requester_email = (select email from auth.users where id = auth.uid())
  or service_order_id in (
    select so.id from public.service_orders so
    where so.assigned_to = auth.uid()
       or so.technician_user_id = auth.uid()
       or so.collaborator_assigned_to = auth.uid()
       or so.attended_by = auth.uid()
  )
);

drop policy if exists support_tickets_v857_insert_authenticated on public.support_tickets;
create policy support_tickets_v857_insert_authenticated
on public.support_tickets
for insert
to authenticated
with check (true);

drop policy if exists support_tickets_v857_update_admin on public.support_tickets;
create policy support_tickets_v857_update_admin
on public.support_tickets
for update
to authenticated
using (public.medtuc_is_admin())
with check (public.medtuc_is_admin());

drop policy if exists notifications_v857_select_scope on public.notifications;
create policy notifications_v857_select_scope
on public.notifications
for select
to authenticated
using (
  public.medtuc_is_admin()
  or target_user = auth.uid()
  or created_by = auth.uid()
  or target_role = public.medtuc_current_role()
);

-- Notificaciones faltantes de asignación.
insert into public.notifications(title, body, module, entity_id, target_user, target_role, created_by, is_read, created_at)
select 'Orden de Servicio asignada',
       'Orden N° ' || coalesce(so.order_number::text, so.satmanager_order::text, so.id::text) || coalesce(' - Oficina: ' || nullif(so.office,''), ''),
       'orders', so.id, coalesce(so.technician_user_id, so.assigned_to), 'Tecnico', so.created_by, false, coalesce(so.created_at, now())
from public.service_orders so
where coalesce(so.technician_user_id, so.assigned_to) is not null
  and not exists (
    select 1 from public.notifications n
    where n.module='orders' and n.entity_id=so.id and n.target_user=coalesce(so.technician_user_id, so.assigned_to)
  );

commit;
