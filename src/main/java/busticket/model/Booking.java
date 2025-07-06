/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author lyric
 */
public class Booking {
    private String ticketCode;
    private String startLocation;
    private String endLocation;
    private String seat;
    private double fare;
    private String departure;
    private String status;

    public Booking() {}

    public Booking(String ticketCode, String startLocation, String endLocation, String seat, double fare, String departure, String status) {
        this.ticketCode = ticketCode;
        this.startLocation = startLocation;
        this.endLocation = endLocation;
        this.seat = seat;
        this.fare = fare;
        this.departure = departure;
        this.status = status;
    }

    // Getters và Setters
    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    public String getStartLocation() { return startLocation; }
    public void setStartLocation(String startLocation) { this.startLocation = startLocation; }

    public String getEndLocation() { return endLocation; }
    public void setEndLocation(String endLocation) { this.endLocation = endLocation; }

    public String getSeat() { return seat; }
    public void setSeat(String seat) { this.seat = seat; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public String getDeparture() { return departure; }
    public void setDeparture(String departure) { this.departure = departure; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

