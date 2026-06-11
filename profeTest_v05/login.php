<?php session_start(); require_once __DIR__.'/config/database.php'; if(!empty($_SESSION['user'])) { header('Location: ./index.php?view=dashboard'); exit; }
function mp_login_settings(){ $d=['app_title'=>'EL MASTER PROFE CRM','app_short_title'=>'EL MASTER','app_subtitle'=>'PROFE CRM','logo_path'=>'assets/img/icon.svg','favicon_path'=>'assets/img/icon.svg','brand_color'=>'#3b747b','accent_color'=>'#69d3d1','title_color'=>'#ffffff','subtitle_color'=>'#ffe05d','login_bg_type'=>'css','login_bg_url'=>'','login_bg_path'=>'']; try{ $rows=db()->query('SELECT key_name,value FROM app_settings')->fetchAll(); foreach($rows as $r){$d[$r['key_name']]=$r['value'];}}catch(Throwable $e){} return $d;}
$cfg=mp_login_settings(); ?>
<?php
$bgType = $cfg['login_bg_type'] ?? 'css';
$bgUrl = trim((string)($cfg['login_bg_url'] ?? ''));
$bgPath = trim((string)($cfg['login_bg_path'] ?? ''));
$heroStyle = '';
$heroVideo = '';
if($bgPath !== '') { $heroStyle = ' style="background-image:linear-gradient(140deg,rgba(5,15,16,.78),rgba(2,3,4,.72)),url('.htmlspecialchars($bgPath).');background-size:cover;background-position:center;"'; }
elseif($bgUrl !== '' && $bgType !== 'video') { $heroStyle = ' style="background-image:linear-gradient(140deg,rgba(5,15,16,.78),rgba(2,3,4,.72)),url('.htmlspecialchars($bgUrl).');background-size:cover;background-position:center;"'; }
if($bgUrl !== '' && $bgType === 'video') { $heroVideo = '<video class="login-bg-video" autoplay muted loop playsinline src="'.htmlspecialchars($bgUrl).'"></video>'; }
?>

<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="<?=htmlspecialchars($cfg['favicon_path'])?>"><title><?=htmlspecialchars($cfg['app_title'])?> · Login</title><link rel="manifest" href="manifest.json"><link rel="stylesheet" href="assets/css/app.css"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script></head><body class="login-page" style="--brand: <?=htmlspecialchars($cfg['brand_color'])?>; --brand2: <?=htmlspecialchars($cfg['accent_color'])?>;">
<main class="login-shell">
  <section class="login-panel">
    <div class="brand"><img src="<?=htmlspecialchars($cfg['logo_path'])?>"><div><b style="color:<?=htmlspecialchars($cfg['title_color'])?>"><?=htmlspecialchars($cfg['app_short_title'])?></b><span style="color:<?=htmlspecialchars($cfg['subtitle_color'])?>"><?=htmlspecialchars($cfg['app_subtitle'])?></span></div></div>
    <div class="login-badge">Inversiones · Socios · Retiros</div>
    <h1>Acceso al CRM</h1>
    <p class="login-copy">Panel PWA para trazabilidad de ganancias broker, distribuciones, socios inversores y retiros.</p>
    <form id="loginForm" class="login-form"><label>Email<input name="email" type="email" autocomplete="username" required></label><label>Contraseña<input name="password" type="password" autocomplete="current-password" required></label><button class="btn primary">Iniciar sesión</button></form>
    <div class="login-actions"><button class="btn google" id="googleBtn" type="button"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09Z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23Z"/><path fill="#FBBC05" d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18A10.95 10.95 0 0 0 1 12c0 1.77.42 3.45 1.18 4.94l3.66-2.84Z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06L5.84 9.9C6.71 7.31 9.14 5.38 12 5.38Z"/></svg>Continuar con Google</button><button class="btn" id="createBtn" type="button">Crear cuenta</button><button class="btn ghost" id="recoverBtn" type="button">Recuperar contraseña</button></div>
    <p class="google-help"><b>Google:</b> presioná “Continuar con Google” para ver las instrucciones de configuración OAuth. Una vez configurado el Client ID, el mismo botón inicia sesión o registra la cuenta.</p>
  </section>
  <section class="investment-hero" aria-hidden="true"<?=$heroStyle?>><?=$heroVideo?><div class="ticker"><span>BTC +2.4%</span><span>NASDAQ +0.8%</span><span>ROI mensual</span></div><div class="coin coin-a">US$</div><div class="coin coin-b">%</div><div class="chart-lines"><i></i><i></i><i></i><i></i></div><div class="hero-card login-brand-card"><small>CRM de inversiones</small><strong>Capital · ROI · Retiros</strong><em>Gestión auditada, segura y trazable para socios inversores.</em></div></section>
</main>
<script src="assets/js/auth.js"></script></body></html>
