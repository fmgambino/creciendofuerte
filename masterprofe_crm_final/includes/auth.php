<?php
session_start();
require_once __DIR__.'/../config/database.php';
function current_user(){ return $_SESSION['user'] ?? null; }
function require_login(){ if(!current_user()){ header('Location: login.php'); exit; } }
function is_superadmin(){ return (current_user()['role'] ?? '') === 'superadmin'; }
