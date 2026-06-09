<?php require_once 'helpers.php'; $u=need_login();
if($_SERVER['REQUEST_METHOD']==='GET'){
 $st=db()->prepare('SELECT id,full_name,email,role,status,profile_photo,created_at FROM users WHERE id=?'); $st->execute([$u['id']]); $user=$st->fetch();
 $st=db()->prepare('SELECT * FROM partners WHERE user_id=? OR email=? LIMIT 1'); $st->execute([$u['id'],$u['email']]); $partner=$st->fetch();
 out(true,['user'=>$user,'partner'=>$partner]);
}
$name=clean($_POST['full_name']??''); $email=clean($_POST['email']??''); $phone=clean($_POST['phone']??''); $address=clean($_POST['address']??''); $bank=clean($_POST['bank_account']??''); $pass=trim((string)($_POST['password']??''));
try{
 if($pass!=='') db()->prepare('UPDATE users SET full_name=?,email=?,password_hash=? WHERE id=?')->execute([$name,$email,password_hash($pass,PASSWORD_DEFAULT),$u['id']]);
 else db()->prepare('UPDATE users SET full_name=?,email=? WHERE id=?')->execute([$name,$email,$u['id']]);
 db()->prepare('UPDATE partners SET full_name=?,email=?,phone=?,address=?,bank_account=? WHERE user_id=? OR email=?')->execute([$name,$email,$phone,$address,$bank,$u['id'],$u['email']]);
 $st=db()->prepare('SELECT id,full_name,email,role,status,profile_photo,created_at FROM users WHERE id=?'); $st->execute([$u['id']]); $_SESSION['user']=$st->fetch();
 audit('Actualizó su perfil','profile'); out(true,['message'=>'Perfil actualizado']);
}catch(Throwable $e){out(false,['message'=>$e->getMessage()],500);} ?>
