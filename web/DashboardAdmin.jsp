<%@ page import="java.util.*, DAO.ReservaDAO, Modelo.Reserva" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
        }

        .navbar {
            background: rgba(0, 255, 153, 0.1);
            backdrop-filter: blur(10px);
            padding: 15px 25px;
            border-bottom: 1px solid rgba(0, 255, 153, 0.2);
        }

        .navbar h4 {
            color: #00ff99;
            font-weight: 600;
            margin: 0;
        }

        .container {
            max-width: 1100px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border-radius: 18px;
            padding: 35px 40px;
            margin: 50px auto;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
        }

        h2 {
            text-align: center;
            color: #00ff99;
            font-weight: 600;
            text-shadow: 0 0 10px rgba(0, 255, 153, 0.3);
            margin-bottom: 30px;
        }

        table {
            text-align: center;
            color: #fff;
            border-collapse: collapse;
        }

        thead {
            background: #00ff99;
            color: #000;
            font-weight: bold;
        }

        tbody tr {
            background: rgba(255, 255, 255, 0.05);
            transition: background 0.3s;
        }

        tbody tr:hover {
            background: rgba(0, 255, 153, 0.15);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-success {
            background-color: #00b874;
            border: none;
        }

        .btn-success:hover {
            background-color: #00e18b;
            transform: scale(1.05);
        }

        .btn-outline-danger {
            border-color: #ff4b4b;
            color: #ff4b4b;
        }

        .btn-outline-danger:hover {
            background: #ff4b4b;
            color: #fff;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 12px;
        }

        .top-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .footer-text {
            text-align: center;
            color: #aaa;
            font-size: 0.9rem;
            margin-top: 25px;
        }
    </style>
</head>
<body>

    <!-- Barra superior -->
    <nav class="navbar d-flex justify-content-between align-items-center">
        <h4>⚙️ Panel del Administrador</h4>
        <a href="LogoutController" class="btn btn-outline-danger btn-sm">Cerrar sesión</a>
    </nav>

    <!-- Contenido principal -->
    <div class="container">
        <h2>Gestión de Reservas</h2>

        <div class="top-buttons">
            <a href="VerLozas.jsp" class="btn btn-success">Ver Lozas</a>
            <a href="AgregarLoza.jsp" class="btn btn-success">Agregar Loza</a>
            <a href="VerReservas.jsp" class="btn btn-success">Ver Reservas</a>
        </div>

        <div class="table-container">
            <table class="table table-dark table-bordered table-hover align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Cliente</th>
                        <th>Cancha</th>
                        <th>Fecha</th>
                        <th>Hora Inicio</th>
                        <th>Hora Fin</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ReservaDAO dao = new ReservaDAO();
                        List<Reserva> lista = dao.listarTodas();
                        for(Reserva r : lista){
                    %>
                    <tr>
                        <td><%= r.getIdReserva() %></td>
                        <td><%= r.getNombreCliente() %></td>
                        <td><%= r.getNombreLoza() %></td>
                        <td><%= r.getFecha() %></td>
                        <td><%= r.getHoraInicio() %></td>
                        <td><%= (r.getHoraFin() == null ? "-" : r.getHoraFin()) %></td>
                        <td><%= r.getEstado() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <p class="footer-text">© 2025 Gestión de Lozas Deportivas — Panel Administrativo</p>
    </div>

</body>
</html>
