<?php
require_once __DIR__.'/helpers.php';
function settings_defaults(){return [
 'app_title'=>'EL MASTER PROFE CRM','app_short_title'=>'EL MASTER','app_subtitle'=>'PROFE CRM',
 'title_color'=>'#ffffff','subtitle_color'=>'#ffe05d','brand_color'=>'#3b747b','accent_color'=>'#69d3d1',
 'logo_path'=>'assets/img/icon.svg','favicon_path'=>'assets/img/icon.svg','pwa_icon_path'=>'assets/img/icon.svg','email_logo_path'=>'assets/img/icon.svg',
 'footer_text'=>'© 2026 EL MASTER 10K - Todos los derechos Registrados - Desarrollado por Electrónica Gambino',
 'footer_url'=>'https://electronicagambino.com',
 'smtp_enabled'=>'0','smtp_host'=>'smtp.gmail.com','smtp_port'=>'587','smtp_username'=>'electronicagambino@gmail.com','smtp_password'=>'','smtp_secure'=>'tls','smtp_from_email'=>'electronicagambino@gmail.com','smtp_from_name'=>'Electrónica Gambino',
 'login_bg_type'=>'css','login_bg_url'=>'','login_bg_path'=>'',
 'pending_activation_text'=>'Tu cuenta fue registrada correctamente y quedó pendiente de activación por el SuperAdmin. Este proceso puede demorar hasta 48 hs hábiles.'
];}
function ensure_settings_table(){try{db()->exec("CREATE TABLE IF NOT EXISTS app_settings (`key_name` varchar(80) NOT NULL PRIMARY KEY, `value` text NULL, `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");}catch(Throwable $e){}}
function get_settings(){ensure_settings_table(); $d=settings_defaults(); try{$rows=db()->query('SELECT key_name,value FROM app_settings')->fetchAll(); foreach($rows as $r){$d[$r['key_name']]=$r['value'];}}catch(Throwable $e){} return $d;}
if($_SERVER['REQUEST_METHOD']==='GET'){out(true,['settings'=>get_settings()]);}
$u=need_login(); if(($u['role']??'')!=='superadmin') out(false,['message'=>'Solo SuperAdmin puede modificar configuraciones'],403);
ensure_settings_table();
$allowed=['app_title','app_short_title','app_subtitle','title_color','subtitle_color','brand_color','accent_color','footer_text','footer_url','smtp_enabled','smtp_host','smtp_port','smtp_username','smtp_password','smtp_secure','smtp_from_email','smtp_from_name','login_bg_type','login_bg_url','pending_activation_text'];
foreach($allowed as $k){ if(isset($_POST[$k])){ db()->prepare('REPLACE INTO app_settings(key_name,value) VALUES(?,?)')->execute([$k,clean($_POST[$k])]); }}
$uploadDir=__DIR__.'/../uploads/settings'; if(!is_dir($uploadDir)) @mkdir($uploadDir,0775,true);
$files=['logo'=>'logo_path','favicon'=>'favicon_path','pwa_icon'=>'pwa_icon_path','email_logo'=>'email_logo_path','login_bg'=>'login_bg_path'];
foreach($files as $field=>$key){ if(!empty($_FILES[$field]['tmp_name'])){ $ext=strtolower(pathinfo($_FILES[$field]['name'],PATHINFO_EXTENSION)); if(!in_array($ext,['png','jpg','jpeg','webp','svg','ico'])) continue; $name=$field.'_'.time().'.'.$ext; $dest=$uploadDir.'/'.$name; if(move_uploaded_file($_FILES[$field]['tmp_name'],$dest)){ db()->prepare('REPLACE INTO app_settings(key_name,value) VALUES(?,?)')->execute([$key,'uploads/settings/'.$name]); } }}
audit('Actualizó configuraciones de la PWA','config'); out(true,['settings'=>get_settings()]);
?>