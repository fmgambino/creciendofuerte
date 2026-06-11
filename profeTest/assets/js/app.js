const $=s=>document.querySelector(s); const $$=s=>[...document.querySelectorAll(s)];
const svg=p=>`<svg viewBox="0 0 24 24" aria-hidden="true">${p}</svg>`;
const ICON={
 dashboard:svg('<rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>'),
 perfil:svg('<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>'),
 users:svg('<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/>'),
 roles:svg('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/>'),
 socios:svg('<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>'),
 referidos:svg('<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>'),
 profits:svg('<rect x="3" y="8" width="18" height="10" rx="2"/><path d="M7 12h.01M12 12h5"/>'),
 distribuciones:svg('<circle cx="12" cy="12" r="9"/><path d="M12 3v9l6 3"/>'),
 retiros:svg('<path d="M19 12H5"/><path d="M12 19l-7-7 7-7"/>'),
 whatsapp:svg('<path d="M21 11.5a8.38 8.38 0 0 1-12.11 7.5L3 21l2-5.7A8.38 8.38 0 1 1 21 11.5Z"/>'),
 notificaciones:svg('<path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 7h18s-3 0-3-7"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>'),
 configuraciones:svg('<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9c.22.61.8 1 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1Z"/>'),
 auditoria:svg('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z"/><path d="M14 2v6h6M8 13h8M8 17h5"/>'),
 sun:svg('<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/>'),
 moon:svg('<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79Z"/>'),
 full:svg('<path d="M8 3H5a2 2 0 0 0-2 2v3M21 8V5a2 2 0 0 0-2-2h-3M3 16v3a2 2 0 0 0 2 2h3M16 21h3a2 2 0 0 0 2-2v-3"/>'),
 eye:svg('<path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/><circle cx="12" cy="12" r="3"/>'),
 edit:svg('<path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>'),
 trash:svg('<path d="M3 6h18"/><path d="M8 6V4h8v2M19 6l-1 14H6L5 6"/>')
};
const titles={dashboard:'Dashboard',perfil:'Mi Perfil',users:'Usuarios',roles:'Roles y permisos',socios:'Socios',referidos:'Referidos',profits:'Ganancias broker',distribuciones:'Distribuciones',capitales:'Niveles de capital',retiros:'Retiros',whatsapp:'WhatsApp',notificaciones:'Notificaciones',auditoria:'Auditoría',configuraciones:'Configuraciones'};
const entityMap={users:'users',socios:'partners',referidos:'referrals',profits:'broker_profits',distribuciones:'distributions',capitales:'capital_levels',retiros:'withdrawals',whatsapp:'whatsapp_numbers',notificaciones:'notifications',auditoria:'audit_logs',configuraciones:'app_settings'};
const actions=['can_view','can_create','can_edit','can_delete','can_export']; const actionLabels={can_view:'Ver',can_create:'Crear',can_edit:'Editar',can_delete:'Eliminar',can_export:'Exportar CSV/PDF'};
let state={modules:[],perms:[],notifications:[],options:{},rows:[],filtered:[],page:1,perPage:10,current:'dashboard',user:JSON.parse(document.body.dataset.user||'{}'),settings:JSON.parse(document.body.dataset.settings||'{}')};
const schemas={
 users:[['full_name','Nombre completo'],['email','Email','email'],['password','Contraseña','password'],['role','Rol','select',['superadmin','empleado','socio']],['status','Estado','select',['active','inactive']]],
 partners:[['partner_code','Código socio'],['full_name','Nombre completo'],['email','Email','email'],['phone','Teléfono'],['address','Dirección'],['bank_account','Cuenta / Wallet'],['capital_usd','Capital USD','number'],['gains_usd','Ganancia USD','number'],['kyc_status','KYC','select',['pendiente','aprobado','rechazado']],['status','Estado','select',['active','inactive']],['joined_at','Fecha ingreso','date']],
 referrals:[['referrer_partner_id','Socio referente','partnerselect'],['referred_name','Nombre referido'],['referred_email','Email referido','email'],['capital_usd','Capital USD','number'],['commission_percent','% comisión referido','number'],['status','Estado','select',['nuevo','activo','pagado','cancelado']]],
 broker_profits:[['profit_date','Fecha','date'],['gross_profit_usd','Ganancia broker USD','number'],['notes','Notas','textarea']],
 distributions:[['partner_id','Socio','partnerselect'],['amount_usd','Monto USD','number'],['percent_share','% participación','number'],['status','Estado','select',['pendiente','en_proceso','transferido','acreditado','pagado']]],
 capital_levels:[['name','Nivel'],['amount_usd','Capital USD','number'],['percent_share','% sugerido','number'],['status','Estado','select',['active','inactive']]],
 withdrawals:[['partner_id','Socio','partnerselect'],['amount_usd','Monto USD','number'],['request_type','Tipo','select',['ganancias']],['destination','Destino / wallet','textarea'],['status','Estado','select',['pendiente','en_proceso','transferido','acreditado','pagado','rechazado']]],
 whatsapp_numbers:[['label','Etiqueta'],['phone','Número con país'],['message','Mensaje','textarea'],['status','Estado','select',['active','inactive']]]
};
async function init(){ bindHeader(); const b=await fetch('api/bootstrap.php',{credentials:'same-origin'}).then(r=>r.json()).catch(()=>({ok:false})); if(!b.ok){location.replace('./login.php');return} Object.assign(state,{modules:b.modules,perms:b.permissions,notifications:b.notifications,user:b.user}); renderMenu(); const cleanView=document.body.dataset.view||''; const hash=location.hash.replace('#',''); const path=location.pathname.split('/').pop().replace('.php','')||''; route(hash||cleanView||path||'dashboard', false); }
function perm(module,act='can_view',role=state.user.role){ const p=state.perms.find(x=>x.module_key===module&&x.role===role); return state.user.role==='superadmin' || (p && +p[act]); }
function renderMenu(){ const html=state.modules.filter(m=>perm(m.key,'can_view')).map(m=>`<div class="navitem" data-route="${m.key}">${ICON[m.key]||ICON.dashboard}<span>${m.name}</span></div>`).join(''); $('#menu').innerHTML=html; $$('#menu .navitem').forEach(i=>i.onclick=()=>route(i.dataset.route)); renderBottomNav(); }

