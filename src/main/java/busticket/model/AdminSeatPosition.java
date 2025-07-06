/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminSeatPosition {

    private int busTypeId;               // bus_type_id từ bảng Bus_Types
    private String zone;                 // khu vực của ghế, có thể là 'down' hoặc 'up'
    private int row;                     // số hàng của ghế
    private int col;                     // số cột của ghế
    private String code;                 // mã ghế, ví dụ: A1, B2...

    public AdminSeatPosition() {
    }

    public AdminSeatPosition(int busTypeId, String zone, int row, int col, String code) {
        this.busTypeId = busTypeId;
        this.zone = zone;
        this.row = row;
        this.col = col;
        this.code = code;
    }
    
    

    public int getBusTypeId() {
        return busTypeId;
    }

    public void setBusTypeId(int busTypeId) {
        this.busTypeId = busTypeId;
    }

    public String getZone() {
        return zone;
    }

    public void setZone(String zone) {
        this.zone = zone;
    }

    public int getRow() {
        return row;
    }

    public void setRow(int row) {
        this.row = row;
    }

    public int getCol() {
        return col;
    }

    public void setCol(int col) {
        this.col = col;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    
}
