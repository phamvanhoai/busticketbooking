/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffRoute {

    private int routeId;
    private String routeName;

    public StaffRoute() {
    }

    public StaffRoute(int routeId, String routeName) {
        this.routeId = routeId;
        this.routeName = routeName;
    }
    
    

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }
}
