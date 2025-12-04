<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="Modelo.Reserva, DAO.ReservaDAO, DAO.Conexion" %>
<%@ page import="java.sql.*" %>

<%
    String idReservaStr = request.getParameter("idReserva");
    if (idReservaStr == null) {
        response.sendRedirect("VerReservas.jsp");
        return;
    }

    int idReserva = Integer.parseInt(idReservaStr);
    ReservaDAO dao = new ReservaDAO();
    Reserva reserva = dao.obtenerPorId(idReserva);

    if (reserva == null) {
        response.getWriter().println("<h3>No se encontró la reserva con ID " + idReserva + "</h3>");
        return;
    }

    // Normaliza horas a HH:MM para <input type="time">
    String hIni = reserva.getHoraInicio();
    String hFin = reserva.getHoraFin();
    if (hIni != null && hIni.length() >= 5) hIni = hIni.substring(0, 5);
    if (hFin != null && hFin.length() >= 5) hFin = hFin.substring(0, 5);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Reserva</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #004d40, #009688); color: white; min-height: 100vh; }
        .container { background-color: rgba(255,255,255,0.1); border-radius: 15px; padding: 30px; margin-top: 60px; max-width: 600px; }
        label { font-weight: 500; }
        input, select { border-radius: 8px; }
        .btn { background-color: #26a69a; border: none; }
        .btn:hover { background-color: #2bbbad; }
        .muted { color: #d1f2f2; font-size: .9rem; }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">Editar Reserva</h3>

    <form action="ReservaController" method="post" onsubmit="return validarHoras();">
        <input type="hidden" name="accion" value="editar">
        <input type="hidden" name="idReserva" value="<%= reserva.getIdReserva() %>">

        <!-- Loza (cambiable) -->
        <div class="mb-3">
            <label for="idLoza" class="form-label">Loza / Cancha</label>
            <select class="form-select" id="idLoza" name="idLoza" style="pointer-events: none; background-color: #e9ecef;">
                <option value="">— Seleccione —</option>
                <%
                    try (Connection con = Conexion.getConnection();
                         PreparedStatement ps = con.prepareStatement(
                             "SELECT idLoza, nombre, tipo, precioHora FROM loza ORDER BY nombre"
                         );
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            int id = rs.getInt("idLoza");
                            String nombre = rs.getString("nombre");
                            String tipo = rs.getString("tipo");
                            int precio = rs.getInt("precioHora");
                            String selected = (id == reserva.getIdLoza()) ? "selected" : "";
                %>
                    <option value="<%= id %>" <%= selected %>>
                        <%= nombre %> — <%= tipo %> (S/ <%= precio %>/h)
                    </option>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("<option disabled>— Error cargando lozas —</option>");
                    }
                %>
            </select>
            <div class="muted mt-1">Puedes cambiar la loza si es necesario.</div>
        </div>

        <!-- Fecha -->
        <div class="mb-3">
            <label for="fecha" class="form-label">Fecha</label>
            <input type="date" class="form-control" id="fecha" name="fecha" value="<%= reserva.getFecha() %>" readonly>
        </div>

        <!-- Hora inicio -->
        <div class="mb-3">
            <label for="horaInicio" class="form-label">Hora de inicio</label>
            <input type="time" class="form-control" id="horaInicio" name="horaInicio" value="<%= hIni %>" readonly>
        </div>

        <!-- Hora fin -->
        <div class="mb-3">
            <label for="horaFin" class="form-label">Hora de fin</label>
            <input type="time" class="form-control" id="horaFin" name="horaFin" value="<%= hFin %>" readonly>
        </div>

        <!-- Estado -->
        <div class="mb-3">
            <label for="estado" class="form-label">Estado</label>
            <select class="form-select" id="estado" name="estado">
                <option value="Pendiente"  <%= "Pendiente".equals(reserva.getEstado())  ? "selected" : "" %>>Pendiente</option>
                <option value="Confirmada" <%= "Confirmada".equals(reserva.getEstado()) ? "selected" : "" %>>Confirmada</option>
                <option value="Cancelada"  <%= "Cancelada".equals(reserva.getEstado())  ? "selected" : "" %>>Cancelada</option>
                <option value="Finalizada" <%= "Finalizada".equals(reserva.getEstado()) ? "selected" : "" %>>Finalizada</option>
            </select>
        </div>

        <button type="submit" class="btn w-100 text-white">Guardar Cambios</button>
        <a href="VerReservas.jsp" class="btn btn-outline-light w-100 mt-2">Volver</a>
    </form>
</div>

<script>
function validarHoras() {
    const ini = document.getElementById('horaInicio').value; // "HH:MM"
    const fin = document.getElementById('horaFin').value;    // "HH:MM"
    if (!ini || !fin) return true;
    if (ini >= fin) {
        alert('La hora de inicio debe ser menor que la hora de fin.');
        return false;
    }
    return true;
}
</script>

</body>
</html>
