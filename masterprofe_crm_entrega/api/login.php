<?php require_once 'helpers.php';
$email=clean($_POST['email']??''); $pass=(string)($_POST['password']??'');
$stmt=db()->prepare('SELECT * FROM users WHERE email=? AND status="active" LIMIT 1'); $stmt->execute([$email]); $u=$stmt->fetch();
if(!$u || !password_verify($pass,$u['password_hash'])) out(false,['message'=>'Credenciales inválidas'],401);
$_SESSION['user']=['id'=>$u['id'],'full_name'=>$u['full_name'],'email'=>$u['email'],'role'=>$u['role'],'profile_photo'=>$u['profile_photo']]; audit('Inicio de sesión','auth'); out(true,['user'=>$_SESSION['user']]);
?>
