/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */package busticket.model;

public class AdminRoutes {
    private int routeId;
    private Integer startLocationId;
    private Integer endLocationId;
    private String startLocation;
    private String endLocation;
    private double distanceKm;
    private int estimatedTime;      // in minutes


    public AdminRoutes() {
    }

    // Constructor ngắn để show danh sách
    public AdminRoutes(int routeId, String startLocation, String endLocation) {
        this.routeId = routeId;
        this.startLocation = startLocation;
        this.endLocation = endLocation;
    }

    // Full constructor nếu cần
    public AdminRoutes(int routeId, String startLocation, String endLocation,
                       double distanceKm, int estimatedTime) {
        this.routeId = routeId;
        this.startLocation = startLocation;
        this.endLocation = endLocation;
        this.distanceKm = distanceKm;
        this.estimatedTime = estimatedTime;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
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

    public int getEstimatedTime() {
        return estimatedTime;
    }

    public void setEstimatedTime(int estimatedTime) {
        this.estimatedTime = estimatedTime;
    }
}
