/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;
import java.util.Date;

/**
 *
 * @author pc
 */
public class DriverRequestTripChange {

/**
 * Model đại diện cho bảng Driver_Trip_Change_Request
 * Tương ứng với các cột trong database
 */

    private int requestId;
    private int driverId;
    private int tripId;
    private Date requestDate;
    private String changeReason;
    private String requestStatus;
    private Integer approvedByDriverId;
    private Date approvalDate;

    // Constructor không đối số
    public DriverRequestTripChange() {
    }

    // Constructor đầy đủ
    public DriverRequestTripChange(int requestId, int driverId, int tripId, Date requestDate, String changeReason, String requestStatus, Integer approvedByDriverId, Date approvalDate) {
        this.requestId = requestId;
        this.driverId = driverId;
        this.tripId = tripId;
        this.requestDate = requestDate;
        this.changeReason = changeReason;
        this.requestStatus = requestStatus;
        this.approvedByDriverId = approvedByDriverId;
        this.approvalDate = approvalDate;
    }

    // Getter & Setter
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
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

    public Integer getApprovedByDriverId() {
        return approvedByDriverId;
    }

    public void setApprovedByDriverId(Integer approvedByDriverId) {
        this.approvedByDriverId = approvedByDriverId;
    }

    public Date getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Date approvalDate) {
        this.approvalDate = approvalDate;
    }

    @Override
    public String toString() {
        return "DriverRequestTripChange{" +
                "requestId=" + requestId +
                ", driverId=" + driverId +
                ", tripId=" + tripId +
                ", requestDate=" + requestDate +
                ", changeReason='" + changeReason + '\'' +
                ", requestStatus='" + requestStatus + '\'' +
                ", approvedByDriverId=" + approvedByDriverId +
                ", approvalDate=" + approvalDate +
                '}';
    }
}




