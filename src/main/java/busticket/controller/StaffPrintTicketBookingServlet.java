/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffManageBookingDAO;
import busticket.model.StaffTicket;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import java.io.OutputStream;
import com.itextpdf.text.Phrase;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
@WebServlet(name = "StaffPrintTicketBookingServlet", urlPatterns = {"/StaffPrintTicketBookingServlet"})
public class StaffPrintTicketBookingServlet extends HttpServlet {

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
        // Get ticketId from query
        String ticketId = request.getParameter("id");

        StaffManageBookingDAO dao = new StaffManageBookingDAO();
        StaffTicket booking = dao.getBookingById(ticketId);

        // Forward to print preview JSP
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/print-ticket.jsp").forward(request, response);
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
        String ticketId = request.getParameter("id");

        StaffManageBookingDAO dao = new StaffManageBookingDAO();
        StaffTicket booking = dao.getBookingById(ticketId);

        if (booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }

        // Set response headers for PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Ticket_" + booking.getTicketId() + ".pdf");

        try {
            Document document = new Document();
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);

            document.open();

            // Title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD, BaseColor.ORANGE);
            Paragraph title = new Paragraph("Bus Ticket", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            document.add(new Paragraph(" ")); // spacing

            // Ticket Info Table
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            addRow(table, "Ticket ID", booking.getFormattedTicketId());
            addRow(table, "Customer Name", booking.getUserName());
            addRow(table, "Route", booking.getRouteName());
            addRow(table, "Departure Time", booking.getDepartureTime().toString());
            addRow(table, "Seat Code", booking.getSeatCode());
            addRow(table, "Bus Type", booking.getBusType());
            addRow(table, "Driver", booking.getDriverName());
            addRow(table, "Payment Status", booking.getPaymentStatus());
            addRow(table, "Total Amount", booking.getInvoiceAmount() + " VND");

            document.add(table);

            document.close();
            out.close();
        } catch (Exception e) {
            throw new ServletException("Error generating PDF", e);
        }
    }

    private void addRow(PdfPTable table, String label, String value) {
        Font labelFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 12);

        PdfPCell cell1 = new PdfPCell(new Phrase(label, labelFont));
        PdfPCell cell2 = new PdfPCell(new Phrase(value != null ? value : "N/A", valueFont));

        cell1.setPadding(8);
        cell2.setPadding(8);

        table.addCell(cell1);
        table.addCell(cell2);
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
