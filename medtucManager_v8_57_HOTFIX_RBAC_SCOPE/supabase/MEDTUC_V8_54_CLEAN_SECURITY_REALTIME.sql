-- MEDTUC Manager v8.54
-- Limpieza RBAC, roles canonicos, permisos idempotentes, Realtime e helpers de cifrado.
-- Ejecutar completo desde Supabase SQL Editor.

begin;

create extension if not exists pgcrypto;

create or replace function public.medtuc_canonical_role(input_role text)
returns text
language sql
immutable
as $$
  select case
    when lower(regexp_replace(coalesce(input_role,''), '[^a-zA-Z0-9]+', '', 'g')) in ('superadmin','superadministrator','superadministrador') then 'SuperAdmin'
    when lower(regexp_replace(coalesce(input_role,''), '[^a-zA-Z0-9]+', '', 'g')) in ('admin','administrador') then 'Admin'
    when lower(regexp_replace(coalesce(input_role,''), '[^a-zA-Z0-9]+', '', 'g')) in ('tecnico','tecnicos','tecnica','tecnicas','profesionaltecnico') then 'Tecnico'
    when lower(regexp_replace(coalesce(input_role,''), '[^a-zA-Z0-9]+', '', 'g')) in ('referente','referentes') then 'Referente'
    else 'Usuarios'
  end
$$;

insert into public.roles (name, description, is_system)
values
  ('SuperAdmin','Acceso total al sistema institucional', true),
  ('Admin','Administracion operativa sin privilegios de superusuario', true),
  ('Tecnico','Profesional tecnico con alcance solo sobre registros asignados', true),
  ('Referente','Referente institucional con seguimiento de sus solicitudes', true),
  ('Usuarios','Usuario institucional de consulta', true)
on conflict (name) do update
set description = excluded.description,
    is_system = true,
    updated_at = now();

update public.profiles
set role_name = public.medtuc_canonical_role(role_name),
    updated_at = now()
where role_name is distinct from public.medtuc_canonical_role(role_name);

with mapped as (
  select r.id as legacy_id, c.id as canonical_id
  from public.roles r
  join public.roles c on c.name = public.medtuc_canonical_role(r.name)
)
insert into public.role_permissions (role_id, permission_id)
select distinct m.canonical_id, rp.permission_id
from public.role_permissions rp
join mapped m on m.legacy_id = rp.role_id
where m.legacy_id <> m.canonical_id
on conflict do nothing;

with mapped as (
  select r.id as legacy_id, c.id as canonical_id
  from public.roles r
  join public.roles c on c.name = public.medtuc_canonical_role(r.name)
)
delete from public.role_permissions rp
using mapped m
where rp.role_id = m.legacy_id
  and m.legacy_id <> m.canonical_id;

delete from public.roles r
where public.medtuc_canonical_role(r.name) <> r.name;

insert into public.permissions (code, module, action, description)
select module_key || '.' || action_name, module_key, action_name, 'Permiso ' || action_name || ' sobre ' || module_key
from (values
  ('dashboard'), ('users'), ('roles'), ('orders'), ('inventory'), ('loans'),
  ('tickets'), ('notifications'), ('offices'), ('exceptions'), ('logs'),
  ('profile'), ('settings')
) m(module_key)
cross join (values ('view'), ('create'), ('edit'), ('delete'), ('import'), ('export')) a(action_name)
on conflict (code) do update
set module = excluded.module,
    action = excluded.action,
    description = excluded.description;

delete from public.role_permissions rp
using public.roles r
where rp.role_id = r.id
  and r.name in ('SuperAdmin','Admin','Tecnico','Referente','Usuarios');

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles r
join public.permissions p on true
where r.name = 'SuperAdmin'
on conflict do nothing;

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles r
join public.permissions p on p.module in ('dashboard','users','roles','orders','inventory','loans','tickets','notifications','offices','exceptions','logs','profile','settings')
where r.name = 'Admin'
on conflict do nothing;

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles r
join public.permissions p on
  (p.module in ('dashboard','orders','tickets','notifications','profile') and p.action in ('view','export'))
where r.name = 'Tecnico'
on conflict do nothing;

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles r
join public.permissions p on
  (p.module in ('dashboard','tickets','notifications','profile') and p.action in ('view','create','export'))
where r.name = 'Referente'
on conflict do nothing;

insert into public.role_permissions (role_id, permission_id)
select r.id, p.id
from public.roles r
join public.permissions p on
  (p.module in ('dashboard','notifications','profile') and p.action = 'view')
where r.name = 'Usuarios'
on conflict do nothing;

delete from public.role_module_permissions
where public.medtuc_canonical_role(role_name) in ('SuperAdmin','Admin','Tecnico','Referente','Usuarios');

