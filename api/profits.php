<?php
require_once __DIR__ . '/helpers.php';
$user = require_login();
$pdo = db();
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
 $rows = $pdo->query('SELECT * FROM broker_profits ORDER BY profit_date DESC, id DESC')->fetchAll();
 json_response(['ok'=>true,'data'=>$rows]);
}
require_superadmin($user);
$data = body();
$gross = (float)($data['gross_profit_usd'] ?? 0);
if ($gross <= 0) json_response(['ok'=>false,'message'=>'La ganancia debe ser mayor a cero'],422);
$admin = round($gross * 0.60,2);
$pool = round($gross * 0.40,2);
$pdo->beginTransaction();
$stmt = $pdo->prepare('INSERT INTO broker_profits(profit_date,gross_profit_usd,admin_share_usd,partners_pool_usd,notes,created_by) VALUES(?,?,?,?,?,?)');
$stmt->execute([$data['profit_date'] ?? date('Y-m-d'),$gross,$admin,$pool,$data['notes'] ?? '',$user['id']]);
$profitId = $pdo->lastInsertId();
$totalCapital = (float)$pdo->query('SELECT COALESCE(SUM(capital_usd),0) total FROM partners')->fetch()['total'];
$partners = $pdo->query('SELECT id, capital_usd FROM partners')->fetchAll();
foreach ($partners as $p) {
 $percent = $totalCapital > 0 ? ((float)$p['capital_usd'] / $totalCapital) * 100 : 0;
 $amount = round($pool * ($percent / 100),2);
 $stmt = $pdo->prepare('INSERT INTO distributions(broker_profit_id,partner_id,capital_at_distribution,participation_percent,amount_usd) VALUES(?,?,?,?,?)');
 $stmt->execute([$profitId,$p['id'],$p['capital_usd'],$percent,$amount]);
}
$pdo->commit();
json_response(['ok'=>true,'message'=>'Ganancia cargada y distribuida automáticamente']);
