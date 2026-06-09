<?php require_once 'helpers.php'; need_login(); $entity=preg_replace('/[^a-z_]/','',$_POST['entity']??''); $id=(int)($_POST['id']??0);
$map=['users'=>'users','partners'=>'partners','referrals'=>'referrals','broker_profits'=>'broker_profits','withdrawals'=>'withdrawals','distributions'=>'distributions','capital_levels'=>'capital_levels','whatsapp_numbers'=>'whatsapp_numbers','notifications'=>'notifications'];
if(!isset($map[$entity])||!$id) out(false,['message'=>'Solicitud inválida'],400);
if($entity==='users' && $id==($_SESSION['user']['id']??0)) out(false,['message'=>'No puede eliminar su propio usuario'],400);
db()->prepare('DELETE FROM '.$map[$entity].' WHERE id=?')->execute([$id]); audit('Eliminó '.$entity.' #'.$id,'crud'); out(true,['message'=>'Eliminado correctamente']);
?>
