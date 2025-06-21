<%-- 
    Document   : view-booking-statistics
    Created on : Jun 19, 2025, 1:45:51 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>
<body class="bg-[#f9fafb]">

    <div class="min-h-screen bg-white py-10 px-6">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">View Booking Statistics</h2>

        <!-- Filters -->
        <form method="post" class="flex flex-wrap items-center gap-4 mb-8">
            <select name="route" class="border p-2 rounded-md">
                <c:forEach var="route" items="${allRoutes}">
                    <option value="${route}" ${route == selectedRoute ? "selected" : ""}>${route}</option>
                </c:forEach>
            </select>

            <input type="date" name="date" value="${selectedDate}" class="border p-2 rounded-md" />

            <button type="submit" class="bg-orange-500 text-white px-4 py-2 rounded-md">
                Search
            </button>
        </form>

        <!-- Table -->
        <table class="w-full border rounded-xl overflow-hidden">
            <thead class="bg-orange-100 text-orange-700">
                <tr>
                    <th class="p-2 text-left">Date</th>
                    <th class="p-2 text-left">Route</th>
                    <th class="p-2 text-left">Tickets Sold</th>
                    <th class="p-2 text-left">Occupancy (%)</th>
                    <th class="p-2 text-left">Driver</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stat" items="${stats}">
                    <tr class="border-t hover:bg-gray-50">
                        <td class="p-2">${stat.date}</td>
                        <td class="p-2">
                            ${fn:replace(stat.routeName, "?", "→")}
                        </td>

                        <td class="p-2">${stat.ticketsSold}</td>
                        <td class="p-2">${stat.occupancyPercent}%</td>
                        <td class="p-2">${stat.driverName}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stats}">
                    <tr><td colspan="5" class="p-4 text-center text-gray-500">No statistics found.</td></tr>
                </c:if>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 gap-2">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <a href="?route=${selectedRoute}&date=${selectedDate}&page=${i}"
                   class="px-3 py-1 rounded-md border
                   ${i == currentPage ? 'bg-orange-500 text-white' : 'bg-white text-orange-500 border-orange-300 hover:bg-orange-100'}">
                    ${i}
                </a>
            </c:forEach>
        </div>

        <!-- Top Drivers Podium -->
        <div class="mt-12">
            <h3 class="text-2xl font-bold text-[#EF5222] text-center mb-8">
                <i class="fas fa-trophy text-yellow-400 text-2xl"></i>
                Top Drivers
            </h3>

            <div class="flex justify-center items-end gap-8">
                <c:forEach var="name" items="${topDrivers}" varStatus="i">
                    <div class="flex flex-col items-center">
                        <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-lg font-bold shadow-md">
                            ${fn:substring(name, 0, 1)}
                        </div>
                        <div class="font-medium mt-1">${name}</div>
                        <div class="text-sm text-gray-500">${4 - i.index} trips</div>
                        <div class="w-20
                             ${i.index == 0 ? 'h-32 bg-[#EF5222]' : 
                               i.index == 1 ? 'h-24 bg-[#FF9F75]' :
                               'h-20 bg-[#FFDBC7]'}
                             text-white text-center flex items-center justify-center font-bold rounded-t-lg shadow">
                            ${i.index + 1}
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
