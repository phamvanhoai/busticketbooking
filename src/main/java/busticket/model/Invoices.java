/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class Invoices {

    private int invoiceId;
    private int userId;
    private float invoiceTotalAmount;
    private String paymentMethod;
    private Timestamp paidAt;
    private String invoiceCode;
    private String invoiceStatus;
    private int ticketCount;
    private String route;
    private Timestamp departureTime;
    private String customerName; // Thông tin khách hàng
    private String customerPhone;
    private Integer reviewRating;
    private String reviewText;
    private boolean reviewed; // ✅ Đánh giá: đã review hay chưa

    // Constructor mặc định
    public Invoices() {
    }

    // Constructor đầy đủ (bạn có thể cập nhật nếu dùng)
    public Invoices(int invoiceId, int userId, float invoiceTotalAmount, String paymentMethod,
            Timestamp paidAt, String invoiceCode, String invoiceStatus, int ticketCount,
            String route, Timestamp departureTime, String customerName,
            Integer reviewRating, String reviewText, boolean reviewed) {
        this.invoiceId = invoiceId;
        this.userId = userId;
        this.invoiceTotalAmount = invoiceTotalAmount;
        this.paymentMethod = paymentMethod;
        this.paidAt = paidAt;
        this.invoiceCode = invoiceCode;
        this.invoiceStatus = invoiceStatus;
        this.ticketCount = ticketCount;
        this.route = route;
        this.departureTime = departureTime;
        this.customerName = customerName;
        this.reviewRating = reviewRating;
        this.reviewText = reviewText;
        this.reviewed = reviewed;
    }

    // Getter/Setter

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    
    public Integer getReviewRating() {
        return reviewRating;
    }

    public void setReviewRating(Integer reviewRating) {
        this.reviewRating = reviewRating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public boolean isReviewed() {
        return reviewed;
    }

    public void setReviewed(boolean reviewed) {
        this.reviewed = reviewed;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public int getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(int ticketCount) {
        this.ticketCount = ticketCount;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public float getInvoiceTotalAmount() {
        return invoiceTotalAmount;
    }

    public void setInvoiceTotalAmount(float invoiceTotalAmount) {
        this.invoiceTotalAmount = invoiceTotalAmount;
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

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public String getInvoiceStatus() {
        return invoiceStatus;
    }

    public void setInvoiceStatus(String invoiceStatus) {
        this.invoiceStatus = invoiceStatus;
    }
}
