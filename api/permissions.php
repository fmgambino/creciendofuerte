<?php
require_once 'helpers.php';
$u=need_login();
if (($u['role'] ?? '') !== 'superadmin') out(false, ['message'=>'Solo SuperAdmin puede guardar permisos.'], 403);
try {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    if (!is_array($data)) out(false, ['message' => 'Payload inválido para permisos.'], 400);
    $pdo = db();
    $pdo->beginTransaction();
    $exists = $pdo->prepare('SELECT id FROM permissions WHERE module_key=? AND role=? LIMIT 1');
    $upd = $pdo->prepare('UPDATE permissions SET module_name=?, can_view=?, can_create=?, can_edit=?, can_delete=?, can_export=? WHERE module_key=? AND role=?');
    $ins = $pdo->prepare('INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES(?,?,?,?,?,?,?,?)');
    foreach ($data as $p) {
        if (empty($p['module_key']) || empty($p['role'])) continue;
        $module_key=(string)$p['module_key']; $role=(string)$p['role']; $module_name=(string)($p['module_name'] ?? $module_key);
        $vals=[!empty($p['can_view'])?1:0,!empty($p['can_create'])?1:0,!empty($p['can_edit'])?1:0,!empty($p['can_delete'])?1:0,!empty($p['can_export'])?1:0];
        $exists->execute([$module_key,$role]);
        if($exists->fetchColumn()) $upd->execute([$module_name,...$vals,$module_key,$role]);
        else $ins->execute([$module_key,$module_name,$role,...$vals]);
    }
    $pdo->commit();
    audit('Actualizó roles y permisos','security');
    out(true, ['message'=>'Permisos guardados']);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    out(false, ['message'=>'Error al guardar permisos: '.$e->getMessage()], 500);
}
?>
