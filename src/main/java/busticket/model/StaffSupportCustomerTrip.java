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
public class StaffSupportCustomerTrip {
    private int requestId;
    private int invoiceId;
    private String invoiceCode;
    private String customerName;
    private Timestamp requestDate;
    private String cancelReason;
    private String requestStatus;
    private Integer approvedByStaffId;
    private Timestamp approvalDate;
    public StaffSupportCustomerTrip() {
    }

    public int getRequestId() {
        return requestId;
    }

    public StaffSupportCustomerTrip(int requestId, int invoiceId, String invoiceCode, String customerName, Timestamp requestDate, String cancelReason, String requestStatus, Integer approvedByStaffId, Timestamp approvalDate) {
        this.requestId = requestId;
        this.invoiceId = invoiceId;
        this.invoiceCode = invoiceCode;
        this.customerName = customerName;
        this.requestDate = requestDate;
        this.cancelReason = cancelReason;
        this.requestStatus = requestStatus;
        this.approvedByStaffId = approvedByStaffId;
        this.approvalDate = approvalDate;
    }
    
    

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public Integer getApprovedByStaffId() {
        return approvedByStaffId;
    }

    public void setApprovedByStaffId(Integer approvedByStaffId) {
        this.approvedByStaffId = approvedByStaffId;
    }

    public Timestamp getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Timestamp approvalDate) {
        this.approvalDate = approvalDate;
    }

    
}