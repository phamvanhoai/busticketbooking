/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.BookingDAO;
import busticket.model.Tickets;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffManageBookingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final BookingDAO dao = new BookingDAO();

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
        // Retrieve all bookings
        List<Tickets> all = dao.getAllBookings();

        // Read search and status parameters
        String q = request.getParameter("q");
        String status = request.getParameter("status");

        // Filter in-memory
        List<Tickets> filtered = new ArrayList<>();
        for (Tickets b : all) {
            boolean matchesSearch = (q == null || q.isEmpty())
                    || b.getTicketId().toLowerCase().contains(q.toLowerCase())
                    || b.getUserName().toLowerCase().contains(q.toLowerCase());
            boolean matchesStatus = (status == null || status.isEmpty())
                    || b.getPaymentStatus().equalsIgnoreCase(status);

            if (matchesSearch && matchesStatus) {
                filtered.add(b);
            }
        }

        // Set attributes for JSP
        request.setAttribute("bookings", filtered);
        request.setAttribute("q", q);
        request.setAttribute("status", status);

        // Forward to JSP view
        request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/manage-bookings.jsp")
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
        // Read form parameters
        String q = request.getParameter("q");
        String status = request.getParameter("status");

        // Build redirect URL including parameters
        String redirectUrl = request.getContextPath() + "/staff/manage-bookings";
        boolean hasQuery = false;
        if (q != null && !q.isEmpty()) {
            redirectUrl += "?q=" + q;
            hasQuery = true;
        }
        if (status != null && !status.isEmpty()) {
            redirectUrl += hasQuery ? "&" : "?";
            redirectUrl += "status=" + status;
        }

        // Redirect to GET handler
        response.sendRedirect(redirectUrl);
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
