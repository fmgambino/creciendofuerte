<?php
session_start();
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
  $enabled=app_setting('smtp_enabled','0')==='1';
  $fromEmail=app_setting('smtp_from_email','');
  $fromName=app_setting('smtp_from_name','EL MASTER PROFE CRM');
  if(!$fromEmail) $fromEmail='no-reply@'.($_SERVER['HTTP_HOST'] ?? 'localhost');
  $autoload=__DIR__.'/../vendor/autoload.php';
  if($enabled && file_exists($autoload)){
    require_once $autoload;
    try{
      $mail=new PHPMailer\PHPMailer\PHPMailer(true);
      $mail->isSMTP();
      $mail->Host=app_setting('smtp_host','');
      $mail->SMTPAuth=true;
      $mail->Username=app_setting('smtp_username','');
      $mail->Password=app_setting('smtp_password','');
      $secure=app_setting('smtp_secure','tls'); if($secure) $mail->SMTPSecure=$secure;
      $mail->Port=(int)app_setting('smtp_port','587');
      $mail->CharSet='UTF-8';
      $mail->setFrom($fromEmail,$fromName);
      $mail->addAddress($to);
      $mail->isHTML(true);
      $mail->Subject=$subject;
      $mail->Body=$html;
      $mail->AltBody=$plain ?: strip_tags($html);
      $mail->send();
      audit('Email enviado a '.$to.' · '.$subject,'email');
      return true;
    }catch(Throwable $e){ audit('Error PHPMailer: '.$e->getMessage(),'email'); return false; }
  }
  $headers="MIME-Version: 1.0\r\nContent-Type: text/html; charset=UTF-8\r\nFrom: ".mb_encode_mimeheader($fromName)." <{$fromEmail}>\r\n";
  $ok=@mail($to,$subject,$html,$headers);
  audit(($ok?'Email enviado':'Error al enviar email').' a '.$to.' · '.$subject,'email');
  return $ok;
}

function notify($title,$body,$type='info'){
  try { db()->prepare('INSERT INTO notifications(title,body,type) VALUES(?,?,?)')->execute([$title,$body,$type]); } catch(Throwable $e){}
}
?>
