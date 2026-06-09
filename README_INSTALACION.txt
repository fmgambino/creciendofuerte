EL MASTER PROFE CRM - Versión final Hostinger + XAMPP

REQUISITOS
- PHP 8.1+
- MySQL/MariaDB
- Apache con mod_rewrite activo
- En XAMPP: colocar la carpeta dentro de htdocs/creciendofuerte o htdocs/masterprofe.
- En Hostinger: subir el contenido de esta carpeta a public_html.

BASE DE DATOS
Local XAMPP:
1) Crear/importar la base revenue_crm.
2) Importar sql/FULL_REINSTALL_LOCAL_XAMPP.sql.
3) Usuario: root, password vacío.

Hostinger:
1) Base esperada: u570224512_master10k.
2) Usuario esperado: u570224512_fmgambino.
3) Editar config/database.php y colocar DB_PASS real de Hostinger.
4) Si es instalación nueva, importar sql/FULL_REINSTALL_HOSTINGER.sql.
5) Si ya hay datos, importar sql/PATCH_HOSTINGER_FINAL_SEGURO.sql.

ACCESO DEMO
Email: fernando.m.gambino@gmail.com
Contraseña: Demo1234

CORRECCIONES INCLUIDAS
- Redirección segura post-login al Dashboard.
- Logout compatible con XAMPP y Hostinger.
- URLs limpias en producción: /login, /dashboard, /roles, etc.
- En local usa index.php?view=dashboard para evitar errores de rutas en subcarpetas.
- Distribución equitativa del 40% entre socios activos al cargar Ganancias Broker.
- Socios visualizan acumulación de ganancias.
- Mi Perfil editable con foto.
- Menú lateral por rol y permisos.
- Roles y permisos con ABM por módulo.
- Tablas con búsqueda, selección múltiple, paginación 5/10/25/50/100/500/1000 y botones atrás/siguiente.
- Exportación CSV/PDF con membrete.
- Dashboard con filtros desde/hasta, socio, referente y gráfico línea/barra/torta.
- Módulo Niveles de capital: $2000, $5000, $10000 y niveles personalizados.
