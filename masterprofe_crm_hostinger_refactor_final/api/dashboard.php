<?php require_once 'helpers.php'; need_login();
$stats=[]; $stats['users']=db()->query('SELECT COUNT(*) c FROM users')->fetch()['c']; $stats['partners']=db()->query('SELECT COUNT(*) c FROM partners')->fetch()['c'];
$stats['capital']=db()->query('SELECT COALESCE(SUM(capital_usd),0) c FROM partners')->fetch()['c']; $stats['gains']=db()->query('SELECT COALESCE(SUM(gains_usd),0) c FROM partners')->fetch()['c'];
$stats['pending_withdrawals']=db()->query("SELECT COUNT(*) c FROM withdrawals WHERE status IN('solicitado','en_revision')")->fetch()['c'];
$trend=db()->query('SELECT DATE_FORMAT(profit_date,"%d/%m") label,gross_profit_usd value FROM broker_profits ORDER BY profit_date DESC LIMIT 12')->fetchAll();
out(true,['stats'=>$stats,'trend'=>array_reverse($trend)]);
?>
