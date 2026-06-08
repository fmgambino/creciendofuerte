<?php
require_once __DIR__.'/helpers.php';
$d=body(); $email=trim($d['email']??''); $pass=$d['password']??'';
$stmt=db()->prepare('SELECT * FROM users WHERE email=? AND status="active" LIMIT 1'); $stmt->execute([$email]); $u=$stmt->fetch();
if(!$u || !password_verify($pass,$u['password_hash'])) json_fail('Credenciales inválidas',401);
$_SESSION['user']=['id'=>$u['id'],'name'=>$u['full_name'],'email'=>$u['email'],'role'=>$u['role']];
json_ok(['user'=>$_SESSION['user']]);
