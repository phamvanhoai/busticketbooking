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

    public AdminBusTypes() {
    }

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
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
