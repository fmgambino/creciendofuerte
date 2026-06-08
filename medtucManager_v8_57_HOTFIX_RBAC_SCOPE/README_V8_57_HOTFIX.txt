MEDTUC Ticket Manager v8.57 HOTFIX

Correcciones incluidas:
1) Se eliminó el parpadeo del dashboard por re-renderizados heredados.
2) El menú del Profesional Técnico vuelve a mostrar Órdenes de Servicio.
3) El dashboard y calendario del técnico filtran estrictamente por UUID asignado: assigned_to, technician_user_id, collaborator_assigned_to o attended_by.
4) Se agregó SQL Supabase v8.57 sin la columna inexistente so.attended_by_name.
5) Se normalizan roles y permisos RBAC para Técnico, Referente, Admin y SuperAdmin.
6) Se agregan políticas RLS defensivas para service_orders, support_tickets y notifications.

Pasos:
1) Subir/reemplazar todos los archivos del proyecto.
2) En Supabase SQL Editor ejecutar: supabase/MEDTUC_V8_57_RBAC_ASSIGNMENT_SCOPE_HOTFIX.sql
3) Cerrar sesión, borrar caché del navegador y volver a iniciar sesión.
