/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffBookingDAO;
import busticket.model.StaffBookingInfo;
import busticket.model.StaffTicket;
import busticket.util.QRCodeUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingDetailServlet extends HttpServlet {

    private final StaffBookingDAO bookingDAO = new StaffBookingDAO();

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

        String invoiceIdStr = request.getParameter("id");
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing booking ID");
            return;
        }

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int pageSize = 5;

        try {
            int invoiceId = Integer.parseInt(invoiceIdStr);
            StaffBookingInfo bookingInfo = bookingDAO.getBookingInfoByInvoiceId(invoiceId);
            if (bookingInfo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }

            int totalTickets = bookingDAO.countTicketsByInvoiceId(invoiceId);

            int numOfPages = (int) Math.ceil((double) totalTickets / pageSize);

            List<StaffTicket> ticketDetails = bookingDAO.getTicketsByInvoiceIdPaging(invoiceId, (currentPage - 1) * pageSize, pageSize);

            for (StaffTicket ticket : ticketDetails) {
                try {
                    String qrText = "TicketID:" + ticket.getTicketId() + ";Invoice:" + bookingInfo.getInvoiceCode();
                    String qrBase64 = QRCodeUtil.generateQRCodeBase64(qrText, 100, 100);
                    ticket.setQrCodeBase64(qrBase64);
                } catch (Exception e) {
                    ticket.setQrCodeBase64("");
                    e.printStackTrace();
                }
            }

            request.setAttribute("bookingInfo", bookingInfo);
            request.setAttribute("ticketDetails", ticketDetails);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("numOfPages", numOfPages);
            request.setAttribute("baseUrlWithSearch", request.getRequestURI() + "?id=" + invoiceId);

            request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/view-booking.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading booking details");
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
        doGet(request, response);
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
