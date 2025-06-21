/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package busticket.controller;

import busticket.model.AdminBusTypes;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesServlet extends HttpServlet {

    private static boolean updateBusType(AdminBusTypes updatedBusType) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private static boolean addBusType(AdminBusTypes newBusType) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
 
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
            return;
        }
        
        if (request.getParameter("delete") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/delete-bus-type.jsp").forward(request, response);
            return;
        }
        
        if (request.getParameter("editId") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/edit-bus-type.jsp").forward(request, response);
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/admin/bus-types/bus-types.jsp")
                .forward(request, response);
        
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       // Check if it's an edit request
        if (request.getParameter("editId") != null) {
            int busTypeId = Integer.parseInt(request.getParameter("editId"));
            String busTypeName = request.getParameter("busTypeName");
            String busTypeDescription = request.getParameter("busTypeDescription");

            AdminBusTypes updatedBusType = new AdminBusTypes(busTypeId, busTypeName, busTypeDescription);
            boolean updated = AdminBusTypesServlet.updateBusType(updatedBusType);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/bus-types");
            } else {
                request.setAttribute("error", "Failed to update bus type.");
                request.getRequestDispatcher("/WEB-INF/admin/bus-types/edit-bus-type.jsp").forward(request, response);
            }
        } else {
            // Add new bus type
            String busTypeName = request.getParameter("busTypeName");
            String busTypeDescription = request.getParameter("busTypeDescription");

            AdminBusTypes newBusType = new AdminBusTypes(0, busTypeName, busTypeDescription);
            boolean added;
            added = AdminBusTypesServlet.addBusType(newBusType);

            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/bus-types");
            } else {
                request.setAttribute("error", "Failed to add new bus type.");
                request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
            }
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
