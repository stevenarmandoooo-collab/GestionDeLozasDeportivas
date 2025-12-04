/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package DAO;
import Modelo.Cliente;
import Modelo.Administrador;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author paoye
 */
public class adminDAOTest {
    
    public adminDAOTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }



    //CP04
    @Test
    public void testLoginAdminIncorrecto() {
        System.out.println("Login administrador INCORRECTO");

        String usuario = "xxxx";
        String clave = "9999";

        adminDAO instance = new adminDAO();
        Administrador result = instance.validar(usuario, clave);

        assertNull("El administrador NO debería loguearse con credenciales inválidas.", result);
    }
    
    //CP03
    @Test
    public void testLoginAdminCorrecto() {
        System.out.println("Login administrador CORRECTO");

        String usuario = "admin";    
        String clave = "admin123";

        adminDAO instance = new adminDAO();
        Administrador result = instance.validar(usuario, clave);

        assertNotNull("El administrador debería loguearse correctamente.", result);
    }
    
    /*cp13*/
    @Test
    public void testClienteNoPuedeAccederComoAdmin() {
        System.out.println("Verificando que un cliente no acceda como administrador");

        // simulamos un cliente con credenciales válidas en la tabla cliente
        String usuarioCliente = "Bryan";
        String claveCliente = "1234";

        ClienteDAO clienteDAO = new ClienteDAO();
        Cliente cliente = clienteDAO.validar(usuarioCliente, claveCliente);

        // intentamos validar el mismo usuario en la tabla administrador
        adminDAO adminDAO = new adminDAO();
        Administrador admin = adminDAO.validar(usuarioCliente, claveCliente);

        // validaciones
        assertNotNull("El usuario debe validarse como cliente", cliente);
        assertNull("El cliente no debe poder validarse como administrador", admin);

        System.out.println("Test correcto: el cliente no puede acceder al login del administrador.");
    }
    
}