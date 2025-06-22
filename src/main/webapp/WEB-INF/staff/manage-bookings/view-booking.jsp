<%-- 
    Document   : view-booking
    Created on : Jun 22, 2025, 12:42:39 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page import="busticket.model.StaffTicket" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="w-full px-10 mt-12">
        <h2 class="text-4xl font-bold text-orange-600 mb-8">Booking Details</h2>

        <c:if test="${not empty booking}">
            <div class="bg-white p-8 rounded-2xl shadow-xl space-y-6">

                <!-- Info Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-y-6 gap-x-10 text-gray-800 text-base">
                    <!-- Booking ID -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-ticket-alt text-orange-500 mr-1"></i>Booking ID</p>
                        <p class="font-semibold">${booking.formattedTicketId}</p>
                    </div>

                    <!-- Customer Name -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-user text-orange-500 mr-1"></i>Customer Name</p>
                        <p class="font-semibold">${booking.userName}</p>
                    </div>

                    <!-- Trip Route -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-road text-orange-500 mr-1"></i>Trip</p>
                        <p class="font-semibold">${booking.routeName}</p>
                    </div>

                    <!-- Departure Time -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-clock text-orange-500 mr-1"></i>Departure Time</p>
                        <p class="font-semibold">
                            <fmt:formatDate value="${booking.departureTime}" pattern="dd/MM/yyyy hh:mm a"/>
                        </p>
                    </div>

                    <!-- Seat Code -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-chair text-orange-500 mr-1"></i>Seat Code</p>
                        <p class="font-semibold">${booking.seatCode}</p>
                    </div>

                    <!-- Bus Type -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-bus text-orange-500 mr-1"></i>Bus Type</p>
                        <p class="font-semibold">${booking.busType}</p>
                    </div>

                    <!-- Driver -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-id-badge text-orange-500 mr-1"></i>Driver</p>
                        <p class="font-semibold">${booking.driverName}</p>
                    </div>

                    <!-- Payment Status -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-money-check text-orange-500 mr-1"></i>Payment Status</p>
                        <span class="inline-block px-3 py-1 text-sm font-medium rounded-full
                              ${booking.paymentStatus == 'Paid' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                            ${booking.paymentStatus}
                        </span>
                    </div>

                    <!-- Invoice Amount -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-money-bill-wave text-orange-500 mr-1"></i>Amount</p>
                        <p class="font-semibold">
                            <fmt:formatNumber value="${booking.invoiceAmount}" type="currency" currencySymbol="VND" groupingUsed="true" />
                        </p>
                    </div>

                    <!-- Payment Method -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-credit-card text-orange-500 mr-1"></i>Payment Method</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${not empty booking.paymentMethod}">
                                    ${booking.paymentMethod}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <!-- Paid At -->
                    <div>
                        <p class="text-gray-500 text-sm mb-1"><i class="fas fa-calendar-check text-orange-500 mr-1"></i>Paid At</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${not empty booking.paidAt}">
                                    <fmt:formatDate value="${booking.paidAt}" pattern="dd/MM/yyyy hh:mm:ss a" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="pt-6 flex flex-wrap gap-4 items-center">
                    <a href="${pageContext.request.contextPath}/staff/manage-bookings"
                       class="inline-flex items-center gap-2 bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-lg min-w-[160px] justify-center">
                        <i class="fas fa-arrow-left"></i> Back to list
                    </a>

                    <a href="${pageContext.request.contextPath}/staff/print-ticket?id=${booking.ticketId}"
                       target="_blank"
                       class="inline-flex items-center gap-2 bg-[#EF5222] hover:bg-orange-500 text-white px-6 py-3 rounded-lg min-w-[160px] justify-center">
                        <i class="fas fa-print"></i> Print Ticket
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Not Found Case -->
        <c:if test="${empty booking}">
            <div class="text-center text-gray-500 py-12">
                <p>Booking not found or invalid ID.</p>
                <a href="${pageContext.request.contextPath}/staff/manage-bookings"
                   class="bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm inline-flex items-center gap-1 mt-4">
                    <i class="fas fa-arrow-left"></i> Back to list
                </a>
            </div>
        </c:if>
    </div>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
</body>