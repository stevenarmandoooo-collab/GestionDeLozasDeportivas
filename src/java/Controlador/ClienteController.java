package Controlador;

import DAO.ClienteDAO;
import Modelo.Cliente;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ClienteController", urlPatterns = {"/ClienteController"})
public class ClienteController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        // VALIDACIÓN DE CAMPOS VACÍOS
        if (nombre == null || nombre.trim().isEmpty() ||
            apellidos == null || apellidos.trim().isEmpty() ||
            dni == null || dni.trim().isEmpty() ||
            telefono == null || telefono.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            direccion == null || direccion.trim().isEmpty() ||
            usuario == null || usuario.trim().isEmpty() ||
            clave == null || clave.trim().isEmpty()) {

            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("RegistroCliente.jsp").forward(request, response);
            return;
        }

        Cliente c = new Cliente();
        c.setNombre(nombre);
        c.setApellidos(apellidos);
        c.setDni(dni);
        c.setTelefono(telefono);
        c.setEmail(email);
        c.setDireccion(direccion);
        c.setUsuario(usuario);
        c.setClave(clave);

        ClienteDAO dao = new ClienteDAO();

        boolean exito = dao.registrar(c);

        if (exito) {
            response.sendRedirect("login.jsp?registro=exitoso");
        } else {
            request.setAttribute("error", "El DNI o el usuario ya están registrados o ocurrió un error.");
            request.getRequestDispatcher("RegistroCliente.jsp").forward(request, response);
        }
    }
}
