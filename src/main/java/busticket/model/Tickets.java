/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class Tickets {

    private String ticketId;
    private String userName;
    private String routeName;
    private Timestamp departureTime;
    private String seatCode;
    private String driverName;
    private String busType;
    private String paymentStatus;

    public Tickets() {
    }

    public Tickets(String ticketId, String userName, String routeName,
            Timestamp departureTime, String seatCode,
            String driverName, String busType, String paymentStatus) {
        this.ticketId = ticketId;
        this.userName = userName;
        this.routeName = routeName;
        this.departureTime = departureTime;
        this.seatCode = seatCode;
        this.driverName = driverName;
        this.busType = busType;
        this.paymentStatus = paymentStatus;
    }

    public String getTicketId() {
        return ticketId;
    }

    public void setTicketId(String ticketId) {
        this.ticketId = ticketId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

}
