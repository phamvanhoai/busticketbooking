<%-- 
    Document   : search-ticket
    Created on : Jul 14, 2025, 2:40:09 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/include/header.jsp" %>

<body class="bg-gray-100 py-10">

    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <h1 class="text-2xl font-bold text-orange-600 mb-6">Search Ticket</h1>

        <!-- Search Form -->
        <form action="${pageContext.request.contextPath}/search-ticket" method="get" class="space-y-6">
            <div>
                <label for="ticketCode" class="block text-sm font-medium text-gray-700 mb-2">Ticket Code</label>
                <input type="text" id="ticketCode" name="ticketCode" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400" placeholder="Enter Ticket Code">
            </div>

            <div>
                <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">Passenger Phone</label>
                <input type="text" id="phone" name="phone" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400" placeholder="Enter Passenger Phone">
            </div>

            <div class="flex justify-end gap-4">
                <button type="reset" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                    Reset
                </button>
                <button type="submit" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                    Search
                </button>
            </div>
        </form>

        <!-- Search Results -->
        <!-- Search Results -->
        <c:if test="${not empty tickets}">
            <div class="mt-10 px-4">
                <h2 class="text-3xl font-bold text-orange-600">Ticket Search Results</h2>
                <div class="bg-white shadow-md rounded-xl overflow-x-auto mt-6">
                    <table class="min-w-full text-left">
                        <thead class="bg-orange-100 text-orange-700">
                            <tr>
                                <th class="px-4 py-2">Ticket ID</th>
                                <th class="px-4 py-2">Ticket Code</th>
                                <th class="px-4 py-2">Passenger Name</th>
                                <th class="px-4 py-2">Trip ID</th>
                                <th class="px-4 py-2">Route</th>
                                <th class="px-4 py-2">Seat Number</th>
                                <th class="px-4 py-2">Date</th>
                                <th class="px-4 py-2">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ticket" items="${tickets}">
                                <tr class="border-t hover:bg-gray-50">
                                    <td class="px-4 py-2">${ticket.ticketId}</td>
                                    <td class="px-4 py-2">${ticket.ticketCode}</td>
                                    <td class="px-4 py-2">${ticket.passengerName}</td>
                                    <td class="px-4 py-2">${ticket.tripId}</td>
                                    <td class="px-4 py-2">${ticket.route}</td>
                                    <td class="px-4 py-2">${ticket.seat}</td>
                                    <td class="px-4 py-2"><fmt:formatDate value="${ticket.date}" pattern="yyyy-MM-dd" /></td>
                                    <td class="px-4 py-2">${ticket.status}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <c:if test="${empty tickets}">
            <div class="mt-10 px-4">
                <h2 class="text-3xl font-bold text-orange-600">No tickets found</h2>
                <p class="text-gray-500">No tickets match your search criteria.</p>
            </div>
        </c:if>

    </div>

    <%@include file="/WEB-INF/include/footer.jsp" %>