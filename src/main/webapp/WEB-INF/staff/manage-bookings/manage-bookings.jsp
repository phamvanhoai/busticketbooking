<%-- 
    Document   : manage-bookings
    Created on : Jun 18, 2025, 11:23:31 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page import="java.util.List" %>
<%@ page import="busticket.model.StaffTicket" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>

    <body class="bg-[#f9fafb]">
        <div class="mt-12 px-4">
            <!-- Loading spinner -->
            <div id="loading-spinner" class="flex justify-center items-center py-6 hidden">
                <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                </svg>
                <span class="ml-3 text-sm text-gray-600 animate-pulse">Loading bookings...</span>
            </div>
            <h2 class="text-3xl font-bold text-orange-600 mb-6">Manage Bookings</h2>

            <!-- Search & Filter Form -->
            <form id="filterForm" method="post" action="${pageContext.request.contextPath}/staff/manage-bookings" class="flex flex-wrap items-center gap-4 mb-6">
                <!-- Search input -->
                <div class="flex-grow flex gap-2 min-w-[250px]">
                    <input type="text" name="q" value="${fn:escapeXml(q)}" placeholder="Search by Invoice Code or Customer Name" class="w-full border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />
                    <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                        <i class="fas fa-search"></i>
                    </button>
                </div>

                <!-- Date filter -->
                <div class="relative">
                    <input id="datepicker" name="date" type="text"
                           value="${date}" 
                           placeholder="Select date"
                           class="w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500" />
                    <span id="calendar-icon" 
                          class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer">
                        <i class="fas fa-calendar-alt"></i>
                    </span>
                </div>

                <!-- Route filter -->
                <div class="relative w-[200px]">
                    <select name="routeId"
                            class="appearance-none w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500 text-sm">
                        <option value="">All Routes</option>
                        <c:forEach var="route" items="${distinctRoutes}">
                            <option value="${route.routeId}" <c:if test="${routeId == route.routeId}">selected</c:if>>
                                ${route.routeName}
                            </option>
                        </c:forEach>
                    </select>

                    <span class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none">
                        <i class="fas fa-filter text-sm"></i>
                    </span>
                </div>


                <!-- Status filter -->
                <div class="relative w-[160px]">
                    <select name="status"
                            class="appearance-none w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500 text-sm">
                        <option value="">All Status</option>
                        <option value="Paid" <c:if test="${status == 'Paid'}">selected</c:if>>Paid</option>
                        <option value="Unpaid" <c:if test="${status == 'Unpaid'}">selected</c:if>>Unpaid</option>
                        </select>

                        <span class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none">
                            <i class="fas fa-filter text-sm"></i>
                        </span>
                    </div>

                    <!-- Reset button -->
                    <div>
                        <button type="button" onclick="resetFilters()" class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                            <i class="fas fa-sync-alt"></i>
                            Reset Filters
                        </button>
                    </div>
                </form>

                <!-- Booking Table -->
                <div class="bg-white rounded-xl shadow-lg overflow-x-auto">
                    <table class="min-w-full text-left text-sm">
                        <thead class="bg-orange-100 text-orange-700">
                            <tr>
                                <th class="py-2 px-4">No.</th>
                                <th class="py-2 px-4">Invoice Code</th>
                                <th class="py-2 px-4">Customer</th>
                                <th class="py-2 px-4">Route</th>
                                <th class="py-2 px-4">Departure</th>
                                <th class="py-2 px-4">Driver</th>
                                <th class="py-2 px-4">Status</th>
                                <th class="py-2 px-4">Amount</th>
                                <th class="py-2 px-4 text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr class="border-t hover:bg-gray-50">
                                <td class="py-2 px-4">${ticket.stt}</td>
                                <td class="py-2 px-4">${ticket.invoiceCode}</td>
                                <td class="py-2 px-4">${ticket.customerName}</td>
                                <td class="py-2 px-4">${ticket.routeName}</td>
                                <td class="py-2 px-4">
                                    <fmt:formatDate value="${ticket.departureTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="py-2 px-4">${ticket.driverName}</td>
                                <td class="py-2 px-4">
                                    <span class="px-3 py-1 text-sm rounded-full font-medium flex items-center gap-1
                                          ${ticket.paymentStatus == 'Paid' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                                        <i class="fas ${ticket.paymentStatus == 'Paid' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                        ${ticket.paymentStatus}
                                    </span>
                                </td>

                                <td class="py-2 px-4">
                                    <fmt:formatNumber value="${ticket.invoiceAmount}" type="currency" currencySymbol="VND"/>
                                </td>
                                <td class="py-2 px-4 text-center w-[100px]">
                                    <a href="${pageContext.request.contextPath}/staff/view-booking?id=${ticket.invoiceId}"
                                       class="inline-flex items-center justify-center gap-2 text-blue-600 hover:bg-blue-50 px-2 py-1 rounded text-sm transition">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty tickets}">
                            <tr>
                                <td colspan="10" class="py-4 px-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <span class="text-sm text-gray-500 font-medium">No bookings found for your search.</span>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <!-- Pagination component using custom tag -->
            <div class="flex justify-center space-x-2 mt-6">
                <fbus:adminpagination
                    currentPage="${currentPage}"
                    totalPages="${numOfPages}"
                    url="${baseUrlWithSearch}" />
            </div>
        </div>

        <script>
            function showLoading() {
                document.getElementById("loading-spinner").classList.remove("hidden");
            }

            function hideLoading() {
                document.getElementById("loading-spinner").classList.add("hidden");
            }

            document.querySelectorAll("#filterForm select, #filterForm input[name='date'], #filterForm input[name='q']").forEach(el => {
                el.addEventListener("change", () => {
                    showLoading();
                    setTimeout(() => el.form.submit(), 300);
                });
            });

            const searchInput = document.querySelector("#filterForm input[name='q']");
            if (searchInput) {
                searchInput.addEventListener("keypress", function (e) {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        showLoading();
                        setTimeout(() => this.form.submit(), 300);
                    }
                });
            }

            function resetFilters() {
                const form = document.getElementById("filterForm");
                form.reset();
                const fp = flatpickrInstance;
                if (fp)
                    fp.clear();
                window.location.href = "<c:url value='/staff/manage-bookings'/>";
            }

            let flatpickrInstance;
            document.addEventListener("DOMContentLoaded", function () {
                flatpickrInstance = flatpickr("#datepicker", {
                    altInput: true,
                    altFormat: "d/m/Y",
                    dateFormat: "Y-m-d",
                    allowInput: true
                });

                const icon = document.getElementById("calendar-icon");
                if (icon) {
                    icon.addEventListener("click", function () {
                        flatpickrInstance.open();
                    });
                }
            });
        </script>
        <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>