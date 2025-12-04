<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="Modelo.Reserva" %>
<%@ page import="DAO.ReservaDAO" %>

<%
    request.setCharacterEncoding("UTF-8");
    ReservaDAO dao = new ReservaDAO();

    // --- parámetros ---
    String qIdStr = request.getParameter("qId");         // buscar DETALLE por idReserva
    String idClienteStr = request.getParameter("idCliente"); // FILTRO por idCliente

    // --- modo detalle por idReserva (tiene prioridad si viene qId) ---
    Reserva detalle = null;
    if (qIdStr != null && !qIdStr.isBlank()) {
        try {
            int qId = Integer.parseInt(qIdStr);
            // Debes tener este método en ReservaDAO:
            // public Reserva obtenerDetallePorId(int idReserva)
            detalle = dao.obtenerDetallePorId(qId);
        } catch (NumberFormatException ignore) {}
    }

    // --- listado ---
    List<Reserva> lista;
    if (detalle != null) {
        lista = Collections.emptyList(); // cuando hay detalle, escondemos el listado
    } else {
        Integer idClienteFiltro = null;
        try {
            if (idClienteStr != null && !idClienteStr.isBlank()) {
                idClienteFiltro = Integer.parseInt(idClienteStr);
            }
        } catch (NumberFormatException ignore) {}

        if (idClienteFiltro != null) {
            // Debes tener este método en ReservaDAO:
            // public List<Reserva> listarPorClienteAdmin(int idCliente)
            lista = dao.listarPorClienteAdmin(idClienteFiltro);
        } else {
            lista = dao.listarTodas();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #004d40, #009688); color: white; min-height: 100vh; }
        .container { background-color: rgba(255, 255, 255, 0.1); border-radius: 15px; padding: 30px; margin-top: 40px; }
        table { color: white; }
        thead tr { background-color: rgba(0, 0, 0, 0.3); }
        tbody tr:hover { background-color: rgba(255, 255, 255, 0.08); }
        a.btn, button.btn { border-radius: 8px; }
        .btn-warning { background-color: #ffca28; border: none; color: #000; font-weight: 500; }
        .btn-warning:hover { background-color: #ffd54f; color: #000; }
        .btn-danger { background-color: #e53935; border: none; }
        .btn-danger:hover { background-color: #ef5350; }
        .card-glass { background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.2); border-radius: 16px; }
        .muted { color: #d1f2f2; font-size: .9rem; }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">📋 Gestión de Reservas</h3>

    <!-- 🔎 Buscadores -->
    <div class="row g-3 mb-4">
        <!-- Buscar por ID de cliente (lista) -->
        <div class="col-md-7">
            <form class="row g-2 align-items-end" method="get" action="VerReservas.jsp">
                <div class="col-auto">
                    <label for="idCliente" class="col-form-label">Buscar por ID de cliente:</label>
                </div>
                <div class="col-auto">
                    <input type="number" min="1" class="form-control" id="idCliente" name="idCliente"
                           placeholder="Ej. 1" value="<%= (idClienteStr != null ? idClienteStr : "") %>">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-light">Filtrar</button>
                </div>
                <div class="col-auto">
                    <a href="VerReservas.jsp" class="btn btn-outline-light">Limpiar</a>
                </div>
            </form>
            <% if (! (qIdStr != null && !qIdStr.isBlank()) && idClienteStr != null && !idClienteStr.isBlank()) { %>
                <div class="mt-2">Mostrando reservas del cliente ID <strong><%= idClienteStr %></strong>.</div>
            <% } %>
        </div>

        <!-- Buscar detalle por ID de reserva (tarjeta) -->
        <div class="col-md-5">
            <form class="row g-2 align-items-end" method="get" action="VerReservas.jsp">
                <div class="col-auto">
                    <label for="qId" class="col-form-label">Detalle por ID de reserva:</label>
                </div>
                <div class="col-auto">
                    <input type="number" min="1" class="form-control" id="qId" name="qId"
                           placeholder="Ej. 123" value="<%= (qIdStr != null ? qIdStr : "") %>">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-light">Buscar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Si hay detalle, mostramos tarjeta; si no, listamos -->
    <%
        if (detalle != null) {
    %>
    <!-- 🧾 Tarjeta de detalle -->
    <div class="card card-glass p-3 mb-4">
        <h5 class="mb-3">Detalle de la reserva #<%= detalle.getIdReserva() %></h5>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Cliente:</strong> <%= detalle.getNombreCliente() %> <span class="muted">(ID Cliente: <%= detalle.getIdCliente() %>)</span></p>
                <p><strong>Loza:</strong> <%= detalle.getNombreLoza() %> <span class="muted">(ID Loza: <%= detalle.getIdLoza() %>)</span></p>
                <p><strong>Fecha:</strong> <%= detalle.getFecha() %></p>
            </div>
            <div class="col-md-6">
                <p><strong>Hora Inicio:</strong> <%= detalle.getHoraInicio() %></p>
                <p><strong>Hora Fin:</strong> <%= detalle.getHoraFin() %></p>
                <p><strong>Estado:</strong> <%= detalle.getEstado() %></p>
            </div>
        </div>
        <div class="mt-3 d-flex gap-2">
            <a href="EditarReserva.jsp?idReserva=<%= detalle.getIdReserva() %>" class="btn btn-warning btn-sm text-dark">Editar</a>
            <form action="ReservaController" method="post" onsubmit="return confirm('¿Eliminar la reserva #<%= detalle.getIdReserva() %>?');">
                <input type="hidden" name="accion" value="eliminar">
                <input type="hidden" name="idReserva" value="<%= detalle.getIdReserva() %>">
                <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
            </form>
            <a href="VerReservas.jsp" class="btn btn-outline-light btn-sm">Volver al listado</a>
        </div>
    </div>
    <%
        } else {
    %>

    <!-- 📑 Listado (total o filtrado por idCliente) -->
    <table class="table table-bordered text-center align-middle table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>ID Cliente</th>
            <th>Cliente</th>
            <th>Loza</th>
            <th>Fecha</th>
            <th>Hora Inicio</th>
            <th>Hora Fin</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (lista.isEmpty()) {
        %>
            <tr><td colspan="9">No hay reservas.</td></tr>
        <%
            } else {
                for (Reserva r : lista) {
        %>
            <tr>
                <td><%= r.getIdReserva() %></td>
                <td><%= r.getIdCliente() %></td>
                <td><%= r.getNombreCliente() %></td>
                <td><%= r.getNombreLoza() %></td>
                <td><%= r.getFecha() %></td>
                <td><%= r.getHoraInicio() %></td>
                <td><%= r.getHoraFin() %></td>
                <td><%= r.getEstado() %></td>
                <td>
                    <a href="EditarReserva.jsp?idReserva=<%= r.getIdReserva() %>" class="btn btn-warning btn-sm text-dark">Editar</a>
                    <form action="ReservaController" method="post" style="display:inline;" onsubmit="return confirm('¿Seguro que deseas eliminar esta reserva?');">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="idReserva" value="<%= r.getIdReserva() %>">
                        <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                    </form>
                </td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    <%
        } // fin else listado
    %>

    <div class="text-center mt-4">
        <a href="DashboardAdmin.jsp" class="btn btn-light">⬅ Volver al Panel</a>
    </div>
</div>

</body>
</html>
