/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package DAO;

import Modelo.Reserva;
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
public class ReservaDAOTest {
    
    public ReservaDAOTest() {
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

    //CP10 -CP11 (REPETIRLO PARA VALIDAR CP11)
    /*@Test
    public void testRegistrarReservaExito() {
        ReservaDAO dao = new ReservaDAO();
        Reserva r = new Reserva();
        r.setIdCliente(1);
        r.setIdLoza(2);
        r.setFecha("2025-11-15");
        r.setHoraInicio("11:00:00");
        r.setHoraFin("12:00:00");
        r.setEstado("Pendiente");

        boolean resultado = dao.registrar(r);

        assertTrue(resultado); // se registre correctamente la reserva
    }*/
    
    //CP12
    /*@Test
    public void testListarTodasReservasExito() {
        ReservaDAO dao = new ReservaDAO();
        List<Reserva> lista = dao.listarTodas();
        // la lista no sea nula
        assertNotNull("La lista de reservas no debe ser nula", lista);
        // al menos que haya una reserva
        assertTrue("Debe listar al menos una reserva", lista.size() > 0);
        // Mostrar las reservas revisión visual
        for (Reserva r : lista) {
            System.out.println("Reserva ID: " + r.getIdReserva() +
                               " | Cliente: " + r.getNombreCliente() +
                               " | Loza: " + r.getNombreLoza() +
                               " | Fecha: " + r.getFecha() +
                               " | Estado: " + r.getEstado());
        }
    }*/
    
    //CP18
    /*@Test
    public void testListarPorCliente_Exito() {
        System.out.println("CP18 - Mostrar historial de reservas del usuario");

        // Arrange
        ReservaDAO dao = new ReservaDAO();
        int idCliente = 1; // ID válido que exista en tu BD de pruebas

        // Act
        List<Reserva> reservas = dao.listarPorCliente(idCliente);

        // Assert
        assertNotNull("La lista de reservas no debe ser nula", reservas);
        assertTrue("El cliente debería tener al menos una reserva registrada", reservas.size() > 0);

        // Mensaje de control opcional
        for (Reserva r : reservas) {
            System.out.println("Reserva: " + r.getIdReserva() + " - Loza: " + r.getNombreLoza());
        }
    }*/
    
    //CP19
    @Test
    public void testMostrarMensajeConfirmacionReserva() {
        // Arrange
        ReservaDAO dao = new ReservaDAO();
        Reserva r = new Reserva();
        r.setIdCliente(1);               // idCliente existente en la BD
        r.setIdLoza(2);                  // idLoza existente
        r.setFecha("2025-11-20");        // fecha disponible
        r.setHoraInicio("09:00:00");
        r.setHoraFin("10:00:00");
        r.setEstado("Pendiente");

        // Act
        boolean resultado = dao.registrar(r);

        // Assert
        assertTrue("La reserva debería registrarse correctamente y mostrar 'Reserva confirmada'", resultado);
    }
    
}