function renderBottomNav(){
 const bn=$('#bottomNav'); if(!bn) return;
 const allowed=state.modules.filter(m=>perm(m.key,'can_view'));
 const preferred=['dashboard','perfil','socios','referidos','retiros','distribuciones','profits','notificaciones'];
 let primary=[];
 for(const key of preferred){ const m=allowed.find(x=>x.key===key); if(m && !primary.find(x=>x.key===key)) primary.push(m); if(primary.length>=4) break; }
 for(const m of allowed){ if(primary.length>=4) break; if(!primary.find(x=>x.key===m.key)) primary.push(m); }
 const rest=allowed.filter(m=>!primary.find(x=>x.key===m.key));
 bn.innerHTML = primary.map(m=>`<button class="bottom-item" data-route="${m.key}" title="${m.name}">${ICON[m.key]||ICON.dashboard}<span>${m.name}</span></button>`).join('') + `<button class="bottom-item more" id="moreBtn" title="Más">${svg('<path d="M4 6h16M4 12h16M4 18h16"/>')}<span>Más</span></button>`;
 $$('#bottomNav .bottom-item[data-route]').forEach(b=>b.onclick=()=>route(b.dataset.route));
 const moreBtn=$('#moreBtn'); if(moreBtn) moreBtn.onclick=()=>openMoreSheet(rest.length?rest:allowed);
 $$('.bottom-item').forEach(i=>i.classList.toggle('active',i.dataset.route===state.current));
}
function openMoreSheet(items){
 const sheet=$('#moreSheet'), links=$('#moreLinks'); if(!sheet||!links)return;
 links.className='more-links';
 links.innerHTML=items.map(m=>`<button class="more-link" data-route="${m.key}">${ICON[m.key]||ICON.dashboard}<span>${m.name}</span></button>`).join('');
 sheet.classList.remove('hidden');
 $$('#moreLinks .more-link').forEach(b=>b.onclick=()=>{sheet.classList.add('hidden');route(b.dataset.route)});
 const close=$('#closeMore'); if(close) close.onclick=()=>sheet.classList.add('hidden');
 sheet.onclick=e=>{if(e.target===sheet)sheet.classList.add('hidden')};
}

