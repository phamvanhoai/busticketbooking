/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminRouteStop;
import busticket.model.AdminSeatPosition;
import busticket.model.HomeTrip;
import busticket.model.StaffTicket;
import busticket.model.Tickets;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class BookingDAO extends DBContext {

    /**
     * Generates a random invoice code using UUID. The generated code is a
     * unique identifier for the invoice, in the format: "INV-XXXXXXX".
     *
     * @return a randomly generated invoice code.
     */
    public String generateInvoiceCode() {
        return "INV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    /**
     * Inserts a new invoice record into the Invoices table.
     *
     * @param userId the ID of the user associated with the invoice (0 for
     * guest).
     * @param totalAmount the total amount of the invoice.
     * @param paymentMethod the payment method used (e.g., "FPTUPay").
     * @return the generated invoice ID.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public int insertInvoice(Integer userId, BigDecimal totalAmount, String paymentMethod, String fullName, String email, String phone) throws SQLException {
        String sql = "INSERT INTO Invoices (user_id, invoice_total_amount, payment_method, paid_at, invoice_code, invoice_status, invoice_full_name, invoice_email, invoice_phone) "
                + "VALUES (?, ?, ?, GETDATE(), ?, 'Paid', ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (userId == null) {
                ps.setNull(1, java.sql.Types.INTEGER); // Set user_id to NULL for guest bookings
            } else {
                ps.setInt(1, userId);
            }
            ps.setBigDecimal(2, totalAmount);
            ps.setString(3, paymentMethod);
            ps.setString(4, generateInvoiceCode());
            ps.setString(5, fullName);  // Add fullName
            ps.setString(6, email);     // Add email
            ps.setString(7, phone);     // Add phone
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Return the invoice ID
            } else {
                throw new SQLException("Could not generate a new invoice.");
            }
        }
    }

    /**
     * Inserts an invoice item into the Invoice_Items table, linking a ticket to
     * an invoice.
     *
     * @param invoiceId the ID of the invoice.
     * @param ticketId the ID of the ticket.
     * @param amount the amount for this ticket.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public void insertInvoiceItem(int invoiceId, int ticketId, BigDecimal amount) throws SQLException {
        String sql = "INSERT INTO Invoice_Items (invoice_id, ticket_id, invoice_amount) VALUES (?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, ticketId);
            ps.setBigDecimal(3, amount);
            ps.executeUpdate();
        }
    }

    /**
     * Generates a random ticket code using UUID. The generated code is a unique
     * identifier for the ticket, in the format: "TKT-XXXXXXX".
     *
     * @return a randomly generated ticket code.
     */
    public String generateTicketCode() {
        return "TKT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    /**
     * Inserts a new ticket record into the Tickets table. The method takes a
     * Tickets object as a parameter and inserts the ticket data into the
     * database.
     *
     * @param ticket the ticket object containing ticket details to be inserted
     * into the database.
     * @return the generated ticket ID from the database after insertion.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public int insertTicket(Tickets ticket) throws SQLException {
        String sql = "INSERT INTO Tickets (trip_id, user_id, ticket_status, ticket_code, pickup_location_id, dropoff_location_id, check_in, check_out) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, ticket.getTripId());
            ps.setInt(2, ticket.getUserId());
            ps.setString(3, ticket.getTicketStatus());
            ps.setString(4, ticket.getTicketCode());
            ps.setInt(5, ticket.getPickupLocationId());
            ps.setInt(6, ticket.getDropoffLocationId());
            ps.setTimestamp(7, ticket.getCheckIn());
            ps.setTimestamp(8, ticket.getCheckOut());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Return the ticket ID of the newly created ticket
            } else {
                throw new SQLException("Could not generate a new ticket.");
            }
        }
    }

    /**
     * Inserts the selected seat numbers for a specific ticket into the
     * Ticket_Seat table. The method adds multiple seat codes associated with a
     * specific ticket to the database.
     *
     * @param ticketId the ID of the ticket for which the seats are being
     * reserved.
     * @param seatCodes a list of seat codes to be inserted for the ticket.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public void insertTicketSeats(int ticketId, List<String> seatCodes) throws SQLException {
        String sql = "INSERT INTO Ticket_Seat (ticket_id, seat_number) VALUES (?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String code : seatCodes) {
                ps.setInt(1, ticketId);
                ps.setString(2, code.trim());
                ps.addBatch(); // Add the seat to the batch
            }
            ps.executeBatch(); // Execute all the insertions at once
        }
    }

    /**
     * Retrieves a list of booked seats for a specific trip. The method queries
     * the database to get all seats that have been booked for a given trip.
     *
     * @param tripId the ID of the trip for which booked seats are being
     * retrieved.
     * @return a list of seat numbers that have been booked for the trip.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public List<String> getBookedSeatNumbers(int tripId) throws SQLException {
        String sql = "SELECT ts.seat_number FROM Ticket_Seat ts "
                + "JOIN Tickets t ON ts.ticket_id = t.ticket_id "
                + "WHERE t.trip_id = ? AND t.ticket_status = 'Booked'";
        List<String> booked = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    booked.add(rs.getString("seat_number"));
                }
            }
        }
        return booked;
    }

    /**
     * Checks if a specific seat is already booked for a given trip. This method
     * is used to validate if a seat is available before booking.
     *
     * @param tripId the ID of the trip where the seat availability is being
     * checked.
     * @param seatCode the seat code to check if it is booked for the trip.
     * @return true if the seat is booked, false if it is available.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public boolean isSeatBooked(int tripId, String seatCode) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Ticket_Seat ts "
                + "JOIN Tickets t ON ts.ticket_id = t.ticket_id "
                + "WHERE t.trip_id = ? AND ts.seat_number = ? AND t.ticket_status = 'Booked'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.setString(2, seatCode);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // If count > 0, the seat is booked
                }
            }
        }
        return false; // If the seat is not booked
    }

    /**
     * Calculates the remaining number of seats for a specific trip. It
     * subtracts the number of booked seats from the total bus capacity to get
     * the remaining seats.
     *
     * @param tripId the ID of the trip for which the remaining seat count is
     * being calculated.
     * @param totalCapacity the total seat capacity of the bus.
     * @return the number of remaining available seats for the trip.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public int getRemainingSeats(int tripId, int totalCapacity) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t WHERE t.trip_id = ? AND t.ticket_status = 'Booked'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int booked = rs.getInt(1);
                    return totalCapacity - booked; // Calculate remaining seats
                }
            }
        }
        return totalCapacity; // If no seats are booked, all are available
    }

    /**
     * Retrieves detailed information for a specific trip by its ID. The method
     * fetches details such as trip origin, destination, departure time, price,
     * and bus information.
     *
     * @param tripId the ID of the trip to retrieve details for.
     * @return a HomeTrip object containing the details of the trip, or null if
     * the trip is not found.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public HomeTrip getTripById(int tripId) throws SQLException {
        String sql = "SELECT "
                + "  t.trip_id, ls.location_name AS origin, le.location_name AS destination, "
                + "  CAST(t.departure_time AS date) AS tripDate, "
                + "  CONVERT(varchar(5), t.departure_time, 108) AS tripTime, "
                + "  bt.bus_type_id, bt.rowsDown, bt.colsDown, bt.rowsUp, bt.colsUp, "
                + "  bt.bus_type_name AS busType, b.capacity, "
                + "  (SELECT COUNT(*) FROM Tickets tk WHERE tk.trip_id = t.trip_id AND tk.ticket_status = 'Booked') AS bookedSeats, "
                + "  (SELECT SUM(rs.travel_minutes + rs.route_stop_dwell_minutes) FROM Route_Stops rs WHERE rs.route_id = t.route_id) AS durationMinutes, "
                + "  (SELECT TOP 1 rp.route_price FROM Route_Prices rp "
                + "     WHERE rp.route_id = t.route_id AND rp.bus_type_id = b.bus_type_id "
                + "     AND rp.route_price_effective_from <= CAST(t.departure_time AS date) "
                + "     ORDER BY rp.route_price_effective_from DESC) AS price "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON t.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "WHERE t.trip_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Retrieve and process the trip details
                    // Calculate the arrival time based on the departure time and duration
                    java.time.LocalTime dep = java.time.LocalTime.parse(rs.getString("tripTime"));
                    String arrival = dep.plusMinutes(rs.getInt("durationMinutes")).toString().substring(0, 5);

                    HomeTrip trip = new HomeTrip(
                            tripId, rs.getString("origin"), rs.getString("destination"),
                            rs.getDate("tripDate"), rs.getString("tripTime"),
                            rs.getInt("durationMinutes"), arrival, rs.getString("busType"),
                            rs.getInt("capacity"), rs.getInt("bookedSeats"), rs.getBigDecimal("price")
                    );
                    trip.setBusTypeId(rs.getInt("bus_type_id"));
                    trip.setRowsDown(rs.getInt("rowsDown"));
                    trip.setColsDown(rs.getInt("colsDown"));
                    trip.setRowsUp(rs.getInt("rowsUp"));
                    trip.setColsUp(rs.getInt("colsUp"));
                    return trip;
                }
            }
        }
        return null; // Return null if no trip is found
    }

    /**
     * Retrieves the route stops for a specific trip. It returns a list of stops
     * with their associated details such as location name, address, and stop
     * times.
     *
     * @param tripId the ID of the trip for which the route stops are being
     * retrieved.
     * @return a list of AdminRouteStop objects representing the route stops for
     * the trip.
     */
    public List<AdminRouteStop> getRouteStopsForTrip(int tripId) {
        List<AdminRouteStop> routeStops = new ArrayList<>();
        String sql = "SELECT rs.route_id, rs.route_stop_number, rs.location_id, ls.location_name, "
                + "rs.route_stop_dwell_minutes, rs.travel_minutes, l.address "
                + "FROM Route_Stops rs "
                + "JOIN Locations ls ON rs.location_id = ls.location_id "
                + "JOIN Routes r ON rs.route_id = r.route_id "
                + "JOIN Locations l ON rs.location_id = l.location_id "
                + "WHERE rs.route_id = (SELECT route_id FROM Trips WHERE trip_id = ?) "
                + "ORDER BY rs.route_stop_number";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRouteStop stop = new AdminRouteStop();
                    stop.setRouteId(rs.getInt("route_id"));
                    stop.setStopNumber(rs.getInt("route_stop_number"));
                    stop.setLocationId(rs.getInt("location_id"));
                    stop.setLocationName(rs.getString("location_name"));
                    stop.setDwellMinutes(rs.getInt("route_stop_dwell_minutes"));
                    stop.setTravelMinutes(rs.getInt("travel_minutes"));
                    stop.setAddress(rs.getString("address"));

                    routeStops.add(stop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving route stops", e);
        }

        return routeStops;
    }

    /**
     * Retrieves seat positions based on the bus type and seating zone. The
     * method returns a list of seat positions for a given bus type and zone.
     *
     * @param busTypeId the ID of the bus type for which the seat positions are
     * being retrieved.
     * @param zone the seating zone for which seat positions are being queried
     * (e.g., "Up", "Down").
     * @return a list of AdminSeatPosition objects representing the seat
     * positions.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public List<AdminSeatPosition> getSeatPositions(int busTypeId, String zone) throws SQLException {
        List<AdminSeatPosition> seats = new ArrayList<>();
        String sql = "SELECT bus_type_id, bus_type_seat_template_zone AS zone, "
                + "bus_type_seat_template_row AS row, "
                + "bus_type_seat_template_col AS col, "
                + "bus_type_seat_code AS code "
                + "FROM Bus_Type_Seat_Template "
                + "WHERE bus_type_id = ? AND bus_type_seat_template_zone = ? "
                + "ORDER BY bus_type_seat_template_order";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            ps.setString(2, zone);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminSeatPosition seat = new AdminSeatPosition(
                            rs.getInt("bus_type_id"),
                            rs.getString("zone"),
                            rs.getInt("row"),
                            rs.getInt("col"),
                            rs.getString("code")
                    );
                    seats.add(seat);
                }
            }
        }
        return seats;
    }

    /**
     * Retrieves the location name for a given location ID. This method queries
     * the Location table to fetch the name of the location based on its ID.
     *
     * @param locationId the ID of the location for which the name is being
     * retrieved.
     * @return the name of the location, or "N/A" if the location is not found.
     * @throws SQLException if an error occurs during the SQL operation.
     */
    public String getLocationNameById(int locationId) throws SQLException {
        String sql = "SELECT location_name FROM Locations WHERE location_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("location_name");
            }
        }
        return "N/A"; // Return "N/A" if location is not found
    }
}
