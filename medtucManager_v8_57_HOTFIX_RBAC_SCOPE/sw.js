const CACHE='ticket-manager-v8-56-assignment-scope';
const ASSETS=['./','./index.html','./app.html','./styles.css?v=8.56','./js/app.js?v=8.56','./js/auth.js?v=8.56','./js/config.js','./manifest.webmanifest','./assets/logo.svg'];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',e=>{ if(e.request.method==='GET') e.respondWith(fetch(e.request).catch(()=>caches.match(e.request).then(r=>r||caches.match('./index.html')))); });
