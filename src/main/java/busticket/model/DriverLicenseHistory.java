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
public class DriverLicenseHistory {
    private int id;
    private int userId;
    private String oldLicenseClass;
    private String newLicenseClass;
    private String reason;
    private int changedBy;
    private String userName; // Thêm để lưu tên người dùng
    private Timestamp changedAt;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

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

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
    
    
}
