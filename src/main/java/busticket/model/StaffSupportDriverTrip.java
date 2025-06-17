/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author pc
 */
public class StaffSupportDriverTrip {
    private int requestId;
    private int tripId;
    private String tripStatus;
    private int routeId;
    private Timestamp departureTime;
    
    private int driverId;
    private String driverName; // từ Users.name (join)
    
    private Integer changeRequestId; // có thể null nếu chưa có request
    private String changeReason;
    private String requestStatus;
    private Timestamp requestDate;
    private Integer approvedByStaffId;
    private Timestamp approvalDate;

    public StaffSupportDriverTrip(int requestId, int driverId, int tripId, Timestamp requestDate, String changeReason, String requestStatus, Integer approvedByStaffId, Timestamp approvalDate) {
        this.requestId = requestId;
        this.driverId = driverId;
        this.tripId = tripId;
        this.requestDate = requestDate;
        this.changeReason = changeReason;
        this.requestStatus = requestStatus;
        this.approvedByStaffId = approvedByStaffId;
        this.approvalDate = approvalDate;
    }
    
    
    

    public StaffSupportDriverTrip() {
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }
    
    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public String getTripStatus() {
        return tripStatus;
    }

    public void setTripStatus(String tripStatus) {
        this.tripStatus = tripStatus;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public Integer getChangeRequestId() {
        return changeRequestId;
    }

    public void setChangeRequestId(Integer changeRequestId) {
        this.changeRequestId = changeRequestId;
    }

    public String getChangeReason() {
        return changeReason;
    }

    public void setChangeReason(String changeReason) {
        this.changeReason = changeReason;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public Integer getApprovedByStaffId() {
        return approvedByStaffId;
    }

    public void setApprovedByStaffId(Integer approvedByDriverId) {
        this.approvedByStaffId = approvedByDriverId;
    }

    public Timestamp getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Timestamp approvalDate) {
        this.approvalDate = approvalDate;
    }
    
    
    
}
