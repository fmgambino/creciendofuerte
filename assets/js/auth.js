
document.getElementById('loginForm').addEventListener('submit', async e=>{
  e.preventDefault();
  const fd=new FormData(e.target);
  try{
    const r=await fetch('api/login.php',{method:'POST',body:fd,credentials:'same-origin',redirect:'follow'});
    const j=await r.json();
    if(j.ok){
      const local = ['localhost','127.0.0.1'].includes(location.hostname);
      location.replace(local ? './index.php?view=dashboard' : './dashboard');
      return;
    }
    Swal.fire('Error',j.message||'Credenciales inválidas','error');
  }catch(err){
    Swal.fire('Error','No se pudo conectar con el servidor. Verificá que estés abriendo el proyecto desde Apache/PHP y no como archivo suelto.','error');
  }
});
if('serviceWorker' in navigator && !['localhost','127.0.0.1'].includes(location.hostname)) navigator.serviceWorker.register('./sw.js').catch(()=>{});
