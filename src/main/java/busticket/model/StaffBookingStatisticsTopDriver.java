/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsTopDriver {

    private String driverName;
    private BigDecimal revenue;
    private int tripCount;
    private int ticketCount;

    public StaffBookingStatisticsTopDriver() {
    }

    public StaffBookingStatisticsTopDriver(String driverName, BigDecimal revenue, int tripCount, int ticketCount) {
        this.driverName = driverName;
        this.revenue = revenue;
        this.tripCount = tripCount;
        this.ticketCount = ticketCount;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public int getTripCount() {
        return tripCount;
    }

    public void setTripCount(int tripCount) {
        this.tripCount = tripCount;
    }

    public int getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(int ticketCount) {
        this.ticketCount = ticketCount;
    }

}
