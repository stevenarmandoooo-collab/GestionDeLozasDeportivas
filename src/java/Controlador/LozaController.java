package Controlador;

import DAO.LozaDAO;
import Modelo.Loza;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LozaController", urlPatterns = {"/LozaController"})
public class LozaController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("agregar".equals(accion)) {

            String nombre = request.getParameter("nombre");
            String ubicacion = request.getParameter("ubicacion");
            String tipo = request.getParameter("tipo");
            String precioStr = request.getParameter("precioHora");

            // 🔹 VALIDACIÓN: Evitar campos vacíos o nulos
            if (nombre == null || nombre.trim().isEmpty() ||
                ubicacion == null || ubicacion.trim().isEmpty() ||
                tipo == null || tipo.trim().isEmpty() ||
                precioStr == null || precioStr.trim().isEmpty()) {

                response.getWriter().println("<script>alert('Todos los campos son obligatorios');window.location='AgregarLoza.jsp';</script>");
                return;
            }

            double precioHora = Double.parseDouble(precioStr);

            Loza l = new Loza();
            l.setNombre(nombre);
            l.setUbicacion(ubicacion);
            l.setTipo(tipo);
            l.setPrecioHora(precioHora);

            LozaDAO dao = new LozaDAO();
            boolean exito = dao.agregar(l);

            if (exito) {
                response.sendRedirect("VerLozas.jsp");
            } else {
                response.getWriter().println("<script>alert('Error al registrar la loza');window.location='AgregarLoza.jsp';</script>");
            }
        }

        else if ("actualizar".equals(accion)) {
            try {
                int idLoza = Integer.parseInt(request.getParameter("idLoza"));
                String nombre = request.getParameter("nombre");
                String ubicacion = request.getParameter("ubicacion");
                String tipo = request.getParameter("tipo");
                String precioStr = request.getParameter("precioHora");

                // 🔹 VALIDACIÓN PARA NO ACTUALIZAR CAMPOS VACÍOS
                if (nombre == null || nombre.trim().isEmpty() ||
                    ubicacion == null || ubicacion.trim().isEmpty() ||
                    tipo == null || tipo.trim().isEmpty() ||
                    precioStr == null || precioStr.trim().isEmpty()) {

                    response.getWriter().println("<script>alert('Todos los campos son obligatorios');window.location='EditarLoza.jsp?idLoza=" + idLoza + "';</script>");
                    return;
                }

                double precioHora = Double.parseDouble(precioStr);

                Loza l = new Loza();
                l.setIdLoza(idLoza);
                l.setNombre(nombre);
                l.setUbicacion(ubicacion);
                l.setTipo(tipo);
                l.setPrecioHora(precioHora);

                LozaDAO dao = new LozaDAO();
                boolean exito = dao.actualizar(l);

                if (exito) {
                    response.sendRedirect("VerLozas.jsp");
                } else {
                    response.getWriter().println("<script>alert('Error al actualizar la loza');window.location='EditarLoza.jsp?idLoza=" + idLoza + "';</script>");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<script>alert('Error al procesar la edición');window.location='VerLozas.jsp';</script>");
            }
        }

        else if ("eliminar".equals(accion)) {

            try {
                int idLoza = Integer.parseInt(request.getParameter("idLoza"));
                LozaDAO dao = new LozaDAO();
                boolean ok = dao.eliminar(idLoza);

                if (ok) {
                    response.sendRedirect("VerLozas.jsp");
                } else {
                    response.getWriter().println("<script>alert('No se pudo eliminar la loza');window.location='VerLozas.jsp';</script>");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<script>alert('Error al eliminar la loza');window.location='VerLozas.jsp';</script>");
            }
        }

    }
}
