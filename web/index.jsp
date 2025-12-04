<%@ page import="Modelo.Cliente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Cliente cliente = (Cliente) session.getAttribute("cliente");
    if (cliente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bienvenido</title>
</head>
<body>
    <h2>Hola, <%= cliente.getNombre() %> 👋</h2>
    <a href="logout.jsp">Cerrar sesión</a>
</body>
</html>
