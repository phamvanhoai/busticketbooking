/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class Tickets {
    private int ticketId;
    private int tripId;
    private int userId;
    private String ticketStatus;
    private Timestamp checkIn;
    private Timestamp checkOut;
    private String ticketCode;
    private int pickupLocationId;
    private int dropoffLocationId;

    public Tickets() {
    }

    public Tickets(int ticketId, int tripId, int userId, String ticketStatus, Timestamp checkIn, Timestamp checkOut, String ticketCode, int pickupLocationId, int dropoffLocationId) {
        this.ticketId = ticketId;
        this.tripId = tripId;
        this.userId = userId;
        this.ticketStatus = ticketStatus;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.ticketCode = ticketCode;
        this.pickupLocationId = pickupLocationId;
        this.dropoffLocationId = dropoffLocationId;
    }

    
    
    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTicketStatus() {
        return ticketStatus;
    }

    public void setTicketStatus(String ticketStatus) {
        this.ticketStatus = ticketStatus;
    }

    public Timestamp getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Timestamp checkIn) {
        this.checkIn = checkIn;
    }

    public Timestamp getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Timestamp checkOut) {
        this.checkOut = checkOut;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public int getPickupLocationId() {
        return pickupLocationId;
    }

    public void setPickupLocationId(int pickupLocationId) {
        this.pickupLocationId = pickupLocationId;
    }

    public int getDropoffLocationId() {
        return dropoffLocationId;
    }

    public void setDropoffLocationId(int dropoffLocationId) {
        this.dropoffLocationId = dropoffLocationId;
    }
    
}
