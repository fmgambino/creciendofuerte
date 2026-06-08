<?php
session_start();
require_once __DIR__.'/../config/database.php';
function current_user(){return $_SESSION['user'] ?? null;}
function require_auth(){ if(!current_user()){ header('Location: login.php'); exit; } }
function require_api_auth(){ if(!current_user()){ http_response_code(401); echo json_encode(['ok'=>false,'message'=>'No autorizado']); exit; } }
function can($module,$action='view'){ $u=current_user(); return $u && ($u['role']==='superadmin' || $action==='view'); }
?>
