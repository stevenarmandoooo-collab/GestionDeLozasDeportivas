<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pago Exitoso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border-radius: 18px;
            padding: 40px 50px;
            max-width: 450px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
            text-align: center;
            color: #fff;
        }

        h2 {
            font-weight: 600;
            color: #00ff99;
            margin-top: 10px;
            text-shadow: 0 0 10px rgba(0, 255, 153, 0.4);
        }

        p {
            color: #ccc;
            font-size: 1rem;
            margin-top: 10px;
        }

        .checkmark {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: inline-block;
            background-color: rgba(0, 255, 153, 0.1);
            border: 3px solid #00ff99;
            position: relative;
            margin-bottom: 15px;
            animation: pop 0.6s ease-out;
        }

        .checkmark::after {
            content: '';
            position: absolute;
            left: 30px;
            top: 45px;
            width: 20px;
            height: 40px;
            border-right: 5px solid #00ff99;
            border-bottom: 5px solid #00ff99;
            transform: rotate(45deg);
            opacity: 0;
            animation: draw 0.6s ease forwards 0.3s;
        }

        @keyframes pop {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        @keyframes draw {
            from { opacity: 0; transform: rotate(45deg) scale(0.6); }
            to { opacity: 1; transform: rotate(45deg) scale(1); }
        }

        .btn-success {
            background-color: #00b874;
            border: none;
            font-weight: bold;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 20px;
        }

        .btn-success:hover {
            background-color: #00e18b;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="checkmark"></div>
        <h2>¡Pago realizado con éxito!</h2>
        <p>Tu reserva fue confirmada correctamente.<br>Gracias por confiar en nuestro servicio ?</p>
        <a href="DashboardCliente.jsp" class="btn btn-success mt-3">Volver al Panel</a>
    </div>
</body>
</html>
