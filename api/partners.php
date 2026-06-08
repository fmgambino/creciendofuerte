<?php
require_once __DIR__ . '/helpers.php';
$user = require_login();
$pdo = db();
$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'GET') {
    $rows = $pdo->query('SELECT p.id, u.full_name, u.email, u.status, p.capital_usd, p.wallet, p.join_date,
      COALESCE((SELECT SUM(amount_usd) FROM distributions d WHERE d.partner_id=p.id),0) earnings
      FROM partners p JOIN users u ON u.id=p.user_id ORDER BY p.id DESC')->fetchAll();
    json_response(['ok'=>true,'data'=>$rows]);
}
require_superadmin($user);
$data = body();
if ($method === 'POST') {
    $pdo->beginTransaction();
    $hash = password_hash($data['password'] ?: 'Demo1234', PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('INSERT INTO users(full_name,email,password_hash,role,status) VALUES(?,?,?,?,"active")');
    $stmt->execute([$data['full_name'],$data['email'],$hash,'partner']);
    $uid = $pdo->lastInsertId();
    $stmt = $pdo->prepare('INSERT INTO partners(user_id,capital_usd,wallet,join_date,notes) VALUES(?,?,?,?,?)');
    $stmt->execute([$uid,(float)$data['capital_usd'],$data['wallet'] ?? '',$data['join_date'] ?? date('Y-m-d'),$data['notes'] ?? '']);
    $pdo->commit();
    json_response(['ok'=>true,'message'=>'Socio creado correctamente']);
}
if ($method === 'DELETE') {
    $id = (int)($data['id'] ?? 0);
    $stmt = $pdo->prepare('SELECT user_id FROM partners WHERE id=?'); $stmt->execute([$id]); $p=$stmt->fetch();
    if ($p) { $pdo->prepare('DELETE FROM users WHERE id=?')->execute([$p['user_id']]); }
    json_response(['ok'=>true]);
}
