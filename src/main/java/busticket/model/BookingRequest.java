/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class BookingRequest {

    private Tickets ticket;
    private String fullName;
    private String phoneNumber;
    private String email;
    private List<String> seatCodes;

    public BookingRequest() {
    }

    public BookingRequest(Tickets ticket, String fullName, String phoneNumber, String email, List<String> seatCodes) {
        this.ticket = ticket;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.seatCodes = seatCodes;
    }

    public Tickets getTicket() {
        return ticket;
    }

    public void setTicket(Tickets ticket) {
        this.ticket = ticket;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<String> getSeatCodes() {
        return seatCodes;
    }

    public void setSeatCodes(List<String> seatCodes) {
        this.seatCodes = seatCodes;
    }
}
