/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffBookingStatisticsDAO;
import busticket.model.StaffBookingStatistics;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsExportServlet extends HttpServlet {

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

        StaffBookingStatisticsDAO dao = new StaffBookingStatisticsDAO();
        List<StaffBookingStatistics> list = dao.getAllStatsForExport();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Booking Statistics");

        // Header row
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("Booking ID");
        headerRow.createCell(1).setCellValue("Customer");
        headerRow.createCell(2).setCellValue("Route");
        headerRow.createCell(3).setCellValue("Departure");
        headerRow.createCell(4).setCellValue("Driver");
        headerRow.createCell(5).setCellValue("Amount (VND)");
        headerRow.createCell(6).setCellValue("Status");

        // Data rows
        int rowNum = 1;
        for (StaffBookingStatistics b : list) {
            Row row = sheet.createRow(rowNum++);
            String bookingId = "INV" + String.format("%04d", b.getInvoiceId());

            row.createCell(0).setCellValue(bookingId);
            row.createCell(1).setCellValue(b.getCustomerName());
            row.createCell(2).setCellValue(b.getRouteName());
            row.createCell(3).setCellValue(b.getDepartureTime() != null ? b.getDepartureTime().toString() : "");
            row.createCell(4).setCellValue(b.getDriverName());
            row.createCell(5).setCellValue(b.getInvoiceAmount());
            row.createCell(6).setCellValue(b.getPaymentStatus());
        }

        // Auto-size columns
        for (int i = 0; i <= 6; i++) {
            sheet.autoSizeColumn(i);
        }

        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=booking-statistics.xlsx");

        try ( ServletOutputStream out = response.getOutputStream()) {
            workbook.write(out);
            out.flush();
        }

        workbook.close();
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
