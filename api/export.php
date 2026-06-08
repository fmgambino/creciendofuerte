<?php
require_once __DIR__.'/../includes/auth.php'; require_login();
$module=preg_replace('/[^a-z_]/','',$_GET['module']??'users'); $format=$_GET['format']??'csv';
$map=['users'=>'users','partners'=>'partners','referrals'=>'referrals','withdrawals'=>'withdrawals','profits'=>'broker_profits','distributions'=>'distributions','audit'=>'audit_logs']; if(!isset($map[$module])) die('Invalid');
$rows=db()->query('SELECT * FROM '.$map[$module].' ORDER BY id DESC')->fetchAll();
if($format==='csv'){ header('Content-Type:text/csv'); header('Content-Disposition:attachment; filename='.$module.'.csv'); $out=fopen('php://output','w'); if($rows) fputcsv($out,array_keys($rows[0])); foreach($rows as $r) fputcsv($out,$r); exit; }
header('Content-Type:text/html'); echo '<h2>EL MASTER PROFE</h2><h3>Reporte: '.htmlspecialchars($module).'</h3><p>Fecha: '.date('d/m/Y H:i').' · Solicitado por: '.htmlspecialchars(current_user()['name']).'</p><table border="1" cellpadding="6" cellspacing="0">'; if($rows){ echo '<tr>'; foreach(array_keys($rows[0]) as $h) echo '<th>'.htmlspecialchars($h).'</th>'; echo '</tr>'; foreach($rows as $r){echo '<tr>'; foreach($r as $v) echo '<td>'.htmlspecialchars((string)$v).'</td>'; echo '</tr>';}} echo '</table><script>window.print()</script>';
