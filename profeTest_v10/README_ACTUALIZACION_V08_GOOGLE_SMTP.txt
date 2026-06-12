# ACTUALIZACIÓN v08 · Google Login + Configuraciones + Gmail SMTP

## Archivos corregidos

- `assets/js/auth.js`
  - Se eliminó el popup de instrucciones de Google.
  - El botón “Continuar con Google” ahora redirige directamente a `auth/google-login.php`.

- `auth/google-login.php`
  - Nuevo flujo OAuth Google.

- `auth/google-callback.php`
  - Nuevo callback OAuth Google.
  - Si el email ya existe en `users`, inicia sesión.
  - Si no existe, crea usuario con rol `socio`, estado `active`, y vincula partner básico.

- `login.php`
  - Texto de ayuda Google corregido.
  - Muestra error OAuth si Google devuelve fallo.

- `assets/js/app.js`
  - Se corrigió el guardado de Configuraciones.
  - Ya no ejecuta `location.reload()` al guardar, evitando la redirección a “This Page Does Not Exist”.
  - Se agregó ayuda visual para configurar Gmail SMTP.

- `api/settings.php`
  - Valores por defecto SMTP preparados para Gmail:
    - Host: `smtp.gmail.com`
    - Puerto: `587`
    - Seguridad: `tls`
    - Usuario/remitente: `electronicagambino@gmail.com`

## Google Cloud OAuth

En Google Cloud Console, en el cliente OAuth web, configurar:

### Orígenes JavaScript autorizados

```txt
https://creciendofuerte.com
```

### URI de redirección autorizada

```txt
https://creciendofuerte.com/auth/google-callback.php
```

Luego revisar:

```php
config/google.php
```

Debe contener el Client ID y Client Secret reales.

## Gmail SMTP para envío de emails

En el módulo Configuraciones cargar:

```txt
Activar SMTP / PHPMailer: Sí
SMTP Host: smtp.gmail.com
SMTP Puerto: 587
SMTP Seguridad: TLS
SMTP Usuario: electronicagambino@gmail.com
SMTP Password: CONTRASEÑA DE APLICACIÓN DE GOOGLE
Email remitente: electronicagambino@gmail.com
Nombre remitente: Electrónica Gambino
```

Importante: Gmail NO permite usar la contraseña normal de la cuenta. Hay que crear una contraseña de aplicación.

Ruta:
Google Account → Seguridad → Verificación en 2 pasos → Contraseñas de aplicaciones.

## Actualización en Hostinger

Subir y reemplazar estos archivos/carpetas:

```txt
auth/
assets/js/auth.js
assets/js/app.js
api/settings.php
api/helpers.php
login.php
config/google.php
vendor/
composer.json
composer.lock
```

Si ya ejecutaste Composer en Hostinger, no hace falta volver a ejecutar nada.
