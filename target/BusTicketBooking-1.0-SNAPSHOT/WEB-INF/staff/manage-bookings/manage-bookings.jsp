<%-- 
    Document   : manage-bookings
    Created on : Jun 18, 2025, 11:23:31 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page import="java.util.List" %>
<%@ page import="busticket.model.Tickets" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="mt-12 px-4">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Manage Bookings</h2>

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
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr class="border-t hover:bg-gray-50 transition">
                            <td class="py-2 px-4">${b.ticketId}</td>
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
                            </tr>
                        </c:forEach>
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="8" class="py-6 px-4 text-center text-gray-500">
                                    No bookings found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <%@ include file="/WEB-INF/include/staff/staff-footer.jsp" %>
    </body>