<?php
if (session_status() !== PHP_SESSION_ACTIVE) { session_start(); }
require_once __DIR__.'/../config/database.php';
header('Content-Type: application/json; charset=utf-8');
ini_set('display_errors','0');
error_reporting(E_ALL);
function out($ok, $data=[], $code=200){ http_response_code($code); echo json_encode(['ok'=>$ok]+$data, JSON_UNESCAPED_UNICODE); exit; }
function need_login(){ if(empty($_SESSION['user'])) out(false,['message'=>'No autorizado'],401); return $_SESSION['user']; }
function clean($v){ return trim((string)$v); }
function audit($event,$type='system'){
  try { $u=$_SESSION['user']['full_name']??'Sistema'; db()->prepare('INSERT INTO audit_logs(event,author,type) VALUES(?,?,?)')->execute([$event,$u,$type]); } catch(Throwable $e){}
}

function app_setting($key,$default=''){
  try{
    db()->exec("CREATE TABLE IF NOT EXISTS app_settings (`key_name` varchar(80) NOT NULL PRIMARY KEY, `value` text NULL, `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    $st=db()->prepare('SELECT value FROM app_settings WHERE key_name=? LIMIT 1'); $st->execute([$key]);
    $v=$st->fetchColumn(); return $v!==false ? $v : $default;
  }catch(Throwable $e){return $default;}
}
function send_crm_email($to,$subject,$html,$plain=''){
  $GLOBALS['CRM_MAIL_LAST_ERROR']='';
  $enabled=app_setting('smtp_enabled','0')==='1';
  $host=trim(app_setting('smtp_host','smtp.gmail.com'));
  $port=(int)app_setting('smtp_port','587');
  $username=trim(app_setting('smtp_username',''));
  $password=(string)app_setting('smtp_password','');
  // Google muestra la contraseña de aplicación con espacios; PHPMailer debe recibirla sin espacios.
  if(stripos($host,'gmail.com')!==false) $password=preg_replace('/\s+/', '', $password);
  $secure=strtolower(trim(app_setting('smtp_secure','tls')));
  $fromEmail=trim(app_setting('smtp_from_email',''));
  $fromName=trim(app_setting('smtp_from_name','Electrónica Gambino'));

  // Gmail exige que el remitente sea la misma cuenta autenticada o un alias verificado.
  // Si se cargó no-responder@..., se usa el usuario Gmail como From y se deja Reply-To con el valor configurado.
  $replyTo='';
  if(stripos($host,'gmail.com')!==false && $username && strcasecmp($fromEmail,$username)!==0){
    if(filter_var($fromEmail,FILTER_VALIDATE_EMAIL)) $replyTo=$fromEmail;
    $fromEmail=$username;
  }
  if(!$fromEmail) $fromEmail=$username ?: ('no-reply@'.($_SERVER['HTTP_HOST'] ?? 'localhost'));

  $autoload=__DIR__.'/../vendor/autoload.php';
  if($enabled){
    if(!file_exists($autoload)){
      $GLOBALS['CRM_MAIL_LAST_ERROR']='No existe vendor/autoload.php. Ejecutá composer install o subí la carpeta vendor completa.';
      audit('Error PHPMailer: '.$GLOBALS['CRM_MAIL_LAST_ERROR'],'email');
      return false;
    }
    require_once $autoload;
    try{
      $mail=new PHPMailer\PHPMailer\PHPMailer(true);
      $mail->isSMTP();
      $mail->Host=$host;
      $mail->SMTPAuth=true;
      $mail->Username=$username;
      $mail->Password=$password;
      if($secure==='ssl') $mail->SMTPSecure=PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS;
      elseif($secure==='tls') $mail->SMTPSecure=PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
      else $mail->SMTPSecure=false;
      $mail->SMTPAutoTLS=($secure==='tls');
      $mail->Port=$port ?: (($secure==='ssl')?465:587);
      $mail->CharSet='UTF-8';
      $mail->Encoding='base64';
      $mail->setFrom($fromEmail,$fromName);
      if($replyTo) $mail->addReplyTo($replyTo,$fromName);
      $mail->addAddress($to);
      $mail->isHTML(true);
      $mail->Subject=$subject;
      $mail->Body=$html;
      $mail->AltBody=$plain ?: strip_tags($html);
      $mail->send();
      audit('Email enviado a '.$to.' · '.$subject,'email');
      return true;
    }catch(Throwable $e){
      $GLOBALS['CRM_MAIL_LAST_ERROR']=$e->getMessage();
      audit('Error PHPMailer: '.$e->getMessage(),'email');
      return false;
    }
  }
  $headers="MIME-Version: 1.0\r\nContent-Type: text/html; charset=UTF-8\r\nFrom: ".mb_encode_mimeheader($fromName)." <{$fromEmail}>\r\n";
  $ok=@mail($to,$subject,$html,$headers);
  if(!$ok) $GLOBALS['CRM_MAIL_LAST_ERROR']='mail() devolvió false. Activá SMTP/PHPMailer para Gmail.';
  audit(($ok?'Email enviado':'Error al enviar email').' a '.$to.' · '.$subject,'email');
  return $ok;
}
function crm_mail_last_error(){ return $GLOBALS['CRM_MAIL_LAST_ERROR'] ?? ''; }

function absolute_url($path=''){
  $base=defined('APP_DOMAIN') ? APP_DOMAIN : ('https://'.($_SERVER['HTTP_HOST'] ?? 'creciendofuerte.com'));
  return rtrim($base,'/').'/'.ltrim((string)$path,'/');
}
function email_logo_url(){
  $p=trim(app_setting('email_logo_path','assets/img/icon.svg'));
  if($p==='') $p='assets/img/icon.svg';
  if(preg_match('~^https?://~i',$p)) return $p;
  return absolute_url($p);
}
function render_email_template($template,$vars=[]){
  $file=__DIR__.'/../emails/'.basename($template).'.html';
  $html=file_exists($file) ? file_get_contents($file) : '';
  if($html===''){
    $html='<!doctype html><html><body style="font-family:Arial,sans-serif"><h1>{{TITULO}}</h1><p>{{MENSAJE}}</p><p><a href="'.absolute_url().'">Ingresar al CRM</a></p></body></html>';
  }
  $defaults=[
    'EMAIL_LOGO'=>email_logo_url(),
    'TITULO'=>$vars['titulo'] ?? $vars['TITULO'] ?? '10K CRM',
    'MENSAJE'=>$vars['mensaje'] ?? $vars['MENSAJE'] ?? '',
    'nombre'=>$vars['nombre'] ?? $vars['NOMBRE'] ?? 'Usuario',
    'mensaje'=>$vars['mensaje'] ?? $vars['MENSAJE'] ?? '',
    'app_url'=>absolute_url(),
    'APP_URL'=>absolute_url(),
  ];
  $vars=array_merge($defaults,$vars);
  foreach($vars as $k=>$v){
    $safe=(string)$v;
    $html=str_replace('{{'.$k.'}}',$safe,$html);
  }
  return $html;
}
function crm_superadmin_recipients(){
  try{
    $st=db()->query("SELECT email FROM users WHERE role='superadmin' AND status='active' AND email<>''");
    return array_values(array_unique(array_filter($st->fetchAll(PDO::FETCH_COLUMN), fn($e)=>filter_var($e,FILTER_VALIDATE_EMAIL))));
  }catch(Throwable $e){ return []; }
}
function crm_partner_email($partnerId){
  try{
    $st=db()->prepare('SELECT COALESCE(u.email,p.email) email, p.full_name FROM partners p LEFT JOIN users u ON u.id=p.user_id WHERE p.id=? LIMIT 1');
    $st->execute([(int)$partnerId]);
    $r=$st->fetch();
    if($r && filter_var($r['email'],FILTER_VALIDATE_EMAIL)) return $r;
  }catch(Throwable $e){}
  return null;
}
function crm_active_partner_recipients(){
  try{
    $sql="SELECT p.id, p.full_name, COALESCE(u.email,p.email) email FROM partners p LEFT JOIN users u ON u.id=p.user_id WHERE p.status='active' AND p.kyc_status IN('aprobado','pendiente') AND COALESCE(u.email,p.email)<>''";
    $rows=db()->query($sql)->fetchAll();
    return array_values(array_filter($rows, fn($r)=>filter_var($r['email']??'',FILTER_VALIDATE_EMAIL)));
  }catch(Throwable $e){ return []; }
}
function crm_send_template($to,$subject,$template,$vars=[]){
  if(!filter_var((string)$to,FILTER_VALIDATE_EMAIL)) return false;
  $html=render_email_template($template,$vars);
  return send_crm_email($to,$subject,$html);
}
function crm_email_superadmins($subject,$template,$vars=[]){
  $ok=0; foreach(crm_superadmin_recipients() as $email){ if(crm_send_template($email,$subject,$template,$vars)) $ok++; }
  return $ok;
}
function crm_email_partner($partnerId,$subject,$template,$vars=[]){
  $p=crm_partner_email((int)$partnerId); if(!$p) return false;
  $vars=array_merge(['nombre'=>$p['full_name'] ?: 'Socio'], $vars);
  return crm_send_template($p['email'],$subject,$template,$vars);
}


function ensure_notifications_scope_columns(){
  static $done=false; if($done) return; $done=true;
  try{
    $cols=db()->query('SHOW COLUMNS FROM notifications')->fetchAll(PDO::FETCH_COLUMN);
    if(!in_array('user_id',$cols,true)) db()->exec('ALTER TABLE notifications ADD COLUMN user_id INT UNSIGNED NULL AFTER type');
    if(!in_array('partner_id',$cols,true)) db()->exec('ALTER TABLE notifications ADD COLUMN partner_id INT UNSIGNED NULL AFTER user_id');
    if(!in_array('audience',$cols,true)) db()->exec("ALTER TABLE notifications ADD COLUMN audience ENUM('admin','partner','all') NOT NULL DEFAULT 'admin' AFTER partner_id");
  }catch(Throwable $e){}
}
function notify($title,$body,$type='info',$userId=null,$partnerId=null,$audience='admin'){
  try {
    ensure_notifications_scope_columns();
    db()->prepare('INSERT INTO notifications(title,body,type,user_id,partner_id,audience) VALUES(?,?,?,?,?,?)')->execute([$title,$body,$type,$userId,$partnerId,$audience]);
  } catch(Throwable $e){
    try { db()->prepare('INSERT INTO notifications(title,body,type) VALUES(?,?,?)')->execute([$title,$body,$type]); } catch(Throwable $e2){}
  }
}
function sync_partner_gains($partnerId=null){
  try{
    $active=(int)db()->query('SELECT COUNT(*) FROM partners WHERE status="active"')->fetchColumn();
    $pool=(float)db()->query('SELECT COALESCE(SUM(partners_share_usd),0) FROM broker_profits')->fetchColumn();
    $per=$active>0 ? round($pool/$active,2) : 0;
    $sql='SELECT id FROM partners'.($partnerId?' WHERE id='.(int)$partnerId:'');
    foreach(db()->query($sql)->fetchAll(PDO::FETCH_COLUMN) as $pid){
      $st=db()->prepare("SELECT COALESCE(SUM(amount_usd),0) FROM withdrawals WHERE partner_id=? AND status IN('pagado','acreditado','transferido')");
      $st->execute([$pid]);
      $paid=(float)$st->fetchColumn();
      db()->prepare('UPDATE partners SET gains_usd=? WHERE id=?')->execute([max(0,round($per-$paid,2)),$pid]);
    }
  }catch(Throwable $e){}
}
?>
