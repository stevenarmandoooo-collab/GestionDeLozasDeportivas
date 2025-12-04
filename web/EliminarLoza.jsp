<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.LozaDAO, Modelo.Loza" %>

<%
    String idStr = request.getParameter("idLoza");
    if (idStr == null) { response.sendRedirect("VerLozas.jsp"); return; }
    int idLoza = Integer.parseInt(idStr);
    LozaDAO dao = new LozaDAO();
    Loza loza = dao.obtenerPorId(idLoza);
    if (loza == null) {
        out.println("<h3>No se encontró la loza con ID " + idLoza + "</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eliminar Loza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background:#102a43; color:#fff; min-height:100vh; display:flex; align-items:center; justify-content:center;}
        .card { background:rgba(255,255,255,.08); border-radius:14px; padding:28px; width:520px;}
    </style>
</head>
<body>
<div class="card">
    <h4 class="mb-3 text-warning">Confirmar eliminación</h4>
    <p><strong>ID:</strong> <%= loza.getIdLoza() %></p>
    <p><strong>Nombre:</strong> <%= loza.getNombre() %></p>
    <p><strong>Tipo:</strong> <%= loza.getTipo() %></p>
    <p><strong>Precio/hora:</strong> S/ <%= loza.getPrecioHora() %></p>
    <div class="alert alert-danger mt-3">Esta acción no se puede deshacer.</div>

    <form action="LozaController" method="post" class="mt-3">
        <input type="hidden" name="accion" value="eliminar">
        <input type="hidden" name="idLoza" value="<%= loza.getIdLoza() %>">
        <button type="submit" class="btn btn-danger">Eliminar</button>
        <a href="VerLozas.jsp" class="btn btn-outline-light ms-2">Cancelar</a>
    </form>
</div>
</body>
</html>
