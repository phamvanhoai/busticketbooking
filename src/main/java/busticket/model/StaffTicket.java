/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffTicket {

    private String ticketId;
    private String userName;
    private String routeName;
    private Timestamp departureTime;
    private String seatCode;
    private String driverName;
    private String busType;
    private String paymentStatus;
    private BigDecimal invoiceAmount;
    private String paymentMethod;
    private Timestamp paidAt;
    private String routeId;

    public String getFormattedTicketId() {
        try {
            return String.format("BKG %04d", Integer.parseInt(ticketId));
        } catch (NumberFormatException e) {
            return "BKG" + ticketId;
        }
    }

    public StaffTicket() {
    }

    public StaffTicket(String ticketId, String formattedTicketId, String userName,
            String routeName, Timestamp departureTime,
            String seatCode, String driverName, String busType,
            String paymentStatus) {
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

    public BigDecimal getInvoiceAmount() {
        return invoiceAmount;
    }

    public void setInvoiceAmount(BigDecimal invoiceAmount) {
        this.invoiceAmount = invoiceAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public String getRouteId() {
        return routeId;
    }

    public void setRouteId(String routeId) {
        this.routeId = routeId;
    }

}
