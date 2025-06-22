<%-- 
    Document   : booking-statistics
    Created on : Jun 19, 2025, 1:45:51 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<!-- Flatpickr CSS and JS for date picker input -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <body class="bg-[#f9fafb]">
        <div class="mt-12 px-4">

            <!-- Page Title -->
            <h2 class="text-3xl font-bold text-[#EF5222] mb-6">View Booking Statistics</h2>

            <!-- Loading spinner to indicate data is being processed -->
            <div id="loading-spinner" class="flex justify-center items-center py-6 hidden">
                <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                </svg>
                <span class="ml-3 text-sm text-gray-600">Loading statistics...</span>
            </div>

            <!-- Filter form to search by booking ID / customer name, route and date -->
            <form id="filterForm" method="post" action="${pageContext.request.contextPath}/staff/booking-statistics" class="flex flex-wrap items-center gap-4 mb-6">

                <!-- Search box for booking ID or customer name -->
                <div class="flex-grow flex gap-2 min-w-[250px]">
                    <input type="text" name="q" value="${fn:escapeXml(q)}" placeholder="Search by Booking ID or Customer Name"
                           class="w-full border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />
                    <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                        <i class="fas fa-search"></i>
                    </button>
                </div>

                <!-- Route selection dropdown -->
                <div class="relative w-[220px]">
                    <select name="route" class="appearance-none w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500">
                        <option value="">All Routes</option>
                        <c:forEach var="route" items="${allRoutes}">
                            <option value="${route}" <c:if test="${route == selectedRoute}">selected</c:if>>${route}</option>
                        </c:forEach>
                    </select>
                    <span class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none">
                        <i class="fas fa-filter"></i>
                    </span>
                </div>

                <!-- Date picker using Flatpickr -->
                <div class="relative">
                    <input id="datepicker" type="text" name="date" value="${selectedDate}" placeholder="Select date"
                           class="border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500" />
                    <span id="calendar-icon" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer">
                        <i class="fas fa-calendar-alt"></i>
                    </span>
                </div>

                <!-- Reset filters button -->
                <button type="button" onclick="resetFilters()" class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                    <i class="fas fa-sync-alt"></i> Reset Filters
                </button>
            </form>

            <!-- Statistics Table: shows filtered results with booking and ticket info -->
            <div class="bg-white rounded-xl shadow-lg overflow-x-auto">
                <table class="w-full border rounded-xl overflow-hidden">
                    <thead class="bg-orange-100 text-orange-700">
                        <tr>
                            <th class="p-2 text-left">Booking ID</th>
                            <th class="p-2 text-left">Date</th>
                            <th class="p-2 text-left">Route</th>
                            <th class="p-2 text-left">Tickets Sold</th>
                            <th class="p-2 text-left">Paid</th>
                            <th class="p-2 text-left">Unpaid</th>
                            <th class="p-2 text-left">Occupancy (%)</th>
                            <th class="p-2 text-left">Driver</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stat" items="${stats}">
                            <tr class="border-t hover:bg-gray-50">
                                <td class="p-2">${stat.formattedBookingId}</td>
                                <td class="py-2 px-4 text-sm text-gray-700">
                                    <fmt:formatDate value="${stat.statDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td class="p-2">${fn:replace(stat.routeName, "?", "→")}</td>
                                <td class="p-2">${stat.ticketsSold}</td>
                                <td class="p-2">${stat.paidTickets}</td>
                                <td class="p-2">${stat.unpaidTickets}</td>
                                <td class="p-2">${stat.occupancyPercent}%</td>
                                <td class="p-2">${stat.driverName}</td>
                            </tr>
                        </c:forEach>

                        <!-- Message when no records are found -->
                        <c:if test="${empty stats}">
                            <tr>
                                <td colspan="8" class="py-4 px-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <span class="text-sm text-gray-500 font-medium">No statistics found for your search.</span>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Custom pagination component using taglib -->
            <div class="flex justify-center space-x-2 mt-6">
                <fbus:adminpagination
                    currentPage="${currentPage}"
                    totalPages="${totalPages}"
                    url="${pageContext.request.contextPath}/staff/booking-statistics?route=${selectedRoute}&date=${selectedDate}&onlyPaid=${onlyPaid}&q=${fn:escapeXml(q)}"/>
            </div>

            <!-- Top 3 Drivers section by ticket sold -->
            <div class="mt-12">
                <h2 class="text-2xl font-bold text-[#F24822] mb-6 text-center flex items-center justify-center gap-2">
                    <i class="fas fa-trophy text-yellow-500"></i> Top Drivers (by Tickets Sold)
                </h2>

                <!-- Driver podium display: 3rd, 1st, 2nd -->
                <div class="flex justify-center items-end gap-8">
                    <!-- 3rd place -->
                    <c:if test="${not empty topDrivers[2]}">
                        <div class="flex flex-col items-center order-1">
                            <div class="w-20 h-20 bg-gray-200 rounded-full flex items-center justify-center text-xl font-semibold shadow-md">
                                ${fn:substring(topDrivers[2].driverName, 0, 1)}
                            </div>
                            <p class="mt-2 font-semibold">${topDrivers[2].driverName}</p>
                            <p class="text-gray-600">${topDrivers[2].ticketsSold} tickets</p>
                            <div class="bg-[#F24822] text-white font-bold rounded-md mt-2 px-4 py-2">3</div>
                        </div>
                    </c:if>

                    <!-- 1st place -->
                    <c:if test="${not empty topDrivers[0]}">
                        <div class="flex flex-col items-center order-2 scale-110">
                            <div class="w-24 h-24 bg-gray-200 rounded-full flex items-center justify-center text-2xl font-bold shadow-md">
                                ${fn:substring(topDrivers[0].driverName, 0, 1)}
                            </div>
                            <p class="mt-2 font-semibold">${topDrivers[0].driverName}</p>
                            <p class="text-gray-600">${topDrivers[0].ticketsSold} tickets</p>
                            <div class="bg-[#F24822] text-white font-bold rounded-md mt-2 px-5 py-3 text-lg">1</div>
                        </div>
                    </c:if>

                    <!-- 2nd place -->
                    <c:if test="${not empty topDrivers[1]}">
                        <div class="flex flex-col items-center order-3">
                            <div class="w-20 h-20 bg-gray-200 rounded-full flex items-center justify-center text-xl font-semibold shadow-md">
                                ${fn:substring(topDrivers[1].driverName, 0, 1)}
                            </div>
                            <p class="mt-2 font-semibold">${topDrivers[1].driverName}</p>
                            <p class="text-gray-600">${topDrivers[1].ticketsSold} tickets</p>
                            <div class="bg-[#F24822] text-white font-bold rounded-md mt-2 px-4 py-2">2</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- JavaScript: Flatpickr setup and auto-submit logic -->
        <script>
            function showLoading() {
                document.getElementById("loading-spinner").classList.remove("hidden");
            }

            function hideLoading() {
                document.getElementById("loading-spinner").classList.add("hidden");
            }

            // Automatically submit form when route/date input changes
            document.querySelectorAll("#filterForm select, #filterForm input[name='date']").forEach(el => {
                el.addEventListener("change", () => {
                    showLoading();
                    document.getElementById("filterForm").submit();
                });
            });

            // Reset filter form and go back to base URL
            function resetFilters() {
                document.getElementById("filterForm").reset();
                if (flatpickrInstance)
                    flatpickrInstance.clear();
                window.location.href = "<c:url value='/staff/booking-statistics'/>";
            }

            // Flatpickr initialization
            let flatpickrInstance;
            document.addEventListener("DOMContentLoaded", function () {
                flatpickrInstance = flatpickr("#datepicker", {
                    altInput: true,
                    altFormat: "d/m/Y",
                    dateFormat: "Y-m-d",
                    allowInput: true
                });

                // Open date picker when calendar icon is clicked
                const icon = document.getElementById("calendar-icon");
                if (icon) {
                    icon.addEventListener("click", function () {
                        flatpickrInstance.open();
                    });
                }
            });
        </script>
        <%@include file="/WEB-INF/include/staff/staff-footer.jsp"%>
    </body>
</html>