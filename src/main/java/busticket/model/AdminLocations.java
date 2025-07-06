/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;


import java.sql.Timestamp;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminLocations {
    private int locationId;
    private String locationName;
    private String address;
    private double latitude;
    private double longitude;
    private String locationType;
    private String locationDescription;
    private Timestamp   locationCreatedAt;
    private String locationStatus;

    public AdminLocations() {
    }

    public AdminLocations(int locationId, String locationName, String address, double latitude, double longitude, String locationType, String locationDescription, Timestamp locationCreatedAt, String locationStatus) {
        this.locationId = locationId;
        this.locationName = locationName;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.locationType = locationType;
        this.locationDescription = locationDescription;
        this.locationCreatedAt = locationCreatedAt;
        this.locationStatus = locationStatus;
    }

    
    
    

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getLocationType() {
        return locationType;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public String getLocationDescription() {
        return locationDescription;
    }

    public void setLocationDescription(String locationDescription) {
        this.locationDescription = locationDescription;
    }

    public Timestamp getLocationCreatedAt() {
        return locationCreatedAt;
    }

    public void setLocationCreatedAt(Timestamp locationCreatedAt) {
        this.locationCreatedAt = locationCreatedAt;
    }

    public String getLocationStatus() {
        return locationStatus;
    }

    public void setLocationStatus(String locationStatus) {
        this.locationStatus = locationStatus;
    }
    
    
    
    
}
