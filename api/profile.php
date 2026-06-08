<?php require_once 'helpers.php'; $u=need_login();
if($_SERVER['REQUEST_METHOD']==='POST'){
 $name=clean($_POST['full_name']??''); $phone=clean($_POST['phone']??''); $address=clean($_POST['address']??''); $pass=trim($_POST['password']??'');
 if($pass!=='') db()->prepare('UPDATE users SET full_name=?,phone=?,address=?,password_hash=? WHERE id=?')->execute([$name,$phone,$address,password_hash($pass,PASSWORD_DEFAULT),$u['id']]);
 else db()->prepare('UPDATE users SET full_name=?,phone=?,address=? WHERE id=?')->execute([$name,$phone,$address,$u['id']]);
 audit('Actualizó perfil','perfil'); out(true,['message'=>'Perfil actualizado']);
}
$me=db()->prepare('SELECT id,full_name,email,role,status,phone,address,profile_photo,created_at FROM users WHERE id=?'); $me->execute([$u['id']]);
$partner=null; if($u['role']==='socio' || $u['role']==='referido'){ $q=db()->prepare('SELECT * FROM partners WHERE user_id=? OR email=? LIMIT 1'); $q->execute([$u['id'],$u['email']]); $partner=$q->fetch(); }
out(true,['user'=>$me->fetch(),'partner'=>$partner]);
?>
