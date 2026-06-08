<?php require_once 'helpers.php'; need_login();
$data=json_decode(file_get_contents('php://input'),true) ?: [];
foreach($data as $p){
  db()->prepare('INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES(?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE module_name=VALUES(module_name),can_view=VALUES(can_view),can_create=VALUES(can_create),can_edit=VALUES(can_edit),can_delete=VALUES(can_delete),can_export=VALUES(can_export)')
    ->execute([$p['module_key'],$p['module_name']??$p['module_key'],$p['role'],(int)$p['can_view'],(int)$p['can_create'],(int)$p['can_edit'],(int)$p['can_delete'],(int)$p['can_export']]);
}
audit('Actualizó roles y permisos','security'); out(true,['message'=>'Permisos guardados']);
?>
