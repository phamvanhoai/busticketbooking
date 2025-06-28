/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.TicketManagementDAO;
import busticket.model.Invoices;
import busticket.model.Users;
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
        // Get the logged-in user's ID from session (or any other method to identify the user)
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session
        Users users = (Users) session.getAttribute("currentUser");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        String cancel = request.getParameter("cancel");
        if (cancel != null) {
            try {
                // Convert invoiceId to int from String
                int invoiceId = Integer.parseInt(cancel);

                // Lấy thông tin hóa đơn từ DAO
                Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);

                // Kiểm tra nếu hóa đơn tồn tại
                if (invoice != null) {
                    // Truyền hóa đơn vào request để hiển thị trên trang JSP
                    request.setAttribute("invoice", invoice);
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/cancel-ticket.jsp")
                            .forward(request, response);
                    return; // Ensure no further code is executed after forward
                } else {
                    // Nếu không tìm thấy hóa đơn, chuyển hướng về trang quản lý và hiển thị thông báo lỗi
                    request.setAttribute("errorMessage", "Invoice not found!");
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                            .forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Nếu không thể chuyển đổi invoiceId sang int, trả về trang quản lý và hiển thị thông báo lỗi
                request.setAttribute("errorMessage", "Invalid invoice ID format!");
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                        .forward(request, response);
                return;
            }
        }

        // View details (optional, logic for viewing details could go here)
        String detail = request.getParameter("detail");
        if (detail != null) {
            // Handle view details logic if needed
        }
        
        // View details (optional, logic for viewing details could go here)
        String review = request.getParameter("review");
        if (review != null) {
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/review-booking.jsp")
                        .forward(request, response);
                return;
        }

        // Get the user ID and perform search and pagination
        int userId = users.getUser_id();

        String ticketCode = request.getParameter("ticketCode");
        String route = request.getParameter("route");
        String status = request.getParameter("status");

        // Pagination logic
        int currentPage = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1; // Default to page 1 in case of error
            }
        }

        int offset = (currentPage - 1) * recordsPerPage;

        // Fetch data from DAO with filters and pagination
        List<String> locations = ticketManagementDAO.getAllLocations();  // Get locations for filter
        List<Invoices> invoicesList = ticketManagementDAO.getAllInvoices(ticketCode, route, status, offset, recordsPerPage);
        int totalRecords = ticketManagementDAO.getTotalInvoicesCount(ticketCode, route, status);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Set attributes for JSP
        request.setAttribute("invoicesList", invoicesList);
        request.setAttribute("locations", locations);  // Locations for route filter
        request.setAttribute("ticketCode", ticketCode);
        request.setAttribute("route", route);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward to the view bookings JSP
        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
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
// Lấy thông tin từ session (người dùng đang đăng nhập)
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        // Lấy thông tin từ form
        String invoiceId = request.getParameter("invoiceId");
        String cancellationReason = request.getParameter("reason");

        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        // Thực hiện hủy hóa đơn
        boolean success = ticketManagementDAO.cancelInvoice(invoiceId, cancellationReason, user.getUser_id());

        if (success) {
            // Nếu hủy thành công, chuyển hướng về trang danh sách hóa đơn với trạng thái hủy
            response.sendRedirect(request.getContextPath() + "/ticket-management?status=Pending Cancellation");
        } else {
            // Nếu có lỗi, chuyển hướng về trang lỗi
            response.sendRedirect(request.getContextPath() + "/ticket-management?status=error");
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
