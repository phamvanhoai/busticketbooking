/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.SearchTicketDAO;
import busticket.model.SearchTicket;
import java.io.IOException;
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
public class SearchTicketServlet extends HttpServlet {

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

        String ticketCode = request.getParameter("ticketCode");
        String phone = request.getParameter("phone");

        // Lưu giá trị ticketCode và phone vào request attributes
        request.setAttribute("ticketCode", ticketCode);
        request.setAttribute("phone", phone);

        // Chỉ tìm kiếm nếu ít nhất một trong hai trường có giá trị
        List<SearchTicket> tickets = new ArrayList<>();
        if ((ticketCode != null && !ticketCode.trim().isEmpty()) || (phone != null && !phone.trim().isEmpty())) {
            SearchTicketDAO dao = new SearchTicketDAO();
            tickets = dao.searchTickets(ticketCode, phone);
        }

        // Truyền danh sách vé vào request
        request.setAttribute("tickets", tickets);

        // Forward tới JSP
        request.getRequestDispatcher("/WEB-INF/pages/search-ticket.jsp").forward(request, response);
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
