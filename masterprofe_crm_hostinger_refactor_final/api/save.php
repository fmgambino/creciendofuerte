<?php require_once 'helpers.php'; $u=need_login();
$entity=preg_replace('/[^a-z_]/','',$_POST['entity']??''); $id=(int)($_POST['id']??0);
try{
 if($entity==='users'){
  $fields=['full_name'=>clean($_POST['full_name']??''),'email'=>clean($_POST['email']??''),'role'=>clean($_POST['role']??'socio'),'status'=>clean($_POST['status']??'active')];
  $plainPassword = trim((string)($_POST['password'] ?? ''));

  if($id){
    if($plainPassword !== ''){
      $hash=password_hash($plainPassword, PASSWORD_DEFAULT);
      db()->prepare('UPDATE users SET full_name=?,email=?,password_hash=?,role=?,status=? WHERE id=?')
        ->execute([$fields['full_name'],$fields['email'],$hash,$fields['role'],$fields['status'],$id]);
    } else {
      db()->prepare('UPDATE users SET full_name=?,email=?,role=?,status=? WHERE id=?')
        ->execute([$fields['full_name'],$fields['email'],$fields['role'],$fields['status'],$id]);
    }
  }
  else {
    $hash=password_hash($plainPassword !== '' ? $plainPassword : 'Demo1234', PASSWORD_DEFAULT);
    db()->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,?)')->execute([$fields['full_name'],$fields['email'],$hash,$fields['role'],$fields['status']]);
    notify('Nuevo usuario','Se creó el usuario '.$fields['full_name'],'usuario');
  }
 }
 elseif($entity==='partners'){
  $vals=[clean($_POST['partner_code']??('MSTR-'.rand(1000,9999))),clean($_POST['full_name']??''),clean($_POST['email']??''),clean($_POST['phone']??''),clean($_POST['address']??''),clean($_POST['bank_account']??''),(float)($_POST['capital_usd']??0),(float)($_POST['gains_usd']??0),clean($_POST['kyc_status']??'pendiente'),clean($_POST['status']??'active'),clean($_POST['joined_at']??date('Y-m-d'))];
  if($id){ db()->prepare('UPDATE partners SET partner_code=?,full_name=?,email=?,phone=?,address=?,bank_account=?,capital_usd=?,gains_usd=?,kyc_status=?,status=?,joined_at=? WHERE id=?')->execute([...$vals,$id]); }
  else { db()->prepare('INSERT INTO partners(partner_code,full_name,email,phone,address,bank_account,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES(?,?,?,?,?,?,?,?,?,?,?)')->execute($vals); notify('Nuevo socio','Se creó el socio '.$vals[1],'socio'); }
 }
 elseif($entity==='referrals'){
  $vals=[(int)$_POST['referrer_partner_id'],clean($_POST['referred_name']??''),clean($_POST['referred_email']??''),(float)$_POST['capital_usd'],(float)$_POST['commission_percent'],clean($_POST['status']??'nuevo')];
  if($id) db()->prepare('UPDATE referrals SET referrer_partner_id=?,referred_name=?,referred_email=?,capital_usd=?,commission_percent=?,status=? WHERE id=?')->execute([...$vals,$id]);
  else { db()->prepare('INSERT INTO referrals(referrer_partner_id,referred_name,referred_email,capital_usd,commission_percent,status) VALUES(?,?,?,?,?,?)')->execute($vals); notify('Nuevo referido','Se registró '.$vals[1],'referido'); }
 }
 elseif($entity==='broker_profits'){
  $gross=(float)$_POST['gross_profit_usd']; $master=round($gross*.60,2); $partners=round($gross*.40,2); $date=clean($_POST['profit_date']??date('Y-m-d')); $notes=clean($_POST['notes']??'');
  if($id) db()->prepare('UPDATE broker_profits SET profit_date=?,gross_profit_usd=?,master_share_usd=?,partners_share_usd=?,notes=? WHERE id=?')->execute([$date,$gross,$master,$partners,$notes,$id]);
  else { db()->prepare('INSERT INTO broker_profits(profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes) VALUES(?,?,?,?,?)')->execute([$date,$gross,$master,$partners,$notes]); $pid=db()->lastInsertId(); $total=(float)db()->query('SELECT SUM(capital_usd) s FROM partners WHERE status="active"')->fetch()['s']; if($total>0){foreach(db()->query('SELECT id,capital_usd FROM partners WHERE status="active"') as $p){$pct=$p['capital_usd']/$total*100; $amt=$partners*$p['capital_usd']/$total; db()->prepare('INSERT INTO distributions(broker_profit_id,partner_id,amount_usd,percent_share,status) VALUES(?,?,?,?,"acreditado")')->execute([$pid,$p['id'],$amt,$pct]); db()->prepare('UPDATE partners SET gains_usd=gains_usd+? WHERE id=?')->execute([$amt,$p['id']]);}} notify('Nueva repartición de ganancias','Se distribuyó el 40% a socios.','distribucion'); }
 }
 elseif($entity==='withdrawals'){
  $vals=[(int)$_POST['partner_id'],(float)$_POST['amount_usd'],clean($_POST['request_type']??'ganancias'),clean($_POST['destination']??''),clean($_POST['status']??'solicitado')];
  if($id) db()->prepare('UPDATE withdrawals SET partner_id=?,amount_usd=?,request_type=?,destination=?,status=? WHERE id=?')->execute([...$vals,$id]);
  else { db()->prepare('INSERT INTO withdrawals(partner_id,amount_usd,request_type,destination,status) VALUES(?,?,?,?,?)')->execute($vals); notify('Nuevo retiro solicitado','Se solicitó un retiro.','retiro'); }
 }
 elseif($entity==='whatsapp_numbers'){
  $vals=[clean($_POST['label']??''),clean($_POST['phone']??''),clean($_POST['message']??''),clean($_POST['status']??'active')];
  if($id) db()->prepare('UPDATE whatsapp_numbers SET label=?,phone=?,message=?,status=? WHERE id=?')->execute([...$vals,$id]); else db()->prepare('INSERT INTO whatsapp_numbers(label,phone,message,status) VALUES(?,?,?,?)')->execute($vals);
 }
 else out(false,['message'=>'Entidad no soportada'],400);
 audit('Guardó '.$entity,'crud'); out(true,['message'=>'Guardado correctamente']);
}catch(Throwable $e){ out(false,['message'=>$e->getMessage()],500); }
?>
