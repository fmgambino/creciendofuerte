<?php require_once 'helpers.php';
try{
  $name=clean($_POST['full_name']??'');
  $email=clean($_POST['email']??'');
  $pass=clean($_POST['password']??'');
  if(!$name||!filter_var($email,FILTER_VALIDATE_EMAIL)||strlen($pass)<6) out(false,['message'=>'Completá nombre, email válido y contraseña mínima de 6 caracteres'],400);
  $st=db()->prepare('SELECT id FROM users WHERE email=?');
  $st->execute([$email]);
  if($st->fetchColumn()) out(false,['message'=>'El email ya está registrado'],400);
  $hash=password_hash($pass,PASSWORD_DEFAULT);
  db()->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,?)')->execute([$name,$email,$hash,'socio','inactive']);
  $uid=db()->lastInsertId();
  $code='MSTR-'.strtoupper(substr(preg_replace('/[^a-z0-9]/i','',$name),0,4)).'-'.str_pad((string)$uid,4,'0',STR_PAD_LEFT);
  db()->prepare('INSERT INTO partners(user_id,partner_code,full_name,email,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES(?,?,?,?,0,0,"pendiente","inactive",CURDATE())')->execute([$uid,$code,$name,$email]);
  notify('Nueva solicitud de cuenta','Se registró '.$name.' y espera aprobación.','usuario');
  crm_send_template($email,'Solicitud de cuenta recibida - 10K CRM','cuenta_creada',['titulo'=>'Solicitud de cuenta recibida','nombre'=>$name,'mensaje'=>'Tu cuenta fue creada correctamente y queda pendiente de aprobación por el SuperAdmin. Este proceso puede llevar hasta 48 hs hábiles.']);
  crm_email_superadmins('Nueva solicitud de cuenta - 10K CRM','solicitud_cuenta_nueva',['titulo'=>'Nueva solicitud de cuenta','nombre'=>'Administrador','mensaje'=>'Se registró '.$name.' con email '.$email.' y espera aprobación.']);
  out(true,['message'=>'Cuenta creada. Queda pendiente de aprobación por el administrador.']);
}catch(Throwable $e){out(false,['message'=>$e->getMessage()],500);} ?>
