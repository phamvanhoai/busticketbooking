/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.util.Date;

/**
 *
 * @author pc
 */

public class DriverManageAssignedTrips {

    private int tripId;
    private Date departureTime;
    private String route;
    private String busType;
    private int passengerCount;
    private String status;

    // Constructor không đối số
    public DriverManageAssignedTrips() {
    }

    // Constructor đầy đủ
    public DriverManageAssignedTrips(int tripId, Date departureTime, String route, String busType, int passengerCount, String status) {
        this.tripId = tripId;
        this.departureTime = departureTime;
        this.route = route;
        this.busType = busType;
        this.passengerCount = passengerCount;
        this.status = status;
    }

    // Getter và Setter
    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public Date getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Date departureTime) {
        this.departureTime = departureTime;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public int getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(int passengerCount) {
        this.passengerCount = passengerCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // toString để tiện debug/log
    @Override
    public String toString() {
        return "DriverManageAssignedTrips{" +
                "tripId=" + tripId +
                ", departureTime=" + departureTime +
                ", route='" + route + '\'' +
                ", busType='" + busType + '\'' +
                ", passengerCount=" + passengerCount +
                ", status='" + status + '\'' +
                '}';
    }
}

