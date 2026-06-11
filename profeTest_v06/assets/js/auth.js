const form = document.getElementById('loginForm');

if (form) {
  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const fd = new FormData(form);

    const payload = {
      email: fd.get('email'),
      password: fd.get('password')
    };

    try {
      const res = await fetch('api/login.php', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify(payload)
      });

      const data = await res.json();

      if (!res.ok || !data.ok) {
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: data.message || 'Credenciales inválidas'
        });
        return;
      }

      window.location.href = data.redirect || './index.php?view=dashboard';

    } catch (err) {
      Swal.fire({
        icon: 'error',
        title: 'Error de conexión',
        text: 'No se pudo conectar con el servidor.'
      });
    }
  });
}
const googleBtn = document.getElementById('googleBtn');
if (googleBtn) {
  googleBtn.addEventListener('click', () => {
    Swal.fire({
      icon: 'info',
      title: 'Inicio / registro con Google',
      html: `<div style="text-align:left;line-height:1.55">
        <p><b>Para activar Google OAuth:</b></p>
        <ol>
          <li>Crear credenciales OAuth en Google Cloud Console.</li>
          <li>Agregar como URI autorizado: <code>${location.origin}${location.pathname.replace(/login\.php.*/, '')}api/google_callback.php</code></li>
          <li>Guardar <b>GOOGLE_CLIENT_ID</b> y <b>GOOGLE_CLIENT_SECRET</b> en la configuración del hosting.</li>
          <li>Una vez configurado, este botón permite iniciar sesión o crear la cuenta institucional.</li>
        </ol>
      </div>`,
      confirmButtonText: 'Entendido'
    });
  });
}
