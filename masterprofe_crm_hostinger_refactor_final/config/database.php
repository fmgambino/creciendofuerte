<?php
// Base de datos solicitada: NO CAMBIAR NOMBRE
const DB_HOST = '127.0.0.1';
const DB_NAME = 'revenue_crm';
const DB_USER = 'root';
const DB_PASS = '';
const APP_NAME = 'EL MASTER PROFE CRM';
const APP_DOMAIN = 'https://creciendofuerte.com';
const FOOTER_TEXT = '© 2026 EL MASTER 10K - Todos los derecho Registrados - Desarrollado por Electrónica Gambino';
function db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4', DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }
    return $pdo;
}
?>
