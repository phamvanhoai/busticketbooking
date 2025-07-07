/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminSeatTemplate {
    private int id;
    private String code;
    private String level;

    public AdminSeatTemplate() {
    }

    public AdminSeatTemplate(int id, String code, String level) {
        this.id = id;
        this.code = code;
        this.level = level;
    }

    
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
    
    
}
