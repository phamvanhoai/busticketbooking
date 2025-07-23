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
public class DriverIncidents {

    private int incidentId;
    private int driverId;
    private Integer tripId;
    private String description;
    private String location;
    private String photoUrl;
    private String incidentType;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt; // Thêm cột incident_updated_at
    private String incidentNote; // Thêm cột incident_note
    private Integer staffId;    // Thêm cột staff_id
    
    //DRIVER
    public DriverIncidents(int incidentId, int driverId, Integer tripId, String description, String location, String photoUrl, String incidentType, String status, Timestamp createdAt) {
        this.incidentId = incidentId;
        this.driverId = driverId;
        this.tripId = tripId;
        this.description = description;
        this.location = location;
        this.photoUrl = photoUrl;
        this.incidentType = incidentType;
        this.status = status;
        this.createdAt = createdAt;
    }

    //STAFF
    public DriverIncidents(int incidentId, int driverId, Integer tripId, String description, String location, String photoUrl, String incidentType, String status, Timestamp createdAt, String incidentNote, Integer staffId) {
        this.incidentId = incidentId;
        this.driverId = driverId;
        this.tripId = tripId;
        this.description = description;
        this.location = location;
        this.photoUrl = photoUrl;
        this.incidentType = incidentType;
        this.status = status;
        this.createdAt = createdAt;
        this.incidentNote = incidentNote;
        this.staffId = staffId;
    }

    public DriverIncidents(int incidentId, int driverId, Integer tripId, String description, String location, String photoUrl, String incidentType, String status, Timestamp createdAt, Timestamp updatedAt, String incidentNote, Integer staffId) {
        this.incidentId = incidentId;
        this.driverId = driverId;
        this.tripId = tripId;
        this.description = description;
        this.location = location;
        this.photoUrl = photoUrl;
        this.incidentType = incidentType;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.incidentNote = incidentNote;
        this.staffId = staffId;
    }
    
    

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    

    public String getIncidentNote() {
        return incidentNote;
    }

    public void setIncidentNote(String incidentNote) {
        this.incidentNote = incidentNote;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }
    

    public int getIncidentId() {
        return incidentId;
    }

    public void setIncidentId(int incidentId) {
        this.incidentId = incidentId;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public Integer getTripId() {
        return tripId;
    }

    public void setTripId(Integer tripId) {
        this.tripId = tripId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public String getIncidentType() {
        return incidentType;
    }

    public void setIncidentType(String incidentType) {
        this.incidentType = incidentType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}
