
package DAO;

import Modelo.Administrador;
import java.sql.*;

public class adminDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    /**
     *
     * @param usuario
     * @param clave
     * @return
     */
    public Administrador validar(String usuario, String clave) {
        Administrador a = null;
        String sql = "SELECT * FROM administrador WHERE usuario=? AND clave=?";
        try {
            con = Conexion.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            rs = ps.executeQuery();
            if (rs.next()) {
                a = new Administrador();
                a.setIdAdmin(rs.getInt("idAdmin"));
                a.setNombre(rs.getString("nombre"));
                a.setApellidos(rs.getString("apellidos"));
                a.setUsuario(rs.getString("usuario"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }
}
  
