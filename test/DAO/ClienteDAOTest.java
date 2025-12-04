/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package DAO;

import Modelo.Cliente;
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
public class ClienteDAOTest {
    
    public ClienteDAOTest() {
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

    //CP01
   /* @Test
    public void testValidarLoginCorrecto() {
        System.out.println("Login Correcto");

        String usuario = "Bryan";   
        String clave = "1234";      

        ClienteDAO instance = new ClienteDAO();
        Cliente result = instance.validar(usuario, clave);

        assertNotNull("El usuario debería validarse correctamente.", result);
    }

    //CP02
    @Test
    public void testValidarLoginIncorrecto() {
        System.out.println("Login Incorrecto");

        String usuario = "usu";   // usuario NOE XISTE EN BD
        String clave = "5678";    

        ClienteDAO instance = new ClienteDAO();
        Cliente result = instance.validar(usuario, clave);

        assertNull("El usuario NO debería existir.", result);
    }*/

    //CP05
   /* @Test
    public void testRegistrarClienteExito() {
        System.out.println("Registrar nuevo cliente - ÉXITO");

        ClienteDAO dao = new ClienteDAO();
        Cliente nuevo = new Cliente();
        nuevo.setNombre("Cristopher");
        nuevo.setApellidos("Quispe Tupayachi");
        nuevo.setDni("77889966");        // importante no debe coincidir en la bd
        nuevo.setTelefono("987654321");
        nuevo.setEmail("cris@mail.com");
        nuevo.setDireccion("Av Siempre Viva 123");
        nuevo.setUsuario("cris123");   
        nuevo.setClave("abc123");

        boolean resultado = dao.registrar(nuevo);

        assertTrue("El cliente DEBERÍA registrarse correctamente.", resultado);
    }*/
    
    //CP06 -- VOLVER A PROBAR
    @Test
    public void testRegistrarClienteCamposVacios() {
        System.out.println("Registrar nuevo cliente - ERROR POR CAMPOS VACÍOS");

        ClienteDAO dao = new ClienteDAO();
        Cliente nuevo = new Cliente();

        // Dejamos campos obligatorios vacíos a proposito
        nuevo.setNombre(""); // dato obligatorio
        nuevo.setApellidos(""); // dato obligatorio
        nuevo.setDni("");          // dato obligatorio -- no debe ser duplicado
        nuevo.setTelefono("");
        nuevo.setEmail("");
        nuevo.setDireccion("");
        nuevo.setUsuario("");// dato obligatorio -- no debe coincidir con un usuario en la bd
        nuevo.setClave(""); // dato obligatorio

        boolean resultado = dao.registrar(nuevo);

        // Se espera que NO registre
        assertFalse("No debe registrar si hay campos obligatorios vacíos.", resultado);
    }

    
}