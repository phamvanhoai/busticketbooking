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
public class DriverPassenger {
    private int id;               // ID của hành khách
    private String seat;              // Ghế ngồi
    private String name;              // Tên hành khách
    private String phone;             // Số điện thoại hành khách
    private String pickupLocation;    // Điểm lên xe
    private String dropoffLocation;   // Điểm xuống xe
    private Timestamp checkInTime = null;    // Thời gian check-in (Lưu dưới dạng DateTime)
    private Timestamp checkOutTime = null;   // Thời gian check-out (Lưu dưới dạng DateTime)

    public DriverPassenger(String seat, String name, String phone, String pickupLocation, String dropoffLocation, Timestamp checkInTime, Timestamp checkOutTime) {
        this.seat = seat;
        this.name = name;
        this.phone = phone;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkInTime;
    }

    public DriverPassenger(String seat, String name, String phone, String pickupLocation, String dropoffLocation) {
        this.seat = seat;
        this.name = name;
        this.phone = phone;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
    }
    
    

    public DriverPassenger() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public String getSeat() {
        return seat;
    }

    public void setSeat(String seat) {
        this.seat = seat;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public String getDropoffLocation() {
        return dropoffLocation;
    }

    public void setDropoffLocation(String dropoffLocation) {
        this.dropoffLocation = dropoffLocation;
    }

    public Timestamp getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Timestamp checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Timestamp getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Timestamp checkOutTime) {
        this.checkOutTime = checkOutTime;
    }
    
    
}
