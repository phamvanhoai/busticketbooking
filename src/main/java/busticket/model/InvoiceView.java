/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author lyric
 */
public class InvoiceView {

    private int invoiceId;
    private String invoiceCode;
    private double totalAmount;
    private String paymentMethod;
    private String status;
    private int ticketId;
    private String cancelReason;
    private String departureTime;

    // Constructor đầy đủ
    public InvoiceView(int invoiceId, String invoiceCode, double totalAmount,
            String paymentMethod, String status, int ticketId,
            String cancelReason, String departureTime) {
        this.invoiceId = invoiceId;
        this.invoiceCode = invoiceCode;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.ticketId = ticketId;
        this.cancelReason = cancelReason;
        this.departureTime = departureTime;
    }

    // Getters
    public String getDepartureTime() {
        return departureTime;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public int getTicketId() {
        return ticketId;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    // Setters
    public void setDepartureTime(String departureTime) {
        this.departureTime = departureTime;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    @Override
    public String toString() {
        return "InvoiceView{"
                + "invoiceId=" + invoiceId
                + ", invoiceCode='" + invoiceCode + '\''
                + ", totalAmount=" + totalAmount
                + ", paymentMethod='" + paymentMethod + '\''
                + ", status='" + status + '\''
                + ", ticketId=" + ticketId
                + ", cancelReason='" + cancelReason + '\''
                + '}';
    }
}
