MEDTUC Manager v8.56 - Assignment Scope Final

Correcciones principales:
- El panel Tecnico ya no depende solo del UUID: tambien reconoce asignaciones historicas por nombre del profesional tecnico.
- Referente ve solo tickets cargados por su usuario y las ordenes generadas desde esos tickets.
- SuperAdmin/Admin ven toda la operatoria.
- Crear un Soporte Ticket genera una Orden de Servicio, asigna tecnico activo al azar y respeta excepciones vigentes.
- Se crean notificaciones para el tecnico asignado y para el usuario que cargo el ticket.
- Se agrego migracion SQL idempotente para normalizar roles, rellenar assigned_to/technician_user_id y crear notificaciones faltantes.

Pasos recomendados:
1. Subir/usar esta version completa de la PWA.
2. En Supabase SQL Editor ejecutar:
   supabase/MEDTUC_V8_56_ASSIGNMENT_SCOPE_FIX.sql
3. Limpiar cache del navegador o recargar con Ctrl+F5. Si hay service worker viejo, cerrar sesion y volver a entrar.
4. Probar con SuperAdmin, Referente y Tecnico.

Orden esperado:
- Referente crea un ticket.
- El sistema elige un Tecnico activo sin excepcion vigente.
- Se inserta el ticket.
- Se inserta la Orden de Servicio vinculada.
- El Tecnico ve esa orden/ticket en Dashboard, Ordenes de Servicio, Soporte Ticket y Notificaciones.
