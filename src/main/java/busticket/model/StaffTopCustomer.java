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
public class StaffTopCustomer {

    private String customerName;
    private int invoiceCount;
    private double totalSpent;

    public StaffTopCustomer() {
    }

    public StaffTopCustomer(String customerName, int invoiceCount, double totalSpent) {
        this.customerName = customerName;
        this.invoiceCount = invoiceCount;
        this.totalSpent = totalSpent;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getInvoiceCount() {
        return invoiceCount;
    }

    public void setInvoiceCount(int invoiceCount) {
        this.invoiceCount = invoiceCount;
    }

    public double getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(double totalSpent) {
        this.totalSpent = totalSpent;
    }
}
