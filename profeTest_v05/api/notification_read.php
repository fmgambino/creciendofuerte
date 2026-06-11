<?php
require_once __DIR__.'/helpers.php';
$u=need_login();
$id=(int)($_POST['id'] ?? 0);
if($id<=0) out(false,['message'=>'ID inválido'],400);
ensure_notifications_scope_columns();
try{
  if(($u['role'] ?? '')==='socio'){
    $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1');
    $st->execute([(int)$u['id'], $u['email'] ?? '']);
    $pid=(int)$st->fetchColumn();
    $up=db()->prepare("UPDATE notifications SET is_read=1 WHERE id=? AND audience='partner' AND (partner_id=? OR user_id=?)");
    $up->execute([$id,$pid,(int)$u['id']]);
  } else {
    $up=db()->prepare("UPDATE notifications SET is_read=1 WHERE id=? AND audience IN('admin','all')");
    $up->execute([$id]);
  }
  out(true,['message'=>'Notificación marcada como leída']);
}catch(Throwable $e){ out(false,['message'=>$e->getMessage()],500); }
?>
