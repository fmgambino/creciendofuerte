<?php
require_once __DIR__.'/helpers.php';
$data=input(); $email=trim($data['email']??''); $pass=$data['password']??'';
$stmt=db()->prepare('SELECT * FROM users WHERE email=? AND status="active" LIMIT 1'); $stmt->execute([$email]); $u=$stmt->fetch();
if(!$u || !password_verify($pass,$u['password_hash'])) json_err('Credenciales inválidas',401);
unset($u['password_hash']); $_SESSION['user']=$u; log_event('Inicio de sesión','auth'); json_ok(['user'=>$u]);
?>
