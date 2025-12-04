package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // ⚠️ Ajusta USER/PASS a los tuyos
    private static final String URL =
            "jdbc:mysql://localhost:3306/gestion_lozas" +
            "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" +
            "&useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASS = ""; // <-- tu password

    /** Devuelve SIEMPRE una conexión NUEVA. */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encontró el driver de MySQL", e);
        }
        Connection cn = DriverManager.getConnection(URL, USER, PASS);
        // Log opcional
        System.out.println("Conexión abierta a MySQL: " + !cn.isClosed());
        return cn;
    }

    private Conexion() {}
}
