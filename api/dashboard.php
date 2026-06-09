<?php require_once 'helpers.php'; $u=need_login();
$from = clean($_GET['from'] ?? '');
$to = clean($_GET['to'] ?? '');
$partner = (int)($_GET['partner_id'] ?? 0);
$referrer = (int)($_GET['referrer_partner_id'] ?? 0);
$type = clean($_GET['type'] ?? 'line');
$where=[]; $params=[];
if($from){ $where[]='bp.profit_date >= ?'; $params[]=$from; }
if($to){ $where[]='bp.profit_date <= ?'; $params[]=$to; }
$w = $where ? 'WHERE '.implode(' AND ', $where) : '';

$myPartnerId=null;
if(($u['role']??'')==='socio'){
  $st=db()->prepare('SELECT id FROM partners WHERE user_id=? OR email=? LIMIT 1');
  $st->execute([$u['id'],$u['email']]);
  $myPartnerId=(int)$st->fetchColumn();
  if($myPartnerId) $partner=$myPartnerId;
}

$activePartners=(int)db()->query('SELECT COUNT(*) c FROM partners WHERE status="active"')->fetch()['c'];
$totalBrokerSql='SELECT COALESCE(SUM(bp.gross_profit_usd),0) c FROM broker_profits bp '.$w;
$st=db()->prepare($totalBrokerSql); $st->execute($params); $brokerTotal=(float)$st->fetch()['c'];
$partnersPool=round($brokerTotal*0.40,2);
$perPartner=$activePartners>0 ? round($partnersPool/$activePartners,2) : 0;

$stats=[];
if(($u['role']??'')==='socio' && $myPartnerId){
  $st=db()->prepare('SELECT COALESCE(capital_usd,0) capital, COALESCE(gains_usd,0) gains FROM partners WHERE id=?'); $st->execute([$myPartnerId]); $row=$st->fetch() ?: ['capital'=>0,'gains'=>0];
  $stats['capital']=$row['capital'];
  $stats['broker_total']=$brokerTotal;
  $stats['partners_pool']=$partnersPool;
  $stats['per_partner']=$perPartner;
  $stats['gains']=$row['gains'];
  $stats['partners']=1;
  $st=db()->prepare("SELECT COUNT(*) c FROM withdrawals WHERE partner_id=? AND status IN('solicitado','pendiente','en_revision','en_proceso')"); $st->execute([$myPartnerId]); $stats['pending_withdrawals']=$st->fetch()['c'];
} else {
  $stats['partners']=$activePartners;
  $stats['capital']=(float)db()->query('SELECT COALESCE(SUM(capital_usd),0) c FROM partners WHERE status="active"')->fetch()['c'];
  $stats['broker_total']=$brokerTotal;
  $stats['partners_pool']=$partnersPool;
  $stats['per_partner']=$perPartner;
  $stats['gains']=$perPartner;
  $stats['pending_withdrawals']=db()->query("SELECT COUNT(*) c FROM withdrawals WHERE status IN('solicitado','pendiente','en_revision','en_proceso')")->fetch()['c'];
}

if($partner){
  $sql='SELECT DATE_FORMAT(bp.profit_date,"%d/%m") label, SUM(d.amount_usd) value FROM distributions d JOIN broker_profits bp ON bp.id=d.broker_profit_id WHERE d.partner_id=?';
  $p=[$partner];
  if($from){$sql.=' AND bp.profit_date>=?';$p[]=$from;} if($to){$sql.=' AND bp.profit_date<=?';$p[]=$to;}
  $sql.=' GROUP BY bp.profit_date ORDER BY bp.profit_date ASC LIMIT 60';
  $st=db()->prepare($sql); $st->execute($p); $trend=$st->fetchAll();
} elseif($referrer){
  $sql='SELECT DATE_FORMAT(created_at,"%d/%m") label, SUM(capital_usd) value FROM referrals WHERE referrer_partner_id=?';
  $p=[$referrer]; if($from){$sql.=' AND DATE(created_at)>=?';$p[]=$from;} if($to){$sql.=' AND DATE(created_at)<=?';$p[]=$to;}
  $sql.=' GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC LIMIT 60';
  $st=db()->prepare($sql); $st->execute($p); $trend=$st->fetchAll();
} else {
  $sql='SELECT DATE_FORMAT(bp.profit_date,"%d/%m") label, SUM(bp.gross_profit_usd) value FROM broker_profits bp '.$w.' GROUP BY bp.profit_date ORDER BY bp.profit_date ASC LIMIT 60';
  $st=db()->prepare($sql); $st->execute($params); $trend=$st->fetchAll();
}
if(!$trend) $trend=[['label'=>date('d/m'),'value'=>0]];
out(true,['stats'=>$stats,'trend'=>$trend,'chart_type'=>$type]);
?>
