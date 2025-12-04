<%@ page import="java.util.List" %>
<%@ page import="Modelo.Reserva" %>
<%@ page import="DAO.ReservaDAO" %>
<%@ page import="Modelo.Cliente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession sesion = request.getSession();
    Cliente cliente = (Cliente) sesion.getAttribute("cliente");
    if (cliente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ReservaDAO dao = new ReservaDAO();
    List<Reserva> lista = dao.listarPorCliente(cliente.getIdCliente());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Cliente</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            min-height: 100vh;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Poppins', sans-serif;
        }

        .dashboard-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            width: 70%;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
            color: #fff;
        }

        h2 {
            font-weight: 600;
            color: #00ff99;
            text-shadow: 0 0 10px rgba(0, 255, 153, 0.4);
        }

        .btn-success {
            background-color: #00b874;
            border: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .btn-success:hover {
            background-color: #00e18b;
            transform: scale(1.05);
        }

        .btn-danger {
            border: none;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            transform: scale(1.05);
        }

        table {
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }

        thead {
            background-color: rgba(0, 255, 153, 0.2);
            color: #00ff99;
        }

        tbody tr:hover {
            background-color: rgba(0, 255, 153, 0.1);
        }

        hr {
            border-color: #00ff99;
            opacity: 0.5;
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Bienvenido <%= cliente.getNombre() %></h2>
        <a href="LogoutController" class="btn btn-danger">Cerrar sesión</a>
    </div>

    <a href="ReservaLosa.jsp" class="btn btn-success mb-4">Reservar Losa</a>

    <hr>

    <h4 class="mb-3">Mis Reservas</h4>
    <table class="table table-hover text-center">
        <thead>
        <tr>
            <th>#</th>
            <th>Loza</th>
            <th>Fecha</th>
            <th>Hora Inicio</th>
            <th>Hora Fin</th>
            <th>Estado</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (lista != null && !lista.isEmpty()) {
                for (Reserva r : lista) {
        %>
        <tr>
            <td><%= r.getIdReserva() %></td>
            <td><%= r.getNombreLoza() %></td>
            <td><%= r.getFecha() %></td>
            <td><%= r.getHoraInicio() %></td>
            <td><%= r.getHoraFin() != null ? r.getHoraFin() : "-" %></td>
            <td><%= r.getEstado() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="6" class="text-center text-muted">No tienes reservas registradas.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
