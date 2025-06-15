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
    private String route;
    private Date tripDate;
    private String tripTime;
    private String busType;
    private String driver;
    private String busId;
    private String status;

    public AdminTrips() {
    }

    public AdminTrips(int tripId, String route, Date tripDate, String tripTime, String busType, String driver, String busId, String status) {
        this.tripId = tripId;
        this.route = route;
        this.tripDate = tripDate;
        this.tripTime = tripTime;
        this.busType = busType;
        this.driver = driver;
        this.busId = busId;
        this.status = status;
    }
    
    

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
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

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getBusId() {
        return busId;
    }

    public void setBusId(String busId) {
        this.busId = busId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
}
