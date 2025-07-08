/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class Schedule {
    private String origin;
    private String destination;
    private String busType;
    private double distanceKm;
    private int durationMinutes;
    private BigDecimal price;

    public Schedule() {
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    /**
     * Trả về chuỗi định dạng "Xh Ym"
     */
    public String getDurationFormatted() {
        int h = durationMinutes / 60;
        int m = durationMinutes % 60;
        if (m == 0) {
            return h + "h";
        }
        return h + "h " + m + "m";
    }
}
