package Modelo;

public class Loza {
    private int idLoza;
    private String nombre;
    private String ubicacion;
    private String tipo;
    private double precioHora;

    // Getters y setters
    public int getIdLoza() { return idLoza; }
    public void setIdLoza(int idLoza) { this.idLoza = idLoza; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public double getPrecioHora() { return precioHora; }
    public void setPrecioHora(double precioHora) { this.precioHora = precioHora; }
}
