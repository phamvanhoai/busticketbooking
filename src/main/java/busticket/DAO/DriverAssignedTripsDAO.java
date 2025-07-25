/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverPassenger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverAssignedTripsDAO extends DBContext {

    // Get the trips assigned to the driver
    public List<DriverAssignedTrip> getAssignedTrips(int driverId, String route, String status, String date, int offset, int limit) {
        List<DriverAssignedTrip> trips = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT t.trip_id, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "CAST(t.departure_time AS date) AS trip_date, "
                + "CONVERT(varchar(5), t.departure_time, 108) AS trip_time, "
                + "bt.bus_type_name AS bus_type, "
                + "u.user_name AS driver, "
                + "t.bus_id, "
                + "t.trip_status AS status, "
                + "t.departure_time " // Thêm departure_time
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON t.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE u.user_id = ? "
        );

        if (route != null && !route.isEmpty()) {
            query.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            query.append(" AND t.trip_status LIKE ?");
        }
        if (date != null && !date.isEmpty()) {
            query.append(" AND CAST(t.departure_time AS date) = ?");
        }

        query.append(" ORDER BY t.trip_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query.toString())) {
            int idx = 1;
            ps.setInt(idx++, driverId);

            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, "%" + status + "%");
            }
            if (date != null && !date.isEmpty()) {
                ps.setString(idx++, date);
            }

            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DriverAssignedTrip trip = new DriverAssignedTrip();
                    trip.setTripId(rs.getInt("trip_id"));
                    trip.setRoute(rs.getString("route"));
                    trip.setDate(rs.getDate("trip_date"));
                    trip.setTime(rs.getString("trip_time"));
                    trip.setBusType(rs.getString("bus_type"));
                    trip.setDriver(rs.getString("driver"));
                    trip.setBusId(rs.getInt("bus_id"));
                    trip.setStatus(rs.getString("status"));
                    trip.setDepartureTime(rs.getTimestamp("departure_time")); // Gán departure_time
                    trips.add(trip);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    public int getTotalAssignedTripsCount(int driverId, String route, String status, String date) {
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON t.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE u.user_id = ? "
        );

        // Apply filters
        if (route != null && !route.isEmpty()) {
            query.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            query.append(" AND t.trip_status LIKE ?");
        }
        if (date != null && !date.isEmpty()) {
            query.append(" AND CAST(t.departure_time AS date) = ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query.toString())) {
            int idx = 1;
            ps.setInt(idx++, driverId); // Set driverId

            // Apply filters to prepared statement
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, "%" + status + "%");
            }
            if (date != null && !date.isEmpty()) {
                ps.setString(idx++, date);  // Set date filter
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    //get location name for admin trip filter
    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT location_name FROM Locations";

        try ( PreparedStatement ps = getConnection().prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                locations.add(rs.getString("location_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return locations;
    }

    // Get passengers for a specific trip
    // Get passengers for a specific trip
    public List<DriverPassenger> getPassengers(int tripId) {
        List<DriverPassenger> passengers = new ArrayList<>();
        // Cập nhật truy vấn để kết hợp thông tin từ các bảng Tickets, Invoice_Items, Invoices, Locations
        String query = "SELECT ts.seat_number, "
                + "       i.invoice_full_name, "
                + "       i.invoice_phone, "
                + "       ls.location_name AS pickup_location, "
                + "       le.location_name AS dropoff_location, "
                + "       t.check_in, "
                + "       t.check_out, "
                + "       t.ticket_id " // Lấy ticket_id từ bảng Tickets
                + "FROM Ticket_Seat ts "
                + "JOIN Tickets t ON ts.ticket_id = t.ticket_id "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Locations ls ON t.pickup_location_id = ls.location_id "
                + "JOIN Locations le ON t.dropoff_location_id = le.location_id "
                + "WHERE td.trip_id = ?";  // Lọc hành khách theo trip_id

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tripId);  // Truyền tripId vào truy vấn

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DriverPassenger passenger = new DriverPassenger();
                    passenger.setSeat(rs.getString("seat_number"));
                    passenger.setName(rs.getString("invoice_full_name"));  // Lấy tên khách hàng từ bảng Invoices
                    passenger.setPhone(rs.getString("invoice_phone")); // Lấy số điện thoại khách hàng từ bảng Invoices
                    passenger.setPickupLocation(rs.getString("pickup_location"));  // Lấy tên địa điểm từ bảng Locations
                    passenger.setDropoffLocation(rs.getString("dropoff_location")); // Lấy tên địa điểm từ bảng Locations
                    passenger.setCheckInTime(rs.getTimestamp("check_in"));
                    passenger.setCheckOutTime(rs.getTimestamp("check_out"));
                    passenger.setTicketId(rs.getInt("ticket_id")); // Lấy ticket_id từ bảng Tickets
                    passengers.add(passenger);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return passengers;
    }

// Cập nhật trạng thái check-in trong bảng Ticket
    public void updateCheckInStatus(int ticketId, Timestamp checkInTime) {
        String query = "UPDATE Tickets SET check_in = ? WHERE ticket_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            if (checkInTime != null) {
                ps.setTimestamp(1, checkInTime);
            } else {
                ps.setNull(1, java.sql.Types.TIMESTAMP);
            }
            ps.setInt(2, ticketId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateCheckOutStatusWithCheckInValidation(int ticketId, Timestamp checkOutTime) {
        if (checkOutTime != null) {
            String checkQuery = "SELECT check_in FROM Tickets WHERE ticket_id = ?";
            try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                ps.setInt(1, ticketId);
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getTimestamp("check_in") == null) {
                        return false; // Không cập nhật nếu check_in là NULL
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        String query = "UPDATE Tickets SET check_out = ? WHERE ticket_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            if (checkOutTime != null) {
                ps.setTimestamp(1, checkOutTime);
            } else {
                ps.setNull(1, java.sql.Types.TIMESTAMP);
            }
            ps.setInt(2, ticketId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCheckStatus(int ticketId, Timestamp checkInTime, Timestamp checkOutTime) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            if (checkOutTime != null && checkInTime == null) {
                String checkQuery = "SELECT check_in FROM Tickets WHERE ticket_id = ?";
                try ( PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                    ps.setInt(1, ticketId);
                    try ( ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getTimestamp("check_in") == null) {
                            return false;
                        }
                    }
                }
            }

            String query = "UPDATE Tickets SET check_in = ?, check_out = ? WHERE ticket_id = ?";
            try ( PreparedStatement ps = conn.prepareStatement(query)) {
                if (checkInTime != null) {
                    ps.setTimestamp(1, checkInTime);
                } else {
                    ps.setNull(1, java.sql.Types.TIMESTAMP);
                }
                if (checkOutTime != null) {
                    ps.setTimestamp(2, checkOutTime);
                } else {
                    ps.setNull(2, java.sql.Types.TIMESTAMP);
                }
                ps.setInt(3, ticketId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public String getTripStatus(int tripId) {
        String query = "SELECT trip_status FROM Trips WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("trip_status");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTripStatus(int tripId, String status) {
        String query = "UPDATE Trips SET trip_status = ? WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, tripId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating trip status: tripId=" + tripId + ", status=" + status + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasOngoingTrip(int driverId) {
        String query = "SELECT COUNT(*) "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE u.user_id = ? AND t.trip_status = 'Ongoing'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking ongoing trips: driverId=" + driverId + ", error=" + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
