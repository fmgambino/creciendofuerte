EL MASTER PROFE CRM · Versión refactorizada 2026-06-11
=======================================================

Cambios incluidos
-----------------
1) Dashboard socio corregido:
   - "Ganancia global por socio" mantiene el total global asignado por socio.
   - "Mis ganancias acumuladas" ahora se calcula como: distribuciones del socio - retiros retirados/acreditados/transferidos.
   - Se agregó la quinta card "Ganancias del Broker" entre "Mi Aporte Societario" y "Mis Ganancias Acumuladas".

2) Distribuciones:
   - La columna "Monto USD" refleja la ganancia acumulada real de cada socio.
   - El cálculo descuenta retiros con estado pagado, acreditado o transferido.

3) Configuraciones:
   - Ahora permite editar el texto del footer.
   - Permite editar URL vinculada al footer.
   - Se agregaron campos SMTP/PHPMailer.

4) Email / PHPMailer:
   - Se agregó composer.json con phpmailer/phpmailer.
   - Se agregó función central send_crm_email() en api/helpers.php.
   - Se agregó api/test_email.php para prueba de envío desde un usuario SuperAdmin.
   - Si existe vendor/autoload.php y SMTP está activo, usa PHPMailer.
   - Si no existe vendor/autoload.php, intenta fallback con mail() del servidor.

5) Mobile First:
   - Las cards superiores del dashboard quedan visibles primero al ingresar desde celular.
   - Se agregó botón flotante circular de filtros.
   - El botón flotante de WhatsApp ahora es circular y usa ícono SVG profesional.

Instalación / actualización
---------------------------
1) Subir el contenido de la carpeta del proyecto al hosting o a XAMPP.
2) Verificar config/database.php con los datos correctos de MySQL.
3) Ejecutar en phpMyAdmin el archivo:
   sql/PATCH_20260611_FINAL_CRM.sql
4) Para PHPMailer, desde la raíz del proyecto ejecutar:
   composer install
   Si el hosting no permite Composer por consola, ejecutar composer install localmente y subir la carpeta vendor/.
5) Ingresar como SuperAdmin a Configuraciones y completar los datos SMTP:
   - SMTP Host
   - Puerto
   - Seguridad TLS/SSL
   - Usuario
   - Password
   - Email remitente
   - Nombre remitente
6) Para probar envío, realizar un POST a api/test_email.php con el campo "to" o usar el email del SuperAdmin autenticado.

Notas técnicas
--------------
- No se eliminan datos existentes.
- El patch recalcula partners.gains_usd con una fórmula segura.
- Los retiros pendientes o rechazados no descuentan ganancias acumuladas.
- Estados que descuentan: pagado, acreditado, transferido.
- El footer se guarda en app_settings.footer_text.


=== ACTUALIZACIÓN V05 URGENTE ===
1) Subir todos los archivos del ZIP al directorio del CRM.
2) Ejecutar en phpMyAdmin el archivo: sql/PATCH_20260611_V05_LOGIN_NOTIFICACIONES_SEGURIDAD.sql
3) En Configuraciones se agregó:
   - URL Video/Imagen para el bloque derecho del login.
   - Adjuntar imagen de fondo para el login.
   - Tipo de fondo: CSS / Imagen / Video.
4) Notificaciones:
   - Un clic sobre una notificación la marca como leída.
   - Los socios solo ven notificaciones con audience='partner' y su partner_id/user_id.
   - SuperAdmin/Admin ve notificaciones audience='admin' o 'all'.
5) Seguridad y cifrado:
   - Activar SSL/HTTPS en Hostinger y forzar HTTPS desde hPanel.
   - Mantener config/database.php fuera de acceso público; el .htaccess incluido bloquea lectura directa.
   - Usar contraseñas fuertes para MySQL, SMTP y usuarios SuperAdmin.
   - PHPMailer debe usar TLS puerto 587 o SSL puerto 465.
   - No es técnicamente correcto prometer cifrado extremo a extremo real en una app PHP con base de datos consultable por el servidor. Esta versión aplica cifrado en tránsito mediante HTTPS/TLS, hashing seguro de contraseñas con password_hash, cabeceras HTTP de seguridad y restricción de acceso por rol/scope.
   - Para cifrado de campos sensibles en reposo se recomienda configurar APP_ENCRYPTION_KEY y extender el helper de cifrado para wallets/datos bancarios antes de guardar en DB.

========================================
PATCH V06 - LOGIN FONDO EXCLUSIVO
========================================
Corrección aplicada:
- Si Configuraciones > Fondo login: tipo = Animación CSS, el bloque derecho ignora cualquier URL o imagen subida y muestra solo la animación CSS.
- Si el tipo = Imagen, muestra únicamente la imagen configurada/subida, sin cards, sin tickers, sin monedas ni overlays.
- Si el tipo = Video, muestra únicamente el video configurado, sin cards, sin tickers, sin monedas ni overlays.
- Se eliminó definitivamente la card del lado derecho del login para que el fondo quede limpio.

SQL recomendado:
1) Importar sql/PATCH_20260611_V06_LOGIN_BG_EXCLUSIVO.sql en phpMyAdmin.
2) Luego entrar como SuperAdmin a Configuraciones y guardar nuevamente la opción Fondo login: tipo.

Hostinger:
- Subir todos los archivos reemplazando la carpeta actual.
- Verificar permisos de escritura en uploads/settings: 775 o 755 según configuración del hosting.
- Si usa imagen o video por URL, cargar URL https pública.
- Si usa Animación CSS, no hace falta borrar la imagen subida: el código la ignora automáticamente.