function bindHeader(){ $('#collapseBtn').onclick=()=>$('#sidebar').classList.toggle(innerWidth<900?'open':'collapsed'); $('#themeBtn').onclick=()=>{document.documentElement.classList.toggle('light'); localStorage.theme=document.documentElement.classList.contains('light')?'light':'dark'; updateThemeIcon(); redrawChart();}; if(localStorage.theme==='light')document.documentElement.classList.add('light'); updateThemeIcon(); $('#fullBtn').innerHTML=ICON.full; $('#fullBtn').onclick=()=>document.fullscreenElement?document.exitFullscreen():document.documentElement.requestFullscreen(); $('#notifBtn').innerHTML=ICON.notificaciones; $('#logoutBtn').onclick=async()=>{try{await fetch('api/logout.php',{credentials:'same-origin',redirect:'follow'});}catch(e){} const local=['localhost','127.0.0.1'].includes(location.hostname); location.replace(local?'./login.php':'./login');}; $('#photoInput').onchange=uploadPhoto; $('#installBtn').onclick=()=>deferredPrompt&&deferredPrompt.prompt(); $('#waFloat').onclick=showWhatsApp; window.addEventListener('beforeinstallprompt',e=>{e.preventDefault();deferredPrompt=e;$('#installBtn').classList.remove('hidden')}); }
let deferredPrompt=null,lastTrend=[];function updateThemeIcon(){ $('#themeBtn').innerHTML=document.documentElement.classList.contains('light')?ICON.moon:ICON.sun; }
function renderNotifs(){ let unread=state.notifications.filter(n=>!+n.is_read).length; $('#notifBtn').dataset.count=unread; $('#notifPreview').innerHTML=state.notifications.map(n=>`<div class="notif-item"><b>${n.title}</b><small>${n.created_at}</small><p>${n.body}</p></div>`).join('')||'<div class="notif-item">Sin notificaciones</div>'; }
async function route(r, push=true){ const aliases={'usuarios':'users','ganancias-broker':'profits','niveles-capital':'capitales','configuracion':'configuraciones','configuraciones':'configuraciones'}; r=aliases[r]||r||'dashboard'; if(!perm(r,'can_view')) r='dashboard'; state.current=r; if(push){ const local=['localhost','127.0.0.1'].includes(location.hostname); if(local) history.replaceState(null,'','./index.php?view='+r); else history.pushState(null,'','./'+r); } $('#pageTitle').textContent=titles[r]||r; const dpt=$('#desktopPageTitle'); if(dpt)dpt.textContent=titles[r]||r; $$('.navitem').forEach(i=>i.classList.toggle('active',i.dataset.route===r)); $$('.bottom-item').forEach(i=>i.classList.toggle('active',i.dataset.route===r)); renderNotifs(); if(r==='dashboard') return dashboard(); if(r==='perfil') return profile(); if(r==='roles') return roles(); if(r==='configuraciones') return configuraciones(); return tablePage(r); }
async function dashboard(){
 const today=new Date().toISOString().slice(0,10); const from=new Date(Date.now()-1000*60*60*24*30).toISOString().slice(0,10);
 const options=await fetch('api/form_options.php').then(r=>r.json()).catch(()=>({partners:[]}));
 const partnerOptions=(options.partners||[]).map(p=>`<option value="${p.id}">${p.full_name}</option>`).join('');
 $('#content').innerHTML=`<section class="dashboard-filters panel"><div class="filter-row"><div><label>Desde</label><input type="date" id="fFrom" value="${from}"></div><div><label>Hasta</label><input type="date" id="fTo" value="${today}"></div><div><label>Socio</label><select id="fPartner"><option value="">Todos</option>${partnerOptions}</select></div><div><label>Referente</label><select id="fRef"><option value="">Todos</option>${partnerOptions}</select></div><div><label>Gráfico</label><select id="fChart"><option value="line">Línea</option><option value="bar">Barra</option><option value="pie">Torta</option></select></div><button class="btn yellow" id="applyFilters">Aplicar filtros</button></div></section><section id="dashStats" class="grid cards"></section><section class="panel chart-panel"><div class="toolbar"><div><h2 id="chartTitle">Evolución de ganancias broker</h2><p>Filtrá por período, socio, referente y tipo de gráfico.</p></div></div><canvas id="chart" height="120"></canvas></section>`;
 $('#applyFilters').onclick=loadDashboardData; await loadDashboardData();
}
async function loadDashboardData(){
 const qs=new URLSearchParams({from:$('#fFrom').value,to:$('#fTo').value,type:$('#fChart').value});
 if($('#fPartner').value) qs.set('partner_id',$('#fPartner').value); if($('#fRef').value) qs.set('referrer_partner_id',$('#fRef').value);
 const j=await fetch('api/dashboard.php?'+qs.toString()).then(r=>r.json()); const s=j.stats||{}; let role=state.user.role;
 if(role==='socio'){
  $('#dashStats').innerHTML=`<div class="card"><span>Mi aporte societario</span><strong>US$ ${money(s.capital)}</strong></div><div class="card success-card"><span>Mis ganancias acumuladas</span><strong>US$ ${money(s.gains)}</strong></div><div class="card global-card"><span>Ganancia global por socio</span><strong>US$ ${money(s.per_partner)}</strong></div><div class="card"><span>Mis retiros pendientes</span><strong>${s.pending_withdrawals||0}</strong></div>`;
 } else {
  $('#dashStats').innerHTML=`<div class="card"><span>Capital total aportado</span><strong>US$ ${money(s.capital)}</strong></div><div class="card"><span>Ganancias Broker</span><strong>US$ ${money(s.broker_total)}</strong></div><div class="card"><span>Disponible socios</span><strong>US$ ${money(s.partners_available)}</strong></div><div class="card"><span>Retiros pendientes</span><strong>${s.pending_withdrawals||0}</strong></div>`;
 }
 $('#chartTitle').textContent= role==='socio'?'Mi rendimiento como socio':($('#fPartner').value?'Ganancias del socio seleccionado':($('#fRef').value?'Capital generado por referidos':'Evolución de ganancias broker'));
 lastTrend=j.trend||[]; drawChart(lastTrend,$('#fChart').value);
}

