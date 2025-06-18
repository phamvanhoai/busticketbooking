/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class Buses {

    private int busId; // primary key
    private String busCode;
    private String licensePlate;
    private int busTypeId; // Foreign key to BusType
    private String busTypeName; // To display bus type name directly
    private int capacity;
    private String status; // "Active", "Inactive"

    public Buses() {
    }

    public Buses(int busId, String busCode, String licensePlate, int busTypeId, String busTypeName, int capacity, String status) {
        this.busId = busId;
        this.busCode = busCode;
        this.licensePlate = licensePlate;
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.capacity = capacity;
        this.status = status;
    }

    // Constructor for creating new bus (without busId)
    public Buses(String busCode, String licensePlate, int busTypeId, int capacity, String status) {
        this.busCode = busCode;
        this.licensePlate = licensePlate;
        this.busTypeId = busTypeId;
        this.capacity = capacity;
        this.status = status;
    }

    // Getters and Setters
    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public String getBusCode() {
        return busCode;
    }

    public void setBusCode(String busCode) {
        this.busCode = busCode;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getBusTypeId() {
        return busTypeId;
    }

    public void setBusTypeId(int busTypeId) {
        this.busTypeId = busTypeId;
    }

    public String getBusTypeName() {
        return busTypeName;
    }

    public void setBusTypeName(String busTypeName) {
        this.busTypeName = busTypeName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
