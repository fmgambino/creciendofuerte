<?php
require_once __DIR__.'/helpers.php'; require_login();
$d=body(); $module=$d['module']??''; $id=(int)($d['id']??0); unset($d['module']);
$map=['users'=>'users','partners'=>'partners','referrals'=>'referrals','withdrawals'=>'withdrawals','profits'=>'broker_profits','whatsapp'=>'whatsapp_numbers','notifications'=>'notifications'];
if(!isset($map[$module])) json_fail('Módulo no editable');
$table=$map[$module];
if($module==='users' && !empty($d['password'])){ $d['password_hash']=password_hash($d['password'], PASSWORD_DEFAULT); unset($d['password']); } else unset($d['password']);
if($module==='profits' && isset($d['gross_profit_usd'])){
 $gross=(float)$d['gross_profit_usd']; $d['master_share_usd']=money($gross*0.60); $d['partners_share_usd']=money($gross*0.40);
}
$cols=array_keys($d);
if($id>0){ $set=implode(',',array_map(fn($c)=>"$c=?",$cols)); $vals=array_values($d); $vals[]=$id; db()->prepare("UPDATE $table SET $set WHERE id=?")->execute($vals); }
else { $ph=implode(',',array_fill(0,count($cols),'?')); db()->prepare("INSERT INTO $table (".implode(',',$cols).") VALUES ($ph)")->execute(array_values($d)); }
json_ok();
