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

    private String driverId;
    private String fullName;
    private String phone;

    public Driver() {
    }

    public Driver(String driverId, String fullName, String phone) {
        this.driverId = driverId;
        this.fullName = fullName;
        this.phone = phone;
    }

    public String getDriverId() {
        return driverId;
    }

    public void setDriverId(String driverId) {
        this.driverId = driverId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