function redrawChart(){ if($('#chart')) drawChart(lastTrend,$('#fChart')?.value||'line'); }
function drawChart(data,type='line'){
 const c=$('#chart'),ctx=c.getContext('2d'),dpr=devicePixelRatio||1,w=Math.max(600,c.offsetWidth)*dpr,h=330*dpr;c.width=w;c.height=h;ctx.clearRect(0,0,w,h);
 const cs=getComputedStyle(document.documentElement), text=cs.getPropertyValue('--text').trim(), muted=cs.getPropertyValue('--muted').trim(), brand=cs.getPropertyValue('--brand2').trim(), grid=cs.getPropertyValue('--line').trim(), warn=cs.getPropertyValue('--warn').trim();
 data=(data&&data.length?data:[{label:'Sin datos',value:0}]).map(x=>({label:x.label,value:+x.value||0})); const vals=data.map(d=>d.value), max=Math.max(...vals,100);
 if(type==='pie'){
   const total=vals.reduce((a,b)=>a+b,0)||1,cx=w/2,cy=h/2,r=Math.min(w,h)*.32; let a=-Math.PI/2; const colors=[brand,warn,'#69d3d1','#3b747b','#95a3b3','#26d98b','#e96073'];
   data.forEach((p,i)=>{let ang=p.value/total*Math.PI*2;ctx.beginPath();ctx.moveTo(cx,cy);ctx.arc(cx,cy,r,a,a+ang);ctx.closePath();ctx.fillStyle=colors[i%colors.length];ctx.fill();a+=ang;});
   ctx.fillStyle=text;ctx.font=`${14*dpr}px Arial`;data.slice(0,8).forEach((p,i)=>{ctx.fillStyle=colors[i%colors.length];ctx.fillRect(30*dpr,(30+i*24)*dpr,14*dpr,14*dpr);ctx.fillStyle=text;ctx.fillText(`${p.label}: US$ ${money(p.value)}`,52*dpr,(42+i*24)*dpr);}); return;
 }
 ctx.strokeStyle=grid; ctx.lineWidth=1*dpr; ctx.fillStyle=muted; ctx.font=`${12*dpr}px Arial`; for(let i=0;i<=5;i++){let y=25*dpr+i*(h-75*dpr)/5;ctx.beginPath();ctx.moveTo(45*dpr,y);ctx.lineTo(w-25*dpr,y);ctx.stroke();}
 if(type==='bar'){
   const bw=(w-90*dpr)/data.length*.62; data.forEach((p,i)=>{let x=55*dpr+i*(w-90*dpr)/data.length, bh=(p.value/max)*(h-95*dpr), y=h-40*dpr-bh;ctx.fillStyle='rgba(105,211,209,.85)';ctx.fillRect(x,y,bw,bh);ctx.fillStyle=muted;ctx.fillText(p.label,x,h-12*dpr);}); return;
 }
 ctx.beginPath(); ctx.strokeStyle=brand; ctx.lineWidth=4*dpr; data.forEach((p,i)=>{let x=55*dpr+i*(w-100*dpr)/Math.max(1,data.length-1), y=h-40*dpr-(p.value/max)*(h-95*dpr); i?ctx.lineTo(x,y):ctx.moveTo(x,y);}); ctx.stroke(); ctx.lineTo(w-45*dpr,h-40*dpr); ctx.lineTo(55*dpr,h-40*dpr); ctx.closePath(); ctx.fillStyle='rgba(59,116,123,.22)'; ctx.fill();
 data.forEach((p,i)=>{let x=55*dpr+i*(w-100*dpr)/Math.max(1,data.length-1), y=h-40*dpr-(p.value/max)*(h-95*dpr); ctx.beginPath();ctx.arc(x,y,4*dpr,0,Math.PI*2);ctx.fillStyle=brand;ctx.fill();ctx.fillStyle=muted;ctx.fillText(p.label,x-12*dpr,h-12*dpr);});
}

async function profile(){ const j=await fetch('api/profile.php').then(r=>r.json()); const u=j.user, p=j.partner||{}; $('#content').innerHTML=`<section class="profile-grid"><div class="profile-card"><div class="profile-cover"></div><div class="profile-avatar"><img src="${u.profile_photo||'assets/img/avatar.svg'}"></div><button class="btn small" onclick="$('#photoInput').click()">Cambiar foto</button><h2>${u.full_name}</h2><span class="badge">${u.role}</span><div class="profile-info"><div><b>Email</b><p>${u.email}</p></div><div><b>Estado</b><p>${u.status}</p></div><div><b>Teléfono</b><p>${p.phone||'-'}</p></div><div><b>Cuenta / Wallet</b><p>${p.bank_account||'-'}</p></div><div><b>Capital</b><p>US$ ${money(p.capital_usd||0)}</p></div><div><b>Ganancias</b><p>US$ ${money(p.gains_usd||0)}</p></div></div><button class="btn primary" onclick='editProfile(${JSON.stringify({full_name:u.full_name,email:u.email,phone:p.phone||'',address:p.address||'',bank_account:p.bank_account||''})})'>Editar datos</button></div><div class="panel"><h2>Accesos rápidos</h2>${state.modules.filter(m=>perm(m.key,'can_view')&&m.key!=='perfil').slice(0,8).map(m=>`<button class="btn quick" onclick="route('${m.key}')">${m.name}</button>`).join('')}</div></section>`; }
async function editProfile(row){ let html=`<form id="swForm" class="form-grid"><div class="field"><label>Nombre completo</label><input name="full_name" value="${row.full_name}"></div><div class="field"><label>Email</label><input name="email" type="email" value="${row.email}"></div><div class="field"><label>Teléfono</label><input name="phone" value="${row.phone}"></div><div class="field"><label>Cuenta / Wallet</label><input name="bank_account" value="${row.bank_account}"></div><div class="field full"><label>Dirección</label><input name="address" value="${row.address}"></div><div class="field full"><label>Nueva contraseña</label><input name="password" type="password" placeholder="Dejar vacío para conservar"></div></form>`; const res=await Swal.fire({title:'Editar mi perfil',html,showCancelButton:true,confirmButtonText:'Guardar',width:760,preConfirm:()=>fetch('api/profile.php',{method:'POST',body:new FormData($('#swForm'))}).then(r=>r.json()).then(j=>{if(!j.ok)throw new Error(j.message);return j}).catch(e=>Swal.showValidationMessage(e.message))}); if(res.isConfirmed){Swal.fire('Listo','Perfil actualizado','success').then(()=>location.reload())} }


