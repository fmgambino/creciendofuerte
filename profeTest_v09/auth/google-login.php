<?php
declare(strict_types=1);

session_start();

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../config/google.php';

$client = new Google_Client();
$client->setClientId(GOOGLE_CLIENT_ID);
$client->setClientSecret(GOOGLE_CLIENT_SECRET);
$client->setRedirectUri(GOOGLE_REDIRECT_URI);
$client->addScope('email');
$client->addScope('profile');

$client->setPrompt('select_account');
$_SESSION['google_oauth_state'] = bin2hex(random_bytes(16));
$client->setState($_SESSION['google_oauth_state']);

header('Location: ' . $client->createAuthUrl());
exit;
