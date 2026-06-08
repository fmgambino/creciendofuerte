<?php require_once 'helpers.php'; need_login();
$entity=preg_replace('/[^a-z_]/','',$_GET['entity']??'users');
$map=[
'users'=>'SELECT id,full_name,email,role,status,profile_photo,created_at FROM users ORDER BY id DESC',
'partners'=>'SELECT id,partner_code,full_name,email,phone,capital_usd,gains_usd,kyc_status,status,joined_at FROM partners ORDER BY id DESC',
'referrals'=>'SELECT r.id,p.full_name referrer,r.referred_name,r.referred_email,r.capital_usd,r.commission_percent,r.status,r.created_at FROM referrals r JOIN partners p ON p.id=r.referrer_partner_id ORDER BY r.id DESC',
'broker_profits'=>'SELECT * FROM broker_profits ORDER BY id DESC',
'distributions'=>'SELECT d.id,b.profit_date,p.full_name partner,d.amount_usd,d.percent_share,d.status,d.created_at FROM distributions d LEFT JOIN broker_profits b ON b.id=d.broker_profit_id JOIN partners p ON p.id=d.partner_id ORDER BY d.id DESC',
'withdrawals'=>'SELECT w.id,p.full_name partner,w.amount_usd,w.request_type,w.destination,w.status,w.created_at FROM withdrawals w JOIN partners p ON p.id=w.partner_id ORDER BY w.id DESC',
'whatsapp_numbers'=>'SELECT * FROM whatsapp_numbers ORDER BY id DESC',
'notifications'=>'SELECT * FROM notifications ORDER BY id DESC',
'audit_logs'=>'SELECT * FROM audit_logs ORDER BY id DESC LIMIT 200'];
if(!isset($map[$entity])) out(false,['message'=>'Entidad inválida'],400);
out(true,['rows'=>db()->query($map[$entity])->fetchAll()]);
?>
