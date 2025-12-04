<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String loza          = request.getParameter("loza");
    String fecha         = request.getParameter("fecha");
    String horaInicio    = request.getParameter("horaInicio");   // "HH:MM" o "HH:MM:SS"
    String horaFinParam  = request.getParameter("horaFin");      // puede venir null
    String total         = request.getParameter("total");
    String idLoza        = request.getParameter("idLoza");
    String duracionPanel = request.getParameter("duracionPanel"); // minutos
    String cantidadHoras = request.getParameter("cantidadHoras"); // 1/2/3

    // Calcula horaFin si no vino
    String horaFin = horaFinParam;
    java.util.function.BiFunction<String, Integer, String> sumarHoras = (hhmm, horas) -> {
        try {
            int h = Integer.parseInt(hhmm.substring(0, 2));
            int m = Integer.parseInt(hhmm.substring(3, 5));
            h = (h + horas) % 24;
            return String.format("%02d:%02d:00", h, m); // HH:MM:00
        } catch (Exception e) { return null; }
    };
    if (horaFin == null || horaFin.isBlank() || ":".equals(horaFin)) {
        int horas = 1;
        try {
            if (cantidadHoras != null && !cantidadHoras.isBlank()) {
                horas = Integer.parseInt(cantidadHoras);
            } else if (duracionPanel != null && !duracionPanel.isBlank()) {
                horas = Integer.parseInt(duracionPanel) / 60;
            }
        } catch (Exception ignore) { horas = 1; }
        if (horaInicio != null && horaInicio.length() >= 5) {
            horaFin = sumarHoras.apply(horaInicio, horas);
        }
    }
    if (horaInicio != null && horaInicio.length() == 5) horaInicio = horaInicio + ":00";
    if (horaFin    != null && horaFin.length()    == 5) horaFin    = horaFin    + ":00";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmar Pago</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f2027, #203a43, #2c5364); color:#fff; font-family:'Poppins',sans-serif; min-height:100vh; display:flex; align-items:center; justify-content:center;}
        .card { background:rgba(255,255,255,.08); backdrop-filter:blur(10px); border-radius:18px; padding:35px 40px; width:460px; box-shadow:0 4px 30px rgba(0,0,0,.5); text-align:center;}
        h3 { font-weight:600; color:#00ff99; text-shadow:0 0 10px rgba(0,255,153,.4); margin-bottom:20px;}
        .text-success { color:#00ff99 !important; font-weight:600; font-size:1.2rem;}
        .metodo { background:rgba(255,255,255,.12); border-radius:10px; padding:10px 12px; text-align:left; cursor:pointer; border:1px solid transparent; transition:.3s;}
        .metodo:hover { border-color:#00ff99; background:rgba(0,255,153,.1);}
        input[type="radio"]{ accent-color:#00ff99; margin-right:8px;}
        #loader{ display:none; margin-top:15px;}
        .spinner-border{ color:#00ff99;}
        .btn-success { background:#00b874; border:none; font-weight:bold;}
        .btn-success:hover { background:#00e18b; transform:scale(1.02);}
    </style>
</head>
<body>
<div class="card shadow-lg">
    <h3>Confirmar Pago</h3>

    <p><strong>Loza:</strong> <%= (loza != null ? loza : "-") %></p>
    <p><strong>Fecha:</strong> <%= (fecha != null ? fecha : "-") %></p>
    <p><strong>Hora Inicio:</strong> <%= (horaInicio != null ? horaInicio : "-") %></p>
    <p><strong>Hora Fin:</strong> <%= (horaFin != null ? horaFin : "-") %></p>
    <p class="text-success mt-3">Total: S/ <%= (total != null ? total : "0") %></p>

    <hr style="border-color: rgba(0,255,153,0.3);">

    <h5 class="mb-3">Selecciona un método de pago:</h5>

    <!-- 🔥 UN SOLO FORMULARIO -->
    <form id="pagoForm" action="PagoController" method="post">
        <!-- obligatorios para el PagoController -->
        <input type="hidden" name="idReserva"     value="<%= request.getParameter("idReserva") %>">
        <input type="hidden" name="idLoza"        value="<%= (idLoza != null ? idLoza : "") %>">
        <input type="hidden" name="loza"          value="<%= (loza != null ? loza : "") %>">
        <input type="hidden" name="fecha"         value="<%= (fecha != null ? fecha : "") %>">
        <input type="hidden" name="horaInicio"    value="<%= (horaInicio != null ? horaInicio : "") %>">
        <input type="hidden" name="horaFin"       value="<%= (horaFin != null ? horaFin : "") %>">
        <input type="hidden" name="duracionPanel" value="<%= (duracionPanel != null ? duracionPanel : "") %>">
        <input type="hidden" name="cantidadHoras" value="<%= (cantidadHoras != null ? cantidadHoras : "") %>">
        <input type="hidden" name="total"         value="<%= (total != null ? total : "") %>">

        <div class="mb-3 text-start">
            <label class="metodo d-block mb-2">
                <input type="radio" name="metodoPago" value="Yape" required> Yape
            </label>
            <label class="metodo d-block mb-2">
                <input type="radio" name="metodoPago" value="Plin"> Plin
            </label>
            <label class="metodo d-block mb-2">
                <input type="radio" name="metodoPago" value="Efectivo"> Efectivo
            </label>
        </div>

        <!-- Un solo botón de submit -->
        <button id="btnPagar" type="submit" class="btn btn-success w-100 mt-3">
            Confirmar Pago
        </button>
        <a href="DashboardCliente.jsp" class="btn btn-outline-light w-100 mt-2">Cancelar</a>

        <div id="loader">
            <div class="spinner-border" role="status"></div>
            <p class="mt-2">Procesando pago...</p>
        </div>
    </form>
</div>

<script>
    const form   = document.getElementById('pagoForm');
    const loader = document.getElementById('loader');
    const btn    = document.getElementById('btnPagar');

    form.addEventListener('submit', function () {
        btn.disabled = true;           // evita doble submit
        loader.style.display = 'block';
    });
</script>
</body>
</html>