const columnLabels={
 id:'ID',full_name:'Nombre completo',email:'Email',role:'Rol',status:'Estado',profile_photo:'Foto',created_at:'Creado',updated_at:'Actualizado',partner_code:'Código de socio',phone:'Teléfono',address:'Dirección',bank_account:'Cuenta / Wallet',capital_usd:'Aporte societario USD',gains_usd:'Ganancias acumuladas USD',kyc_status:'KYC',joined_at:'Fecha de ingreso',referrer:'Socio referente',referrer_partner_id:'Socio referente',referred_name:'Nombre referido',referred_email:'Email referido',commission_percent:'% comisión',profit_date:'Fecha ganancia broker',gross_profit_usd:'Ganancia broker USD',master_share_usd:'60% El Master Profe',partners_share_usd:'40% socios',notes:'Notas',partner:'Socio inversor',partner_id:'Socio inversor',partner_capital:'Aporte societario USD',amount_usd:'Monto USD',percent_share:'% participación',request_type:'Tipo de retiro',destination:'Destino / Wallet',label:'Etiqueta',phone:'Teléfono',message:'Mensaje',title:'Título',body:'Mensaje',type:'Tipo',is_read:'Leída',author:'Autor',event:'Evento',name:'Nivel',amount_usd:'Monto USD'};
const entityLabels={users:'Usuario',partners:'Socio inversor',referrals:'Referido',broker_profits:'Ganancia broker',distributions:'Distribución',capital_levels:'Nivel de capital',withdrawals:'Retiro',whatsapp_numbers:'WhatsApp',notifications:'Notificación',audit_logs:'Auditoría'};
const hiddenFields={distributions:['partner_id'],referrals:['referrer_partner_id'],withdrawals:['partner_id']};
function label(k){return columnLabels[k]||k.replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}
function prettyValue(k,v){ if(v==null||v==='')return '-'; if(['capital_usd','gains_usd','gross_profit_usd','master_share_usd','partners_share_usd','amount_usd','partner_capital'].includes(k)) return 'US$ '+money(v); if(k==='percent_share'||k==='commission_percent') return money(v)+'%'; const map={active:'Activo',inactive:'Inactivo',pendiente:'Pendiente',en_proceso:'En proceso',transferido:'Transferido',acreditado:'Acreditado',pagado:'Pagado',rechazado:'Rechazado',ganancias:'Ganancias',capital_total:'Capital total',superadmin:'SuperAdmin',empleado:'Empleado',socio:'Socio',aprobado:'Aprobado'}; return map[String(v)]||String(v).replaceAll('_',' '); }

