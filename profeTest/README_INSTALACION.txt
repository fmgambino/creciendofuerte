EL MASTER PROFE CRM - Instalación XAMPP / Hostinger

1) Local XAMPP
- Copiar la carpeta del proyecto dentro de htdocs/creciendofuerte
- Crear la base revenue_crm en phpMyAdmin
- Importar sql/schema.sql o el dump provisto
- Importar sql/PATCH_CONFIGURACIONES_EMAILS.sql
- Acceder a http://localhost/creciendofuerte/login.php

2) Hostinger
- Subir todo el contenido a public_html o a la carpeta del dominio creciendofuerte.com
- Importar primero la base actual y luego sql/PATCH_CONFIGURACIONES_EMAILS.sql
- Editar config/database.php y configurar DB_PASS con la contraseña real de MySQL Hostinger
- DB_NAME y DB_USER ya están preparados para u570224512_master10k / u570224512_fmgambino

3) Configuraciones
- Ingresar como SuperAdmin
- Abrir módulo Configuraciones
- Cambiar título, subtítulo, colores, logo, favicon, ícono PWA y logo de emails

4) Emails
- Las plantillas HTML están en /emails
- Usan variables tipo {{TITULO}}, {{MENSAJE}}, {{EMAIL_LOGO}}
- Firma institucional: EL MASTER Y LA JEFA

5) Lógica de ganancias
- El SuperAdmin carga Ganancias Broker.
- El sistema calcula 60% Master y 40% Socios.
- El 40% se distribuye en partes iguales entre socios activos.
- El capital aportado queda solo como dato societario.
- Cuando un retiro pasa a Pagado, se descuenta de ganancias acumuladas del socio.

6) Login
- Se quitaron datos demo del formulario.
- Incluye Crear cuenta, Recuperar contraseña y botón preparado para Google OAuth.
