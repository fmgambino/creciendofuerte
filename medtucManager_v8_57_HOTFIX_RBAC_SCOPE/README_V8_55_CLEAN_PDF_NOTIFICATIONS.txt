MEDTUC Manager v8.55 CLEAN PDF NOTIFICATIONS

Base:
- Mantiene la SQL v8.54: supabase/MEDTUC_V8_54_CLEAN_SECURITY_REALTIME.sql
- Mantiene Edge Function IA: supabase/functions/ai-note-draft/index.ts

Correcciones v8.55:
- Modal de Nota institucional con botones IA acomodados en panel profesional.
- Eliminada leyenda de fallback IA dentro del popup.
- Exportacion PDF refactorizada para Usuarios, Ordenes, Prestamos, Tickets y Notificaciones.
- PDF usa columnas humanas, anchos definidos, saltos de linea y logo de modo claro cuando esta disponible.
- Evita exportar columnas tecnicas crudas como id, avatar_url, created_at/update_at innecesarias.
- Modulo Notificaciones vuelve a formato de historial operativo tipo v8.34, con seleccion, lectura, paginacion y acciones.
- Cache busting actualizado a v8.55.

Nota:
Si ya ejecutaste la SQL v8.54 no hace falta volver a ejecutarla para estas correcciones de frontend.
