/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Date;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminTrips {

    private int tripId;
    private int routeId;
    private String route;
    private String startLocation;
    private String endLocation;
    private Date tripDate;
    private String tripTime;
    private String arrivalTime;
    private int duration;
    private int busId;
    private String busType;
    private String plateNumber;
    private int capacity;
    private int bookedSeats;
    private int driverId;
    private String driver;
    private String status;

    public AdminTrips() {
    }
    
    //get all
    public AdminTrips(int tripId, String route, Date tripDate, String tripTime, String busType, String driver, int busId, String status) {
        this.tripId = tripId;
        this.route = route;
        this.tripDate = tripDate;
        this.tripTime = tripTime;
        this.busType = busType;
        this.driver = driver;
        this.busId = busId;
        this.status = status;
    }
    
    //getTripById
    public AdminTrips(int tripId, int routeId, String route, Date tripDate, String tripTime, int busId, String busType, String driver, String status) {
        this.tripId = tripId;
        this.routeId = routeId;
        this.route = route;
        this.tripDate = tripDate;
        this.tripTime = tripTime;
        this.busId = busId;
        this.busType = busType;
//        this.driverId = driverId;
        this.driver = driver;
        this.status = status;
    }
    
    //getTripDetailById
    public AdminTrips(int tripId, String route, String startLocation, String endLocation, Date tripDate, String tripTime, String arrivalTime, int duration, String busType, String plateNumber, int capacity, int bookedSeats, String driver, String status) {
        this.tripId = tripId;
        this.route = route;
        this.startLocation = startLocation;
        this.endLocation = endLocation;
        this.tripDate = tripDate;
        this.tripTime = tripTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.busType = busType;
        this.plateNumber = plateNumber;
        this.capacity = capacity;
        this.bookedSeats = bookedSeats;
        this.driver = driver;
        this.status = status;
    }

   
    

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
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

    public String getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
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

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
}
