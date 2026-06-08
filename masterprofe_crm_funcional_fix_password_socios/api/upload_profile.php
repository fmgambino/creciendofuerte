<?php require_once 'helpers.php'; $u=need_login();
if(empty($_FILES['photo'])) out(false,['message'=>'Sin archivo'],400); $f=$_FILES['photo'];
$ext=strtolower(pathinfo($f['name'],PATHINFO_EXTENSION)); if(!in_array($ext,['jpg','jpeg','png','webp','gif','svg'])) out(false,['message'=>'Formato no permitido'],400);
$path='uploads/profiles/profile_'.$u['id'].'_'.time().'.'.$ext; move_uploaded_file($f['tmp_name'], __DIR__.'/../'.$path);
db()->prepare('UPDATE users SET profile_photo=? WHERE id=?')->execute([$path,$u['id']]); $_SESSION['user']['profile_photo']=$path; out(true,['path'=>$path]);
?>
