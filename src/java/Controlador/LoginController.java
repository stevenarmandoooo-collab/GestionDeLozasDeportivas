package Controlador;

import DAO.ClienteDAO;
import DAO.adminDAO;
import Modelo.Administrador;
import Modelo.Cliente;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol"); // Viene del formulario

        HttpSession sesion = request.getSession();

        if ("admin".equals(rol)) {
            adminDAO adao = new adminDAO();
            Administrador admin = adao.validar(usuario, clave);
            if (admin != null) {
                sesion.setAttribute("admin", admin);
                response.sendRedirect("DashboardAdmin.jsp");
                return;
            }
        } else {
            ClienteDAO cdao = new ClienteDAO();
            Cliente cliente = cdao.validar(usuario, clave);
            if (cliente != null) {
                sesion.setAttribute("cliente", cliente);
                response.sendRedirect("DashboardCliente.jsp");
                return;
            }
        }

        request.setAttribute("error", "Usuario o contraseña incorrectos");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