async function tablePage(routeName){
 const entity=entityMap[routeName];
 const j=await fetch(`api/data.php?entity=${entity}`,{credentials:'same-origin'}).then(r=>r.json());
 state.rows=j.rows||[]; state.page=1; state.perPage=10;
 $('#content').innerHTML=`<section class="panel data-panel ${routeName==='distribuciones'?'distribuciones-panel':''}">${routeName==='distribuciones'?'<div class="module-note"><b>Distribución de ganancias</b><p>El 40% de cada ganancia broker se reparte en partes iguales entre todos los socios inversores activos. El capital aportado queda registrado solo como dato societario.</p></div>':''}
   <div class="toolbar module-toolbar"><input class="search" id="search" placeholder="Buscar...">
   <div class="actions top-export">
     <button class="btn" onclick="importCSV('${entity}')">Importar CSV</button>
     ${perm(routeName,'can_export')?`<button class="btn" onclick="exportCSV('${entity}')">Exportar CSV</button><button class="btn" onclick="exportPDF('${routeName}')">Exportar PDF</button>`:''}
     ${schemas[entity]&&perm(routeName,'can_create')?`<button class="btn yellow" onclick="openForm('${entity}')">+ Nuevo</button>`:''}
   </div></div>
   <div class="pager-row"><label>Mostrar <select id="perPage"><option>5</option><option selected>10</option><option>25</option><option>50</option><option>100</option><option>500</option><option>1000</option></select></label><span id="pageInfo"></span><div><button class="btn" id="prevPage">← Atrás</button><button class="btn" id="nextPage">Siguiente →</button></div></div>
   <div class="table-wrap"><table id="dataTable"></table></div>
   <div class="pager-row bottom"><p id="count"></p><div><button class="btn" id="prevPage2">← Atrás</button><button class="btn" id="nextPage2">Siguiente →</button></div></div>
 </section>`;
 $('#search').oninput=()=>{state.page=1;renderRows(entity,routeName)};
 $('#perPage').onchange=()=>{state.perPage=+$('#perPage').value;state.page=1;renderRows(entity,routeName)};
 $('#prevPage').onclick=$('#prevPage2').onclick=()=>{if(state.page>1){state.page--;renderRows(entity,routeName)}};
 $('#nextPage').onclick=$('#nextPage2').onclick=()=>{state.page++;renderRows(entity,routeName)};
 renderRows(entity,routeName);
}
function renderRows(entity,routeName){
 let q=($('#search')?.value||'').toLowerCase();
 let rows=state.rows.filter(r=>Object.values(r).join(' ').toLowerCase().includes(q));
 state.filtered=rows;
 let keys=rows[0]?Object.keys(rows[0]).filter(k=>!['password_hash',...(hiddenFields[entity]||[])].includes(k)):[];
 const total=rows.length, pages=Math.max(1,Math.ceil(total/state.perPage)); if(state.page>pages)state.page=pages;
 const start=(state.page-1)*state.perPage; const pageRows=rows.slice(start,start+state.perPage);
 $('#dataTable').innerHTML=`<thead><tr><th><input type="checkbox" id="checkAll"></th>${keys.map(k=>`<th>${label(k)}</th>`).join('')}<th>Acciones</th></tr></thead><tbody>${pageRows.map(r=>`<tr><td><input class="row-check" type="checkbox" value="${r.id}"></td>${keys.map(k=>`<td>${fmt(k,r[k])}</td>`).join('')}<td>${actionBtns(entity,routeName,r)}</td></tr>`).join('')||`<tr><td colspan="${keys.length+2}">Sin registros</td></tr>`}</tbody>`;
 $('#checkAll')?.addEventListener('change',e=>$$('.row-check').forEach(c=>c.checked=e.target.checked));
 $('#count').textContent=`Mostrando ${pageRows.length} de ${total} registros`;
 $('#pageInfo').textContent=`Página ${state.page} de ${pages}`;
 ['prevPage','prevPage2'].forEach(id=>{const b=$('#'+id); if(b)b.disabled=state.page<=1}); ['nextPage','nextPage2'].forEach(id=>{const b=$('#'+id); if(b)b.disabled=state.page>=pages});
}
function selectedIds(){return $$('.row-check:checked').map(x=>x.value)}
function actionBtns(entity,routeName,r){ const lockSocioWithdrawal=(state.user.role==='socio'&&entity==='withdrawals'); return `<button class="rowbtn" title="Ver" onclick='viewRow(${JSON.stringify(r)})'>${ICON.eye}</button>${schemas[entity]&&perm(routeName,'can_edit')&&!lockSocioWithdrawal?`<button class="rowbtn" title="Editar" onclick='openForm("${entity}",${JSON.stringify(r)})'>${ICON.edit}</button>`:''}${schemas[entity]&&perm(routeName,'can_delete')&&!lockSocioWithdrawal?`<button class="rowbtn" title="Eliminar" onclick='delRow("${entity}",${r.id})'>${ICON.trash}</button>`:''}`; }
function fmt(k,v){ if(v==null)return ''; if(['status','role','kyc_status'].some(x=>k.includes(x))) return `<span class="badge ${String(v).includes('rechaz')||String(v).includes('inactive')?'danger':String(v).includes('pend')||String(v).includes('solicit')||String(v).includes('proceso')?'warn':''}">${prettyValue(k,v)}</span>`; if(String(k).includes('photo')) return `<img src="${v}" style="width:38px;height:38px;border-radius:50%;object-fit:cover">`; return prettyValue(k,v); }
async function loadOptions(){ const o=await fetch('api/form_options.php',{credentials:'same-origin'}).then(r=>r.json()); state.options.partners=o.partners||[]; state.options.capital_levels=o.capital_levels||[]; }
async function openForm(entity,row={}){ await loadOptions(); let fields=[...(schemas[entity]||[])]; const isSocio=state.user.role==='socio';
 if(entity==='withdrawals' && isSocio){
   fields=fields.filter(f=>!['partner_id','request_type','status'].includes(f[0]));
   const p=(state.options.partners||[])[0]||{};
   if(!row.destination && p.bank_account) row.destination=p.bank_account;
 }
 if(entity==='referrals' && isSocio){ fields=fields.filter(f=>f[0]!=='referrer_partner_id'); }
 if(entity==='distributions'){
   fields=[['status','Estado','select',['pendiente','en_proceso','transferido','acreditado','pagado']]];
 }
 let html=`<form id="swForm" class="form-grid">${entity==='distributions'?`<input type="hidden" name="partner_id" value="${row.partner_id||''}"><input type="hidden" name="amount_usd" value="${row.amount_usd||0}"><input type="hidden" name="percent_share" value="${row.percent_share||0}"><div class="field"><label>Socio</label><input value="${row.partner||''}" disabled></div><div class="field"><label>Saldo actual no editable</label><input value="US$ ${money(row.amount_usd||0)}" disabled></div>`:''}${fields.map(f=>fieldHtml(f,row)).join('')}</form>`;
 if(entity==='withdrawals' && isSocio){
   const p=(state.options.partners||[])[0]||{};
   html=`<div class="module-note"><b>Solicitud de retiro de ganancias</b><p>Disponible actual: <b>US$ ${money(p.gains_usd||0)}</b>. La solicitud se registra inicialmente como <b>Pendiente</b>; solo el SuperAdmin puede cambiar su estado.</p></div>`+html;
 }
 const res=await Swal.fire({title:(row.id?'Editar ':'Nuevo ')+(entityLabels[entity]||entity),html,showCancelButton:true,confirmButtonText:'Guardar',width:780,preConfirm:()=>{let fd=new FormData($('#swForm')); fd.append('entity',entity); if(row.id)fd.append('id',row.id); return fetch('api/save.php',{method:'POST',body:fd,credentials:'same-origin'}).then(r=>r.json()).then(j=>{if(!j.ok)throw new Error(j.message); return j}).catch(e=>Swal.showValidationMessage(e.message));}}); if(res.isConfirmed){Swal.fire('Listo','Guardado correctamente','success'); tablePage(state.current);} }
