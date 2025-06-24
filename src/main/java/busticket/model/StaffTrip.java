/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffTrip {

    private int tripId;
    private Timestamp departureTime;
    private String routeName;
    private String driverName;
    private String plateNumber;
    private String busTypeName;

    public StaffTrip() {
    }

    public StaffTrip(int tripId, Timestamp departureTime, String routeName, String driverName, String plateNumber, String busTypeName) {
        this.tripId = tripId;
        this.departureTime = departureTime;
        this.routeName = routeName;
        this.driverName = driverName;
        this.plateNumber = plateNumber;
        this.busTypeName = busTypeName;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public String getBusTypeName() {
        return busTypeName;
    }

    public void setBusTypeName(String busTypeName) {
        this.busTypeName = busTypeName;
    }
}
