/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminStat {
    private String stat_date;
    private String route_name;
    private int tickets_sold;
    private double revenue;
    private double occupancy_rate;

    public AdminStat(String stat_date, String route_name, int tickets_sold, double revenue, double occupancy_rate) {
        this.stat_date = stat_date;
        this.route_name = route_name;
        this.tickets_sold = tickets_sold;
        this.revenue = revenue;
        this.occupancy_rate = occupancy_rate;
    }
    
    public String getStat_date() {
        return stat_date;
    }

    public void setStat_date(String stat_date) {
        this.stat_date = stat_date;
    }

    public String getRoute_name() {
        return route_name;
    }

    public void setRoute_name(String route_name) {
        this.route_name = route_name;
    }

    public int getTickets_sold() {
        return tickets_sold;
    }

    public void setTickets_sold(int tickets_sold) {
        this.tickets_sold = tickets_sold;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }

    public double getOccupancy_rate() {
        return occupancy_rate;
    }

    public void setOccupancy_rate(double occupancy_rate) {
        this.occupancy_rate = occupancy_rate;
    }
    
    
}
