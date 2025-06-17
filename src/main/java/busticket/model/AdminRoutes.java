/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminRoutes {
    private int routeId;
    private String startLocation;
    private String endLocation;
    private double distanceKm;
    private String estimatedTime;
    private Integer startLocationId;
    private Integer endLocationId;

    public AdminRoutes() {
    }

    //get route for Admin add trip
    public AdminRoutes(int routeId, String startLocation, String endLocation) {
        this.routeId = routeId;
        this.startLocation = startLocation;
        this.endLocation = endLocation;
    }
    
    

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
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

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getEstimatedTime() {
        return estimatedTime;
    }

    public void setEstimatedTime(String estimatedTime) {
        this.estimatedTime = estimatedTime;
    }

    public Integer getStartLocationId() {
        return startLocationId;
    }

    public void setStartLocationId(Integer startLocationId) {
        this.startLocationId = startLocationId;
    }

    public Integer getEndLocationId() {
        return endLocationId;
    }

    public void setEndLocationId(Integer endLocationId) {
        this.endLocationId = endLocationId;
    }
    
    
}
