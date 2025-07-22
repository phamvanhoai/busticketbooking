/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverDashboardDAO;
import busticket.model.DriverAssignedTrip;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverDashboardServlet extends HttpServlet {

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
        // Kiểm tra xem người dùng có phải là tài xế không
        if (!SessionUtil.isDriver(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        // Lấy user_id từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = ((busticket.model.Users) session.getAttribute("currentUser")).getUser_id();
        DriverDashboardDAO dao = new DriverDashboardDAO();

        // Lấy thông tin thống kê
        String driverName = dao.getDriverName(userId);
        DriverAssignedTrip upcomingTrip = dao.getUpcomingTrip(userId);
        int completedTrips = dao.countCompletedTrips(userId);
        int totalTrips = dao.countTotalTrips(userId);
        int pendingChangeRequests = dao.countPendingChangeRequests(userId);
        int checkedInPassengers = dao.countCheckedInPassengers(userId);
        int ongoingTrips = dao.countOngoingTrips(userId);
        int cancelledTrips = dao.countCancelledTrips(userId);
        int totalTicketsSold = dao.countTotalTicketsSold(userId);
        double approvedChangeRequestRate = dao.getApprovedChangeRequestRate(userId);
        List<Integer> checkedInPassengersByDate = dao.getCheckedInPassengersByDate(userId);

        // Tính tỷ lệ hoàn thành chuyến đi
        double completionRate = totalTrips > 0 ? (double) completedTrips / totalTrips * 100 : 0;

        // Tạo danh sách nhãn ngày (7 ngày gần nhất, định dạng MM-dd)
        List<String> dateLabels = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd");
        long currentTime = System.currentTimeMillis();
        for (int i = 6; i >= 0; i--) {
            Date date = new Date(currentTime - i * 24 * 60 * 60 * 1000L);
            dateLabels.add(sdf.format(date));
        }

        // Đặt các thuộc tính vào request
        request.setAttribute("driverName", driverName != null ? driverName : "Unknown Driver");
        request.setAttribute("upcomingTrip", upcomingTrip);
        request.setAttribute("completedTrips", completedTrips);
        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("pendingChangeRequests", pendingChangeRequests);
        request.setAttribute("checkedInPassengers", checkedInPassengers);
        request.setAttribute("ongoingTrips", ongoingTrips);
        request.setAttribute("cancelledTrips", cancelledTrips);
        request.setAttribute("totalTicketsSold", totalTicketsSold);
        request.setAttribute("approvedChangeRequestRate", String.format("%.1f", approvedChangeRequestRate));
        request.setAttribute("checkedInPassengersByDate", checkedInPassengersByDate);
        request.setAttribute("dateLabels", dateLabels);

        // Chuyển tiếp tới JSP
        request.getRequestDispatcher("/WEB-INF/driver/driver-dashboard.jsp").forward(request, response);
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
