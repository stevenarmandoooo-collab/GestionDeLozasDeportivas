package DAO;

import Modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ClienteDAO {

    // 🔹 Registrar nuevo cliente
    public boolean registrar(Cliente c) {

        // ================================
        // VALIDACIÓN DE CAMPOS OBLIGATORIOS
        // ================================
        if (c.getNombre() == null || c.getNombre().trim().isEmpty()
                || c.getApellidos() == null || c.getApellidos().trim().isEmpty()
                || c.getDni() == null || c.getDni().trim().isEmpty()
                || c.getTelefono() == null || c.getTelefono().trim().isEmpty()
                || c.getEmail() == null || c.getEmail().trim().isEmpty()
                || c.getDireccion() == null || c.getDireccion().trim().isEmpty()
                || c.getUsuario() == null || c.getUsuario().trim().isEmpty()
                || c.getClave() == null || c.getClave().trim().isEmpty()) {

            System.out.println("❌ ERROR POR CAMPOS VACÍOS");
            return false;
        }

        String sql = "INSERT INTO cliente (nombre, apellidos, dni, telefono, email, direccion, usuario, clave) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getConnection();

            // 🔹 Validar duplicado de DNI
            if (existeDni(con, c.getDni())) {
                System.out.println("⚠️ DNI ya registrado.");
                return false;
            }

            // 🔹 Validar duplicado de usuario
            if (existeUsuario(con, c.getUsuario())) {
                System.out.println("⚠️ Usuario ya registrado.");
                return false;
            }

            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getApellidos());
            ps.setString(3, c.getDni());
            ps.setString(4, c.getTelefono());
            ps.setString(5, c.getEmail());
            ps.setString(6, c.getDireccion());
            ps.setString(7, c.getUsuario());
            ps.setString(8, c.getClave());

            ps.executeUpdate();
            System.out.println("✅ Cliente registrado correctamente.");
            return true;

        } catch (SQLException e) {
            System.out.println("❌ Error al registrar cliente: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 🔹 Verificar DNI
    private boolean existeDni(Connection con, String dni) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente WHERE dni = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dni);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // 🔹 Verificar usuario
    private boolean existeUsuario(Connection con, String usuario) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente WHERE usuario = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // 🔹 Validar login
    public Cliente validar(String usuario, String clave) {
        Cliente cliente = null;
        String sql = "SELECT * FROM cliente WHERE usuario = ? AND clave = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, clave);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellidos(rs.getString("apellidos"));
                cliente.setDni(rs.getString("dni"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setUsuario(rs.getString("usuario"));
                cliente.setClave(rs.getString("clave"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cliente;
    }
}
