const CACHE='master-profe-crm-v1';
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(['./','login.php','index.php','assets/css/app.css','assets/js/app.js','assets/js/auth.js','assets/img/icon.svg']))));
self.addEventListener('fetch',e=>{ if(e.request.method==='GET') e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request).catch(()=>r))); });
