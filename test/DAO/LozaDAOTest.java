/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package DAO;

import Modelo.Loza;
import java.util.List;
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
public class LozaDAOTest {
    
    public LozaDAOTest() {
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

    //CP08
   /* @Test
    public void testListarLozas() {
        System.out.println("listar lozas disponibles...");
        LozaDAO dao = new LozaDAO();
        List<Loza> lista = dao.listar();
        // validar que la lista no sea nula
        assertNotNull("La lista de lozas no debe ser nula", lista);
        // validar por lo  menos una loza registrada en la bd
        assertTrue("Debe existir al menos una loza registrada", lista.size() > 0);
        // mostrar las lozas recuperadas para verificación manual
        for (Loza l : lista) {
            System.out.println(" °ID: " + l.getIdLoza() +
                               " | Nombre: " + l.getNombre() +
                               " | Ubicación: " + l.getUbicacion() +
                               " | Tipo: " + l.getTipo() +
                               " | Precio/hora: " + l.getPrecioHora());
        }
    }*/
    
    //CP14
    /*@Test
    public void testActualizarLozaExito() {
        System.out.println("Editar información de una loza");

        LozaDAO dao = new LozaDAO();
        Loza loza = new Loza();
        loza.setIdLoza(1); // ID existente en la base de datos
        loza.setNombre("Loza Central");
        loza.setUbicacion("Av. Principal 123");
        loza.setTipo("Fútbol");
        loza.setPrecioHora(55.00);

        boolean resultado = dao.actualizar(loza);

        assertTrue("La loza debería actualizarse correctamente.", resultado);
    }*/
    
    //CP16
   /* @Test
    public void testAgregarLozaExito() {
        System.out.println("Registrar una nueva loza");

        // Crear el DAO y el objeto Loza
        LozaDAO dao = new LozaDAO();
        Loza nueva = new Loza();
        nueva.setNombre("Loza Primavera");
        nueva.setUbicacion("Av. Los Olivos 456");
        nueva.setTipo("Fútbol 7");
        nueva.setPrecioHora(40.00);

        // Ejecutar el método
        boolean resultado = dao.agregar(nueva);

        // Verificar resultado
        assertTrue("La loza debería registrarse correctamente.", resultado);
    }*/
    
    //CP17 --- PROBAR NUEVAMENTE
     @Test
    public void testAgregarLozaCamposVacios() {
        System.out.println("CP17 - Registrar loza con campos vacíos");
        
        // Arrange
        LozaDAO dao = new LozaDAO();
        Loza loza = new Loza();
        loza.setNombre(""); // Campo vacío
        loza.setUbicacion("Av. Central 123");
        loza.setTipo("Fútbol");
        loza.setPrecioHora(55.00); // Simula error o dato faltante

        // Act
        boolean resultado = dao.agregar(loza);

        // Assert
        assertFalse("No debería permitir registrar una loza con campos vacíos", resultado);
    }
}