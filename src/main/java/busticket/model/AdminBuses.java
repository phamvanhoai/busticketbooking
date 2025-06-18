/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBuses {
    private int busId;
    private String plateNumber;
    private int capacity;
    private String busStatus;
    private String busCode;
    private int busTypeId;
    private String busTypeName;

    public AdminBuses() {
    }

    //get bus for Admin add trip
    public AdminBuses(int busId, String plateNumber) {
        this.busId = busId;
        this.plateNumber = plateNumber;
    }

    public AdminBuses(String busCode, String plateNumber, int busTypeId, int capacity, String busStatus) {
        this.busCode = busCode;
        this.plateNumber = plateNumber;
        this.busTypeId = busTypeId;
        this.capacity = capacity;
        this.busStatus = busStatus;
    }

    public AdminBuses(int busId, String busCode, String plateNumber, int busTypeId, String busTypeName, int capacity, String busStatus) {
        this.busId = busId;
        this.busCode = busCode;
        this.plateNumber = plateNumber;
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.capacity = capacity;
        this.busStatus = busStatus;
    }

    public AdminBuses(int busId, String busCode, String plateNumber, int capacity, String busStatus, String busTypeName) {
        this.busId = busId;
        this.busCode = busCode;
        this.plateNumber = plateNumber;
        this.capacity = capacity;
        this.busStatus = busStatus;
        this.busTypeName = busTypeName;
    }
    
    public AdminBuses(int busId, String busCode, String plateNumber, int capacity, String busStatus, int busTypeId) {
        this.busId = busId;
        this.busCode = busCode;
        this.plateNumber = plateNumber;
        this.capacity = capacity;
        this.busStatus = busStatus;
        this.busTypeId = busTypeId;
    }

    

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
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

    public String getBusStatus() {
        return busStatus;
    }

    public void setBusStatus(String busStatus) {
        this.busStatus = busStatus;
    }

    public String getBusCode() {
        return busCode;
    }

    public void setBusCode(String busCode) {
        this.busCode = busCode;
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
    
    
}
