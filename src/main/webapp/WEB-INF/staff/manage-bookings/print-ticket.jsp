<%-- 
    Document   : print-ticket
    Created on : Jun 22, 2025, 5:25:47 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="busticket.model.StaffTicket" %>

<%@include file="/WEB-INF/include/header.jsp" %>

<!-- Custom print styles to hide unnecessary UI elements and format the print layout -->
<style>
    @media print {
        .no-print,             /* Elements marked as 'no-print' will not be shown when printing */
        header,                /* Hide header/navbar during print */
        footer,                /* Hide footer during print */
        .navbar, .nav,         /* Optional: hide navigation if exists */
        .page-footer,          /* Optional: hide page footer if exists */
        .copyright,
        .pagination,           /* Hide pagination numbers */
        .print-hide {          /* Additional class to hide during print if needed */
            display: none !important;
        }

        body {
            margin: 0;
            padding: 0;
        }

        @page {
            size: A4 portrait; /* Set print page size to A4 */
            margin: 20mm;
        }
    }
</style>

<title>Print Ticket</title>

<body class="bg-white w-full px-10 mt-12 text-gray-800">

    <!-- Ticket container -->
    <div class="max-w-3xl mx-auto bg-white p-10 rounded-2xl shadow-xl border border-gray-200">
        <h2 class="text-4xl font-bold text-orange-600 text-center mb-10">FBUS - Booking Ticket</h2>

        <!-- Ticket details in grid layout -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-6 text-base">

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

            <!-- Trip route -->
            <div>
                <p class="text-gray-500 text-sm mb-1"><i class="fas fa-road text-orange-500 mr-1"></i>Trip</p>
                <p class="font-semibold">${booking.routeName}</p>
            </div>

            <!-- Departure Time -->
            <div>
                <p class="text-gray-500 text-sm mb-1"><i class="fas fa-clock text-orange-500 mr-1"></i>Departure Time</p>
                <p class="font-semibold">
                    <fmt:formatDate value="${booking.departureTime}" pattern="dd/MM/yyyy hh:mm a" />
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

            <!-- Driver Name -->
            <div>
                <p class="text-gray-500 text-sm mb-1"><i class="fas fa-id-badge text-orange-500 mr-1"></i>Driver</p>
                <p class="font-semibold">${booking.driverName}</p>
            </div>

            <!-- Payment Status -->
            <div>
                <p class="text-gray-500 text-sm mb-1"><i class="fas fa-money-check text-orange-500 mr-1"></i>Payment Status</p>
                <span class="inline-flex items-center gap-2 px-3 py-1 text-sm font-medium rounded-full
                      ${booking.paymentStatus == 'Paid' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                    <i class="fas ${booking.paymentStatus == 'Paid' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                    ${booking.paymentStatus}
                </span>

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

            <!-- Paid At (timestamp of successful payment) -->
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

            <!-- Invoice Amount -->
            <div class="md:col-span-2">
                <p class="text-gray-500 text-sm mb-1"><i class="fas fa-money-bill-wave text-orange-500 mr-1"></i>Amount</p>
                <p class="font-semibold text-lg">
                    <fmt:formatNumber value="${booking.invoiceAmount}" type="currency" currencySymbol="VND" groupingUsed="true" />
                </p>
            </div>
        </div>

        <!-- Action buttons: Print and Back (hidden in print) -->
        <div class="mt-10 text-center no-print">
            <button onclick="window.print()" class="bg-[#EF5222] hover:bg-orange-500 text-white px-6 py-2 rounded-lg">
                <i class="fas fa-print mr-2"></i>Print Ticket
            </button>
            <a href="${pageContext.request.contextPath}/staff/manage-bookings"
               class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-2 rounded-lg">
                <i class="fas fa-arrow-left"></i><span class="ml-2">Back to list</span>
            </a>
        </div>
    </div>

</body>

<%@include file="/WEB-INF/include/footer.jsp" %>
