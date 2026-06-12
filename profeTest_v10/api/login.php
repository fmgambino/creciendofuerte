<?php
declare(strict_types=1);

session_start();

header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../config/database.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);

    if (!is_array($input)) {
        $input = $_POST;
    }

    $email = trim($input['email'] ?? '');
    $password = trim($input['password'] ?? '');

    if ($email === '' || $password === '') {
        http_response_code(422);
        echo json_encode([
            'ok' => false,
            'message' => 'Debe ingresar email y contraseña.'
        ]);
        exit;
    }

    $stmt = db()->prepare("
        SELECT id, full_name, email, password_hash, role, status, profile_photo
        FROM users
        WHERE email = ?
        LIMIT 1
    ");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || ($user['status'] !== 'active' && ($user['role'] ?? '') !== 'socio')) {
        http_response_code(401);
        echo json_encode([
            'ok' => false,
            'message' => 'Credenciales inválidas.'
        ]);
        exit;
    }

    $valid = password_verify($password, $user['password_hash']);

    /*
      Compatibilidad temporal:
      Permite demo123 aunque el hash viejo esté mal.
      Después de entrar, podés quitar este bloque.
    */
    if (!$valid && $email === 'fernando.m.gambino@gmail.com' && $password === 'demo123') {
        $valid = true;
    }

    if (!$valid) {
        http_response_code(401);
        echo json_encode([
            'ok' => false,
            'message' => 'Credenciales inválidas.'
        ]);
        exit;
    }

    $_SESSION['user'] = [
        'id' => (int)$user['id'],
        'full_name' => $user['full_name'],
        'email' => $user['email'],
        'role' => $user['role'],
        'status' => $user['status'],
        'pending_activation' => (($user['role'] ?? '') === 'socio' && ($user['status'] ?? '') !== 'active'),
        'profile_photo' => $user['profile_photo'] ?: 'assets/img/avatar.svg'
    ];

    try {
        $log = db()->prepare("
            INSERT INTO audit_logs(event, author, type)
            VALUES (?, ?, ?)
        ");
        $log->execute(['Inicio de sesión', $user['full_name'], 'auth']);
    } catch (Throwable $e) {}

    echo json_encode([
        'ok' => true,
        'message' => 'Acceso correcto',
        'redirect' => './index.php?view=dashboard'
    ]);
    exit;

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'message' => 'Error interno: ' . $e->getMessage()
    ]);
}