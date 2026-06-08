<?php
require_once __DIR__.'/helpers.php'; require_login();
$module=$_GET['module']??'dashboard';
$tables=['users'=>'users','roles'=>'roles','partners'=>'partners','referrals'=>'referrals','withdrawals'=>'withdrawals','profits'=>'broker_profits','distributions'=>'distributions','whatsapp'=>'whatsapp_numbers','notifications'=>'notifications','audit'=>'audit_logs'];
if($module==='dashboard'){
 $pdo=db();
 $capital=$pdo->query('SELECT COALESCE(SUM(capital_usd),0) v FROM partners')->fetch()['v'];
 $profits=$pdo->query('SELECT COALESCE(SUM(gross_profit_usd),0) v FROM broker_profits')->fetch()['v'];
 $pending=$pdo->query('SELECT COALESCE(SUM(amount_usd),0) v FROM withdrawals WHERE status IN ("solicitado","revision")')->fetch()['v'];
 $partners=$pdo->query('SELECT COUNT(*) v FROM partners')->fetch()['v'];
 $chart=$pdo->query('SELECT DATE_FORMAT(profit_date,"%d/%m") label, gross_profit_usd value FROM broker_profits ORDER BY profit_date DESC LIMIT 12')->fetchAll();
 json_ok(['cards'=>['capital'=>$capital,'profits'=>$profits,'pending'=>$pending,'partners'=>$partners],'chart'=>array_reverse($chart)]);
}
if(!isset($tables[$module])) json_fail('Módulo inválido');
$rows=db()->query('SELECT * FROM '.$tables[$module].' ORDER BY id DESC LIMIT 500')->fetchAll();
json_ok(['rows'=>$rows]);
