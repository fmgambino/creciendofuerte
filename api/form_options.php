<?php require_once 'helpers.php'; $u=need_login();
if(($u['role']??'')==='socio'){
  $st=db()->prepare('SELECT id,full_name,bank_account,gains_usd FROM partners WHERE user_id=? OR email=? ORDER BY full_name');
  $st->execute([$u['id'],$u['email']]);
  $partners=$st->fetchAll();
} else {
  $partners=db()->query('SELECT id,full_name,bank_account,gains_usd FROM partners ORDER BY full_name')->fetchAll();
}
$levels=[];
try{$levels=db()->query('SELECT id,name,amount_usd,percent_share,status FROM capital_levels ORDER BY amount_usd')->fetchAll();}catch(Throwable $e){}
out(true,['partners'=>$partners,'capital_levels'=>$levels]); ?>