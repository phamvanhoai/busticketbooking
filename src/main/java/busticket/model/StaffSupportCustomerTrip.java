/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Date;

/**
 *
 * @author pc
 */
public class StaffSupportCustomerTrip {
    private int requestId;
    private String customerName;
    private String oldTripName;
    private String newTripName; // Nếu chưa có new_trip_id trong DB thì giữ String
    private Date requestDate;
    private String requestStatus;

    public StaffSupportCustomerTrip() {
    }

    public StaffSupportCustomerTrip(int requestId, String customerName, String oldTripName, String newTripName, Date requestDate, String requestStatus) {
        this.requestId = requestId;
        this.customerName = customerName;
        this.oldTripName = oldTripName;
        this.newTripName = newTripName;
        this.requestDate = requestDate;
        this.requestStatus = requestStatus;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getOldTripName() {
        return oldTripName;
    }

    public void setOldTripName(String oldTripName) {
        this.oldTripName = oldTripName;
    }

    public String getNewTripName() {
        return newTripName;
    }

    public void setNewTripName(String newTripName) {
        this.newTripName = newTripName;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }
}