with ranked as (
  select ctid, row_number() over (
    partition by role_name, module_key
    order by updated_at desc nulls last, created_at desc nulls last
  ) as rn
  from public.role_module_permissions
)
delete from public.role_module_permissions r
using ranked d
where r.ctid = d.ctid and d.rn > 1;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'role_module_permissions_role_name_module_key_key'
  ) then
    alter table public.role_module_permissions
      add constraint role_module_permissions_role_name_module_key_key unique (role_name, module_key);
  end if;
end $$;

insert into public.role_module_permissions
  (role_name,module_key,can_view,can_create,can_edit,can_delete,can_import,can_export,updated_at)
select 'SuperAdmin', module_key, true, true, true, true, true, true, now()
from (values
  ('dashboard'),('users'),('roles'),('orders'),('inventory'),('loans'),('tickets'),
  ('notifications'),('offices'),('exceptions'),('logs'),('profile'),('settings')
) m(module_key)
on conflict (role_name,module_key) do update
set can_view=true, can_create=true, can_edit=true, can_delete=true,
    can_import=true, can_export=true, updated_at=now();

insert into public.role_module_permissions
  (role_name,module_key,can_view,can_create,can_edit,can_delete,can_import,can_export,updated_at)
select 'Admin', module_key, true, true, true, true, true, true, now()
from (values
  ('dashboard'),('users'),('roles'),('orders'),('inventory'),('loans'),('tickets'),
  ('notifications'),('offices'),('exceptions'),('logs'),('profile'),('settings')
) m(module_key)
on conflict (role_name,module_key) do update
set can_view=excluded.can_view, can_create=excluded.can_create, can_edit=excluded.can_edit,
    can_delete=excluded.can_delete, can_import=excluded.can_import, can_export=excluded.can_export,
    updated_at=now();

insert into public.role_module_permissions
  (role_name,module_key,can_view,can_create,can_edit,can_delete,can_import,can_export,updated_at)
values
  ('Tecnico','dashboard',true,false,false,false,false,false,now()),
  ('Tecnico','orders',true,false,false,false,false,true,now()),
  ('Tecnico','tickets',true,false,false,false,false,true,now()),
  ('Tecnico','notifications',true,false,false,false,false,false,now()),
  ('Tecnico','profile',true,false,true,false,false,false,now()),
  ('Referente','dashboard',true,false,false,false,false,false,now()),
  ('Referente','tickets',true,true,false,false,false,true,now()),
  ('Referente','notifications',true,false,false,false,false,false,now()),
  ('Referente','profile',true,false,true,false,false,false,now()),
  ('Usuarios','dashboard',true,false,false,false,false,false,now()),
  ('Usuarios','notifications',true,false,false,false,false,false,now()),
  ('Usuarios','profile',true,false,true,false,false,false,now())
on conflict (role_name,module_key) do update
set can_view=excluded.can_view, can_create=excluded.can_create, can_edit=excluded.can_edit,
    can_delete=excluded.can_delete, can_import=excluded.can_import, can_export=excluded.can_export,
    updated_at=now();

create index if not exists idx_service_orders_assigned_to on public.service_orders(assigned_to);
create index if not exists idx_service_orders_technician_user_id on public.service_orders(technician_user_id);
create index if not exists idx_service_orders_collaborator_assigned_to on public.service_orders(collaborator_assigned_to);
create index if not exists idx_service_orders_received_at on public.service_orders(received_at desc);
create index if not exists idx_support_tickets_assigned_to on public.support_tickets(assigned_to);
create index if not exists idx_support_tickets_technician_user_id on public.support_tickets(technician_user_id);
create index if not exists idx_notifications_target_user_read on public.notifications(target_user,is_read,created_at desc);
create index if not exists idx_notifications_target_role_read on public.notifications(target_role,is_read,created_at desc);
create index if not exists idx_profiles_role_name on public.profiles(role_name);

create or replace function public.medtuc_encrypt_text(plain_text text, secret_key text)
returns text
language sql
stable
as $$
  select case
    when plain_text is null or secret_key is null or secret_key = '' then null
    else encode(pgp_sym_encrypt(plain_text, secret_key, 'cipher-algo=aes256,compress-algo=1'), 'base64')
  end
$$;

create or replace function public.medtuc_decrypt_text(cipher_text text, secret_key text)
returns text
language sql
stable
as $$
  select case
    when cipher_text is null or secret_key is null or secret_key = '' then null
    else pgp_sym_decrypt(decode(cipher_text, 'base64'), secret_key)
  end
$$;

do $$
declare
  t text;
  realtime_tables text[] := array[
    'profiles','roles','role_module_permissions','permissions','inventory_items','loans',
    'support_tickets','service_orders','service_order_statuses','service_order_history',
    'service_order_notes','notifications','offices','app_settings'
  ];
begin
  foreach t in array realtime_tables loop
    begin
      execute format('alter publication supabase_realtime add table public.%I', t);
    exception
      when duplicate_object then null;
      when undefined_object then null;
      when undefined_table then null;
    end;
  end loop;
end $$;

commit;
