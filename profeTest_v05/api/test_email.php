<?php require_once 'helpers.php'; $u=need_login(); if(($u['role']??'')!=='superadmin') out(false,['message'=>'Solo SuperAdmin'],403);
$to=clean($_POST['to'] ?? ($u['email'] ?? ''));
if(!filter_var($to,FILTER_VALIDATE_EMAIL)) out(false,['message'=>'Email inválido'],400);
$ok=send_crm_email($to,'Prueba PHPMailer - CRM','<h2>Prueba de envío correcta</h2><p>La configuración SMTP/PHPMailer del CRM está operativa.</p>');
out($ok,['message'=>$ok?'Email enviado':'No se pudo enviar. Revisá SMTP, credenciales y vendor/autoload.php.'],$ok?200:500);
?>
