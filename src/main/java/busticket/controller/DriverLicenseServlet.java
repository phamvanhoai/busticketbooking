/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverLicenseDAO;
import busticket.model.DriverLicense;
import busticket.model.DriverLicenseHistory;
import busticket.model.Users;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverLicenseServlet extends HttpServlet {

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
        // Check if the user is a driver; redirect to home if not
        if (!SessionUtil.isDriver(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        HttpSession session = request.getSession(false);
        // Check if the user is an Staff; redirect to home if not
        if (!SessionUtil.isDriver(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }
        
        Users currentUser = (Users) session.getAttribute("currentUser");
        int userId = currentUser.getUser_id(); // Lấy user_id từ session
        DriverLicenseDAO dao = new DriverLicenseDAO();

        try {
            DriverLicense license = dao.getDriverLicenseByUserId(userId);
            if (license != null) {
                request.setAttribute("license", license);
            } else {
                request.setAttribute("error", "No license information found.");
            }
            // Get driver license history
            List<DriverLicenseHistory> historyList = dao.getDriverLicenseHistoryByUserId(userId);
            request.setAttribute("licenseHistory", historyList);
        } catch (SQLException e) {
            request.setAttribute("error", "Error retrieving license information: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/driver/driver-license.jsp").forward(request, response);
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
