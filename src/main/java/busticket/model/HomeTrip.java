/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class HomeTrip {
    private int tripId;
    private String origin;
    private String destination;
    private Date tripDate;
    private String tripTime;
    private int duration;          // phút
    private String arrivalTime;    // HH:mm
    private String busType;
    private int blankSeats;
    private BigDecimal price;      // nếu không có cột price, bạn có thể set null hoặc mặc định
    
    private int capacity;
    private int bookedSeats;
    
    private String startLocation;
    private String endLocation;
    
    public HomeTrip(int tripId, String origin, String destination,
                    Date tripDate, String tripTime, int duration,
                    String arrivalTime, String busType,
                    int capacity, int bookedSeats, BigDecimal price) {
        this.tripId = tripId;
        this.origin = origin;
        this.destination = destination;
        this.tripDate = tripDate;
        this.tripTime = tripTime;
        this.duration = duration;
        this.arrivalTime = arrivalTime;
        this.busType = busType;
        this.capacity = capacity;
        this.bookedSeats = bookedSeats;
        this.blankSeats = capacity - bookedSeats;
        this.price = price;
    }

    public HomeTrip(int tripId,
                    String origin,
                    String destination,
                    Date tripDate,
                    String tripTime,
                    int duration,
                    String arrivalTime,
                    String busType,
                    int capacity,
                    int bookedSeats) {
        this.tripId       = tripId;
        this.origin       = origin;
        this.destination  = destination;
        this.tripDate     = tripDate;
        this.tripTime     = tripTime;
        this.duration     = duration;
        this.arrivalTime  = arrivalTime;
        this.busType      = busType;
        this.capacity     = capacity;
        this.bookedSeats  = bookedSeats;
    }


    public String getStartLocation() {
        return startLocation;
    }

    public void setStartLocation(String startLocation) {
        this.startLocation = startLocation;
    }

    public String getEndLocation() {
        return endLocation;
    }

    public void setEndLocation(String endLocation) {
        this.endLocation = endLocation;
    }
    
    

    public HomeTrip() {
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
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

    public Date getTripDate() {
        return tripDate;
    }

    public void setTripDate(Date tripDate) {
        this.tripDate = tripDate;
    }

    public String getTripTime() {
        return tripTime;
    }

    public void setTripTime(String tripTime) {
        this.tripTime = tripTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public int getBlankSeats() {
        return blankSeats;
    }

    public void setBlankSeats(int blankSeats) {
        this.blankSeats = blankSeats;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getBookedSeats() {
        return bookedSeats;
    }

    public void setBookedSeats(int bookedSeats) {
        this.bookedSeats = bookedSeats;
    }
    
    @Override
    public String toString() {
        return "HomeTrip{" +
               "tripId=" + tripId +
               ", origin='" + origin + '\'' +
               ", destination='" + destination + '\'' +
               ", tripDate=" + tripDate +
               ", tripTime='" + tripTime + '\'' +
               ", duration=" + duration +
               ", arrivalTime='" + arrivalTime + '\'' +
               ", busType='" + busType + '\'' +
               ", capacity=" + capacity +
               ", bookedSeats=" + bookedSeats +
               '}';
    }

}
