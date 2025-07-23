/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffIncidentsDAO;
import busticket.model.DriverIncidents;
import busticket.model.Users;
import busticket.util.SessionUtil;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffIncidentsServlet extends HttpServlet {


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
        

        StaffIncidentsDAO staffIncidentsDAO = new StaffIncidentsDAO();

        // Handle success/error messages
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }
        StaffIncidentsDAO dao = new StaffIncidentsDAO();
        request.setAttribute("staffDAO", dao); // Truyền DAO vào request scope
        
        // Handle detail view
        String detailId = request.getParameter("detail");
        if (detailId != null) {
            try {
                int incidentId = Integer.parseInt(detailId);
                DriverIncidents incident = staffIncidentsDAO.getIncidentById(incidentId);
                if (incident == null) {
                    session.setAttribute("error", "Incident not found.");
                    response.sendRedirect(request.getContextPath() + "/staff/incidents");
                    return;
                }
                request.setAttribute("incident", incident);
                request.getRequestDispatcher("/WEB-INF/staff/support-incidents/support-incident-details.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid incident ID.");
                response.sendRedirect(request.getContextPath() + "/staff/incidents");
                return;
            }
        }

        // Pagination setup
        int currentPage = 1;
        int requestsPerPage = 10;
        try {
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        int offset = (currentPage - 1) * requestsPerPage;
        
        List<DriverIncidents> incidents = staffIncidentsDAO.getAllIncidents(offset, requestsPerPage);
        int totalIncidents = staffIncidentsDAO.countAllIncidents();
        int totalPages = (int) Math.ceil((double) totalIncidents / requestsPerPage);

        // Set attributes for JSP
        request.setAttribute("incidents", incidents);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalIncidents", totalIncidents);

        request.getRequestDispatcher("/WEB-INF/staff/support-incidents/support-incidents.jsp").forward(request, response);
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
        if ("updateIncident".equals(action)) {
            int incidentId;
            try {
                incidentId = Integer.parseInt(request.getParameter("incidentId"));
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid incident ID.");
                response.sendRedirect(request.getContextPath() + "/staff/incidents?detail=" + request.getParameter("incidentId"));
                return;
            }

            String incidentNote = request.getParameter("incidentNote");
            String status = request.getParameter("status");
            int staffId = currentUser.getUser_id();

            // Validate input
            if (status == null) {
                session.setAttribute("error", "Invalid status selected.");
                response.sendRedirect(request.getContextPath() + "/staff/incidents?detail=" + incidentId);
                return;
            }

            StaffIncidentsDAO dao = new StaffIncidentsDAO();
            boolean updated = dao.updateIncident(incidentId, status, incidentNote, staffId);
            if (updated) {
                session.setAttribute("success", "Incident updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update incident.");
            }

            response.sendRedirect(request.getContextPath() + "/staff/incidents?detail=" + incidentId);
        }
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
