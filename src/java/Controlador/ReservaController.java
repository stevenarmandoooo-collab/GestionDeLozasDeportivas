package Controlador;

import DAO.ReservaDAO;
import DAO.Conexion;
import Modelo.Cliente;
import Modelo.Reserva;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReservaController", urlPatterns = {"/ReservaController"})
public class ReservaController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // UTF-8 para texto y parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String accion = request.getParameter("accion");
        HttpSession sesion = request.getSession();
        ReservaDAO dao = new ReservaDAO();

        // ===== Crear reserva (flujo del cliente) =====
        if (accion == null || accion.isEmpty()) {

            Cliente clienteSesion = (Cliente) sesion.getAttribute("cliente");
            if (clienteSesion == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                // 1) Parámetros del JSP
                String fecha          = request.getParameter("fecha");
                String horaInicioRaw  = request.getParameter("hora");          // radio "hora"
                String horaFinRaw     = request.getParameter("horaFin");       // hidden (JS)
                String idLozaStr      = request.getParameter("idLoza");
                String cantHorasStr   = request.getParameter("cantidadHoras"); // 1/2/3
                String duracionPanel  = request.getParameter("duracionPanel"); // minutos
                String lozaTxt        = request.getParameter("loza");          // texto para pago
                String totalStr       = request.getParameter("total");         // total para pago

                if (fecha == null || fecha.isBlank()) {
                    response.getWriter().println("<script>alert('Selecciona la fecha.');window.location='ReservaLosa.jsp';</script>");
                    return;
                }
                if (idLozaStr == null || idLozaStr.isEmpty()) {
                    response.getWriter().println("<script>alert('Selecciona la loza.');window.location='ReservaLosa.jsp';</script>");
                    return;
                }
                if (horaInicioRaw == null || horaInicioRaw.isEmpty()) {
                    response.getWriter().println("<script>alert('Selecciona la hora de inicio.');window.location='ReservaLosa.jsp';</script>");
                    return;
                }

                // 2) Normalizar horas
                String hIni = normalizarHora(horaInicioRaw);
                if (hIni == null) {
                    response.getWriter().println("<script>alert('Hora de inicio inválida');window.location='ReservaLosa.jsp';</script>");
                    return;
                }

                int cantHoras = 1;
                try { cantHoras = Integer.parseInt(cantHorasStr); } catch (Exception ignored) {}
                if (cantHoras <= 0) cantHoras = 1;

                String hFin = normalizarHora(horaFinRaw);
                if (hFin == null) {
                    // calcular desde inicio + cantidadHoras
                    LocalTime iniLT = LocalTime.parse(hIni);
                    LocalTime finLT = iniLT.plusHours(cantHoras);
                    hFin = finLT.toString(); // HH:MM:SS
                }

                // 3) Validar orden
                LocalTime iniLT = LocalTime.parse(hIni);
                LocalTime finLT = LocalTime.parse(hFin);
                if (!iniLT.isBefore(finLT)) {
                    response.getWriter().println("<script>alert('La hora de inicio debe ser menor que la hora de fin');window.location='ReservaLosa.jsp';</script>");
                    return;
                }

                // 4) Coherencia con panel (minutos)
                String duracionFinalMin = duracionPanel;
                if (duracionFinalMin == null || duracionFinalMin.isBlank()) {
                    duracionFinalMin = String.valueOf(cantHoras * 60);
                } else {
                    try {
                        long minutos = Duration.between(iniLT, finLT).toMinutes();
                        if (minutos != Long.parseLong(duracionFinalMin)) {
                            response.getWriter().println("<script>alert('Las horas elegidas no coinciden con la duración seleccionada.');window.location='ReservaLosa.jsp';</script>");
                            return;
                        }
                    } catch (NumberFormatException ignored) {}
                }

                int idLoza = Integer.parseInt(idLozaStr);

                // 5) Pre-chequeo rápido
                if (dao.existeConflicto(idLoza, fecha, hIni, hFin)) {
                    response.getWriter().println("<script>alert('La loza ya está reservada en ese horario.');window.location='ReservaLosa.jsp';</script>");
                    return;
                }

                // 6) Transacción: revalidar + insertar y saltar a PAGO
                Connection cn = null;
                try {
                    cn = Conexion.getConnection();
                    cn.setAutoCommit(false);

                    if (dao.existeConflicto(cn, idLoza, fecha, hIni, hFin)) {
                        cn.rollback();
                        response.getWriter().println("<script>alert('La loza ya está reservada en ese horario.');window.location='ReservaLosa.jsp';</script>");
                        return;
                    }

                    Reserva r = new Reserva();
                    r.setIdCliente(clienteSesion.getIdCliente());
                    r.setIdLoza(idLoza);
                    r.setFecha(fecha);
                    r.setHoraInicio(hIni); // HH:MM:SS
                    r.setHoraFin(hFin);    // HH:MM:SS
                    r.setEstado("Pendiente");

                    // 👉 Inserta y obtén el ID generado
                    int idReservaNuevo = dao.registrarYDevolverId(cn, r);

                    cn.commit();

                    // Redirige a PAGO con datos
                    String lozaEnc  = lozaTxt == null ? "" : URLEncoder.encode(lozaTxt, StandardCharsets.UTF_8.name());
                    String totalEnc = totalStr == null ? "" : totalStr;

                    String url = "PagoReserva.jsp"
                            + "?idReserva=" + idReservaNuevo
                            + "&idLoza=" + idLoza
                            + "&loza=" + lozaEnc
                            + "&fecha=" + fecha
                            + "&horaInicio=" + hIni.substring(0, 5) // HH:MM
                            + "&horaFin=" + hFin                    // HH:MM:SS
                            + "&duracionPanel=" + duracionFinalMin
                            + "&cantidadHoras=" + cantHoras
                            + "&total=" + totalEnc;

                    response.sendRedirect(url);
                    return;

                } catch (Exception exTx) {
                    if (cn != null) {
                        try { cn.rollback(); } catch (SQLException ignore) {}
                    }
                    exTx.printStackTrace();
                    response.getWriter().println("<script>alert('Error al procesar la reserva');window.location='ReservaLosa.jsp';</script>");
                    return;
                } finally {
                    if (cn != null) {
                        try { cn.setAutoCommit(true); } catch (SQLException ignore) {}
                        try { cn.close(); } catch (SQLException ignore) {}
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<script>alert('Error al procesar la reserva');window.location='ReservaLosa.jsp';</script>");
                return;
            }
        }

        // ===== Editar (admin) =====
        else if ("editar".equals(accion)) {
            try {
                int idReserva = Integer.parseInt(request.getParameter("idReserva"));
                int idLoza    = Integer.parseInt(request.getParameter("idLoza"));
                String fecha  = request.getParameter("fecha");

                String horaInicioNorm = normalizarHora(request.getParameter("horaInicio"));
                String horaFinNorm    = normalizarHora(request.getParameter("horaFin"));
                String estado         = request.getParameter("estado");

                if (horaInicioNorm == null || horaFinNorm == null) {
                    response.getWriter().println("<script>alert('Horas inválidas');window.location='EditarReserva.jsp?idReserva=" + idReserva + "';</script>");
                    return;
                }
                if (!LocalTime.parse(horaInicioNorm).isBefore(LocalTime.parse(horaFinNorm))) {
                    response.getWriter().println("<script>alert('La hora de inicio debe ser menor que la hora de fin');window.location='EditarReserva.jsp?idReserva=" + idReserva + "';</script>");
                    return;
                }

                Reserva r = new Reserva();
                r.setIdReserva(idReserva);
                r.setIdLoza(idLoza);
                r.setFecha(fecha);
                r.setHoraInicio(horaInicioNorm);
                r.setHoraFin(horaFinNorm);
                r.setEstado(estado);

                boolean exito = dao.actualizar(r);

                if (exito) {
                    response.sendRedirect("VerReservas.jsp");
                } else {
                    response.getWriter().println("<script>alert('Error al actualizar la reserva');window.location='EditarReserva.jsp?idReserva=" + idReserva + "';</script>");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<script>alert('Error al procesar la edición');window.location='VerReservas.jsp';</script>");
            }
        }

        // ===== Eliminar (admin) =====
        else if ("eliminar".equals(accion)) {
            try {
                int idReserva = Integer.parseInt(request.getParameter("idReserva"));
                boolean exito = dao.eliminar(idReserva);

                if (exito) {
                    response.sendRedirect("VerReservas.jsp");
                } else {
                    response.getWriter().println("<script>alert('Error al eliminar la reserva');window.location='VerReservas.jsp';</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<script>alert('Error al procesar la eliminación');window.location='VerReservas.jsp';</script>");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use POST para esta operación.");
    }

    /** Normaliza horas a "HH:MM:SS". */
    private String normalizarHora(String s) {
        if (s == null) return null;
        s = s.trim();
        if (s.isEmpty()) return null;

        // quitar todo lo que no sea dígitos o ':'
        s = s.replaceAll("[^0-9:]", "");
        if (s.isEmpty()) return null;

        String[] p = s.split(":");
        if (p.length < 2 || p.length > 3) return null;

        try {
            int h = Integer.parseInt(p[0]);
            int m = Integer.parseInt(p[1]);
            int sec = (p.length == 3 && !p[2].isEmpty()) ? Integer.parseInt(p[2]) : 0;

            if (h < 0 || h > 23) return null;
            if (m < 0 || m > 59) return null;
            if (sec < 0 || sec > 59) return null;

            return String.format("%02d:%02d:%02d", h, m, sec);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
