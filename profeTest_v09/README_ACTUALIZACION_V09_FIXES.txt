ACTUALIZACION V09 - LOGIN GOOGLE / CUENTAS / RECUPERO / SMTP TEST

Cambios aplicados:
1) Login:
   - Eliminado el texto inferior:
     "Google: presioná Continuar con Google..."
   - El botón "Continuar con Google" redirige directamente a:
     /auth/google-login.php
   - Se mantiene soporte para Google OAuth con:
     /auth/google-callback.php

2) Crear cuenta:
   - Se restauró el botón "Crear cuenta".
   - Abre popup para nombre, email y contraseña.
   - Envía los datos a:
     /api/register.php

3) Recuperar contraseña:
   - Se restauró el botón "Recuperar contraseña".
   - Abre popup para cargar email.
   - Envía solicitud a:
     /api/recover.php

4) Configuraciones:
   - Se corrigió el botón "Guardar configuración" para evitar navegación incorrecta.
   - Se agregó campo:
     Email test SMTP
   - Se agregó botón:
     Enviar email test
   - El test usa:
     /api/test_email.php

5) SMTP Gmail recomendado:
   Activar SMTP / PHPMailer: Sí
   SMTP Host: smtp.gmail.com
   SMTP Puerto: 587
   SMTP Seguridad: tls
   SMTP Usuario: electronicagambino@gmail.com
   SMTP Password: Contraseña de aplicación de Google
   Email remitente: electronicagambino@gmail.com
   Nombre remitente: Electrónica Gambino

IMPORTANTE:
- Después de subir a Hostinger, limpiar caché del navegador.
- Si la PWA quedó instalada, cerrar y abrir nuevamente.
- En Chrome: DevTools > Application > Service Workers > Unregister.
- Luego recargar con CTRL + F5.

Google Cloud:
URI callback autorizado:
https://creciendofuerte.com/auth/google-callback.php
