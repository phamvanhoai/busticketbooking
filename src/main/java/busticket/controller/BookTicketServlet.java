/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.BookingDAO;
import busticket.DAO.HomeViewTripsDAO;
import busticket.model.AdminRouteStop;
import busticket.model.AdminSeatPosition;
import busticket.model.BookingRequest;
import busticket.model.HomeTrip;
import busticket.model.Tickets;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class BookTicketServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
// Handling AJAX request: returning seat map data in JSON format
        String ajax = request.getParameter("ajax");
        if ("seats".equals(ajax)) {
            try {
                // Retrieve bus type and trip ID from request parameters
                String busTypeIdStr = request.getParameter("busTypeId");
                String tripIdStr = request.getParameter("tripId");

                // Check if required parameters are missing
                if (busTypeIdStr == null || tripIdStr == null || busTypeIdStr.isEmpty() || tripIdStr.isEmpty()) {
                    response.sendError(400, "Missing busTypeId or tripId parameter");
                    return;
                }

                // Parse busTypeId and tripId to integers
                int busTypeId = Integer.parseInt(busTypeIdStr);
                int tripId = Integer.parseInt(tripIdStr);

                // Create DAO object to interact with the database
                BookingDAO dao = new BookingDAO();

                // Get seat positions for the bus type (down and up sections)
                List<AdminSeatPosition> down = dao.getSeatPositions(busTypeId, "down");
                List<AdminSeatPosition> up = dao.getSeatPositions(busTypeId, "up");

                // Get booked seat numbers for the current trip
                List<String> booked = dao.getBookedSeatNumbers(tripId);

                // Create JSON-like data structure for seats (down and up sections)
                List<java.util.Map<String, Object>> downJson = new ArrayList<>();
                List<java.util.Map<String, Object>> upJson = new ArrayList<>();

                // Process down section seats
                for (AdminSeatPosition s : down) {
                    java.util.Map<String, Object> m = new java.util.HashMap<>();
                    m.put("row", s.getRow());
                    m.put("col", s.getCol());
                    m.put("code", s.getCode());
                    m.put("booked", booked.contains(s.getCode())); // Check if seat is booked
                    downJson.add(m);
                }

                // Process up section seats
                for (AdminSeatPosition s : up) {
                    java.util.Map<String, Object> m = new java.util.HashMap<>();
                    m.put("row", s.getRow());
                    m.put("col", s.getCol());
                    m.put("code", s.getCode());
                    m.put("booked", booked.contains(s.getCode())); // Check if seat is booked
                    upJson.add(m);
                }

                // Prepare the result as a map containing down and up seat data
                java.util.Map<String, Object> result = new java.util.HashMap<>();
                result.put("down", downJson);
                result.put("up", upJson);

                // Set the response content type as JSON and send the data back to the client
                response.setContentType("application/json;charset=UTF-8");
                new com.fasterxml.jackson.databind.ObjectMapper().writeValue(response.getWriter(), result);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(500, "Error loading seat map");
                return;
            }
        }

        // If not an AJAX request → proceed to display the book-ticket page as usual
        String tripIdStr = request.getParameter("tripId");
        if (tripIdStr == null || tripIdStr.isEmpty()) {
            // Redirect to view trips if tripId is not provided
            response.sendRedirect("view-trips");
            return;
        }

        try {
            int tripId = Integer.parseInt(tripIdStr);

            // Create DAO object to interact with the database
            BookingDAO dao = new BookingDAO();

            // Get trip details based on tripId
            HomeTrip trip = dao.getTripById(tripId);
            System.out.println("🔍 trip = " + trip);
            System.out.println("🔍 trip.getBusTypeId() = " + trip.getBusTypeId());

            if (trip == null) {
                response.sendRedirect("view-trips");
                return;
            }

            // Get the list of booked seats and route stops for the trip
            List<String> bookedSeats = dao.getBookedSeatNumbers(tripId);
            List<AdminRouteStop> stops = dao.getRouteStopsForTrip(tripId);

            // Calculate stop times based on route stops
            List<String> stopTimes = new ArrayList<>();
            java.time.LocalTime departureTime = java.time.LocalTime.parse(trip.getTripTime());
            int totalMinutes = 0;
            for (AdminRouteStop stop : stops) {
                Integer travel = stop.getTravelMinutes();
                Integer dwell = stop.getDwellMinutes();
                int travelMinutes = (travel != null) ? travel : 0;
                int dwellMinutes = (dwell != null) ? dwell : 0;

                totalMinutes += travelMinutes + dwellMinutes;
                stopTimes.add(departureTime.plusMinutes(totalMinutes).toString().substring(0, 5));
            }

            // Set trip and other attributes in request
            request.setAttribute("trip", trip);
            request.setAttribute("selectedSeats", bookedSeats);
            request.setAttribute("routeStops", stops);
            request.setAttribute("stopTimes", stopTimes); // Add stopTimes attribute
            // Forward the request to book-ticket.jsp to render the booking page
            request.getRequestDispatcher("/WEB-INF/pages/ticket-management/book-ticket.jsp").forward(request, response);
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("view-trips");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("prepare-payment".equals(action)) {

                int tripId = Integer.parseInt(request.getParameter("tripId"));
                String selectedSeatsStr = request.getParameter("selectedSeats");

                if (selectedSeatsStr == null || selectedSeatsStr.trim().isEmpty()) {
                    request.getSession().setAttribute("toast", "Please select seats before proceeding with payment.");
                    response.sendRedirect(request.getContextPath() + "/book-ticket?tripId=" + tripId);
                    return;
                }

                String[] seatArray = selectedSeatsStr.split(",");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phoneNumber");
                String email = request.getParameter("email");
                int pickupLocationId = Integer.parseInt(request.getParameter("pickupLocationId"));
                int dropoffLocationId = Integer.parseInt(request.getParameter("dropoffLocationId"));

                BookingDAO dao = new BookingDAO();
                HomeTrip trip = dao.getTripById(tripId);
                String pickupLocationName = dao.getLocationNameById(pickupLocationId);
                String dropoffLocationName = dao.getLocationNameById(dropoffLocationId);

                Tickets tempTicket = new Tickets();
                tempTicket.setTripId(tripId);
                tempTicket.setPickupLocationId(pickupLocationId);
                tempTicket.setDropoffLocationId(dropoffLocationId);
                tempTicket.setTicketCode(dao.generateTicketCode());

                BookingRequest booking = new BookingRequest();
                booking.setTicket(tempTicket);
                booking.setFullName(fullName);
                booking.setPhoneNumber(phone);
                booking.setEmail(email);
                booking.setSeatCodes(Arrays.asList(seatArray));

                long now = System.currentTimeMillis();
                long expiryTime = now + (20 * 60 * 1000);

                request.setAttribute("booking", booking);
                request.setAttribute("trip", trip);
                request.setAttribute("pickupLocationName", pickupLocationName);
                request.setAttribute("dropoffLocationName", dropoffLocationName);
                request.setAttribute("totalAmount", trip.getPrice().multiply(new BigDecimal(seatArray.length)));
                request.setAttribute("now", now);
                request.setAttribute("expiryTime", expiryTime);
                request.setAttribute("selectedSeatsString", selectedSeatsStr);

                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/booking-payment.jsp").forward(request, response);
                return;
            }

            if ("confirm-payment".equals(action)) {

                int tripId = Integer.parseInt(request.getParameter("tripId"));
                String selectedSeatsStr = request.getParameter("selectedSeats");

                if (selectedSeatsStr == null || selectedSeatsStr.trim().isEmpty()) {
                    request.getSession().setAttribute("toast", "Seat selection missing.");
                    response.sendRedirect(request.getContextPath() + "/view-trips");
                    return;
                }

                String[] seatArray = selectedSeatsStr.split(",");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phoneNumber");
                String email = request.getParameter("email");
                int pickupLocationId = Integer.parseInt(request.getParameter("pickupLocationId"));
                int dropoffLocationId = Integer.parseInt(request.getParameter("dropoffLocationId"));

                BookingDAO dao = new BookingDAO();
                HomeTrip trip = dao.getTripById(tripId);
                String pickupLocationName = dao.getLocationNameById(pickupLocationId);
                String dropoffLocationName = dao.getLocationNameById(dropoffLocationId);

                Tickets ticket = new Tickets();
                ticket.setTripId(tripId);
                ticket.setUserId(0); // Chưa login
                ticket.setTicketStatus("Booked");
                ticket.setPickupLocationId(pickupLocationId);
                ticket.setDropoffLocationId(dropoffLocationId);
                ticket.setCheckIn(null);
                ticket.setCheckOut(null);
                ticket.setTicketCode(dao.generateTicketCode());

                BookingRequest booking = new BookingRequest();
                booking.setTicket(ticket);
                booking.setFullName(fullName);
                booking.setPhoneNumber(phone);
                booking.setEmail(email);
                booking.setSeatCodes(Arrays.asList(seatArray));

                int ticketId = dao.insertTicket(ticket);
                dao.insertTicketSeats(ticketId, booking.getSeatCodes());

                long now = System.currentTimeMillis();
                long expiryTime = now + (20 * 60 * 1000);

                request.setAttribute("booking", booking);
                request.setAttribute("trip", trip);
                request.setAttribute("pickupLocationName", pickupLocationName);
                request.setAttribute("dropoffLocationName", dropoffLocationName);
                request.setAttribute("totalAmount", trip.getPrice().multiply(new BigDecimal(seatArray.length)));
                request.setAttribute("now", now);
                request.setAttribute("expiryTime", expiryTime);

                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/booking-payment.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/view-trips");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("toast", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/ticket-management/book-ticket.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
