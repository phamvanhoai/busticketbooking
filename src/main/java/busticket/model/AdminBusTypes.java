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
    
    // Các biến cấu hình ghế cho tầng dưới và tầng trên
    private int rowsDown;               // Số hàng ghế tầng dưới
    private int colsDown;               // Số cột ghế tầng dưới
    private String prefixDown;          // Tiền tố hàng ghế tầng dưới

    private int rowsUp;                 // Số hàng ghế tầng trên
    private int colsUp;                 // Số cột ghế tầng trên
    private String prefixUp;            // Tiền tố hàng ghế tầng trên
    
    private int seatCount;
    private String seatType;

    public AdminBusTypes() {
    }

    public AdminBusTypes(String busTypeName, String busTypeDescription) {
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
    }

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription, String layoutDown, String layoutUp, int rowsDown, int colsDown, String prefixDown, int rowsUp, int colsUp, String prefixUp) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
        this.layoutDown = layoutDown;
        this.layoutUp = layoutUp;
        this.rowsDown = rowsDown;
        this.colsDown = colsDown;
        this.prefixDown = prefixDown;
        this.rowsUp = rowsUp;
        this.colsUp = colsUp;
        this.prefixUp = prefixUp;
    }
    
    

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
    }

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription, int seatCount) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
        this.seatCount = seatCount;
    }
    
    

    public AdminBusTypes(int busTypeId, String busTypeName, String busTypeDescription, String layoutDown, String layoutUp) {
        this.busTypeId = busTypeId;
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
        this.layoutDown = layoutDown;
        this.layoutUp = layoutUp;
    }

    // Constructor dùng cho insert
    public AdminBusTypes(String busTypeName, String busTypeDescription, String layoutDown, String layoutUp) {
        this.busTypeName = busTypeName;
        this.busTypeDescription = busTypeDescription;
        this.layoutDown = layoutDown;
        this.layoutUp = layoutUp;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }
    
    public int getSeatCount() {
        return seatCount;
    }

    public void setSeatCount(int seatCount) {
        this.seatCount = seatCount;
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

    public int getRowsDown() {
        return rowsDown;
    }

    public void setRowsDown(int rowsDown) {
        this.rowsDown = rowsDown;
    }

    public int getColsDown() {
        return colsDown;
    }

    public void setColsDown(int colsDown) {
        this.colsDown = colsDown;
    }

    public String getPrefixDown() {
        return prefixDown;
    }

    public void setPrefixDown(String prefixDown) {
        this.prefixDown = prefixDown;
    }

    public int getRowsUp() {
        return rowsUp;
    }

    public void setRowsUp(int rowsUp) {
        this.rowsUp = rowsUp;
    }

    public int getColsUp() {
        return colsUp;
    }

    public void setColsUp(int colsUp) {
        this.colsUp = colsUp;
    }

    public String getPrefixUp() {
        return prefixUp;
    }

    public void setPrefixUp(String prefixUp) {
        this.prefixUp = prefixUp;
    }

    
}
