<?php require_once 'helpers.php'; $u=need_login();
$stats=['capital'=>0,'gains'=>0,'partners'=>0,'pending_withdrawals'=>0,'referrals'=>0,'my_capital'=>0,'my_gains'=>0];
$role=$u['role'];
if($role==='socio' || $role==='referido'){
 $p=db()->prepare('SELECT * FROM partners WHERE user_id=? OR email=? LIMIT 1'); $p->execute([$u['id'],$u['email']]); $partner=$p->fetch();
 if($partner){ $stats['my_capital']=(float)$partner['capital_usd']; $stats['my_gains']=(float)$partner['gains_usd']; $stats['referrals']=(int)db()->query('SELECT COUNT(*) c FROM referrals WHERE referrer_partner_id='.(int)$partner['id'])->fetch()['c']; $stats['pending_withdrawals']=(int)db()->query('SELECT COUNT(*) c FROM withdrawals WHERE partner_id='.(int)$partner['id'].' AND status IN ("solicitado","en_revision")')->fetch()['c']; }
}else{
 $stats['capital']=(float)db()->query('SELECT COALESCE(SUM(capital_usd),0) s FROM partners')->fetch()['s'];
 $stats['gains']=(float)db()->query('SELECT COALESCE(SUM(gains_usd),0) s FROM partners')->fetch()['s'];
 $stats['partners']=(int)db()->query('SELECT COUNT(*) c FROM partners WHERE status="active"')->fetch()['c'];
 $stats['pending_withdrawals']=(int)db()->query('SELECT COUNT(*) c FROM withdrawals WHERE status IN ("solicitado","en_revision")')->fetch()['c'];
}
$trend=db()->query('SELECT DATE_FORMAT(profit_date,"%d/%m") label, gross_profit_usd value FROM broker_profits ORDER BY profit_date ASC LIMIT 12')->fetchAll();
out(true,['role'=>$role,'stats'=>$stats,'trend'=>$trend]);?>
