<?php
require_once __DIR__.'/../includes/auth.php';
header('Content-Type: application/json; charset=utf-8');
function json_ok($data=[]){ echo json_encode(['ok'=>true]+$data, JSON_UNESCAPED_UNICODE); exit; }
function json_fail($msg='Error', $code=400){ http_response_code($code); echo json_encode(['ok'=>false,'message'=>$msg], JSON_UNESCAPED_UNICODE); exit; }
function body(){ return json_decode(file_get_contents('php://input'), true) ?: $_POST; }
function money($n){ return number_format((float)$n,2,'.',''); }
