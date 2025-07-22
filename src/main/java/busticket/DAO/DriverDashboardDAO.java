/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverDashboardDAO extends DBContext {

    // Lấy tên người dùng từ user_id
    public String getDriverName(int userId) {
        String query = "SELECT user_name FROM Users WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy chuyến đi sắp tới gần nhất của tài xế
    public DriverAssignedTrip getUpcomingTrip(int userId) {
        String query = "SELECT t.trip_id, CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "t.departure_time, CONVERT(varchar(5), t.departure_time, 108) AS trip_time "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.trip_status = 'Scheduled' AND t.departure_time > GETDATE() "
                + "ORDER BY t.departure_time ASC";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DriverAssignedTrip trip = new DriverAssignedTrip();
                    trip.setTripId(rs.getInt("trip_id"));
                    trip.setRoute(rs.getString("route"));
                    trip.setDepartureTime(rs.getTimestamp("departure_time"));
                    trip.setTime(rs.getString("trip_time"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đếm số chuyến đi đã hoàn thành
    public int countCompletedTrips(int userId) {
        String query = "SELECT COUNT(*) AS completed_count "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.trip_status = 'Completed'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("completed_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số yêu cầu thay đổi chuyến đang chờ phê duyệt
    public int countPendingChangeRequests(int userId) {
        String query = "SELECT COUNT(*) AS pending_count "
                + "FROM Driver_Trip_Change_Request r "
                + "JOIN Drivers d ON r.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND r.request_status = 'Pending'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("pending_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm tổng số chuyến đi của tài xế
    public int countTotalTrips(int userId) {
        String query = "SELECT COUNT(*) AS total_count "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số hành khách đã điểm danh (check-in)
    public int countCheckedInPassengers(int userId) {
        String query = "SELECT COUNT(*) AS checked_in_count "
                + "FROM Tickets t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.check_in IS NOT NULL";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("checked_in_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số chuyến đi đang thực hiện
    public int countOngoingTrips(int userId) {
        String query = "SELECT COUNT(*) AS ongoing_count "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.trip_status = 'Ongoing'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ongoing_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số chuyến đi bị hủy
    public int countCancelledTrips(int userId) {
        String query = "SELECT COUNT(*) AS cancelled_count "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.trip_status = 'Cancelled'";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cancelled_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm tổng số vé đã bán
    public int countTotalTicketsSold(int userId) {
        String query = "SELECT COUNT(*) AS ticket_count "
                + "FROM Tickets t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ticket_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tính tỷ lệ yêu cầu thay đổi được phê duyệt
    public double getApprovedChangeRequestRate(int userId) {
        String query = "SELECT COUNT(*) AS approved_count "
                + "FROM Driver_Trip_Change_Request r "
                + "JOIN Drivers d ON r.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND r.request_status = 'Approved'";
        String totalQuery = "SELECT COUNT(*) AS total_count "
                + "FROM Driver_Trip_Change_Request r "
                + "JOIN Drivers d ON r.driver_id = d.driver_id "
                + "WHERE d.user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement psApproved = conn.prepareStatement(query);  PreparedStatement psTotal = conn.prepareStatement(totalQuery)) {
            psApproved.setInt(1, userId);
            psTotal.setInt(1, userId);
            int approvedCount = 0, totalCount = 0;
            try ( ResultSet rsApproved = psApproved.executeQuery()) {
                if (rsApproved.next()) {
                    approvedCount = rsApproved.getInt("approved_count");
                }
            }
            try ( ResultSet rsTotal = psTotal.executeQuery()) {
                if (rsTotal.next()) {
                    totalCount = rsTotal.getInt("total_count");
                }
            }
            return totalCount > 0 ? (double) approvedCount / totalCount * 100 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy số hành khách đã điểm danh theo ngày (7 ngày gần nhất)
    public List<Integer> getCheckedInPassengersByDate(int userId) {
        List<Integer> passengersByDate = new ArrayList<>();
        String query = "SELECT CAST(t.check_in AS DATE) AS check_in_date, COUNT(*) AS passenger_count "
                + "FROM Tickets t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.user_id = ? AND t.check_in IS NOT NULL "
                + "AND t.check_in >= DATEADD(day, -6, GETDATE()) "
                + "GROUP BY CAST(t.check_in AS DATE) "
                + "ORDER BY check_in_date ASC";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                // Khởi tạo mảng 7 ngày với giá trị 0
                for (int i = 0; i < 7; i++) {
                    passengersByDate.add(0);
                }
                while (rs.next()) {
                    java.sql.Date checkInDate = rs.getDate("check_in_date");
                    long daysDiff = (System.currentTimeMillis() - checkInDate.getTime()) / (1000 * 60 * 60 * 24);
                    int index = 6 - (int) daysDiff; // Map ngày vào chỉ số mảng
                    if (index >= 0 && index < 7) {
                        passengersByDate.set(index, rs.getInt("passenger_count"));
                    }
                }
                // Log dữ liệu để kiểm tra
                System.out.println("Checked-In Passengers by Date for userId " + userId + ": " + passengersByDate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return passengersByDate;
    }
}
