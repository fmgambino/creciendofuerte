const CACHE='masterprofe-crm-v1';
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(['./','login.php','assets/css/app.css','assets/js/app.js','assets/js/auth.js','assets/img/icon.svg']))));
self.addEventListener('fetch',e=>{ if(e.request.method!=='GET') return; e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request).catch(()=>caches.match('login.php')))); });
