<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="Modelo.Administrador" %>

<%
    Administrador admin = (Administrador) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agregar Loza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #004d40, #009688);
            color: white;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
        }
        .container {
            max-width: 500px;
            background-color: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            margin-top: 60px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }
        label {
            font-weight: 500;
        }
        input, select {
            border-radius: 8px;
        }
        .btn {
            background-color: #26a69a;
            border: none;
        }
        .btn:hover {
            background-color: #2bbbad;
        }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">Agregar Nueva Loza</h3>

    <form action="LozaController" method="post">
        <input type="hidden" name="accion" value="agregar">

        <div class="mb-3">
            <label for="nombre" class="form-label">Nombre de la Loza</label>
            <input type="text" class="form-control" name="nombre" id="nombre" required>
        </div>

        <div class="mb-3">
            <label for="ubicacion" class="form-label">Ubicación</label>
            <input type="text" class="form-control" name="ubicacion" id="ubicacion" required>
        </div>

        <div class="mb-3">
            <label for="tipo" class="form-label">Tipo de Deporte</label>
            <select class="form-select" name="tipo" id="tipo" required>
                <option value="">Seleccione...</option>
                <option value="Fútbol">Fútbol</option>
                <option value="Vóley">Vóley</option>
                <option value="Básquet">Básquet</option>
                <option value="Tenis">Tenis</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="precioHora" class="form-label">Precio por hora (S/)</label>
            <input type="number" class="form-control" name="precioHora" id="precioHora" step="0.01" required>
        </div>

        <button type="submit" class="btn w-100 text-white">Guardar Loza</button>
        <a href="VerLozas.jsp" class="btn btn-outline-light w-100 mt-2">Volver</a>
    </form>
</div>

</body>
</html>
