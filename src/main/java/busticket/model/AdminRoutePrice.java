/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.math.BigDecimal;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminRoutePrice {
    private int routeId;
    private int busTypeId;
    private BigDecimal price;

    public AdminRoutePrice() {
    }

    public AdminRoutePrice(int routeId, int busTypeId, BigDecimal price) {
        this.routeId = routeId;
        this.busTypeId = busTypeId;
        this.price = price;
    }

    
    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public int getBusTypeId() {
        return busTypeId;
    }

    public void setBusTypeId(int busTypeId) {
        this.busTypeId = busTypeId;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    
}
