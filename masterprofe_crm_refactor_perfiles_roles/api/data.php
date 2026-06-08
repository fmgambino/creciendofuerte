<?php require_once 'helpers.php'; $u=need_login();
$entity=preg_replace('/[^a-z_]/','',$_GET['entity']??'users'); $wherePartner='';
$partnerId=0; if(in_array($u['role'],['socio','referido'],true)){ $q=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1'); $q->execute([$u['id'],$u['email']]); $partnerId=(int)($q->fetch()['id']??0); }
$map=[
'users'=>'SELECT id,full_name,email,phone,role,status,profile_photo,created_at FROM users ORDER BY id DESC',
'partners'=>'SELECT id,partner_code,full_name,email,phone,capital_usd,gains_usd,kyc_status,status,joined_at FROM partners '.($partnerId?'WHERE id='.$partnerId:'').' ORDER BY id DESC',
'referrals'=>'SELECT r.id,p.full_name referrer,r.referred_name,r.referred_email,r.capital_usd,r.commission_percent,r.status,r.created_at FROM referrals r JOIN partners p ON p.id=r.referrer_partner_id '.($partnerId?'WHERE r.referrer_partner_id='.$partnerId:'').' ORDER BY r.id DESC',
'broker_profits'=>'SELECT id,profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes,created_at FROM broker_profits ORDER BY id DESC',
'distributions'=>'SELECT d.id,b.profit_date,p.full_name partner,d.amount_usd,d.percent_share,d.status,d.created_at FROM distributions d LEFT JOIN broker_profits b ON b.id=d.broker_profit_id JOIN partners p ON p.id=d.partner_id '.($partnerId?'WHERE d.partner_id='.$partnerId:'').' ORDER BY d.id DESC',
'withdrawals'=>'SELECT w.id,p.full_name partner,w.partner_id,w.amount_usd,w.request_type,w.destination,w.status,w.created_at FROM withdrawals w JOIN partners p ON p.id=w.partner_id '.($partnerId?'WHERE w.partner_id='.$partnerId:'').' ORDER BY w.id DESC',
'whatsapp_numbers'=>'SELECT * FROM whatsapp_numbers ORDER BY id DESC',
'notifications'=>'SELECT * FROM notifications ORDER BY id DESC',
'audit_logs'=>'SELECT * FROM audit_logs ORDER BY id DESC LIMIT 200'];
if(!isset($map[$entity])) out(false,['message'=>'Entidad inválida'],400);
out(true,['rows'=>db()->query($map[$entity])->fetchAll()]);
?>
