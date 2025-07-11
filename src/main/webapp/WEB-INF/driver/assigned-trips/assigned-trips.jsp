<%-- 
    Document   : assigned-trips
    Created on : Jun 13, 2025, 10:48:20 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <!-- Tiêu đề -->
        <h1 class="text-3xl font-bold text-orange-600">Assigned Trips</h1>

        <!-- Bộ lọc -->
        <div class="flex flex-col md:flex-row gap-4">
            <input
                type="date"
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                placeholder="Select date"
                />
            <select
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                >
                <option>All Routes</option>
                <option>HCM → Cần Thơ</option>
                <option>Cần Thơ → Châu Đốc</option>
                <option>Huế → Đà Nẵng</option>
            </select>
            <select
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                >
                <option>All Status</option>
                <option>Scheduled</option>
                <option>Ongoing</option>
                <option>Completed</option>
                <option>Cancelled</option>
            </select>
            <button
                class="w-full md:w-auto bg-orange-500 text-white rounded-lg px-6 py-2 hover:bg-orange-600"
                >
                Filter
            </button>
        </div>

        <!-- Bảng Assigned Trips -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-600">
                    <tr>
                        <th class="px-6 py-3">Trip ID</th>
                        <th class="px-6 py-3">Date</th>
                        <th class="px-6 py-3">Time</th>
                        <th class="px-6 py-3">Route</th>
                        <th class="px-6 py-3">Bus Type</th>
                        <th class="px-6 py-3">Passengers</th>
                        <th class="px-6 py-3">Status</th>
                        <th class="px-6 py-3">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <c:forEach var="trip" items="${trips}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4">${trip.tripId}</td>
                            <td class="px-6 py-4">${trip.date}</td>
                            <td class="px-6 py-4">${trip.time}</td>
                            <td class="px-6 py-4">${trip.route}</td>
                            <td class="px-6 py-4">${trip.busType}</td>
                            <td class="px-6 py-4">${trip.passengers}</td>
                            <td class="px-6 py-4">
                                <span class="px-3 py-1 <c:choose>
                                          <c:when test="${trip.status == 'Scheduled'}">bg-green-100 text-green-700</c:when>
                                          <c:when test="${trip.status == 'Ongoing'}">bg-yellow-100 text-yellow-700</c:when>
                                          <c:when test="${trip.status == 'Completed'}">bg-gray-200 text-gray-700</c:when>
                                          <c:otherwise>bg-red-100 text-red-700</c:otherwise>
                                      </c:choose> rounded-full text-xs">
                                    ${trip.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 space-x-2">
                                <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?roll-call">
                                    <button class="text-blue-600 hover:underline text-sm">Roll call</button>
                                </a>
                                <button class="text-gray-600 hover:underline text-sm">Start</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center space-x-2">
            <button class="px-3 py-1 bg-orange-500 text-white rounded">1</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">2</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">3</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">»</button>
        </div>
    </div>
</body>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
