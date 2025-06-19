<%-- 
    Document   : view-bookings
    Created on : Jun 13, 2025, 9:18:21 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page import="busticket.model.InvoiceView"%>
<%@page import="busticket.model.Booking"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#fff6f3] min-h-screen">

    <!-- Header + Buy button -->
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
        <div>
            <h1 class="text-3xl font-bold">Ticket purchase history</h1>
            <p class="text-gray-500">Track and manage your ticket purchase history</p>
        </div>
        <button class="bg-orange-500 hover:bg-orange-600 text-white px-6 py-2 rounded-full">
            Buy Ticket
        </button>
    </div>

    <!-- Filters (có thể giữ nguyên hoặc bỏ) -->
    <form method="get" action="<%= request.getContextPath()%>/ticket-management/view-bookings">
        <div class="bg-white rounded-xl shadow p-6 mb-6 grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
            <!-- Ticket Code -->
            <div>
                <label class="block text-sm font-medium mb-1">Ticket Code</label>
                <input
                    type="text" name="ticketCode"
                    value="<%= request.getParameter("ticketCode") != null ? request.getParameter("ticketCode") : ""%>"
                    placeholder="Enter Ticket Code"
                    class="w-full border rounded-lg px-3 py-2 placeholder-orange-300 focus:ring-2 focus:ring-orange-200"/>
            </div>

            <!-- Time -->
            <div>
                <label class="block text-sm font-medium mb-1">Time</label>
                <input
                    type="date" name="departureDate"
                    value="<%= request.getParameter("departureDate") != null ? request.getParameter("departureDate") : ""%>"
                    class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200"/>
            </div>

            <!-- Route -->
            <div>
                <label class="block text-sm font-medium mb-1">Route</label>
                <input
                    type="text" name="route"
                    value="<%= request.getParameter("route") != null ? request.getParameter("route") : ""%>"
                    placeholder="Enter Route"
                    class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200"/>
            </div>

            <!-- Status -->
            <div>
                <label class="block text-sm font-medium mb-1">Status</label>
                <select name="status" class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200">
                    <option value="">All</option>
                    <option <%= "Paid".equals(request.getParameter("status")) ? "selected" : ""%>>Paid</option>
                    <option <%= "Expires".equals(request.getParameter("status")) ? "selected" : ""%>>Expires</option>
                    <option <%= "Cancelled".equals(request.getParameter("status")) ? "selected" : ""%>>Cancelled</option>
                </select>
            </div>

            <!-- Find -->
            <div>
                <button type="submit" class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg">
                    Find
                </button>
            </div>
        </div>
    </form>
    <!-- ... (giữ nguyên như bạn có) ... -->

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="min-w-full bg-white rounded-xl overflow-hidden">
            <thead class="bg-orange-100 text-left">
                <tr>
                    <th class="px-4 py-3 font-medium">Ticket Code</th>
                    <th class="px-4 py-3 font-medium">Tickets</th>
                    <th class="px-4 py-3 font-medium">Route</th>
                    <th class="px-4 py-3 font-medium">Date of departure</th>
                    <th class="px-4 py-3 font-medium">Amount of money</th>
                    <th class="px-4 py-3 font-medium">Payment</th>
                    <th class="px-4 py-3 font-medium">Status</th>
                    <th class="px-4 py-3 font-medium">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y">
                <%
                    List<InvoiceView> invoices = (List<InvoiceView>) request.getAttribute("invoices");
                    if (invoices != null && !invoices.isEmpty()) {
                        for (InvoiceView inv : invoices) {
                            String status = inv.getStatus();
                            String statusClass = "bg-gray-400 text-white";
                            if ("Paid".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status)) {
                                statusClass = "bg-green-100 text-green-800";
                            } else if ("Cancelled".equalsIgnoreCase(status)) {
                                statusClass = "bg-red-500 text-white";
                            } else if ("Pending".equalsIgnoreCase(status) || "Expires".equalsIgnoreCase(status)) {
                                statusClass = "bg-yellow-300 text-gray-800";
                            }
                %>
                <tr>
                    <td class="px-4 py-3"><%= inv.getInvoiceCode()%></td>
                    <td class="px-4 py-3">1</td> <%-- Nếu cần số lượng vé, có thể mở rộng model --%>
                    <td class="px-4 py-3">Ticket ID: <%= inv.getTicketId()%></td> <%-- Hoặc lộ trình nếu có --%>
                    <td class="px-4 py-3"><%= inv.getDepartureTime()%></td>
                    <td class="px-4 py-3"><%= String.format("%,.0f", inv.getTotalAmount())%>₫</td>
                    <td class="px-4 py-3"><%= inv.getPaymentMethod()%></td>
                    <td class="px-4 py-3">
                        <span class="<%= statusClass%> text-xs px-2 py-1 rounded-full">
                            <%= status%>
                        </span>
                    </td>
                    <td class="px-4 py-3">
                        <% if ("Cancelled".equalsIgnoreCase(status)) { %>
                        <span class="text-gray-400 text-sm">—</span>
                        <% } else {%>
                        <form method="post" action="<%= request.getContextPath()%>/ticket-management/request-cancel">
                            <input type="hidden" name="ticketId" value="<%= inv.getTicketId()%>">
                            <button type="submit" class="bg-gray-200 hover:bg-gray-300 text-gray-700 text-sm px-3 py-1 rounded-full">
                                Cancel
                            </button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <%  } // end for
                } else { %>
                <tr>
                    <td colspan="8" class="text-center px-4 py-6 text-gray-500">You don’t have any invoice bookings.</td>
                </tr>
                <% }%>
            </tbody>
        </table>
    </div>

    <!-- Pagination (giữ nguyên nếu cần) -->
    <div class="mt-6 flex justify-center gap-2">
        <button class="px-4 py-2 bg-orange-500 text-white rounded-lg">1</button>
        <button class="px-4 py-2 border border-orange-500 text-orange-500 rounded-lg">2</button>
    </div>





    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>