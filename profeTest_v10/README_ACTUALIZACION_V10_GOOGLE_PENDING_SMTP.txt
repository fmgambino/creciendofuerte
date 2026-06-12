ACTUALIZACION V10 - GOOGLE OAUTH PENDIENTE + SMTP GMAIL

Cambios incluidos:
1) Los socios creados con Google OAuth quedan como usuario socio INACTIVE y partner INACTIVE/KYC pendiente.
2) El socio pendiente puede iniciar sesión, pero solamente ve Dashboard y Mi Perfil.
3) Dashboard del socio pendiente muestra todas las cards en US$ 0 y aviso institucional.
4) El texto del aviso se puede editar desde Configuraciones:
   "Texto para socios pendientes de activación".
5) SMTP Gmail corregido para PHPMailer:
   - Elimina espacios de la contraseña de aplicación.
   - Si usas Gmail, fuerza From = SMTP Usuario para evitar rechazo.
   - Si el Email remitente es distinto, lo usa como Reply-To.
   - El test SMTP devuelve detalle del error real.
6) Se incluye patch SQL:
   sql/PATCH_V10_GOOGLE_PENDING_SMTP.sql

CONFIG SMTP RECOMENDADA PARA GMAIL:
Activar SMTP / PHPMailer: Sí
SMTP Host: smtp.gmail.com
SMTP Puerto: 587
SMTP Seguridad: TLS
SMTP Usuario: electronicagambino@gmail.com
SMTP Password: contraseña de aplicación Google, no contraseña normal
Email remitente: electronicagambino@gmail.com
Nombre remitente: Electrónica Gambino

IMPORTANTE:
- Ejecutar composer install si vendor no existe en Hostinger.
- Si ya subiste vendor, no hace falta volver a ejecutar composer.
- Ejecutar el patch SQL si no aparece el nuevo texto configurable.
- Limpiar caché del navegador con CTRL + F5.
