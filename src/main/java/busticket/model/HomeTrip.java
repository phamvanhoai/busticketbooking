/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import busticket.model.AdminRouteStop;

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

    private int busTypeId;
    private int rowsDown;
    private int colsDown;
    private int rowsUp;
    private int colsUp;

    // New field to hold Route Stops
    private List<AdminRouteStop> routeStops;

// Getter and Setter for routeStops
    public List<AdminRouteStop> getRouteStops() {
        return routeStops;
    }

    public void setRouteStops(List<AdminRouteStop> routeStops) {
        this.routeStops = routeStops;
    }

    // Thêm biến lưu trữ danh sách giờ đến cho các điểm dừng
    private List<String> stopTimes;

    // Getter và Setter cho stopTimes
    public List<String> getStopTimes() {
        return stopTimes;
    }

    public void setStopTimes(List<String> stopTimes) {
        this.stopTimes = stopTimes;
    }

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
    }

    public int getBusTypeId() {
        return busTypeId;
    }

    public void setBusTypeId(int busTypeId) {
        this.busTypeId = busTypeId;
    }

    public int getRowsDown() {
        return rowsDown;
    }

    public void setRowsDown(int rowsDown) {
        this.rowsDown = rowsDown;
    }

    public int getColsDown() {
        return colsDown;
    }

    public void setColsDown(int colsDown) {
        this.colsDown = colsDown;
    }

    public int getRowsUp() {
        return rowsUp;
    }

    public void setRowsUp(int rowsUp) {
        this.rowsUp = rowsUp;
    }

    public int getColsUp() {
        return colsUp;
    }

    public void setColsUp(int colsUp) {
        this.colsUp = colsUp;
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
        return "HomeTrip{"
                + "tripId=" + tripId
                + ", origin='" + origin + '\''
                + ", destination='" + destination + '\''
                + ", tripDate=" + tripDate
                + ", tripTime='" + tripTime + '\''
                + ", duration=" + duration
                + ", arrivalTime='" + arrivalTime + '\''
                + ", busType='" + busType + '\''
                + ", capacity=" + capacity
                + ", bookedSeats=" + bookedSeats
                + '}';
    }

}
