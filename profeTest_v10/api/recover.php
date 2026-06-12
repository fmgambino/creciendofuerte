<?php require_once 'helpers.php';
$email=clean($_POST['email']??'');
if(!filter_var($email,FILTER_VALIDATE_EMAIL)) out(false,['message'=>'Ingresá un email válido'],400);
try{
  notify('Solicitud de recupero de contraseña','Se solicitó recupero para '.$email,'auth');
  audit('Solicitud de recupero de contraseña para '.$email,'auth');
  crm_email_superadmins('Solicitud de recupero de contraseña - 10K CRM','recupero_password',['titulo'=>'Solicitud de recupero de contraseña','nombre'=>'Administrador','mensaje'=>'Se solicitó recupero de contraseña para: '.$email]);
  $st=db()->prepare('SELECT full_name,email FROM users WHERE email=? LIMIT 1');
  $st->execute([$email]);
  $user=$st->fetch();
  if($user){
    crm_send_template($email,'Recibimos tu solicitud de recupero - 10K CRM','recupero_password',['titulo'=>'Solicitud de recupero recibida','nombre'=>$user['full_name'] ?: 'Usuario','mensaje'=>'Recibimos tu solicitud de recupero de contraseña. El administrador revisará tu caso y se comunicará contigo.']);
  }
}catch(Throwable $e){}
out(true,['message'=>'Si el email existe, el administrador recibirá la solicitud de recupero.']); ?>
