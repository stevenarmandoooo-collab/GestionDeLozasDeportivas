package Modelo;

public class Reserva {
    private int idReserva;
    private int idCliente;
    private int idLoza;
    private String fecha;
    private String horaInicio;
    private String horaFin;
    private String estado;

    // 👇 Nuevos campos
    private String nombreLoza;
    private String nombreCliente; 

    // Getters y Setters
    public int getIdReserva() { return idReserva; }
    public void setIdReserva(int idReserva) { this.idReserva = idReserva; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public int getIdLoza() { return idLoza; }
    public void setIdLoza(int idLoza) { this.idLoza = idLoza; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getHoraInicio() { return horaInicio; }
    public void setHoraInicio(String horaInicio) { this.horaInicio = horaInicio; }

    public String getHoraFin() { return horaFin; }
    public void setHoraFin(String horaFin) { this.horaFin = horaFin; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    // 🔹 Nombre de la losa (para mostrar en tablas)
    public String getNombreLoza() { return nombreLoza; }
    public void setNombreLoza(String nombreLoza) { this.nombreLoza = nombreLoza; }

    // 🔹 Nombre del cliente (para mostrar en el dashboard admin)
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
}