function fieldHtml(f,row){let [name,label,type='text',opts=[]]=f,val=row[name]??''; if(type==='select') return `<div class="field"><label>${label}</label><select name="${name}">${opts.map(o=>`<option ${val==o?'selected':''}>${o}</option>`)}</select></div>`; if(type==='partnerselect') return `<div class="field"><label>${label}</label><select name="${name}">${(state.options.partners||[]).map(p=>`<option value="${p.id}" ${val==p.id?'selected':''}>${p.full_name}</option>`)}</select></div>`; if(type==='textarea') return `<div class="field full"><label>${label}</label><textarea name="${name}">${val}</textarea></div>`; if(name==='password'&&row.id) val=''; return `<div class="field"><label>${label}</label><input name="${name}" type="${type}" value="${val}" placeholder="${name==='password'&&row.id?'Dejar vacío para conservar contraseña':''}"></div>`; }
function viewRow(r){ Swal.fire({title:'Detalle del registro',html:`<div class="detail-grid">${Object.entries(r).filter(([k])=>k!=='password_hash').map(([k,v])=>`<div><b>${label(k)}</b><span>${prettyValue(k,v)}</span></div>`).join('')}</div>`,width:760}); }
async function delRow(entity,id){ let r=await Swal.fire({title:'¿Eliminar registro?',icon:'warning',showCancelButton:true,confirmButtonText:'Eliminar'}); if(!r.isConfirmed)return; let fd=new FormData();fd.append('entity',entity);fd.append('id',id); let j=await fetch('api/delete.php',{method:'POST',body:fd,credentials:'same-origin'}).then(r=>r.json()); if(j.ok){Swal.fire('Eliminado','','success');tablePage(state.current)}else Swal.fire('Error',j.message,'error');}
function importCSV(entity){ Swal.fire('Importar CSV','Función preparada para carga masiva. En esta entrega queda centralizada para conectar el importador definitivo por entidad.','info'); }
async function roles(){ let mods=state.modules, roles=['superadmin','empleado','socio']; $('#content').innerHTML=`<section class="panel"><div class="toolbar"><div><h2>Roles y permisos</h2><p>Configurar visualización y ABM por módulo.</p></div><button class="btn yellow" id="savePerms">Guardar permisos</button></div><div class="table-wrap role-matrix"><table><thead><tr><th>Módulo</th>${roles.map(r=>`<th>${r}</th>`).join('')}</tr></thead><tbody>${mods.map(m=>`<tr><td><b>${m.name}</b></td>${roles.map(r=>{let p=state.perms.find(x=>x.module_key===m.key&&x.role===r)||{};return `<td>${actions.map(a=>`<label class="check"><input type="checkbox" data-module="${m.key}" data-name="${m.name}" data-role="${r}" data-action="${a}" ${+p[a]?'checked':''}> ${actionLabels[a]}</label>`).join('')}</td>`}).join('')}</tr>`).join('')}</tbody></table></div></section>`; $('#savePerms').onclick=savePerms; }
async function savePerms(){ const roles=['superadmin','empleado','socio']; let data=[]; for(const m of state.modules){ for(const r of roles){ let obj={module_key:m.key,module_name:m.name,role:r}; actions.forEach(a=>obj[a]=$(`input[data-module="${m.key}"][data-role="${r}"][data-action="${a}"]`)?.checked?1:0); data.push(obj); } } let j=await fetch('api/permissions.php',{method:'POST',body:JSON.stringify(data)}).then(r=>r.json()); if(j.ok){Swal.fire('Listo','Permisos guardados','success'); state.perms=data; renderMenu();} else Swal.fire('Error',j.message,'error'); }

