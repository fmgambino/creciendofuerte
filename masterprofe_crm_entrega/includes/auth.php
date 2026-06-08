<?php
session_start();
require_once __DIR__.'/../config/database.php';
function require_login(){ if(empty($_SESSION['user'])) { header('Location: login.php'); exit; } }
function current_user(){ return $_SESSION['user'] ?? null; }
?>
