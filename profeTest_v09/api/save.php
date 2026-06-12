<?php require_once 'helpers.php'; $u=need_login();
$entity=preg_replace('/[^a-z_]/','',$_POST['entity']??''); $id=(int)($_POST['id']??0);
function current_partner_id_for_user($u){
  $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1');
  $st->execute([$u['id']??0,$u['email']??'']);
  return (int)$st->fetchColumn();
}
function ensure_partner_user($partnerId,$fullName,$email,$status='active'){
  $email=trim((string)$email); if($email==='') return null;
  $st=db()->prepare('SELECT id FROM users WHERE email=? LIMIT 1'); $st->execute([$email]);
  $uid=(int)$st->fetchColumn();
  if($uid){
    db()->prepare('UPDATE users SET full_name=?, role="socio", status=? WHERE id=?')->execute([$fullName,$status,$uid]);
  } else {
    $hash=password_hash('Demo1234', PASSWORD_DEFAULT);
    db()->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,?)')->execute([$fullName,$email,$hash,'socio',$status]);
    $uid=(int)db()->lastInsertId();
  }
  db()->prepare('UPDATE partners SET user_id=? WHERE id=?')->execute([$uid,$partnerId]);
  return $uid;
}
try{
 if($entity==='users'){
  $fields=['full_name'=>clean($_POST['full_name']??''),'email'=>clean($_POST['email']??''),'role'=>clean($_POST['role']??'socio'),'status'=>clean($_POST['status']??'active')];
  $plainPassword = trim((string)($_POST['password'] ?? ''));
  if($id){
    if($plainPassword !== ''){
      $hash=password_hash($plainPassword, PASSWORD_DEFAULT);
      db()->prepare('UPDATE users SET full_name=?,email=?,password_hash=?,role=?,status=? WHERE id=?')->execute([$fields['full_name'],$fields['email'],$hash,$fields['role'],$fields['status'],$id]);
    } else {
      db()->prepare('UPDATE users SET full_name=?,email=?,role=?,status=? WHERE id=?')->execute([$fields['full_name'],$fields['email'],$fields['role'],$fields['status'],$id]);
    }
    if($fields['role']==='socio'){
      $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1'); $st->execute([$id,$fields['email']]); $pid=(int)$st->fetchColumn();
      if($pid){ db()->prepare('UPDATE partners SET user_id=?, full_name=?, email=?, status=? WHERE id=?')->execute([$id,$fields['full_name'],$fields['email'],$fields['status'],$pid]); }
    }
  } else {
    $hash=password_hash($plainPassword !== '' ? $plainPassword : 'Demo1234', PASSWORD_DEFAULT);
    db()->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,?)')->execute([$fields['full_name'],$fields['email'],$hash,$fields['role'],$fields['status']]);
    $newUserId=(int)db()->lastInsertId();
    if($fields['role']==='socio'){
      $code='MSTR-'.strtoupper(substr(preg_replace('/[^a-z0-9]/i','',$fields['full_name']),0,4)).'-'.str_pad((string)$newUserId,4,'0',STR_PAD_LEFT);
      db()->prepare('INSERT INTO partners(user_id,partner_code,full_name,email,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES(?,?,?,?,0,0,"pendiente",?,CURDATE())')->execute([$newUserId,$code,$fields['full_name'],$fields['email'],$fields['status']]);
    }
    notify('Nuevo usuario','Se creó el usuario '.$fields['full_name'],'usuario',null,null,'admin');
  }
 }
 elseif($entity==='partners'){
  $vals=[clean($_POST['partner_code']??('MSTR-'.rand(1000,9999))),clean($_POST['full_name']??''),clean($_POST['email']??''),clean($_POST['phone']??''),clean($_POST['address']??''),clean($_POST['bank_account']??''),(float)($_POST['capital_usd']??0),(float)($_POST['gains_usd']??0),clean($_POST['kyc_status']??'pendiente'),clean($_POST['status']??'active'),clean($_POST['joined_at']??date('Y-m-d'))];
  if($id){
    db()->prepare('UPDATE partners SET partner_code=?,full_name=?,email=?,phone=?,address=?,bank_account=?,capital_usd=?,gains_usd=?,kyc_status=?,status=?,joined_at=? WHERE id=?')->execute([...$vals,$id]);
    ensure_partner_user($id,$vals[1],$vals[2],$vals[9]);
  } else {
    db()->prepare('INSERT INTO partners(partner_code,full_name,email,phone,address,bank_account,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES(?,?,?,?,?,?,?,?,?,?,?)')->execute($vals);
    $pid=(int)db()->lastInsertId(); ensure_partner_user($pid,$vals[1],$vals[2],$vals[9]); notify('Nuevo socio','Se creó el socio '.$vals[1],'socio',null,null,'admin');
  }
 }
 elseif($entity==='referrals'){
  if(($u['role']??'')==='socio') $_POST['referrer_partner_id']=current_partner_id_for_user($u);
  $vals=[(int)$_POST['referrer_partner_id'],clean($_POST['referred_name']??''),clean($_POST['referred_email']??''),(float)$_POST['capital_usd'],(float)$_POST['commission_percent'],clean($_POST['status']??'nuevo')];
  if($id) db()->prepare('UPDATE referrals SET referrer_partner_id=?,referred_name=?,referred_email=?,capital_usd=?,commission_percent=?,status=? WHERE id=?')->execute([...$vals,$id]);
  else { db()->prepare('INSERT INTO referrals(referrer_partner_id,referred_name,referred_email,capital_usd,commission_percent,status) VALUES(?,?,?,?,?,?)')->execute($vals); notify('Nuevo referido','Se registró '.$vals[1],'referido',null,(int)$vals[0],'partner'); notify('Nuevo referido','El socio registró un referido.','referido',null,null,'admin'); }
 }
 elseif($entity==='broker_profits'){
  $gross=(float)$_POST['gross_profit_usd']; $master=round($gross*.60,2); $partners=round($gross*.40,2); $date=clean($_POST['profit_date']??date('Y-m-d')); $notes=clean($_POST['notes']??'');
  if($id) db()->prepare('UPDATE broker_profits SET profit_date=?,gross_profit_usd=?,master_share_usd=?,partners_share_usd=?,notes=? WHERE id=?')->execute([$date,$gross,$master,$partners,$notes,$id]);
  else { db()->prepare('INSERT INTO broker_profits(profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes) VALUES(?,?,?,?,?)')->execute([$date,$gross,$master,$partners,$notes]); $pid=db()->lastInsertId(); $active=db()->query('SELECT id FROM partners WHERE status="active" ORDER BY id ASC')->fetchAll(); $count=count($active); if($count>0){$pct=round(100/$count,4); $amt=round($partners/$count,2); foreach($active as $p){ db()->prepare('INSERT INTO distributions(broker_profit_id,partner_id,amount_usd,percent_share,status) VALUES(?,?,?,? ,"acreditado")')->execute([$pid,$p['id'],$amt,$pct]); db()->prepare('UPDATE partners SET gains_usd=gains_usd+? WHERE id=?')->execute([$amt,$p['id']]); }} sync_partner_gains(); foreach($active as $p){ notify('Repartición acreditada','Se acreditó la ganancia broker en tu cuenta.','distribucion',null,(int)$p['id'],'partner'); } notify('Nueva repartición de ganancias','Se distribuyó equitativamente el 40% a los socios activos.','distribucion',null,null,'admin'); }
 }
 elseif($entity==='distributions'){
  if(($u['role']??'')!=='superadmin') out(false,['message'=>'Solo SuperAdmin puede modificar distribuciones'],403);
  $vals=[(int)$_POST['partner_id'],(float)$_POST['amount_usd'],(float)$_POST['percent_share'],clean($_POST['status']??'acreditado')];
  if($id) db()->prepare('UPDATE distributions SET partner_id=?,amount_usd=?,percent_share=?,status=? WHERE id=?')->execute([...$vals,$id]);
  else db()->prepare('INSERT INTO distributions(partner_id,amount_usd,percent_share,status) VALUES(?,?,?,?)')->execute($vals);
 }
 elseif($entity==='capital_levels'){
  $vals=[clean($_POST['name']??''),(float)$_POST['amount_usd'],(float)$_POST['percent_share'],clean($_POST['status']??'active')];
  if($id) db()->prepare('UPDATE capital_levels SET name=?,amount_usd=?,percent_share=?,status=? WHERE id=?')->execute([...$vals,$id]);
  else db()->prepare('INSERT INTO capital_levels(name,amount_usd,percent_share,status) VALUES(?,?,?,?)')->execute($vals);
 }
 elseif($entity==='withdrawals'){
  $isSocio=($u['role']??'')==='socio';
  if($isSocio){
    $pid=current_partner_id_for_user($u); if(!$pid) out(false,['message'=>'No se encontró el perfil de socio vinculado a tu usuario.'],400);
    $amount=(float)$_POST['amount_usd'];
    $st=db()->prepare('SELECT gains_usd,bank_account FROM partners WHERE id=?'); $st->execute([$pid]); $pr=$st->fetch();
    if(!$pr) out(false,['message'=>'Socio inválido'],400);
    if($amount<=0) out(false,['message'=>'El monto debe ser mayor a cero'],400);
    if($amount>(float)$pr['gains_usd']) out(false,['message'=>'El monto supera tus ganancias acumuladas disponibles'],400);
    $dest=clean($_POST['destination']??($pr['bank_account']??''));
    if($id) out(false,['message'=>'Los socios no pueden editar una solicitud.'],403);
    db()->prepare('INSERT INTO withdrawals(partner_id,amount_usd,request_type,destination,status) VALUES(?,?,?,?,"pendiente")')->execute([$pid,$amount,'ganancias',$dest]);
    notify('Nuevo retiro solicitado','Solicitaste retirar US$ '.$amount.'.','retiro',null,$pid,'partner'); notify('Nuevo retiro solicitado',($u['full_name']??'Un socio').' solicitó retirar US$ '.$amount.'.','retiro',null,null,'admin');
  } else {
    $pid=(int)$_POST['partner_id']; $amount=(float)$_POST['amount_usd']; $type=clean($_POST['request_type']??'ganancias'); $dest=clean($_POST['destination']??''); $status=clean($_POST['status']??'pendiente');
    if($id){
      $st=db()->prepare('SELECT partner_id,amount_usd,status FROM withdrawals WHERE id=?'); $st->execute([$id]); $old=$st->fetch();
      db()->prepare('UPDATE withdrawals SET partner_id=?,amount_usd=?,request_type=?,destination=?,status=? WHERE id=?')->execute([$pid,$amount,$type,$dest,$status,$id]);
      if($old){
        $paidStatuses=['pagado','acreditado','transferido']; $wasPaid=in_array($old['status'],$paidStatuses,true); $nowPaid=in_array($status,$paidStatuses,true);
        if($wasPaid){ db()->prepare('UPDATE partners SET gains_usd=gains_usd+? WHERE id=?')->execute([(float)$old['amount_usd'],(int)$old['partner_id']]); }
        if($nowPaid){ sync_partner_gains($pid); notify('Retiro pagado','Se acreditó como pagado/transferido tu retiro de US$ '.$amount.'.','retiro',null,$pid,'partner'); }
      }
    } else {
      db()->prepare('INSERT INTO withdrawals(partner_id,amount_usd,request_type,destination,status) VALUES(?,?,?,?,?)')->execute([$pid,$amount,$type,$dest,$status]); notify('Nuevo retiro solicitado','Se registró un retiro en tu cuenta.','retiro',null,$pid,'partner'); notify('Nuevo retiro solicitado','Se solicitó un retiro.','retiro',null,null,'admin');
      if(in_array($status,['pagado','acreditado','transferido'],true)) sync_partner_gains($pid);
    }
  }
 }
 elseif($entity==='whatsapp_numbers'){
  $vals=[clean($_POST['label']??''),clean($_POST['phone']??''),clean($_POST['message']??''),clean($_POST['status']??'active')];
  if($id) db()->prepare('UPDATE whatsapp_numbers SET label=?,phone=?,message=?,status=? WHERE id=?')->execute([...$vals,$id]); else db()->prepare('INSERT INTO whatsapp_numbers(label,phone,message,status) VALUES(?,?,?,?)')->execute($vals);
 }
 else out(false,['message'=>'Entidad no soportada'],400);
 audit('Guardó '.$entity,'crud'); out(true,['message'=>'Guardado correctamente']);
}catch(Throwable $e){ out(false,['message'=>$e->getMessage()],500); }
?>