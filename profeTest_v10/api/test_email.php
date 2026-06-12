<?php
require_once 'helpers.php';
$u=need_login();
if(($u['role']??'')!=='superadmin') out(false,['message'=>'Solo SuperAdmin'],403);
$to=clean($_POST['to'] ?? ($u['email'] ?? ''));
if(!filter_var($to,FILTER_VALIDATE_EMAIL)) out(false,['message'=>'Email inválido'],400);
$ok=send_crm_email(
  $to,
  'Prueba SMTP / PHPMailer - 10K CRM',
  '<h2>Prueba de envío correcta</h2><p>La configuración SMTP/PHPMailer del CRM está operativa.</p><p>Este correo fue generado desde el módulo Configuraciones.</p>'
);
if($ok){
  out(true,['message'=>'Email test enviado correctamente a '.$to],200);
}
$detail=function_exists('crm_mail_last_error') ? crm_mail_last_error() : '';
out(false,['message'=>'No se pudo enviar. '.$detail],500);
?>
