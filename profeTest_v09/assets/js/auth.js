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
    window.location.href = 'auth/google-login.php';
  });
}


const createBtn = document.getElementById('createBtn');
if (createBtn) {
  createBtn.addEventListener('click', async () => {
    const result = await Swal.fire({
      title: 'Crear cuenta',
      html: `
        <input id="regName" class="swal2-input" placeholder="Nombre completo">
        <input id="regEmail" class="swal2-input" type="email" placeholder="Email">
        <input id="regPass" class="swal2-input" type="password" placeholder="Contraseña mínima 6 caracteres">
      `,
      confirmButtonText: 'Crear cuenta',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      focusConfirm: false,
      preConfirm: () => {
        const full_name = document.getElementById('regName').value.trim();
        const email = document.getElementById('regEmail').value.trim();
        const password = document.getElementById('regPass').value;
        if (!full_name || !email || !password) {
          Swal.showValidationMessage('Completá nombre, email y contraseña.');
          return false;
        }
        if (password.length < 6) {
          Swal.showValidationMessage('La contraseña debe tener al menos 6 caracteres.');
          return false;
        }
        return { full_name, email, password };
      }
    });

    if (!result.isConfirmed || !result.value) return;

    const fd = new FormData();
    fd.append('full_name', result.value.full_name);
    fd.append('email', result.value.email);
    fd.append('password', result.value.password);

    try {
      const res = await fetch('api/register.php', {
        method: 'POST',
        body: fd,
        credentials: 'same-origin'
      });
      const data = await res.json();
      if (!res.ok || !data.ok) {
        Swal.fire({ icon: 'error', title: 'Error', text: data.message || 'No se pudo crear la cuenta.' });
        return;
      }
      Swal.fire({ icon: 'success', title: 'Cuenta creada', text: data.message || 'Cuenta creada. Queda pendiente de aprobación.' });
    } catch (err) {
      Swal.fire({ icon: 'error', title: 'Error de conexión', text: 'No se pudo conectar con el servidor.' });
    }
  });
}

const recoverBtn = document.getElementById('recoverBtn');
if (recoverBtn) {
  recoverBtn.addEventListener('click', async () => {
    const result = await Swal.fire({
      title: 'Recuperar contraseña',
      input: 'email',
      inputLabel: 'Email de la cuenta',
      inputPlaceholder: 'tu@email.com',
      confirmButtonText: 'Solicitar recupero',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      inputValidator: (value) => {
        if (!value) return 'Ingresá tu email.';
      }
    });

    if (!result.isConfirmed || !result.value) return;

    const fd = new FormData();
    fd.append('email', result.value.trim());

    try {
      const res = await fetch('api/recover.php', {
        method: 'POST',
        body: fd,
        credentials: 'same-origin'
      });
      const data = await res.json();
      if (!res.ok || !data.ok) {
        Swal.fire({ icon: 'error', title: 'Error', text: data.message || 'No se pudo solicitar el recupero.' });
        return;
      }
      Swal.fire({ icon: 'success', title: 'Solicitud enviada', text: data.message || 'Se registró la solicitud de recupero.' });
    } catch (err) {
      Swal.fire({ icon: 'error', title: 'Error de conexión', text: 'No se pudo conectar con el servidor.' });
    }
  });
}
