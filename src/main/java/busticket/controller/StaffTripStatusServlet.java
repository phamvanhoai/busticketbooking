/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffTripStatusDAO;
import busticket.model.StaffPassenger;
import busticket.model.StaffRouteStop;
import busticket.model.StaffTripStatus;
import busticket.model.StaffTripDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


public class StaffTripStatusServlet extends HttpServlet {

    private final StaffTripStatusDAO dao = new StaffTripStatusDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            handleList(request, response);
        } else if (action.equals("detail")) {
            handleDetail(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        int page = 1;
        int recordsPerPage = 5;
        if (request.getParameter("page") != null) {
            try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * recordsPerPage;

        List<StaffTripStatus> trips = dao.getFilteredTrips(search == null ? "" : search, offset, recordsPerPage);
        int totalTrips = dao.countFilteredTrips(search == null ? "" : search);
        int totalPages = (int) Math.ceil(totalTrips * 1.0 / recordsPerPage);

        request.setAttribute("trips", trips);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.getRequestDispatcher("/WEB-INF/staff/trip-status/view-trip-status.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tripIdParam = request.getParameter("tripId");
        if (tripIdParam == null) {
            response.sendRedirect("trip-status");
            return;
        }

        int tripId;
        try { tripId = Integer.parseInt(tripIdParam); }
        catch (NumberFormatException e) {
            response.sendRedirect("trip-status");
            return;
        }

        StaffTripDetail detail = dao.getTripDetail(tripId);
        List<StaffRouteStop> stops = dao.getRouteStops(tripId);
        List<StaffPassenger> passengers = dao.getPassengerList(tripId);

        request.setAttribute("detail", detail);
        request.setAttribute("stops", stops);
        request.setAttribute("passengers", passengers);

        request.getRequestDispatcher("/WEB-INF/staff/trip-status/view-trip-status.jsp?action=detail").forward(request, response);
    }
}