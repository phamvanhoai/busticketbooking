/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Date;
import java.time.LocalDate;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatistics {

    private Date statDate;
    private String routeName;
    private int ticketsSold;
    private int occupancyPercent;
    private String driverName;

    private int paidTickets;
    private int unpaidTickets;

    private String bookingId;
    private String customerName;

    public StaffBookingStatistics(Date statDate, String routeName, int ticketsSold,
            int occupancyPercent, String driverName,
            int paidTickets, int unpaidTickets) {
        this.statDate = statDate;
        this.routeName = routeName;
        this.ticketsSold = ticketsSold;
        this.occupancyPercent = occupancyPercent;
        this.driverName = driverName;
        this.paidTickets = paidTickets;
        this.unpaidTickets = unpaidTickets;
    }

    // ✅ Getters & Setters
    public Date getStatDate() {
        return statDate;
    }

    public void setStatDate(Date statDate) {
        this.statDate = statDate;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public int getTicketsSold() {
        return ticketsSold;
    }

    public void setTicketsSold(int ticketsSold) {
        this.ticketsSold = ticketsSold;
    }

    public int getOccupancyPercent() {
        return occupancyPercent;
    }

    public void setOccupancyPercent(int occupancyPercent) {
        this.occupancyPercent = occupancyPercent;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public int getPaidTickets() {
        return paidTickets;
    }

    public void setPaidTickets(int paidTickets) {
        this.paidTickets = paidTickets;
    }

    public int getUnpaidTickets() {
        return unpaidTickets;
    }

    public void setUnpaidTickets(int unpaidTickets) {
        this.unpaidTickets = unpaidTickets;
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    /**
     * Returns formatted booking ID in format BKG 00001 or "N/A" if bookingId is
     * null or not a number.
     */
    public String getFormattedBookingId() {
        try {
            int id = Integer.parseInt(bookingId);
            return String.format("BKG %04d", id);
        } catch (Exception e) {
            return "N/A";
        }
    }
}
