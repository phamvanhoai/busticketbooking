/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffSupportCustomerTripDAO;
import busticket.model.StaffSupportCustomerTrip;
import busticket.model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

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
        StaffSupportCustomerTripDAO staffSupportCustomerTripDAO = new StaffSupportCustomerTripDAO();
        // *** Read filter & search parameters ***
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "All";
        }

        // *** Pagination parameters ***
        int currentPage = 1;
        final int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
            }
        }
        int offset = (currentPage - 1) * pageSize;

        // *** Fetch data from DAO ***
        List<StaffSupportCustomerTrip> list = staffSupportCustomerTripDAO.getRequests(search, status, offset, pageSize);
        int total = staffSupportCustomerTripDAO.getTotalCount(search, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // *** Set attributes for JSP ***
        request.setAttribute("requests", list);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // *** Forward to JSP ***
        request.getRequestDispatcher("/WEB-INF/staff/support-customer-trip/customer-trip.jsp")
                .forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        StaffSupportCustomerTripDAO staffSupportCustomerTripDAO = new StaffSupportCustomerTripDAO();
        // Lấy action + requestId
        String action = request.getParameter("action");      // "approve" or "reject"
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        // Lấy user từ session
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        busticket.model.Users currentUser = (busticket.model.Users) session.getAttribute("currentUser");
        if (currentUser == null || !"Staff".equals(currentUser.getRole())|| !"Admin".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Lấy userId từ object Users
        int staffId = currentUser.getUser_id();

        // Xác định status mới và gọi DAO
        String newStatus = "approve".equals(action) ? "Approved" : "Rejected";
        staffSupportCustomerTripDAO.updateStatus(requestId, newStatus, staffId);

        // Lấy lại filter + paging để redirect
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String page = request.getParameter("page");
        if (search == null) {
            search = "";
        }
        if (status == null || status.isEmpty()) {
            status = "All";
        }
        if (page == null) {
            page = "1";
        }

        String redirectUrl = request.getContextPath()
                + "/staff/support-invoice-cancel?search="
                + URLEncoder.encode(search, "UTF-8")
                + "&status=" + URLEncoder.encode(status, "UTF-8")
                + "&page=" + URLEncoder.encode(page, "UTF-8");

        response.sendRedirect(response.encodeRedirectURL(redirectUrl));
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
