<%-- 
    Document   : manage-bookings
    Created on : Jun 18, 2025, 11:23:31 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page import="java.util.List" %>
<<<<<<< Updated upstream
<%@ page import="busticket.model.Tickets" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>
=======
<%@ page import="busticket.model.StaffTicket" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
>>>>>>> Stashed changes

<body class="bg-[#f9fafb]">

    <div class="mt-12 px-4">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Manage Bookings</h2>
        <!-- Spinner while loading -->
        <div id="loading-spinner" class="flex justify-center items-center py-6 hidden">
            <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span class="ml-3 text-sm text-gray-600 animate-pulse">Loading bookings...</span>

<<<<<<< Updated upstream
        <!-- Search & Filter Form -->
        <form method="post"
              action="${pageContext.request.contextPath}/staff/manage-bookings"
              class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
            <div class="flex gap-2 flex-1">
                <input type="text" name="q" value="${fn:escapeXml(q)}"
                       placeholder="Search by Booking ID or Customer Name"
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"/>
                <button type="submit"
                        class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            <select name="status"
                    class="border border-gray-300 rounded-lg px-4 py-2">
                <option value="">All Status</option>
                <option value="Paid"   ${status=='Paid'   ? 'selected' : ''}>Paid</option>
                <option value="Unpaid" ${status=='Unpaid' ? 'selected' : ''}>Unpaid</option>
            </select>
        </form>

=======
        </div>

        <!-- Search & Filter Form -->
        <form id="filterForm" method="post"
              action="${pageContext.request.contextPath}/staff/manage-bookings"
              class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
            <div class="flex gap-2 flex-1">
                <!-- Search input for Booking ID or Customer Name -->
                <input type="text" name="q" value="${fn:escapeXml(q)}"
                       placeholder="Search by Booking ID or Customer Name"
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"/>
                <button type="submit"
                        class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            <!-- Filter by Payment Status -->
            <select name="status"
                    class="border border-gray-300 rounded-lg px-4 py-2">
                <option value="">All Status</option>
                <option value="Paid"   ${status=='Paid'   ? 'selected' : ''}>Paid</option>
                <option value="Unpaid" ${status=='Unpaid' ? 'selected' : ''}>Unpaid</option>
            </select>
        </form>

>>>>>>> Stashed changes
        <!-- Booking Table -->
        <div class="bg-white rounded-xl shadow-lg overflow-x-auto">
            <table class="min-w-full text-left text-sm">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-4">Booking ID</th>
                        <th class="py-2 px-4">Customer</th>
                        <th class="py-2 px-4">Trip</th>
                        <th class="py-2 px-4">Date</th>
                        <th class="py-2 px-4">Seat</th>
                        <th class="py-2 px-4">Driver</th>
                        <th class="py-2 px-4">Bus Type</th>
                        <th class="py-2 px-4">Payment</th>
                        <th class="py-2 px-4 text-center w-[100px]">Action</th>
                    </tr>
                </thead>
                <tbody>
<<<<<<< Updated upstream
                    <c:forEach var="b" items="${bookings}">
                        <tr class="border-t hover:bg-gray-50 transition">
                            <td class="py-2 px-4">${b.ticketId}</td>
=======
                    <!-- Loop through the list of bookings -->
                    <c:forEach var="b" items="${bookings}">
                        <tr class="border-t hover:bg-gray-50 transition">
                            <td>${b.formattedTicketId}</td>
>>>>>>> Stashed changes
                            <td class="py-2 px-4">${b.userName}</td>
                            <td class="py-2 px-4">${b.routeName}</td>
                            <td class="py-2 px-4">${b.departureTime}</td>
                            <td class="py-2 px-4">${b.seatCode}</td>
                            <td class="py-2 px-4">${b.driverName}</td>
                            <td class="py-2 px-4">${b.busType}</td>
                            <td class="py-2 px-4">
                                <span class="px-3 py-1 text-sm rounded-full font-medium
                                      ${b.paymentStatus=='Paid'   ? 'bg-green-100 text-green-700'
                                        : 'bg-red-100 text-red-600'}">
                                          ${b.paymentStatus}
                                      </span>
                                </td>
<<<<<<< Updated upstream
                            </tr>
                        </c:forEach>
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="8" class="py-6 px-4 text-center text-gray-500">
                                    No bookings found.
=======
                                <td class="py-2 px-4 text-center w-[100px]">
                                    <a href="${pageContext.request.contextPath}/staff/view-booking?id=${b.ticketId}"
                                       class="inline-flex items-center justify-center gap-2 text-blue-600 hover:bg-blue-50 px-2 py-1 rounded text-sm transition">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <!-- Show message if no bookings found -->
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="9" class="py-4 px-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <span class="text-sm text-gray-500 font-medium">No bookings found for your search.</span>
                                    </div>
>>>>>>> Stashed changes
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
<<<<<<< Updated upstream
        </div>

=======

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

            // Auto-submit form on select change (status)
            document.querySelectorAll("#filterForm select").forEach(el => {
                el.addEventListener("change", () => {
                    showLoading();
                    setTimeout(() => {
                        el.form.submit();
                    }, 300); // T?o delay ?? th?y loading
                });
            });

            // Submit form when pressing Enter in search input
            const searchInput = document.querySelector("#filterForm input[name='q']");
            if (searchInput) {
                searchInput.addEventListener("keypress", function (e) {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        showLoading();
                        setTimeout(() => {
                            this.form.submit();
                        }, 300);
                    }
                });
            }
        </script>

>>>>>>> Stashed changes
        <%@ include file="/WEB-INF/include/staff/staff-footer.jsp" %>
    </body>