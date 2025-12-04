package Controlador;

import DAO.Conexion;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PagoController", urlPatterns = {"/PagoController"})
public class PagoController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String idReservaStr = request.getParameter("idReserva");
            String metodoPago   = request.getParameter("metodoPago"); // Yape/Plin/Efectivo

            if (idReservaStr == null || idReservaStr.isBlank()) {
                response.getWriter().println("<script>alert('Falta id de reserva.');window.location='DashboardCliente.jsp';</script>");
                return;
            }

            int idReserva = Integer.parseInt(idReservaStr);

            // Aquí podrías guardar un registro en tabla 'pago' si la tienes.
            // De momento, solo actualizamos la reserva a Confirmada.
            try (Connection cn = Conexion.getConnection()) {
                cn.setAutoCommit(false);

                try (PreparedStatement ps = cn.prepareStatement(
                        "UPDATE reserva SET estado = ? WHERE idReserva = ?")) {
                    ps.setString(1, "Confirmada");
                    ps.setInt(2, idReserva);
                    ps.executeUpdate();
                }

                cn.commit();
            } catch (SQLException ex) {
                ex.printStackTrace();
                response.getWriter().println("<script>alert('Error al confirmar el pago.');window.location='DashboardCliente.jsp';</script>");
                return;
            }

            // OK ⇒ Redirige a página de éxito (o dashboard)
            response.sendRedirect("PagoExitoso.jsp?idReserva=" + idReserva);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Ocurrió un error procesando el pago.');window.location='DashboardCliente.jsp';</script>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use POST para esta operación.");
    }
}
