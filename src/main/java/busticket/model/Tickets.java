/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;


import java.util.Date; 

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class Tickets {

    private int ticketId;
    private String tripCode; // Assuming trip_code or similar for easy identification
    private String routeStartLocation;
    private String routeEndLocation;
    private String seatNumber;
    private String ticketCode;
    private double fare; // Corresponds to Route_Pricing.price
    private Date departureTime;
    private String ticketStatus;
    private String busType; // For cancel-ticket, showing bus type and available seats
    private int availableSeats; // For cancel-ticket

    // Constructor for view-bookings
    public Tickets(int ticketId, String routeStartLocation, String routeEndLocation,
            String seatNumber, String ticketCode, double fare, Date departureTime,
            String ticketStatus) {
        this.ticketId = ticketId;
        this.routeStartLocation = routeStartLocation;
        this.routeEndLocation = routeEndLocation;
        this.seatNumber = seatNumber;
        this.ticketCode = ticketCode;
        this.fare = fare;
        this.departureTime = departureTime;
        this.ticketStatus = ticketStatus;
    }

    // Constructor for cancel-ticket (might need more details or a separate model)
    public Tickets(int ticketId, String routeStartLocation, String routeEndLocation,
            String busType, int availableSeats, double fare) {
        this.ticketId = ticketId;
        this.routeStartLocation = routeStartLocation;
        this.routeEndLocation = routeEndLocation;
        this.busType = busType;
        this.availableSeats = availableSeats;
        this.fare = fare;
    }

    // Default constructor
    public Tickets() {
    }

    // Getters and Setters
    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getTripCode() {
        return tripCode;
    }

    public void setTripCode(String tripCode) {
        this.tripCode = tripCode;
    }

    public String getRouteStartLocation() {
        return routeStartLocation;
    }

    public void setRouteStartLocation(String routeStartLocation) {
        this.routeStartLocation = routeStartLocation;
    }

    public String getRouteEndLocation() {
        return routeEndLocation;
    }

    public void setRouteEndLocation(String routeEndLocation) {
        this.routeEndLocation = routeEndLocation;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public double getFare() {
        return fare;
    }

    public void setFare(double fare) {
        this.fare = fare;
    }

    public Date getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Date departureTime) {
        this.departureTime = departureTime;
    }

    public String getTicketStatus() {
        return ticketStatus;
    }

    public void setTicketStatus(String ticketStatus) {
        this.ticketStatus = ticketStatus;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }
}
