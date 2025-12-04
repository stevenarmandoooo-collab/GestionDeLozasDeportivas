package DAO;

import Modelo.Reserva;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    // 🔹 Registrar una nueva reserva (versión simple, por si aún la usas)
    public boolean registrar(Reserva r) {
        String sql = "INSERT INTO reserva (idCliente, idLoza, fecha, horaInicio, horaFin, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getIdCliente());
            ps.setInt(2, r.getIdLoza());
            ps.setString(3, r.getFecha());
            ps.setString(4, r.getHoraInicio());
            ps.setString(5, r.getHoraFin());
            ps.setString(6, r.getEstado());

            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("❌ Error SQL al registrar reserva:");
            e.printStackTrace();
            return false;
        }
    }

    // 🔹 Registrar usando conexión externa (para transacciones)
    public boolean registrar(Connection conExterna, Reserva r) throws SQLException {
        String sql = "INSERT INTO reserva (idCliente, idLoza, fecha, horaInicio, horaFin, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conExterna.prepareStatement(sql)) {
            ps.setInt(1, r.getIdCliente());
            ps.setInt(2, r.getIdLoza());
            ps.setString(3, r.getFecha());
            ps.setString(4, r.getHoraInicio());
            ps.setString(5, r.getHoraFin());
            ps.setString(6, r.getEstado());
            ps.executeUpdate();
            return true;
        }
    }

    // 🔹 Registrar y devolver ID generado (para ir a Pago)
    public int registrarYDevolverId(Connection conExterna, Reserva r) throws SQLException {
        String sql = "INSERT INTO reserva (idCliente, idLoza, fecha, horaInicio, horaFin, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conExterna.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getIdCliente());
            ps.setInt(2, r.getIdLoza());
            ps.setString(3, r.getFecha());
            ps.setString(4, r.getHoraInicio());
            ps.setString(5, r.getHoraFin());
            ps.setString(6, r.getEstado());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("No se pudo obtener el idReserva generado.");
    }

    // 🔹 Listar reservas de un cliente (vista cliente)
    public List<Reserva> listarPorCliente(int idCliente) {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
            SELECT r.idReserva, l.nombre AS nombreLoza, r.fecha, r.horaInicio, r.horaFin, r.estado
            FROM reserva r
            INNER JOIN loza l ON r.idLoza = l.idLoza
            WHERE r.idCliente = ?
            ORDER BY r.fecha DESC, r.horaInicio ASC
        """;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setIdReserva(rs.getInt("idReserva"));
                    r.setNombreLoza(rs.getString("nombreLoza"));
                    r.setFecha(rs.getString("fecha"));
                    r.setHoraInicio(rs.getString("horaInicio"));
                    r.setHoraFin(rs.getString("horaFin"));
                    r.setEstado(rs.getString("estado"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al listar reservas por cliente:");
            e.printStackTrace();
        }
        return lista;
    }

    // 🔹 Listar TODAS las reservas (admin)
    public List<Reserva> listarTodas() {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
            SELECT r.idReserva, r.idCliente,
                   c.nombre AS nombreCliente,
                   l.nombre AS nombreLoza,
                   r.fecha, r.horaInicio, r.horaFin, r.estado
            FROM reserva r
            INNER JOIN loza l ON r.idLoza = l.idLoza
            INNER JOIN cliente c ON r.idCliente = c.idCliente
            ORDER BY r.fecha DESC, r.horaInicio ASC
        """;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setIdReserva(rs.getInt("idReserva"));
                r.setIdCliente(rs.getInt("idCliente"));
                r.setNombreCliente(rs.getString("nombreCliente"));
                r.setNombreLoza(rs.getString("nombreLoza"));
                r.setFecha(rs.getString("fecha"));
                r.setHoraInicio(rs.getString("horaInicio"));
                r.setHoraFin(rs.getString("horaFin"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error al listar todas las reservas:");
            e.printStackTrace();
        }

        return lista;
    }

    // 🔹 NUEVO: Listar reservas por ID de cliente (admin, para filtro)
    public List<Reserva> listarPorClienteAdmin(int idCliente) {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
            SELECT r.idReserva, r.idCliente,
                   c.nombre AS nombreCliente,
                   l.nombre AS nombreLoza,
                   r.fecha, r.horaInicio, r.horaFin, r.estado
            FROM reserva r
            INNER JOIN loza l ON r.idLoza = l.idLoza
            INNER JOIN cliente c ON r.idCliente = c.idCliente
            WHERE r.idCliente = ?
            ORDER BY r.fecha DESC, r.horaInicio ASC
        """;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setIdReserva(rs.getInt("idReserva"));
                    r.setIdCliente(rs.getInt("idCliente"));
                    r.setNombreCliente(rs.getString("nombreCliente"));
                    r.setNombreLoza(rs.getString("nombreLoza"));
                    r.setFecha(rs.getString("fecha"));
                    r.setHoraInicio(rs.getString("horaInicio"));
                    r.setHoraFin(rs.getString("horaFin"));
                    r.setEstado(rs.getString("estado"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al listar reservas por cliente (admin):");
            e.printStackTrace();
        }
        return lista;
    }

    // 🔹 NUEVO: Detalle por ID de reserva (para tarjeta en VerReservas.jsp)
    public Reserva obtenerDetallePorId(int idReserva) {
        String sql = """
            SELECT r.idReserva, r.idCliente, r.idLoza,
                   c.nombre AS nombreCliente,
                   l.nombre AS nombreLoza,
                   r.fecha, r.horaInicio, r.horaFin, r.estado
            FROM reserva r
            INNER JOIN loza l ON r.idLoza = l.idLoza
            INNER JOIN cliente c ON r.idCliente = c.idCliente
            WHERE r.idReserva = ?
        """;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reserva r = new Reserva();
                    r.setIdReserva(rs.getInt("idReserva"));
                    r.setIdCliente(rs.getInt("idCliente"));
                    r.setIdLoza(rs.getInt("idLoza"));
                    r.setNombreCliente(rs.getString("nombreCliente"));
                    r.setNombreLoza(rs.getString("nombreLoza"));
                    r.setFecha(rs.getString("fecha"));
                    r.setHoraInicio(rs.getString("horaInicio"));
                    r.setHoraFin(rs.getString("horaFin"));
                    r.setEstado(rs.getString("estado"));
                    return r;
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener detalle de reserva:");
            e.printStackTrace();
        }
        return null;
    }

    // 🔹 Obtener reserva por ID (versión simple por si la usas en otros lados)
    public Reserva obtenerPorId(int idReserva) {
        String sql = "SELECT * FROM reserva WHERE idReserva = ?";
        Reserva r = null;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r = new Reserva();
                    r.setIdReserva(rs.getInt("idReserva"));
                    r.setIdCliente(rs.getInt("idCliente"));
                    r.setIdLoza(rs.getInt("idLoza"));
                    r.setFecha(rs.getString("fecha"));
                    r.setHoraInicio(rs.getString("horaInicio"));
                    r.setHoraFin(rs.getString("horaFin"));
                    r.setEstado(rs.getString("estado"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return r;
    }

    // 🔹 Actualizar reserva existente
    public boolean actualizar(Reserva r) {
        String sql = "UPDATE reserva SET fecha=?, horaInicio=?, horaFin=?, estado=? WHERE idReserva=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getFecha());
            ps.setString(2, r.getHoraInicio());
            ps.setString(3, r.getHoraFin());
            ps.setString(4, r.getEstado());
            ps.setInt(5, r.getIdReserva());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 🔹 Eliminar reserva
    public boolean eliminar(int idReserva) {
        String sql = "DELETE FROM reserva WHERE idReserva = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 🔹 Conflicto de horarios (INSERT / sin conexión externa)
    public boolean existeConflicto(int idLoza, String fecha, String horaInicio, String horaFin) {
        return existeConflicto(idLoza, fecha, horaInicio, horaFin, null);
    }

    // 🔹 Conflicto de horarios (con opción de excluir una reserva)
    public boolean existeConflicto(int idLoza, String fecha, String horaInicio, String horaFin, Integer excluirIdReserva) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) FROM reserva ");
        sb.append("WHERE idLoza = ? AND fecha = ? ");
        sb.append("AND NOT (horaFin <= ? OR horaInicio >= ?) ");
        if (excluirIdReserva != null) {
            sb.append("AND idReserva <> ? ");
        }
        String sql = sb.toString();

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;
            ps.setInt(idx++, idLoza);
            ps.setString(idx++, fecha);
            ps.setString(idx++, horaInicio);
            ps.setString(idx++, horaFin);
            if (excluirIdReserva != null) {
                ps.setInt(idx++, excluirIdReserva);
            }

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // ante error, bloquea por seguridad
        }
    }

    // 🔹 Conflicto usando la MISMA conexión (para transacción en ReservaController)
    public boolean existeConflicto(Connection cn, int idLoza, String fecha, String horaInicio, String horaFin) {
        String sql = """
            SELECT COUNT(*) FROM reserva
            WHERE idLoza = ? AND fecha = ?
              AND NOT (horaFin <= ? OR horaInicio >= ?)
        """;
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idLoza);
            ps.setString(2, fecha);
            ps.setString(3, horaInicio);
            ps.setString(4, horaFin);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    // 🔹 (Opcional) Listar reservas por loza y fecha (para disponibilidad)
    public List<Reserva> listarPorLozaYFecha(int idLoza, String fecha) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT idReserva, idCliente, idLoza, fecha, horaInicio, horaFin, estado " +
                     "FROM reserva WHERE idLoza = ? AND fecha = ? ORDER BY horaInicio ASC";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLoza);
            ps.setString(2, fecha);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setIdReserva(rs.getInt("idReserva"));
                    r.setIdCliente(rs.getInt("idCliente"));
                    r.setIdLoza(rs.getInt("idLoza"));
                    r.setFecha(rs.getString("fecha"));
                    r.setHoraInicio(rs.getString("horaInicio"));
                    r.setHoraFin(rs.getString("horaFin"));
                    r.setEstado(rs.getString("estado"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
