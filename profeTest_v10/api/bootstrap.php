<?php require_once 'helpers.php'; $u=need_login();
$modules=[
 ['key'=>'dashboard','name'=>'Dashboard'],['key'=>'perfil','name'=>'Mi Perfil'],['key'=>'users','name'=>'Usuarios'],['key'=>'roles','name'=>'Roles y permisos'],['key'=>'socios','name'=>'Socios'],['key'=>'referidos','name'=>'Referidos'],['key'=>'profits','name'=>'Ganancias broker'],['key'=>'distribuciones','name'=>'Distribuciones'],
 ['key'=>'capitales','name'=>'Niveles de capital'],['key'=>'retiros','name'=>'Retiros'],['key'=>'whatsapp','name'=>'WhatsApp'],['key'=>'notificaciones','name'=>'Notificaciones'],['key'=>'configuraciones','name'=>'Configuraciones'],['key'=>'auditoria','name'=>'Auditoría']
];
$perms=db()->query('SELECT * FROM permissions')->fetchAll();

// Estado de socio pendiente: puede ingresar, pero solo ve Dashboard y Mi Perfil.
$pendingActivation=false;
$pendingText=app_setting('pending_activation_text','Tu cuenta fue registrada correctamente y quedó pendiente de activación por el SuperAdmin. Este proceso puede demorar hasta 48 hs hábiles.');
if(($u['role']??'')==='socio'){
  try{
    $stp=db()->prepare('SELECT status, kyc_status FROM partners WHERE user_id=? OR email=? LIMIT 1');
    $stp->execute([(int)$u['id'], $u['email'] ?? '']);
    $partnerStatus=$stp->fetch();
    $pendingActivation=(($u['status']??'')!=='active') || (($partnerStatus['status']??'')!=='active') || (($partnerStatus['kyc_status']??'')!=='aprobado');
  }catch(Throwable $e){ $pendingActivation=(($u['status']??'')!=='active'); }
}
if($pendingActivation){
  $u['pending_activation']=true;
  $u['pending_activation_text']=$pendingText;
  $safe=[];
  foreach($modules as $m){
    $safe[]=[
      'module_key'=>$m['key'], 'module_name'=>$m['name'], 'role'=>'socio',
      'can_view'=>in_array($m['key'], ['dashboard','perfil'], true)?1:0,
      'can_create'=>0, 'can_edit'=>0, 'can_delete'=>0, 'can_export'=>0
    ];
  }
  $perms=$safe;
}
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
