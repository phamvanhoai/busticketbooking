/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffSupportDriverTripDAO;
import busticket.model.StaffSupportDriverTrip;
import busticket.model.Users;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffSupportDriverTripServlet extends HttpServlet {

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
        // Check if the user is an Staff; redirect to home if not
        if (!SessionUtil.isStaff(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }
        // Pagination setup
        int requestsPerPage = 10;
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * requestsPerPage;

// DAO
        StaffSupportDriverTripDAO dao = new StaffSupportDriverTripDAO();
        List<StaffSupportDriverTrip> driverRequests = dao.getDriverCancelTripRequests(offset, requestsPerPage);
        int totalRequests = dao.countDriverCancelTripRequests();
        int totalPages = (int) Math.ceil((double) totalRequests / requestsPerPage);

// Set attributes
        request.setAttribute("driverRequests", driverRequests);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

// Forward to JSP
        request.getRequestDispatcher("/WEB-INF/staff/support-driver-trip/driver-trip.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isStaff(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null) {
            session.setAttribute("error", "Please log in to access this page.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String requestIdStr = request.getParameter("requestId");

        if (action != null && requestIdStr != null) {
            try {
                int requestId = Integer.parseInt(requestIdStr);
                int staffId = currentUser.getUser_id();
                StaffSupportDriverTripDAO dao = new StaffSupportDriverTripDAO();

                boolean success;
                if (action.equals("approve")) {
                    success = dao.updateRequestAndTripStatus(requestId, "Approved", "Cancelled", staffId);
                } else if (action.equals("reject")) {
                    success = dao.updateRequestAndTripStatus(requestId, "Rejected", "Scheduled", staffId);
                } else {
                    session.setAttribute("error", "Invalid action.");
                    response.sendRedirect(request.getContextPath() + "/staff/support-driver-trip");
                    return;
                }

                if (success) {
                    session.setAttribute("success", "Request " + action + " successfully!");
                } else {
                    session.setAttribute("error", "Failed to " + action + " request.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid request ID.");
            }
        } else {
            session.setAttribute("error", "Missing action or request ID.");
        }

        response.sendRedirect(request.getContextPath() + "/staff/support-driver-trip");
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
