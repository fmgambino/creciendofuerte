<?php require_once 'helpers.php'; $u=need_login();
$modules=[
 ['key'=>'dashboard','name'=>'Dashboard'],['key'=>'profile','name'=>'Mi Perfil'],['key'=>'users','name'=>'Usuarios'],['key'=>'roles','name'=>'Roles y permisos'],['key'=>'socios','name'=>'Socios'],['key'=>'referidos','name'=>'Referidos'],['key'=>'profits','name'=>'Ganancias broker'],['key'=>'distribuciones','name'=>'Distribuciones'],['key'=>'retiros','name'=>'Retiros'],['key'=>'whatsapp','name'=>'WhatsApp'],['key'=>'notificaciones','name'=>'Notificaciones'],['key'=>'auditoria','name'=>'Auditoría']
];
$perms=db()->query('SELECT module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export FROM permissions')->fetchAll();
$not=db()->query('SELECT * FROM notifications ORDER BY id DESC LIMIT 50')->fetchAll();
out(true,['user'=>$u,'modules'=>$modules,'permissions'=>$perms,'notifications'=>$not]);
?>
