<?php require_once 'helpers.php'; $u=need_login();
$modules=[
 ['key'=>'dashboard','name'=>'Dashboard'],['key'=>'perfil','name'=>'Mi Perfil'],['key'=>'users','name'=>'Usuarios'],['key'=>'roles','name'=>'Roles y permisos'],['key'=>'socios','name'=>'Socios'],['key'=>'referidos','name'=>'Referidos'],['key'=>'profits','name'=>'Ganancias broker'],['key'=>'distribuciones','name'=>'Distribuciones'],
 ['key'=>'capitales','name'=>'Niveles de capital'],['key'=>'retiros','name'=>'Retiros'],['key'=>'whatsapp','name'=>'WhatsApp'],['key'=>'notificaciones','name'=>'Notificaciones'],['key'=>'configuraciones','name'=>'Configuraciones'],['key'=>'auditoria','name'=>'Auditoría']
];
$perms=db()->query('SELECT * FROM permissions')->fetchAll();
ensure_notifications_scope_columns();
if(($u['role']??'')==='socio'){
  $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1'); $st->execute([$u['id'],$u['email']]); $mypid=(int)$st->fetchColumn();
  $st=db()->prepare("SELECT * FROM notifications WHERE audience='partner' AND (partner_id=? OR user_id=?) ORDER BY id DESC LIMIT 40");
  $st->execute([$mypid,(int)$u['id']]); $not=$st->fetchAll();
} else {
  $not=db()->query("SELECT * FROM notifications WHERE audience IN('admin','all') ORDER BY id DESC LIMIT 40")->fetchAll();
}
out(true,['user'=>$u,'modules'=>$modules,'permissions'=>$perms,'notifications'=>$not]);
?>
