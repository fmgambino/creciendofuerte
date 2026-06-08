<?php require_once 'helpers.php'; need_login();
$data=json_decode(file_get_contents('php://input'),true) ?: [];
foreach($data as $p){ db()->prepare('UPDATE permissions SET can_view=? WHERE module_key=? AND role=?')->execute([(int)$p['can_view'],$p['module_key'],$p['role']]); }
audit('Actualizó roles y permisos','security'); out(true,['message'=>'Permisos guardados']);
?>
