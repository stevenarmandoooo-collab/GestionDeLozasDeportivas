<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.LozaDAO" %>
<%@ page import="Modelo.Loza" %>

<%
    int idLoza = Integer.parseInt(request.getParameter("idLoza"));
    LozaDAO dao = new LozaDAO();
    Loza loza = dao.obtenerPorId(idLoza);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Losa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #004d40, #009688);
            color: white;
            min-height: 100vh;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            margin-top: 60px;
            max-width: 600px;
        }
        label {
            color: white;
        }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">✏️ Editar Losa</h3>

    <form action="LozaController" method="post">
        <input type="hidden" name="accion" value="actualizar">
        <input type="hidden" name="idLoza" value="<%= loza.getIdLoza() %>">

        <div class="mb-3">
            <label for="nombre" class="form-label">Nombre</label>
            <input type="text" class="form-control" id="nombre" name="nombre" value="<%= loza.getNombre() %>" required>
        </div>

        <div class="mb-3">
            <label for="ubicacion" class="form-label">Ubicación</label>
            <input type="text" class="form-control" id="ubicacion" name="ubicacion" value="<%= loza.getUbicacion() %>" required>
        </div>

        <div class="mb-3">
            <label for="tipo" class="form-label">Tipo</label>
            <select id="tipo" name="tipo" class="form-select" required>
                <option value="Fútbol" <%= loza.getTipo().equals("Fútbol") ? "selected" : "" %>>Fútbol</option>
                <option value="Vóley" <%= loza.getTipo().equals("Vóley") ? "selected" : "" %>>Vóley</option>
                <option value="Básquet" <%= loza.getTipo().equals("Básquet") ? "selected" : "" %>>Básquet</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="precioHora" class="form-label">Precio por Hora (S/)</label>
            <input type="number" step="0.01" class="form-control" id="precioHora" name="precioHora" value="<%= loza.getPrecioHora() %>" required>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-success">💾 Guardar Cambios</button>
            <a href="VerLozas.jsp" class="btn btn-light">Cancelar</a>
        </div>
    </form>
</div>

</body>
</html>
