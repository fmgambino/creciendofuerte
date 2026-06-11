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
