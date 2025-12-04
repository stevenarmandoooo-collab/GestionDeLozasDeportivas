<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="Modelo.Cliente" %>
<%@ page import="DAO.Conexion" %>
<%@ page import="java.sql.*" %>

<%
    // Verifica sesión
    Cliente cliente = (Cliente) session.getAttribute("cliente");
    if (cliente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserva de Loza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #ffffff;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .card { 
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border-radius: 18px;
            padding: 35px;
            width: 860px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
            color: #fff;
        }
        h4 { font-weight: 600; color: #00ff99; text-shadow: 0 0 10px rgba(0, 255, 153, 0.4); }
        .badge { font-size: 0.9rem; color: #00ff99; background: rgba(255, 255, 255, 0.1); border-radius: 8px; padding: 6px 12px; }
        select, input[type="date"] { background: rgba(255, 255, 255, 0.15); border: none; color: #fff; }
        select option { background-color: #1c1c1c; color: #fff; }
        select:focus, input:focus { background: rgba(255, 255, 255, 0.25); color: white; box-shadow: 0 0 6px #00ff99; }
        .slot { background: rgba(255, 255, 255, 0.12); border-radius: 8px; padding: 6px 10px; cursor: pointer; user-select: none; font-size: 0.9rem; transition: 0.3s; }
        .slot:hover { background-color: rgba(0, 255, 153, 0.25); }
        input[type="radio"] { accent-color: #00ff99; margin-right: 5px; }
        .summary { background: rgba(255, 255, 255, 0.07); border-radius: 10px; padding: 10px 15px; }
        hr { border-color: rgba(0, 255, 153, 0.4); }
        .btn-success { background-color: #00b874; border: none; font-weight: bold; transition: all 0.3s ease; }
        .btn-success:hover { background-color: #00e18b; transform: scale(1.05); }
        .btn-outline-light { border-color: rgba(255, 255, 255, 0.5); color: #fff; }
        .btn-outline-light:hover { background-color: rgba(255, 255, 255, 0.15); }
        .muted { color: #aaa; font-size: 0.85rem; }
        .hint { font-size:.85rem; color:#9ee6cf; }
    </style>
</head>
<body>
<div class="card p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Reserva de Loza</h4>
        <span class="badge">Cliente: <%= cliente.getNombre() %></span>
    </div>

    <!-- POST al servlet; horaFin/duracionPanel se calculan en prepararEnvio() -->
    <form id="formReserva" action="ReservaController" method="post" onsubmit="return prepararEnvio();">
        <!-- Campos ocultos que lee el Controller -->
        <input type="hidden" name="accion" value="">
        <input type="hidden" name="horaFin" id="horaFin">
        <input type="hidden" name="duracionPanel" id="duracionPanel" value="">

        <div class="row g-4">
            <!-- Tipo -->
            <div class="col-md-4">
                <label class="form-label">Tipo</label>
                <select id="tipo" class="form-select">
                    <option value="">Todos</option>
                    <%
                        try (Connection con = Conexion.getConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT DISTINCT tipo FROM loza ORDER BY tipo");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                    %>
                        <option value="<%= rs.getString("tipo") %>"><%= rs.getString("tipo") %></option>
                    <%
                            }
                        } catch (SQLException e) { out.println("<option disabled>— error tipos —</option>"); }
                    %>
                </select>
                <div class="muted mt-1">Filtra por tipo de cancha.</div>
            </div>

            <!-- Loza -->
            <div class="col-md-4">
                <label for="idLoza" class="form-label">Campo / Loza</label>
                <select name="idLoza" id="idLoza" class="form-select" required>
                    <option value="">Seleccione una loza</option>
                    <%
                        try (Connection con = Conexion.getConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT idLoza, nombre, tipo, precioHora FROM loza ORDER BY nombre");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                int id = rs.getInt("idLoza");
                                String nombre = rs.getString("nombre");
                                String tipo = rs.getString("tipo");
                                int precio = rs.getInt("precioHora");
                    %>
                        <option value="<%= id %>" data-tipo="<%= tipo %>" data-precio="<%= precio %>">
                            <%= nombre %> — <%= tipo %> (S/ <%= precio %>/h)
                        </option>
                    <%
                            }
                        } catch (SQLException e) { out.println("<option disabled>— error lozas —</option>"); }
                    %>
                </select>
                <div class="muted mt-1">Se filtra según el tipo elegido.</div>
            </div>

            <!-- Fecha -->
            <div class="col-md-4">
                <label for="fecha" class="form-label">Fecha</label>
                <input type="date" name="fecha" id="fecha" class="form-control" required>
                <div class="muted mt-1">Elige la fecha de juego.</div>
            </div>

            <!-- Horarios -->
            <div class="col-12">
                <label class="form-label">Horarios Disponibles</label>
                <div class="d-flex flex-wrap gap-2" id="slots">
                    <%
                        String[] horarios = {"08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00",
                                             "16:00","17:00","18:00","19:00","20:00"};
                        for (String h : horarios) {
                            int siguiente = Integer.parseInt(h.split(":")[0]) + 1;
                            String label = h + "–" + (siguiente < 10 ? "0" + siguiente : siguiente) + ":00";
                    %>
                        <label class="slot mb-2"><input type="radio" name="hora" value="<%= h %>"> <%= label %></label>
                    <% } %>
                </div>
                <div class="hint mt-1">Si eliges un horario fijo (ej. 09:00–10:00), la reserva será de 1 hora.</div>
            </div>

            <!-- Cantidad de horas -->
            <div class="col-md-4">
                <label class="form-label">Cantidad de horas</label>
                <select id="cantidadHoras" name="cantidadHoras" class="form-select">
                    <option value="1" selected>1 hora</option>
                    <option value="2">2 horas</option>
                    <option value="3">3 horas</option>
                </select>
                <div class="hint mt-1" id="hintHoras">Para reservar 2 o 3 horas, no selecciones un horario fijo.</div>
            </div>

            <!-- Resumen -->
            <div class="col-md-8">
                <div class="summary">
                    <div class="d-flex justify-content-between">
                        <span>Precio/hora:</span>
                        <strong id="precioHoraLbl">S/ 0</strong>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span>Cantidad de horas:</span>
                        <strong id="cantHorasLbl">1</strong>
                    </div>
                    <hr class="my-2" />
                    <div class="d-flex justify-content-between">
                        <span>Total:</span>
                        <strong id="totalLbl">S/ 0</strong>
                    </div>
                </div>
            </div>

            <!-- Botones -->
            <div class="col-12 d-flex gap-2 justify-content-between mt-3">
                <button type="submit" class="btn btn-success px-4">Confirmar Reserva</button>
                <button type="button" class="btn btn-outline-light px-4" onclick="irAPago()">Ir a pago</button>
                <a href="DashboardCliente.jsp" class="btn btn-outline-light px-4">Volver</a>
            </div>
        </div>
    </form>
</div>

<script>
    const tipoSel = document.getElementById('tipo');
    const lozaSel = document.getElementById('idLoza');
    const precioLbl = document.getElementById('precioHoraLbl');
    const cantHorasSel = document.getElementById('cantidadHoras');
    const cantHorasLbl = document.getElementById('cantHorasLbl');
    const totalLbl = document.getElementById('totalLbl');
    const slotsContainer = document.getElementById('slots');
    const hintHoras = document.getElementById('hintHoras');

    // Filtro por tipo
    tipoSel.addEventListener('change', () => {
        const t = tipoSel.value;
        for (const opt of lozaSel.options) {
            if (opt.value === '') { opt.hidden = false; continue; }
            const tipo = opt.getAttribute('data-tipo');
            opt.hidden = (t && tipo !== t);
        }
        lozaSel.value = '';
        actualizarResumen();
    });

    lozaSel.addEventListener('change', actualizarResumen);
    cantHorasSel.addEventListener('change', () => {
        // Si el usuario pone 2 o 3 horas, desmarcamos cualquier slot elegido
        if (Number(cantHorasSel.value) > 1) {
            desmarcarSlots();
            cantHorasSel.disabled = false; // habilitado porque no hay slot fijo
            hintHoras.textContent = 'Reservarás varias horas desde la hora seleccionada.';
        } else {
            hintHoras.textContent = 'Para reservar 2 o 3 horas, no selecciones un horario fijo.';
        }
        actualizarResumen();
    });

    // Al elegir un slot (horario fijo 1h), bloquea cantidad de horas a 1
    slotsContainer.addEventListener('change', (e) => {
        if (e.target && e.target.name === 'hora') {
            cantHorasSel.value = "1";
            cantHorasSel.disabled = true; // 🔒 bloqueo cuando hay slot elegido
            cantHorasLbl.textContent = "1";
            hintHoras.textContent = 'Has elegido un horario fijo. Duración: 1 hora.';
            actualizarResumen();
        }
    });

    function desmarcarSlots() {
        const checked = document.querySelector('input[name="hora"]:checked');
        if (checked) checked.checked = false;
        cantHorasSel.disabled = false;
    }

    function actualizarResumen() {
        const opt = lozaSel.options[lozaSel.selectedIndex];
        const precio = opt ? Number(opt.getAttribute('data-precio') || 0) : 0;
        const horas = Number(cantHorasSel.value);
        precioLbl.textContent = 'S/ ' + precio.toFixed(2);
        cantHorasLbl.textContent = horas;
        totalLbl.textContent = 'S/ ' + (precio * horas).toFixed(2);
    }

    // === Utilidades ===
    function sumarHoras(hhmm, horas) {
        const [h, m] = hhmm.split(':').map(Number);
        const d = new Date(0, 0, 0, h, m || 0);
        d.setHours(d.getHours() + Number(horas));
        const hh = String(d.getHours()).padStart(2, '0');
        const mm = String(d.getMinutes()).padStart(2, '0');
        return `${hh}:${mm}:00`; // HH:MM:SS
    }

    function prepararEnvio() {
        const fecha     = document.getElementById('fecha').value;
        const slot      = document.querySelector('input[name="hora"]:checked');
        const cantHoras = Number(cantHorasSel.value);

        if (!lozaSel.value || !fecha || (!slot && cantHoras === 1)) {
            // Si es 1 hora debe elegir un slot; si quiere 2 o 3 horas, que deje sin slot.
            alert('Por favor complete todos los campos. Para 1 hora elija un horario; para 2 o 3, no seleccione un horario fijo.');
            return false;
        }

        // Hora de inicio:
        let horaInicio = null;
        if (slot) {
            horaInicio = slot.value;         // HH:MM (de radio)
        } else {
            // Sin slot fijo: toma la primera opción de slots como base o podrías mostrar otro picker
            // Aquí obligamos a que el usuario tenga un slot seleccionado si es 1 hora.
            alert('Elige un horario de inicio para calcular la reserva.');
            return false;
        }

        // Si hay slot (1h), el select ya está bloqueado en 1. Si no hubiera slot, no dejamos continuar (arriba).
        const horaFin = sumarHoras(horaInicio, cantHoras);
        document.getElementById('horaFin').value = horaFin;
        document.getElementById('duracionPanel').value = String(cantHoras * 60);

        if (horaInicio >= horaFin.substring(0,5)) {
            alert('La hora de inicio debe ser menor que la hora de fin.');
            return false;
        }
        return true;
    }

    // Flujo "Ir a pago"
    function irAPago() {
        const fecha     = document.getElementById('fecha').value;
        const slot      = document.querySelector('input[name="hora"]:checked');
        const cantHoras = Number(cantHorasSel.value);

        if (!lozaSel.value || !fecha || !slot) {
            alert('Por favor complete todos los campos antes de continuar.');
            return;
        }

        const opt        = lozaSel.options[lozaSel.selectedIndex];
        const lozaNombre = opt.text;
        const precio     = Number(opt.getAttribute('data-precio'));
        const total      = precio * cantHoras;

        const horaInicio = slot.value;
        const horaFin    = sumarHoras(horaInicio, cantHoras);
        const duracion   = String(cantHoras * 60);

        const url = "PagoReserva.jsp?idReserva=0"
            + "&idLoza=" + lozaSel.value
            + "&loza=" + encodeURIComponent(lozaNombre)
            + "&fecha=" + fecha
            + "&horaInicio=" + horaInicio
            + "&horaFin=" + horaFin
            + "&duracionPanel=" + duracion
            + "&cantidadHoras=" + cantHoras
            + "&total=" + total;

        window.location.href = url;
    }

    actualizarResumen();
</script>
</body>
</html>
