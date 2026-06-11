<?php
require_once 'helpers.php';
try {
  $tables = ['users','partners','broker_profits','distributions','capital_levels','withdrawals','referrals','permissions','notifications','audit_logs','whatsapp_numbers'];
  $out = [];
  foreach($tables as $t){
    try { $c = db()->query("SELECT COUNT(*) c FROM `$t`")->fetch()['c']; $out[$t] = ['ok'=>true,'rows'=>(int)$c]; }
    catch(Throwable $e){ $out[$t] = ['ok'=>false,'error'=>$e->getMessage()]; }
  }
  out(true, ['database'=>DB_NAME, 'php'=>PHP_VERSION, 'tables'=>$out]);
} catch(Throwable $e) { out(false, ['message'=>$e->getMessage()], 500); }
?>
