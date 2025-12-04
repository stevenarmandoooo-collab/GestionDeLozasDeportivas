<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Gestión de Lozas</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Poppins', sans-serif;
            color: #fff;
        }

        .card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
            width: 25rem;
            color: white;
        }

        .card h3 {
            font-weight: 600;
            color: #00ff99;
            text-shadow: 0 0 10px rgba(0, 255, 153, 0.4);
        }

        .form-control {
            background: rgba(255, 255, 255, 0.15);
            border: none;
            color: #fff;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            box-shadow: none;
        }

        .btn-login {
            background-color: #00b874;
            border: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background-color: #00e18b;
            transform: scale(1.05);
        }

        .form-check-label {
            color: #ccc;
        }

        .alert {
            border-radius: 10px;
            text-align: center;
        }

        .alert-success {
            background: rgba(0, 255, 153, 0.15);
            border: 1px solid #00ff99;
            color: #00ff99;
        }

        .alert-danger {
            background: rgba(255, 0, 0, 0.15);
            border: 1px solid #ff4d4d;
            color: #ff7373;
        }

        .text-link {
            text-align: center;
            margin-top: 10px;
        }

        .text-link a {
            color: #00ff99;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .text-link a:hover {
            color: #00e18b;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="card shadow p-4 text-white">
    <h3 class="text-center mb-4">Iniciar Sesión</h3>

    <!-- ✅ Mensaje de registro exitoso -->
    <%
        String registroExitoso = request.getParameter("registro");
        if ("exitoso".equals(registroExitoso)) {
    %>
        <div class="alert alert-success mt-2" role="alert">
            ✅ Registro completado con éxito. ¡Ahora puedes iniciar sesión!
        </div>
    <% } %>

    <!-- ❌ Mensaje de error (si las credenciales fallan) -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="alert alert-danger mt-2" role="alert">
            ⚠️ <%= error %>
        </div>
    <% } %>

    <form action="LoginController" method="post">
        <div class="mb-3">
            <label for="usuario" class="form-label">Usuario</label>
            <input type="text" class="form-control" id="usuario" name="usuario" placeholder="Ingresa tu usuario" required>
        </div>

        <div class="mb-3">
            <label for="clave" class="form-label">Contraseña</label>
            <input type="password" class="form-control" id="clave" name="clave" placeholder="••••••" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Ingresar como:</label><br>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rol" id="rolCliente" value="cliente" checked>
                <label class="form-check-label" for="rolCliente">Cliente</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rol" id="rolAdmin" value="admin">
                <label class="form-check-label" for="rolAdmin">Administrador</label>
            </div>
        </div>

        <button type="submit" class="btn btn-login w-100 py-2 mt-2">Ingresar</button>
    </form>

    <div class="text-link">
        ¿No tienes cuenta? <a href="RegistroCliente.jsp">Regístrate aquí</a>
    </div>
</div>

</body>
</html>
