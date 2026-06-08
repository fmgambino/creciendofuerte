<?php require_once 'helpers.php'; need_login();
$data=json_decode(file_get_contents('php://input'),true); if(!is_array($data)) out(false,['message'=>'Datos inválidos'],400);
$modules=[ 'dashboard'=>'Dashboard','profile'=>'Mi Perfil','users'=>'Usuarios','roles'=>'Roles y permisos','socios'=>'Socios','referidos'=>'Referidos','profits'=>'Ganancias broker','distribuciones'=>'Distribuciones','retiros'=>'Retiros','whatsapp'=>'WhatsApp','notificaciones'=>'Notificaciones','auditoria'=>'Auditoría'];
$roles=['superadmin','empleado','socio','referido'];
$pdo=db(); $pdo->beginTransaction();
try{
 foreach($data as $p){
  $m=$p['module_key']??''; $r=$p['role']??''; if(!isset($modules[$m])||!in_array($r,$roles,true)) continue;
  $vals=[(int)!empty($p['can_view']),(int)!empty($p['can_create']),(int)!empty($p['can_edit']),(int)!empty($p['can_delete']),(int)!empty($p['can_export'])];
  $pdo->prepare('INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES(?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE can_view=VALUES(can_view),can_create=VALUES(can_create),can_edit=VALUES(can_edit),can_delete=VALUES(can_delete),can_export=VALUES(can_export)')->execute([$m,$modules[$m],$r,...$vals]);
 }
 $pdo->commit(); audit('Actualizó roles y permisos','permisos'); out(true,['message'=>'Permisos guardados']);
}catch(Throwable $e){$pdo->rollBack(); out(false,['message'=>$e->getMessage()],500);}?>
