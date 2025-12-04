<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.LozaDAO" %>
<%@ page import="Modelo.Loza" %>
<%@ page import="java.util.List" %>

<%
    LozaDAO dao = new LozaDAO();
    List<Loza> lista = dao.listar();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Lozas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #0a0a0a;
            color: white;
            font-family: 'Poppins', sans-serif;
        }
        .container {
            background-color: #111;
            border-radius: 15px;
            padding: 30px;
            margin-top: 50px;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
        }
        h2 {
            color: #00ff80;
            text-align: center;
            margin-bottom: 25px;
        }
        table {
            color: white;
        }
        .btn-success {
            background-color: #00c853;
            border: none;
        }
        .btn-warning {
            background-color: #ffc107;
            border: none;
            color: black;
        }
        .btn-danger {
            background-color: #e53935;
            border: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Gestión de Lozas</h2>

    <div class="mb-3 text-center">
        <a href="AgregarLoza.jsp" class="btn btn-success">Agregar Nueva Loza</a>
        <a href="DashboardAdmin.jsp" class="btn btn-secondary">Volver al Dashboard</a>
        <a href="LogoutController" class="btn btn-outline-danger btn-sm">Cerrar sesión</a>
    </div>

    <table class="table table-dark table-bordered text-center align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Ubicación</th>
                <th>Tipo</th>
                <th>Precio por Hora</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Loza l : lista) {
        %>
            <tr>
                <td><%= l.getIdLoza() %></td>
                <td><%= l.getNombre() %></td>
                <td><%= l.getUbicacion() %></td>
                <td><%= l.getTipo() %></td>
                <td>S/ <%= l.getPrecioHora() %></td>
                <td>

                    <a href="EditarLoza.jsp?idLoza=<%= l.getIdLoza() %>" 
                       class="btn btn-warning btn-sm">Editar</a>

                    <!-- BOTÓN ELIMINAR -->
                    <form action="LozaController" method="post" style="display:inline;"
                          onsubmit="return confirm('¿Seguro que deseas eliminar esta loza?');">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="idLoza" value="<%= l.getIdLoza() %>">
                        <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                    </form>

                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
