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
public class BookingStatistics {

    private LocalDate date;
    private String routeName;
    private int ticketsSold;
    private int occupancyPercent;
    private String driverName;

    public BookingStatistics() {
    }

    public BookingStatistics(LocalDate date, String routeName, int ticketsSold, int occupancyPercent, String driverName) {
        this.date = date;
        this.routeName = routeName;
        this.ticketsSold = ticketsSold;
        this.occupancyPercent = occupancyPercent;
        this.driverName = driverName;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
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

}
