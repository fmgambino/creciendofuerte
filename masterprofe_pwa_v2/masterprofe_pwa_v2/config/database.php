<?php
const DB_HOST='127.0.0.1';
const DB_NAME='revenue_crm';
const DB_USER='root';
const DB_PASS='';
const APP_NAME='EL MASTER 10K CRM';
const APP_OWNER='El Master Profe';
function db(): PDO {
  static $pdo=null; if($pdo) return $pdo;
  $dsn='mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4';
  $pdo=new PDO($dsn, DB_USER, DB_PASS, [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]);
  return $pdo;
}
?>
