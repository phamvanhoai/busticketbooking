/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffSupportDriverTripDAO;
import busticket.model.StaffSupportDriverTrip;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        String action = request.getParameter("action");
        String requestIdStr = request.getParameter("requestId");

        if (action != null && requestIdStr != null) {
            int requestId = Integer.parseInt(requestIdStr);
            StaffSupportDriverTripDAO dao = new StaffSupportDriverTripDAO();

            if (action.equals("approve")) {
                dao.updateRequestStatus(requestId, "Approved");
            } else if (action.equals("reject")) {
                dao.updateRequestStatus(requestId, "Rejected");
            }
        }

        // Redirect lại về danh sách
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
