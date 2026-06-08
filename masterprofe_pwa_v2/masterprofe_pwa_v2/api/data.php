<?php
require_once __DIR__.'/helpers.php'; require_api_auth();
$pdo=db(); $m=$_GET['module']??'dashboard';
function all($sql){return db()->query($sql)->fetchAll();}
if($m==='dashboard'){
 $k=$pdo->query("SELECT COALESCE(SUM(capital_usd),0) capital, COUNT(*) partners FROM partners WHERE status='active'")->fetch();
 $g=$pdo->query("SELECT COALESCE(SUM(gross_profit_usd),0) gross, COALESCE(SUM(partners_pool_usd),0) pool FROM broker_profits")->fetch();
 $w=$pdo->query("SELECT COALESCE(SUM(amount_usd),0) pending FROM withdrawals WHERE status IN('requested','review')")->fetch();
 $trend=all("SELECT DATE_FORMAT(profit_date,'%d/%m') label, gross_profit_usd value FROM broker_profits ORDER BY profit_date DESC LIMIT 12");
 json_ok(['cards'=>['capital'=>(float)$k['capital'],'partners'=>(int)$k['partners'],'gross'=>(float)$g['gross'],'pool'=>(float)$g['pool'],'pending'=>(float)$w['pending']], 'trend'=>array_reverse($trend)]);
}
$map=[
 'users'=>'SELECT id,full_name,email,role,status,created_at FROM users ORDER BY id DESC',
 'partners'=>'SELECT * FROM partners ORDER BY id DESC',
 'profits'=>'SELECT * FROM broker_profits ORDER BY profit_date DESC',
 'distributions'=>'SELECT d.*, p.full_name partner FROM distributions d LEFT JOIN partners p ON p.id=d.partner_id ORDER BY d.id DESC',
 'withdrawals'=>'SELECT w.*, p.full_name partner FROM withdrawals w LEFT JOIN partners p ON p.id=w.partner_id ORDER BY w.id DESC',
 'referrals'=>'SELECT r.*, p.full_name partner FROM referrals r LEFT JOIN partners p ON p.id=r.partner_id ORDER BY r.id DESC',
 'employees'=>'SELECT id,full_name,email,role,status,created_at FROM users WHERE role="employee" ORDER BY id DESC',
 'audit'=>'SELECT * FROM audit_logs ORDER BY id DESC LIMIT 100',
 'whatsapp'=>'SELECT * FROM whatsapp_numbers ORDER BY id DESC',
 'notifications'=>'SELECT * FROM notifications ORDER BY id DESC LIMIT 80',
 'roles'=>'SELECT * FROM role_permissions ORDER BY module ASC'
];
if(!isset($map[$m])) json_err('Módulo inválido');
json_ok(['rows'=>all($map[$m])]);
?>
