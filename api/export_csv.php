<?php session_start(); require_once __DIR__.'/../config/database.php'; if(empty($_SESSION['user'])) die('No autorizado');
$entity=preg_replace('/[^a-z_]/','',$_GET['entity']??'users');
$_GET['entity']=$entity; ob_start(); include __DIR__.'/data.php'; $json=json_decode(ob_get_clean(),true); $rows=$json['rows']??[];
header('Content-Type: text/csv; charset=utf-8'); header('Content-Disposition: attachment; filename="'.$entity.'_'.date('Ymd_His').'.csv"');
$out=fopen('php://output','w'); if($rows){ fputcsv($out,array_keys($rows[0])); foreach($rows as $r) fputcsv($out,$r); } fclose($out);
?>
