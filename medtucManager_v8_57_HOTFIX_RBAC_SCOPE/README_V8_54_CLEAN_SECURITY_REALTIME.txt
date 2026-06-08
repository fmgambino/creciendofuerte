MEDTUC Manager v8.54 CLEAN SECURITY REALTIME

Contenido de la entrega:
- Proyecto web limpio, sin historiales de README/SQL antiguos ni exportaciones SATMANAGER de respaldo.
- SQL final unica: supabase/MEDTUC_V8_54_CLEAN_SECURITY_REALTIME.sql
- Edge Function opcional para IA segura: supabase/functions/ai-note-draft/index.ts
- Herramienta MDB conservada en tools/.

Instalacion:
1. Subir el proyecto completo.
2. Ejecutar en Supabase SQL Editor:
   supabase/MEDTUC_V8_54_CLEAN_SECURITY_REALTIME.sql
3. Para IA real con OpenAI, desplegar la Edge Function ai-note-draft y configurar el secreto OPENAI_API_KEY.
   Si no se despliega, el boton de IA funciona con redaccion asistida local basada en la orden.
4. Limpiar cache del navegador si se venia usando una version anterior.

Correcciones v8.54:
- SQL sin tabla temporal _medtuc_roles_map, por lo que no falla con relation does not exist.
- Limpieza y unificacion de roles Tecnico/Tecnicos y Referente/Referentes.
- Deduplicacion previa de role_module_permissions antes de crear/aplicar el indice unico.
- Realtime agregado para tablas principales de operacion.
- Indices para ordenes, tickets, perfiles y notificaciones.
- Helpers pgcrypto AES-256 para cifrado/descifrado controlado desde SQL.
- Inicio de sesion robusto ante Invalid Refresh Token: limpia sesion local y vuelve al login.
- Popup de nota con icono IA para redactar o mejorar texto con informacion cargada en la Orden de Servicio.
- No se expone ninguna clave de IA en el frontend.
