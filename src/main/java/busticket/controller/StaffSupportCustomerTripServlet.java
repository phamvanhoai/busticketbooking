/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffSupportCustomerTripDAO;
import busticket.db.DBContext;
import busticket.model.StaffSupportCustomerTrip;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffSupportCustomerTripServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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

        try {
            // 1️⃣ Kết nối DB
            Connection conn = new DBContext().getConnection();  // sửa chỗ này nè

            // 2️⃣ Khởi tạo DAO
            StaffSupportCustomerTripDAO dao = new StaffSupportCustomerTripDAO(conn);

            // 3️⃣ Lấy list yêu cầu đổi chuyến
            List<StaffSupportCustomerTrip> listRequest = dao.getAllRequests();

            // 4️⃣ Gán lên request
            request.setAttribute("listRequest", listRequest);

            // 5️⃣ Forward qua JSP
            request.getRequestDispatcher("/WEB-INF/staff/support-customer-trip/customer-trip.jsp")
                    .forward(request, response);

            // 6️⃣ Close connection (nếu cần)=
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi load dữ liệu!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // tạm gọi lại doGet cho đơn giản
    }

    @Override
    public String getServletInfo() {
        return "Staff Support Change Trip Servlet";
    }

}
