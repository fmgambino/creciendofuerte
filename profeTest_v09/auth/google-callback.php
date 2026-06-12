<?php
declare(strict_types=1);

session_start();

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../config/google.php';
require_once __DIR__ . '/../config/database.php';

try {
    if (isset($_GET['error'])) {
        throw new RuntimeException('Google OAuth cancelado o rechazado: ' . (string)$_GET['error']);
    }

    if (empty($_GET['code'])) {
        throw new RuntimeException('Google no devolvió código de autorización.');
    }

    if (!empty($_SESSION['google_oauth_state'])) {
        $state = (string)($_GET['state'] ?? '');
        if (!hash_equals($_SESSION['google_oauth_state'], $state)) {
            throw new RuntimeException('Estado OAuth inválido. Volvé a intentar.');
        }
    }

    $client = new Google_Client();
    $client->setClientId(GOOGLE_CLIENT_ID);
    $client->setClientSecret(GOOGLE_CLIENT_SECRET);
    $client->setRedirectUri(GOOGLE_REDIRECT_URI);

    $token = $client->fetchAccessTokenWithAuthCode((string)$_GET['code']);

    if (isset($token['error'])) {
        throw new RuntimeException('Error OAuth: ' . ($token['error_description'] ?? $token['error']));
    }

    $client->setAccessToken($token);

    $oauth = new Google_Service_Oauth2($client);
    $googleUser = $oauth->userinfo->get();

    $email = trim((string)$googleUser->email);
    $name = trim((string)$googleUser->name);
    $photo = trim((string)$googleUser->picture);

    if ($email === '') {
        throw new RuntimeException('Google no devolvió un email válido.');
    }

    if ($name === '') {
        $name = $email;
    }

    $pdo = db();

    $stmt = $pdo->prepare("
        SELECT id, full_name, email, role, status, profile_photo
        FROM users
        WHERE email = ?
        LIMIT 1
    ");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user) {
        $hash = password_hash(bin2hex(random_bytes(16)), PASSWORD_DEFAULT);

        $insert = $pdo->prepare("
            INSERT INTO users(full_name, email, password_hash, role, status, profile_photo)
            VALUES (?, ?, ?, 'socio', 'active', ?)
        ");
        $insert->execute([$name, $email, $hash, $photo ?: 'assets/img/avatar.svg']);

        $userId = (int)$pdo->lastInsertId();

        $code = 'MSTR-' . strtoupper(substr(preg_replace('/[^a-z0-9]/i', '', $name), 0, 4)) . '-' . str_pad((string)$userId, 4, '0', STR_PAD_LEFT);

        try {
            $partner = $pdo->prepare("
                INSERT INTO partners(user_id, partner_code, full_name, email, capital_usd, gains_usd, kyc_status, status, joined_at)
                VALUES (?, ?, ?, ?, 0, 0, 'pendiente', 'active', CURDATE())
            ");
            $partner->execute([$userId, $code, $name, $email]);
        } catch (Throwable $e) {}

        $stmt->execute([$email]);
        $user = $stmt->fetch();
    }

    if (!$user || ($user['status'] ?? '') !== 'active') {
        throw new RuntimeException('La cuenta existe pero no está activa. Contactá al administrador.');
    }

    $_SESSION['user'] = [
        'id' => (int)$user['id'],
        'full_name' => $user['full_name'],
        'email' => $user['email'],
        'role' => $user['role'],
        'profile_photo' => $user['profile_photo'] ?: ($photo ?: 'assets/img/avatar.svg')
    ];

    try {
        $log = $pdo->prepare("INSERT INTO audit_logs(event, author, type) VALUES (?, ?, ?)");
        $log->execute(['Inicio de sesión con Google', $user['full_name'], 'auth']);
    } catch (Throwable $e) {}

    unset($_SESSION['google_oauth_state']);

    header('Location: ../index.php?view=dashboard');
    exit;

} catch (Throwable $e) {
    $msg = urlencode($e->getMessage());
    header('Location: ../login.php?google_error=' . $msg);
    exit;
}
