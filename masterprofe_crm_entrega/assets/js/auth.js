document.getElementById('loginForm').addEventListener('submit', async e=>{
 e.preventDefault(); const fd=new FormData(e.target);
 const r=await fetch('api/login.php',{method:'POST',body:fd}); const j=await r.json();
 if(j.ok) location.href='index.php'; else Swal.fire('Error',j.message||'Credenciales inválidas','error');
});
if('serviceWorker' in navigator) navigator.serviceWorker.register('sw.js').catch(()=>{});
