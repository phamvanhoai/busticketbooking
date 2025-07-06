/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class Driver {

    private int driverId;
    private String driverName;
    private String phone;


    public Driver() {
    }

    public Driver(int driverId, String driverName) {
        this.driverId = driverId;
        this.driverName = driverName;

    }

    public Driver(int driverId, String driverName, String phone) {
        this.driverId = driverId;
        this.driverName = driverName;
        this.phone = phone;
    }
 

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }
}
