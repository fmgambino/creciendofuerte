<?php
require_once __DIR__ . '/helpers.php';
$user = require_login();
$pdo = db();
$filter = $user['role'] === 'partner' ? 'WHERE u.id='.(int)$user['id'] : '';
$rows = $pdo->query('SELECT d.*, bp.profit_date, u.full_name FROM distributions d JOIN partners p ON p.id=d.partner_id JOIN users u ON u.id=p.user_id JOIN broker_profits bp ON bp.id=d.broker_profit_id '.$filter.' ORDER BY bp.profit_date DESC, d.id DESC')->fetchAll();
json_response(['ok'=>true,'data'=>$rows]);
