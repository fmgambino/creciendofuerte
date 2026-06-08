<?php
session_start();
require_once __DIR__.'/../config/database.php';
header('Content-Type: application/json; charset=utf-8');
function out($ok, $data=[], $code=200){ http_response_code($code); echo json_encode(['ok'=>$ok]+$data, JSON_UNESCAPED_UNICODE); exit; }
function need_login(){ if(empty($_SESSION['user'])) out(false,['message'=>'No autorizado'],401); return $_SESSION['user']; }
function clean($v){ return trim((string)$v); }
function audit($event,$type='system'){
  try { $u=$_SESSION['user']['full_name']??'Sistema'; db()->prepare('INSERT INTO audit_logs(event,author,type) VALUES(?,?,?)')->execute([$event,$u,$type]); } catch(Throwable $e){}
}
function notify($title,$body,$type='info'){
  try { db()->prepare('INSERT INTO notifications(title,body,type) VALUES(?,?,?)')->execute([$title,$body,$type]); } catch(Throwable $e){}
}
?>
