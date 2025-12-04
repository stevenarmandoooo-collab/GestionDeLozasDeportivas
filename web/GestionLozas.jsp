<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Modelo.Administrador"%>
<%
  Administrador admin = (Administrador) session.getAttribute("admin");
  if (admin == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Lozas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .gestion-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            border-radius: 15px;
            padding: 50px;
            width: 70%;
            box-shadow: 0 4px 40px rgba(0, 0, 0, 0.6);
            color: #fff;
            text-align: center;
        }

        h2 {
            color: #00ff99;
            text-shadow: 0 0 10px rgba(0, 255, 153, 0.4);
            font-weight: 600;
            margin-bottom: 15px;
        }

        .welcome {
            font-size: 1.1rem;
            color: #dcdcdc;
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-success {
            background-color: #00b874;
            border: none;
            color: #fff;
        }

        .btn-success:hover {
            background-color: #00e18b;
            transform: scale(1.05);
        }

        .btn-outline-light {
            border: 1px solid #ccc;
            color: #fff;
        }

        .btn-outline-light:hover {
            background-color: rgba(255,255,255,0.1);
        }

        .btn-danger {
            border: none;
            background: #d9534f;
        }

        .btn-danger:hover {
            background: #ff4c4c;
        }

        .divider {
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin: 25px 0;
        }

        .options {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
    <div class="gestion-container shadow-lg">
        <h2 class="mb-3">Gestión de Lozas</h2>
        <p class="welcome">Bienvenido, <strong><%= admin.getNombre() %></strong></p>

        <div class="divider"></div>

        <div class="options">
            <a href="VerLozas.jsp" class="btn btn-success px-4">Ver Lozas</a>
            <a href="AgregarLoza.jsp" class="btn btn-outline-light px-4">Agregar Nueva</a>
            <a href="DashboardAdmin.jsp" class="btn btn-outline-light px-4">Volver</a>
            <a href="LogoutController" class="btn btn-danger px-4">Cerrar sesión</a>
        </div>
    </div>
</body>
</html>