async function configuraciones(){
 const j=await fetch('api/settings.php',{credentials:'same-origin'}).then(r=>r.json()).catch(()=>({settings:state.settings||{}}));
 const c=j.settings||state.settings||{}; state.settings=c;
 $('#content').innerHTML=`<section class="panel settings-panel"><div class="toolbar"><div><h2>Configuraciones de la PWA</h2><p>Personalización visual, identidad, logo, favicon, icono instalable y logo de emails.</p></div><button class="btn yellow" id="saveSettings">Guardar configuración</button></div>
 <form id="settingsForm" class="settings-grid">
  <div class="field"><label>Título de la PWA</label><input name="app_title" value="${c.app_title||''}"></div>
  <div class="field"><label>Título corto</label><input name="app_short_title" value="${c.app_short_title||''}"></div>
  <div class="field"><label>Subtítulo</label><input name="app_subtitle" value="${c.app_subtitle||''}"></div>
  <div class="field"><label>Color título</label><input name="title_color" type="color" value="${c.title_color||'#ffffff'}"></div>
  <div class="field"><label>Color subtítulo</label><input name="subtitle_color" type="color" value="${c.subtitle_color||'#ffe05d'}"></div>
  <div class="field"><label>Color principal</label><input name="brand_color" type="color" value="${c.brand_color||'#3b747b'}"></div>
  <div class="field"><label>Color acento</label><input name="accent_color" type="color" value="${c.accent_color||'#69d3d1'}"></div>
  <div class="field"><label>Logo del sistema</label><input name="logo" type="file" accept="image/*,.svg,.ico"><small>${c.logo_path||''}</small></div>
  <div class="field"><label>Favicon</label><input name="favicon" type="file" accept="image/*,.svg,.ico"><small>${c.favicon_path||''}</small></div>
  <div class="field"><label>Icono PWA instalable</label><input name="pwa_icon" type="file" accept="image/*,.svg,.ico"><small>${c.pwa_icon_path||''}</small></div>
  <div class="field"><label>Logo para emails</label><input name="email_logo" type="file" accept="image/*,.svg,.ico"><small>${c.email_logo_path||''}</small></div>
 </form>
 <div class="module-note"><b>Plantillas de email</b><p>Las plantillas HTML se encuentran en la carpeta <b>/emails</b>. El logo de email se puede cambiar desde esta pantalla.</p></div></section>`;
 $('#saveSettings').onclick=async()=>{ const fd=new FormData($('#settingsForm')); const r=await fetch('api/settings.php',{method:'POST',body:fd,credentials:'same-origin'}).then(r=>r.json()).catch(()=>({ok:false,message:'Error de conexión'})); if(r.ok){state.settings=r.settings; Swal.fire('Listo','Configuración guardada correctamente','success').then(()=>location.reload());} else Swal.fire('Error',r.message||'No se pudo guardar','error'); };
}

function exportCSV(entity){ location.href=`api/export_csv.php?entity=${entity}`; }
function exportPDF(title){ const {jsPDF}=window.jspdf; const doc=new jsPDF({orientation:'landscape'}); doc.setFillColor(59,116,123); doc.roundedRect(14,9,11,11,2,2,'F'); doc.setTextColor(255,255,255); doc.setFontSize(10); doc.text('↗',17,17); doc.setTextColor(0,0,0); doc.setFontSize(16); doc.text((state.settings.app_title||'EL MASTER PROFE CRM'),30,16); doc.setFontSize(11); doc.text(`Reporte: ${titles[title]} · Fecha y hora: ${new Date().toLocaleString()} · Solicitante: ${state.user.full_name}`,14,28); doc.autoTable({html:$('#dataTable'),startY:36,styles:{fontSize:7},headStyles:{fillColor:[59,116,123]}}); doc.save(`${title}_${Date.now()}.pdf`); }
async function uploadPhoto(){let fd=new FormData();fd.append('photo',$('#photoInput').files[0]);let j=await fetch('api/upload_profile.php',{method:'POST',body:fd}).then(r=>r.json()); if(j.ok){$('#profileImg').src=j.path;Swal.fire('Listo','Foto actualizada','success')}else Swal.fire('Error',j.message,'error');}
async function showWhatsApp(){let j=await fetch('api/data.php?entity=whatsapp_numbers').then(r=>r.json()); let rows=(j.rows||[]).filter(x=>x.status==='active'); let old=$('.wa-menu'); if(old) return old.remove(); let d=document.createElement('div'); d.className='wa-menu'; d.innerHTML=rows.map(w=>`<a target="_blank" href="https://wa.me/${w.phone}?text=${encodeURIComponent(w.message)}">${w.label}</a>`).join('')||'<span>Sin números configurados</span>'; document.body.appendChild(d);}
function money(n){return Number(n||0).toLocaleString('en-US',{maximumFractionDigits:2})}
init();
