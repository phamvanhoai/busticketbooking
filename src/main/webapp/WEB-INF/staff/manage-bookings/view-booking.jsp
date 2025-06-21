<%-- 
    Document   : view-booking
    Created on : Jun 22, 2025, 12:42:39 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="busticket.model.StaffTicket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="busticket.model.StaffTicket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Include shared header for staff layout (top bar, styles, etc.) -->
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="max-w-4xl mx-auto mt-12 px-4">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Booking Details</h2>

        <!-- If booking found, show details -->
        <c:if test="${not empty booking}">
            <div class="bg-white p-6 rounded-xl shadow-md space-y-4">

                <!-- Main information grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Booking ID with format BKGxxxx -->
                    <div>
                        <p class="text-gray-500 text-sm">Booking ID</p>
                        <p class="font-semibold">${booking.ticketId}</p>
                    </div>

                    <!-- Customer full name -->
                    <div>
                        <p class="text-gray-500 text-sm">Customer Name</p>
                        <p class="font-semibold">${booking.userName}</p>
                    </div>

                    <!-- Trip name (Route name) -->
                    <div>
                        <p class="text-gray-500 text-sm">Trip</p>
                        <p class="font-semibold">${booking.routeName}</p>
                    </div>

                    <!-- Trip departure datetime formatted -->
                    <div>
                        <p class="text-gray-500 text-sm">Departure Time</p>
                        <p class="font-semibold">
                            <fmt:formatDate value="${booking.departureTime}" pattern="dd/MM/yyyy hh:mm a"/>
                        </p>
                    </div>

                    <!-- Seat code that user booked -->
                    <div>
                        <p class="text-gray-500 text-sm">Seat Code</p>
                        <p class="font-semibold">${booking.seatCode}</p>
                    </div>

                    <!-- Bus type (e.g., Limousine, Seat, Bunk) -->
                    <div>
                        <p class="text-gray-500 text-sm">Bus Type</p>
                        <p class="font-semibold">${booking.busType}</p>
                    </div>

                    <!-- Assigned driver name -->
                    <div>
                        <p class="text-gray-500 text-sm">Driver</p>
                        <p class="font-semibold">${booking.driverName}</p>
                    </div>

                    <!-- Payment status styled badge -->
                    <div>
                        <p class="text-gray-500 text-sm">Payment Status</p>
                        <span class="inline-block px-3 py-1 text-sm font-medium rounded-full
                              ${booking.paymentStatus == 'Paid' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                            ${booking.paymentStatus}
                        </span>
                    </div>
                </div>

                            <!-- Action Buttons Section -->
                            <div class="pt-6 flex flex-wrap gap-4 items-center">
                                <!-- Back to list of bookings -->
                                <a href="${pageContext.request.contextPath}/staff/manage-bookings"
                                   class="text-orange-600 hover:underline text-sm inline-flex items-center gap-1">
                                    <i class="fas fa-arrow-left"></i> Back to list
                                </a>

                                <!-- Change trip button (POST ticketId to /staff/change-trip) -->
                                <form action="${pageContext.request.contextPath}/staff/change-trip" method="post">
                                    <input type="hidden" name="ticketId" value="${booking.ticketId}" />
                                    <button type="submit" class="text-sm text-blue-600 hover:underline inline-flex items-center gap-1">
                                        <i class="fas fa-exchange-alt"></i> Support Change Trip
                                    </button>
                                </form>

                                <!-- Cancel booking button (with confirmation prompt) -->
                                <form action="${pageContext.request.contextPath}/staff/cancel-booking" method="post"
                                      onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="ticketId" value="${booking.ticketId}" />
                                    <button type="submit" class="text-sm text-red-600 hover:underline inline-flex items-center gap-1">
                                        <i class="fas fa-times-circle"></i> Cancel Booking
                                    </button>
                                </form>

                                <!-- Optional: Print ticket button -->
                                <a href="${pageContext.request.contextPath}/staff/print-ticket?ticketId=${booking.ticketId}" 
                                   target="_blank"
                                   class="text-sm text-gray-600 hover:underline inline-flex items-center gap-1">
                                    <i class="fas fa-print"></i> Print Ticket
                                </a>
                            </div>
            </div>
        </c:if>

        <!-- If booking not found or invalid -->
        <c:if test="${empty booking}">
            <div class="text-center text-gray-500 py-12">
                <p>Booking not found or invalid ID.</p>
                <a href="${pageContext.request.contextPath}/staff/manage-bookings"
                   class="text-orange-600 hover:underline text-sm inline-flex items-center gap-1 mt-4">
                    <i class="fas fa-arrow-left"></i> Back to list
                </a>
            </div>
        </c:if>
    </div>

    <!-- Include shared footer (scripts, end tags, etc.) -->
    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
</body>