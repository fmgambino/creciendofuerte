<?php require_once 'helpers.php';
$email=clean($_POST['email']??''); if(!filter_var($email,FILTER_VALIDATE_EMAIL)) out(false,['message'=>'Ingresá un email válido'],400);
try{notify('Solicitud de recupero de contraseña','Se solicitó recupero para '.$email,'auth'); audit('Solicitud de recupero de contraseña para '.$email,'auth');}catch(Throwable $e){}
out(true,['message'=>'Si el email existe, el administrador recibirá la solicitud de recupero.']); ?>