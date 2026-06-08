<?php
require_once __DIR__.'/../includes/auth.php';
header('Content-Type: application/json; charset=utf-8');
function json_ok($data=[]){ echo json_encode(['ok'=>true]+$data, JSON_UNESCAPED_UNICODE); exit; }
function json_err($msg,$code=400){ http_response_code($code); echo json_encode(['ok'=>false,'message'=>$msg], JSON_UNESCAPED_UNICODE); exit; }
function input(){ return json_decode(file_get_contents('php://input'), true) ?: $_POST; }
function log_event($event,$type='system'){try{$u=current_user(); db()->prepare('INSERT INTO audit_logs(event,author,type) VALUES(?,?,?)')->execute([$event,$u['full_name']??'Sistema',$type]);}catch(Throwable $e){}}
?>
