<?php require_once 'helpers.php'; $u=need_login();
$entity=preg_replace('/[^a-z_]/','',$_GET['entity']??'users');
$myPartnerId=null;
if(($u['role']??'')==='socio'){
  $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1'); $st->execute([$u['id'],$u['email']]); $myPartnerId=$st->fetchColumn();
}
$map=[
'users'=>'SELECT id,full_name,email,role,status,profile_photo,created_at FROM users ORDER BY id DESC',
'partners'=>'SELECT id,partner_code,full_name,email,phone,address,bank_account,capital_usd,gains_usd,kyc_status,status,joined_at FROM partners ORDER BY id DESC',
'referrals'=>'SELECT r.id,p.full_name referrer,r.referrer_partner_id,r.referred_name,r.referred_email,r.capital_usd,r.commission_percent,r.status,r.created_at FROM referrals r JOIN partners p ON p.id=r.referrer_partner_id ORDER BY r.id DESC',
'broker_profits'=>'SELECT id,profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes,created_at FROM broker_profits ORDER BY id DESC',
'distributions'=>'SELECT d.id,b.profit_date,p.full_name partner,p.capital_usd partner_capital,d.partner_id,p.gains_usd AS amount_usd,d.percent_share,d.status,d.created_at FROM distributions d LEFT JOIN broker_profits b ON b.id=d.broker_profit_id JOIN partners p ON p.id=d.partner_id ORDER BY d.id DESC',
'capital_levels'=>'SELECT * FROM capital_levels ORDER BY amount_usd ASC',
'withdrawals'=>'SELECT w.id,p.full_name partner,w.partner_id,w.amount_usd,w.request_type,w.destination,w.status,w.created_at FROM withdrawals w JOIN partners p ON p.id=w.partner_id ORDER BY w.id DESC',
'whatsapp_numbers'=>'SELECT * FROM whatsapp_numbers ORDER BY id DESC',
'notifications'=>'SELECT * FROM notifications ORDER BY id DESC',
'audit_logs'=>'SELECT * FROM audit_logs ORDER BY id DESC LIMIT 200',
'app_settings'=>'SELECT key_name,value,updated_at FROM app_settings ORDER BY key_name'];
if(!isset($map[$entity])) out(false,['message'=>'Entidad inválida'],400);
$sql=$map[$entity]; $params=[];
if(($u['role']??'')==='socio' && $myPartnerId){
 if($entity==='referrals'){ $sql='SELECT r.id,p.full_name referrer,r.referrer_partner_id,r.referred_name,r.referred_email,r.capital_usd,r.commission_percent,r.status,r.created_at FROM referrals r JOIN partners p ON p.id=r.referrer_partner_id WHERE r.referrer_partner_id=? ORDER BY r.id DESC'; $params=[$myPartnerId]; }
 if($entity==='distributions'){ $sql='SELECT d.id,b.profit_date,p.full_name partner,p.capital_usd partner_capital,d.partner_id,p.gains_usd AS amount_usd,d.percent_share,d.status,d.created_at FROM distributions d LEFT JOIN broker_profits b ON b.id=d.broker_profit_id JOIN partners p ON p.id=d.partner_id WHERE d.partner_id=? ORDER BY d.id DESC'; $params=[$myPartnerId]; }
 if($entity==='withdrawals'){ $sql='SELECT w.id,p.full_name partner,w.partner_id,w.amount_usd,w.request_type,w.destination,w.status,w.created_at FROM withdrawals w JOIN partners p ON p.id=w.partner_id WHERE w.partner_id=? ORDER BY w.id DESC'; $params=[$myPartnerId]; }
 if($entity==='partners'){ $sql='SELECT id,partner_code,full_name,email,phone,address,bank_account,capital_usd,gains_usd,kyc_status,status,joined_at FROM partners WHERE id=?'; $params=[$myPartnerId]; }
}
$st=db()->prepare($sql); $st->execute($params); out(true,['rows'=>$st->fetchAll()]);
?>
