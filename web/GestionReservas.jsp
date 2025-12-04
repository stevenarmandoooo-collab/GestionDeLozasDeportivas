<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Modelo.Administrador"%>
<%
  Administrador admin = (Administrador) session.getAttribute("admin");
  if (admin == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>GestionReservas</title></head>
<body>
  <h2>Gestión de Lozas (Admin)</h2>
  <a href="DashboardAdmin.jsp">Volver</a>
</body>
</html>
