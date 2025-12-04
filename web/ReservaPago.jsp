<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="Modelo.Cliente" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("cliente");
    if (cliente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener datos de la reserva desde parámetros
    String idReserva = request.getParameter("idReserva");
    String fecha = request.getParameter("fecha");
    String horaInicio = request.getParameter("horaInicio");
    String horaFin = request.getParameter("horaFin");
    String loza = request.getParameter("loza");
    String total = request.getParameter("total");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pago de Reserva</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background:#0f0f0f; color:#eee; }
        .wrap { max-width: 600px; margin: 40px auto; }
        .card { background:#1b1b1b; border:1px solid #2a2a2a; border-radius:14px; }
        .btn-success { background:#2fbf4b; border:none; }
        .btn-success:hover { background:#29a542; }
        .radio-option {
            background:#222; border:1px solid #333; border-radius:10px;
            padding:10px 15px; cursor:pointer;
        }
        .radio-option:hover { background:#2a2a2a; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card p-4">
        <h4 class="mb-3 text-center text-success">Confirmar y Pagar Reserva</h4>

        <p><strong>Cliente:</strong> <%= cliente.getNombre() %></p>
        <p><strong>Loza:</strong> <%= loza %></p>
        <p><strong>Fecha:</strong> <%= fecha %></p>
        <p><strong>Hora:</strong> <%= horaInicio %> - <%= horaFin %></p>
        <p><strong>Total a pagar:</strong> S/ <%= total %></p>

        <hr>

        <form action="PagoController" method="post">
            <input type="hidden" name="idReserva" value="<%= idReserva %>">

            <label class="form-label mb-2">Elegir método de pago:</label>

            <div class="d-grid gap-2">
                <label class="radio-option">
                    <input type="radio" name="metodoPago" value="Yape" required> Yape
                </label>
                <label class="radio-option">
                    <input type="radio" name="metodoPago" value="Plin"> Plin
                </label>
                <label class="radio-option">
                    <input type="radio" name="metodoPago" value="Efectivo"> Efectivo
                </label>
            </div>

            <div class="mt-4 d-flex justify-content-between">
                <a href="DashboardCliente.jsp" class="btn btn-outline-light">Cancelar</a>
                <button type="submit" class="btn btn-success px-4">Confirmar y Pagar</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
