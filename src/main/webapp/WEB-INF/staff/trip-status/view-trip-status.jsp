<%-- 
    Document   : view-trip-status
    Created on : Jun 14, 2025, 11:28:48 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="busticket.model.StaffTripStatus, busticket.model.TripDetail, busticket.model.RouteStop, busticket.model.Passenger" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<div class="p-8">

    <%
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
    %>

    <h1 class="text-3xl font-bold text-orange-600 mb-6">View Trip Status</h1>
    <form method="get" class="flex flex-wrap items-center gap-4 mb-4">
        <input type="text" name="search"
               value="<%= request.getParameter("search") != null ? request.getParameter("search") : ""%>"
               placeholder="Enter Trip ID or Route"
               class="border p-2 rounded-md w-64"/>
        <button type="submit" class="bg-orange-500 text-white px-4 py-2 rounded-md">Search</button>
    </form>

    <table class="w-full border rounded-xl overflow-hidden">
        <thead class="bg-orange-50 text-gray-800 font-semibold">
            <tr>
                <th class="p-2 text-left">#</th>
                <th class="p-2 text-left">Route</th>
                <th class="p-2 text-left">Departure</th>
                <th class="p-2 text-left">Arrival</th>
                <th class="p-2 text-left">Driver</th>
                <th class="p-2 text-left">Bus Type</th>
                <th class="p-2 text-left">Status</th>
                <th class="p-2 text-left">Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<StaffTripStatus> trips = (List<StaffTripStatus>) request.getAttribute("trips");
                Integer currentPage = (Integer) request.getAttribute("currentPage");
                Integer recordsPerPage = (Integer) request.getAttribute("recordsPerPage");
                int stt = (currentPage - 1) * recordsPerPage + 1;
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

                if (trips != null && !trips.isEmpty()) {
                    for (StaffTripStatus trip : trips) {
                        String status = trip.getTripStatus();
                        String color = "";
                        if ("Scheduled".equals(status)) {
                            color = "bg-green-100 text-green-700";
                        } else if ("Departed".equals(status)) {
                            color = "bg-blue-100 text-blue-700";
                        } else if ("Arrived".equals(status)) {
                            color = "bg-yellow-100 text-yellow-700";
                        } else if ("Cancelled".equals(status)) {
                            color = "bg-red-100 text-red-700";
                        }
            %>
            <tr class="border-t">
                <td class="p-2"><%= stt++%></td>
                <td class="p-2"><%= trip.getStartLocation()%> → <%= trip.getEndLocation()%></td>
                <td class="p-2"><%= sdf.format(trip.getDepartureTime())%></td>
                <td class="p-2"><%= sdf.format(trip.getArrivalTime())%></td>
                <td class="p-2"><%= trip.getDriverName()%></td>
                <td class="p-2"><%= trip.getBusType()%></td>
                <td class="p-2">
                    <span class="px-2 py-1 text-sm rounded-full <%= color%>"><%= status%></span>
                </td>
                <td class="p-2">
                    <a href="trip-status?action=detail&tripId=<%= trip.getTripId()%>" class="text-blue-600">View</a>
                </td>
            </tr>
            <% }
        } else { %>
            <tr><td colspan="8" class="p-4 text-center text-gray-500">No trips found.</td></tr>
            <% } %>
        </tbody>
    </table>

    <!-- Pagination -->
    <%
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        if (totalPages != null && totalPages > 1) {
    %>
    <div class="flex justify-center mt-4 gap-1">
        <% String searchParam = request.getParameter("search") != null ? "&search=" + request.getParameter("search") : "";%>
        <a href="?page=1<%= searchParam%>" class="px-2 py-1 border rounded">«</a>
        <a href="?page=<%= currentPage > 1 ? currentPage - 1 : 1%><%= searchParam%>" class="px-2 py-1 border rounded">‹</a>
        <% for (int i = 1; i <= totalPages; i++) {%>
        <a href="?page=<%= i%><%= searchParam%>"
           class="px-3 py-1 rounded-md border
           <%= i == currentPage ? "bg-orange-500 text-white" : "bg-white text-orange-500 border-orange-300 hover:bg-orange-100"%>">
            <%= i%>
        </a>
        <% }%>
        <a href="?page=<%= currentPage < totalPages ? currentPage + 1 : totalPages%><%= searchParam%>" class="px-2 py-1 border rounded">›</a>
        <a href="?page=<%= totalPages%><%= searchParam%>" class="px-2 py-1 border rounded">»</a>
    </div>
    <% } %>

    <% } else if (action.equals("detail")) { %>
    <%-- View Trip Details Section --%>
    <%
        TripDetail detail = (TripDetail) request.getAttribute("detail");
        List<RouteStop> stops = (List<RouteStop>) request.getAttribute("stops");
        List<Passenger> passengers = (List<Passenger>) request.getAttribute("passengers");
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    %>

    <h1 class="text-3xl font-bold mb-4">Trip Details</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Route</p>
            <p><%= detail.getStartLocation()%> → <%= detail.getEndLocation()%></p>
        </div>
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Departure</p>
            <p><%= sdfDate.format(detail.getDepartureTime())%></p>
        </div>
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Arrival</p>
            <p><%= sdfDate.format(detail.getArrivalTime())%></p>
        </div>
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Driver</p>
            <p><%= detail.getDriverName()%></p>
        </div>
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Bus Type</p>
            <p><%= detail.getBusType()%></p>
        </div>
        <div class="border p-4 rounded bg-white">
            <p class="font-semibold">Status</p>
            <p><%= detail.getTripStatus()%></p>
        </div>
    </div>

    <h2 class="text-2xl font-semibold mb-2">Route Stops</h2>
    <ul class="list-disc ml-6 mb-4">
        <% for (RouteStop stop : stops) {%>
        <li><%= stop.getTime()%> – <%= stop.getLocation()%> | <%= stop.getAddress()%></li>
            <% } %>
    </ul>

    <h2 class="text-2xl font-semibold mb-2">Passenger List</h2>
    <ul class="list-disc ml-6 mb-4">
        <% for (Passenger p : passengers) {%>
        <li><%= p.getName()%></li>
            <% } %>
    </ul>

    <a href="trip-status" class="text-blue-600 underline">← Back to Trip List</a>

    <% }%>
</div>

<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>