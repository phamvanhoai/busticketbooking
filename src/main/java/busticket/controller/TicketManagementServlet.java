/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.BookingDAO;
import busticket.db.DBContext;
import busticket.model.Booking;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class TicketManagementServlet extends HttpServlet {

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
        // Lấy đường dẫn từ URL (xóa phần base path như "/ticket-management")
        String path = request.getPathInfo();

        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/ticket-management/cancel-ticket");
            return;
        }

        // Dựa trên path để chuyển hướng tới các JSP khác nhau
        switch (path) {
            case "/cancel-ticket":
                int userId = 1; // hoặc lấy từ session
                List<Booking> bookings = new BookingDAO(new DBContext().getConnection()).getBookingsByUserId(userId);
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/cancel-ticket.jsp").forward(request, response);
                break;
            case "/view-bookings":
                int userIdInvoice = 1; // TODO: Lấy từ session sau

                // Lấy thông tin lọc từ request
                String ticketCode = request.getParameter("ticketCode");
                String departureDate = request.getParameter("departureDate");
                String route = request.getParameter("route");
                String status = request.getParameter("status");

                // Gọi DAO mới có chức năng lọc
                busticket.DAO.InvoiceDAO invoiceDAO = new busticket.DAO.InvoiceDAO(new DBContext().getConnection());
                List<busticket.model.InvoiceView> invoices = invoiceDAO.searchInvoices(userIdInvoice, ticketCode, departureDate, route, status);

                // Truyền dữ liệu vào JSP
                request.setAttribute("invoices", invoices);
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp").forward(request, response);
                break;

            // Thêm các trường hợp khác nếu cần
            case "/booking-history":
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/booking-history.jsp").forward(request, response);
                break;
            case "/my-tickets":
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/my-tickets.jsp").forward(request, response);
                break;
            default:
                // Nếu không khớp với bất kỳ URL nào, có thể redirect về trang mặc định
                response.sendRedirect(request.getContextPath() + "/ticket-management/cancel-ticket");
                break;
        }
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
