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