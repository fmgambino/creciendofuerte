<?php
/*
 |--------------------------------------------------------------------------
 | Configuración de base de datos
 |--------------------------------------------------------------------------
 | - Local XAMPP: usa revenue_crm / root / sin password.
 | - Hostinger: edita SOLO DB_PASS con tu contraseña real.
 |   DB_NAME y DB_USER ya respetan los datos del hosting del cliente.
 */
$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$isLocal = (strpos($host, 'localhost') !== false) || (strpos($host, '127.0.0.1') !== false);

define('DB_HOST', 'localhost');
define('DB_NAME', $isLocal ? 'revenue_crm' : 'u570224512_master10k');
define('DB_USER', $isLocal ? 'root' : 'u570224512_fmgambino');
define('DB_PASS', $isLocal ? '' : 'CAMBIAR_PASSWORD_MYSQL_HOSTINGER');
define('APP_NAME', 'EL MASTER PROFE CRM');
define('APP_DOMAIN', 'https://creciendofuerte.com');
define('FOOTER_TEXT', '© 2026 EL MASTER 10K - Todos los derecho Registrados - Desarrollado por Electrónica Gambino');

function db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4', DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    }
    return $pdo;
}
?>
