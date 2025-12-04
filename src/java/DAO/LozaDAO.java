package DAO;

import Modelo.Loza;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LozaDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // 🔹 Listar todas las lozas
    public List<Loza> listar() {
        List<Loza> lista = new ArrayList<>();
        String sql = "SELECT * FROM loza";

        try {
            con = Conexion.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Loza l = new Loza();
                l.setIdLoza(rs.getInt("idLoza"));
                l.setNombre(rs.getString("nombre"));
                l.setUbicacion(rs.getString("ubicacion"));
                l.setTipo(rs.getString("tipo"));
                l.setPrecioHora(rs.getDouble("precioHora"));
                lista.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }

        return lista;
    }

    // 🔹 Agregar una nueva loza
    public boolean agregar(Loza l) {

        // === VALIDACIÓN ===
        if (l.getNombre() == null || l.getNombre().trim().isEmpty()) return false;
        if (l.getUbicacion() == null || l.getUbicacion().trim().isEmpty()) return false;
        if (l.getTipo() == null || l.getTipo().trim().isEmpty()) return false;
        if (l.getPrecioHora() <= 0) return false;

        String sql = "INSERT INTO loza (nombre, ubicacion, tipo, precioHora) VALUES (?, ?, ?, ?)";

        try {
            con = Conexion.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, l.getNombre());
            ps.setString(2, l.getUbicacion());
            ps.setString(3, l.getTipo());
            ps.setDouble(4, l.getPrecioHora());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    // 🔹 Actualizar una loza existente
    public boolean actualizar(Loza l) {

        // === VALIDACIÓN ===
        if (l.getNombre() == null || l.getNombre().trim().isEmpty()) return false;
        if (l.getUbicacion() == null || l.getUbicacion().trim().isEmpty()) return false;
        if (l.getTipo() == null || l.getTipo().trim().isEmpty()) return false;
        if (l.getPrecioHora() <= 0) return false;

        String sql = "UPDATE loza SET nombre=?, ubicacion=?, tipo=?, precioHora=? WHERE idLoza=?";

        try {
            con = Conexion.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, l.getNombre());
            ps.setString(2, l.getUbicacion());
            ps.setString(3, l.getTipo());
            ps.setDouble(4, l.getPrecioHora());
            ps.setInt(5, l.getIdLoza());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    // 🔹 Eliminar por ID
    public boolean eliminar(int idLoza) {
        String sql = "DELETE FROM loza WHERE idLoza = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLoza);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Loza obtenerPorId(int idLoza) {
    String sql = "SELECT idLoza, nombre, ubicacion, tipo, precioHora FROM loza WHERE idLoza = ?";
    try (Connection con = Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idLoza);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Loza l = new Loza();
                l.setIdLoza(rs.getInt("idLoza"));
                l.setNombre(rs.getString("nombre"));
                l.setUbicacion(rs.getString("ubicacion"));
                l.setTipo(rs.getString("tipo"));
                l.setPrecioHora(rs.getDouble("precioHora"));
                return l;
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}


    // 🔹 Cerrar conexiones
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null && !con.isClosed()) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
