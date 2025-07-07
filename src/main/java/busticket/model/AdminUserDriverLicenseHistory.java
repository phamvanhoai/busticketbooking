/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Timestamp;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUserDriverLicenseHistory {

    private int id;
    private int userId;
    private String oldLicenseClass;
    private String newLicenseClass;
    private int adminId;
    private String reason;
    private Timestamp createdAt;
    private String adminName;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getOldLicenseClass() {
        return oldLicenseClass;
    }

    public void setOldLicenseClass(String oldLicenseClass) {
        this.oldLicenseClass = oldLicenseClass;
    }

    public String getNewLicenseClass() {
        return newLicenseClass;
    }

    public void setNewLicenseClass(String newLicenseClass) {
        this.newLicenseClass = newLicenseClass;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
}
