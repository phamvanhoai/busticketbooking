/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverAssignedTrip {
    private int tripId;         // ID của chuyến đi
    private String route;       // Tuyến đường (bao gồm điểm bắt đầu và kết thúc)
    private Date date;          // Ngày chuyến đi
    private String time;        // Thời gian chuyến đi (định dạng HH:mm)
    private String busType;     // Loại xe
    private String driver;      // Tên tài xế
    private int busId;          // ID của xe
    private String status;      // Trạng thái chuyến đi (Scheduled, Ongoing, Completed, etc.)
    private Timestamp departureTime; // Thêm thuộc tính departureTime

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    
}
