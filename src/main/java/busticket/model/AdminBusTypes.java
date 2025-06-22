/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypes {
    private int busTypeId;               // bus_type_id INT
    private String busTypeName;          // bus_type_name NVARCHAR(100)
    private String busTypeDescription;   // bus_type_description NVARCHAR(255)
    
    private String layoutDown;    // JSON for downstairs
    private String layoutUp;      // JSON for upstairs

    public AdminBusTypes() {
    }

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
    }

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription, String layoutDown, String layoutUp) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
        this.layoutDown = layoutDown;
        this.layoutUp = layoutUp;
    }
    
    

    public String getLayoutDown() {
        return layoutDown;
    }

    public void setLayoutDown(String layoutDown) {
        this.layoutDown = layoutDown;
    }

    public String getLayoutUp() {
        return layoutUp;
    }

    public void setLayoutUp(String layoutUp) {
        this.layoutUp = layoutUp;
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

    public String getBusTypeDescription() {
        return busTypeDescription;
    }

    public void setBusTypeDescription(String busTypeDescription) {
        this.busTypeDescription = busTypeDescription;
    }
    
    
}
