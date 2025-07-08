/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.util.Objects;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminRouteStop {
    private int routeId;
    private int stopNumber;
    private String locationName;
    private int locationId;
    private int dwellMinutes;
    private int travelMinutes;
    private String address;

    public AdminRouteStop() {
    }

    public AdminRouteStop(int routeId, int stopNumber, int locationId, int dwellMinutes) {
        this.routeId = routeId;
        this.stopNumber = stopNumber;
        this.locationId = locationId;
        this.dwellMinutes = dwellMinutes;
    }

    public AdminRouteStop(int stopNumber, int locationId, String locationName, int dwellMinutes, int travelMinutes) {
        this.stopNumber = stopNumber;
        this.locationId = locationId;
        this.locationName = locationName;
        this.dwellMinutes = dwellMinutes;
        this.travelMinutes = travelMinutes;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    
    

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
    
    

    public int getTravelMinutes() {
        return travelMinutes;
    }

    public void setTravelMinutes(int travelMinutes) {
        this.travelMinutes = travelMinutes;
    }
    
    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public int getStopNumber() {
        return stopNumber;
    }

    public void setStopNumber(int stopNumber) {
        this.stopNumber = stopNumber;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public int getDwellMinutes() {
        return dwellMinutes;
    }

    public void setDwellMinutes(int dwellMinutes) {
        this.dwellMinutes = dwellMinutes;
    }
    
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AdminRouteStop)) return false;
        AdminRouteStop that = (AdminRouteStop) o;
        return routeId == that.routeId && stopNumber == that.stopNumber;
    }

    @Override
    public int hashCode() {
        return Objects.hash(routeId, stopNumber);
    }
}
