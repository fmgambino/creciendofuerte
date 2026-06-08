<?php
require_once __DIR__.'/helpers.php'; require_api_auth();
$d=input(); $module=$d['module']??''; $id=(int)($d['id']??0); $pdo=db();
try{
 if($module==='users'){
   if($id){$pdo->prepare('UPDATE users SET full_name=?,email=?,role=?,status=? WHERE id=?')->execute([$d['full_name'],$d['email'],$d['role'],$d['status'],$id]);}
   else{$pdo->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,?)')->execute([$d['full_name'],$d['email'],password_hash($d['password']?:'Demo1234',PASSWORD_BCRYPT),$d['role'],$d['status']]);}
 }
 if($module==='partners'){
   if($id){$pdo->prepare('UPDATE partners SET full_name=?,email=?,partner_code=?,capital_usd=?,kyc_status=?,status=?,bank_data=? WHERE id=?')->execute([$d['full_name'],$d['email'],$d['partner_code'],$d['capital_usd'],$d['kyc_status'],$d['status'],$d['bank_data'],$id]);}
   else{$pdo->prepare('INSERT INTO partners(full_name,email,partner_code,capital_usd,kyc_status,status,bank_data,join_date) VALUES(?,?,?,?,?,?,?,CURDATE())')->execute([$d['full_name'],$d['email'],$d['partner_code'],$d['capital_usd'],$d['kyc_status'],$d['status'],$d['bank_data']]);}
 }
 if($module==='withdrawals'){
   if($id){$pdo->prepare('UPDATE withdrawals SET status=?,admin_notes=? WHERE id=?')->execute([$d['status'],$d['admin_notes']??'',$id]);}
   else{$pdo->prepare('INSERT INTO withdrawals(partner_id,amount_usd,type,account,status) VALUES(?,?,?,?,"requested")')->execute([$d['partner_id'],$d['amount_usd'],$d['type'],$d['account']]);}
 }
 if($module==='whatsapp'){
   if($id){$pdo->prepare('UPDATE whatsapp_numbers SET label=?,phone=?,message=?,active=? WHERE id=?')->execute([$d['label'],$d['phone'],$d['message'],!empty($d['active'])?1:0,$id]);}
   else{$pdo->prepare('INSERT INTO whatsapp_numbers(label,phone,message,active) VALUES(?,?,?,?)')->execute([$d['label'],$d['phone'],$d['message'],!empty($d['active'])?1:0]);}
 }
 if($module==='referrals'){
   if($id){$pdo->prepare('UPDATE referrals SET invited_name=?,invited_email=?,commission_percent=?,capital_bonus_percent=?,status=? WHERE id=?')->execute([$d['invited_name'],$d['invited_email'],$d['commission_percent'],$d['capital_bonus_percent'],$d['status'],$id]);}
   else{$pdo->prepare('INSERT INTO referrals(partner_id,invited_name,invited_email,ref_code,commission_percent,capital_bonus_percent,status) VALUES(?,?,?,?,?,?,?)')->execute([$d['partner_id'],$d['invited_name'],$d['invited_email'],'REF-'.rand(1000,9999),$d['commission_percent'],$d['capital_bonus_percent'],$d['status']]);}
 }
 if($module==='profits'){
   $gross=(float)$d['gross_profit_usd']; $admin=$gross*.60; $pool=$gross*.40;
   $pdo->prepare('INSERT INTO broker_profits(profit_date,gross_profit_usd,admin_share_usd,partners_pool_usd,notes,created_by) VALUES(?,?,?,?,?,?)')->execute([$d['profit_date'],$gross,$admin,$pool,$d['notes']??'',current_user()['id']]);
   $profitId=$pdo->lastInsertId(); $total=(float)$pdo->query("SELECT COALESCE(SUM(capital_usd),0) FROM partners WHERE status='active'")->fetchColumn();
   foreach($pdo->query("SELECT id,capital_usd FROM partners WHERE status='active'") as $p){$pct=$total>0?($p['capital_usd']/$total*100):0; $amt=$pool*$pct/100; $pdo->prepare('INSERT INTO distributions(broker_profit_id,partner_id,capital_at_distribution,participation_percent,amount_usd) VALUES(?,?,?,?,?)')->execute([$profitId,$p['id'],$p['capital_usd'],$pct,$amt]);}
 }
 log_event('Guardó datos en '.$module,$module); json_ok();
}catch(Throwable $e){json_err($e->getMessage(),500);} ?>
