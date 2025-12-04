<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Cliente</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: grid;
            place-items: center;
        }
        .card {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 32px;
            width: 460px;
            color: #fff;
            box-shadow: 0 4px 30px rgba(0,0,0,.5);
        }
        h3 { color:#00ff99; text-shadow:0 0 10px rgba(0,255,153,.4); text-align:center; margin-bottom:22px; }
        .form-control { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); color:#fff; }
        .form-control:focus { background:rgba(255,255,255,.15); border-color:#00ff99; box-shadow:0 0 5px #00ff99; }
        .btn-success { background:#00b874; border:none; }
        .btn-success:hover { background:#00e18b; transform:scale(1.02); }
        .btn-outline-light { border:1px solid #ccc; color:#fff; }
        .btn-outline-light:hover { background:rgba(255,255,255,.1); }
        .text-danger small { color:#ff8d8d !important; }
    </style>
</head>
<body>

<div class="card shadow">
    <h3>Registro de Nuevo Cliente</h3>

    <% String err = (String) request.getAttribute("error"); %>
    <% if (err != null) { %>
      <div class="alert alert-danger py-2" role="alert" style="border-radius:10px;">
        <%= err %>
      </div>
    <% } %>

    <form action="ClienteController" method="post" onsubmit="return validarFormulario()">
        <div class="mb-3">
            <label class="form-label">Nombre</label>
            <input type="text" class="form-control" name="nombre" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Apellidos</label>
            <input type="text" class="form-control" name="apellidos" required>
        </div>
        <div class="mb-3">
            <label class="form-label">DNI</label>
            <input type="text" class="form-control" name="dni"
       id="dni" inputmode="numeric" pattern="\d{8}" maxlength="8"
       placeholder="8 dígitos" required>

        </div>
        <div class="mb-3">
            <label class="form-label">Teléfono</label>
            <input type="text" class="form-control" name="telefono"
           id="telefono" inputmode="numeric" pattern="\d{9}" maxlength="9"
           placeholder="9 dígitos" required>
    <div class="form-text text-light">Solo números, exactamente 9 dígitos.</div>
        </div>
        <div class="mb-3">
            <label class="form-label">Correo electrónico</label>
            <input type="email" class="form-control" name="email" id="email"
                   placeholder="ejemplo@dominio.com" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Dirección</label>
            <input type="text" class="form-control" name="direccion">
        </div>
        <div class="mb-3">
            <label class="form-label">Usuario</label>
            <input type="text" class="form-control" name="usuario" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Contraseña</label>
            <input type="password" class="form-control" name="clave" required>
        </div>

        <button type="submit" class="btn btn-success w-100 mt-2">Registrar</button>
        <a href="login.jsp" class="btn btn-outline-light w-100 mt-2">Volver al Login</a>
    </form>
</div>

<script>
function validarFormulario() {
    const tel = document.getElementById('telefono').value.trim();
    const dni = document.getElementById('dni').value.trim();
    const email = document.getElementById('email').value.trim();

    const reTel = /^\d{9}$/;          // 9 dígitos exactos
    const reDni = /^\d{8}$/;          // 8 dígitos exactos
    const reMail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/;

    if (!reDni.test(dni)) {
        alert('⚠️ El DNI debe tener exactamente 8 dígitos numéricos.');
        return false;
    }
    if (!reTel.test(tel)) {
        alert('⚠️ El teléfono debe tener solo números y exactamente 9 dígitos.');
        return false;
    }
    if (!reMail.test(email)) {
        alert('⚠️ Ingrese un correo electrónico válido (ejemplo@dominio.com).');
        return false;
    }
    return true;
}
</script>
<script>
function validarReserva() {
    document.querySelectorAll('.text-danger').forEach(div => div.innerHTML = "");

    let valido = true;

    const loza = document.getElementById("IdLoza").value.trim();
    const fecha = document.getElementById("fecha").value.trim();
    const hora = document.querySelector("input[name='hora']:checked");

    // Validar Loza
    if (loza === "") {
        document.getElementById("errorLoza").innerText = "⚠ Debe seleccionar una loza.";
        valido = false;
    }

    // Validar Fecha (no vacia ni pasada)
    if (fecha === "") {
        document.getElementById("errorFecha").innerText = "⚠ Debe seleccionar una fecha.";
        valido = false;
    } else {
        const hoy = new Date();
        hoy.setHours(0,0,0,0);

        const fechaSel = new Date(fecha);

        if (fechaSel < hoy) {
            document.getElementById("errorFecha").innerText = "⚠ La fecha no puede ser pasada.";
            valido = false;
        }
    }

    // Validar Hora
    if (!hora) {
        document.getElementById("errorHora").innerText = "⚠ Debe elegir un horario.";
        valido = false;
    }

    return valido;
}
</script>






</body>
<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
   <div class="alert alert-danger text-center mt-3"><%= error %></div>
<% } %>

<% if (request.getParameter("registro") != null && request.getParameter("registro").equals("exitoso")) { %>
   <div class="alert alert-success text-center mt-3">¡Registro exitoso! Ya puedes iniciar sesión.</div>
<% } %>

</html>
