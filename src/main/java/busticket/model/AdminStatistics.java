/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminStatistics {
    private BigDecimal revenue;
    private List<Map<String, Object>> occupancyRate;
    private List<Map<String, Object>> ticketTypeBreakdown;
    private List<Map<String, Object>> topRoutesRevenue;
    private List<String> driverPerformance;
    private List<Map<String, Object>> detailedStatistics; // Thêm thuộc tính mới
    private String period; // day, week, month, quarter, year
    private String dateValue;

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public List<Map<String, Object>> getOccupancyRate() {
        return occupancyRate;
    }

    public void setOccupancyRate(List<Map<String, Object>> occupancyRate) {
        this.occupancyRate = occupancyRate;
    }

    public List<Map<String, Object>> getTicketTypeBreakdown() {
        return ticketTypeBreakdown;
    }

    public void setTicketTypeBreakdown(List<Map<String, Object>> ticketTypeBreakdown) {
        this.ticketTypeBreakdown = ticketTypeBreakdown;
    }

    public List<Map<String, Object>> getTopRoutesRevenue() {
        return topRoutesRevenue;
    }

    public void setTopRoutesRevenue(List<Map<String, Object>> topRoutesRevenue) {
        this.topRoutesRevenue = topRoutesRevenue;
    }

    public List<String> getDriverPerformance() {
        return driverPerformance;
    }

    public void setDriverPerformance(List<String> driverPerformance) {
        this.driverPerformance = driverPerformance;
    }

    public List<Map<String, Object>> getDetailedStatistics() {
        return detailedStatistics;
    }

    public void setDetailedStatistics(List<Map<String, Object>> detailedStatistics) {
        this.detailedStatistics = detailedStatistics;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getDateValue() {
        return dateValue;
    }

    public void setDateValue(String dateValue) {
        this.dateValue = dateValue;
    }

    
}
