/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffReviews;
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
public class StaffReviewsDAO extends DBContext {

    // Lấy danh sách đánh giá (với phân trang)
    public List<StaffReviews> getReviewsForAdmin(int offset, int limit) {
    List<StaffReviews> reviews = new ArrayList<>();
    
    // SQL query to get review information including route
    String query = "SELECT ir.review_id, "
                 + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, " // Adding route information
                 + "ir.invoice_id, i.invoice_code, ir.review_rating, ir.review_text, ir.review_created_at "
                 + "FROM Invoice_Reviews ir "
                 + "JOIN Invoices i ON ir.invoice_id = i.invoice_id "
                 + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                 + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                 + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                 + "JOIN Routes r ON tr.route_id = r.route_id "
                 + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                 + "JOIN Locations le ON r.end_location_id = le.location_id "
                 + "ORDER BY ir.review_created_at DESC "
                 + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";  // Pagination

    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, offset);
        ps.setInt(2, limit);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffReviews review = new StaffReviews();
                review.setReviewId(rs.getInt("review_id"));
                review.setRoute(rs.getString("route"));  // Fetch route info
                review.setInvoiceId(rs.getInt("invoice_id"));
                review.setInvoiceCode(rs.getString("invoice_code"));
                review.setRating(rs.getInt("review_rating"));
                review.setReviewText(rs.getString("review_text"));
                review.setCreatedAt(rs.getTimestamp("review_created_at"));
                reviews.add(review);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return reviews;
}



    // Đếm tổng số đánh giá
    public int getTotalReviewsCount() {
        String query = "SELECT COUNT(*) FROM Invoice_Reviews";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
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
}
