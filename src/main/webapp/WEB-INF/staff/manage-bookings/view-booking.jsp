<%-- 
    Document   : view-booking
    Created on : Jun 22, 2025, 12:42:39 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page import="java.util.List" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.util.Base64" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.EncodeHintType" %>
<%@ page import="com.google.zxing.MultiFormatWriter" %>
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="busticket.model.StaffTicket" %>
<%@ page import="busticket.model.StaffBookingInfo" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="mt-12 px-4 w-full max-w-full mx-auto">

        <div class="flex justify-between items-center mb-8 px-4 max-w-full mx-auto">
            <a href="${pageContext.request.contextPath}/staff/manage-bookings"
               class="bg-gray-200 text-gray-700 px-4 py-2 rounded hover:bg-gray-300 flex items-center gap-2">
                <i class="fas fa-arrow-left"></i> Back to list
            </a>

            <a href="${pageContext.request.contextPath}/staff/print-ticket?id=${bookingInfo.invoiceId}"
               target="_blank"
               class="bg-[#EF5222] text-white px-4 py-2 rounded hover:bg-orange-700 flex items-center gap-2">
                <i class="fas fa-print"></i> Print Ticket
            </a>
        </div>

        <h2 class="text-3xl font-bold text-orange-600 mb-6">Booking Details</h2>
        <c:if test="${not empty bookingInfo}">
            <div class="bg-white rounded-lg shadow-lg p-6 mb-8 border border-orange-300">
                <div class="grid grid-cols-2 gap-12">
                    <!-- Left column -->
                    <div class="space-y-8">
                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-l-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-6a2 2 0 012-2h4" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 17h10M7 13h4" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V9a2 2 0 012-2z" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Invoice Code</p>
                                <p class="text-gray-900 font-bold text-lg">${bookingInfo.invoiceCode}</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-l-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10m-10 4h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Booking Date</p>
                                <p class="text-gray-900 font-bold text-lg"><fmt:formatDate value="${bookingInfo.bookingDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-l-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.38 0-2.5 1.12-2.5 2.5S10.62 13 12 13s2.5-1.12 2.5-2.5S13.38 8 12 8z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v4m0 0H9m3 0h3" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Total Amount</p>
                                <p class="text-orange-700 font-extrabold text-xl">
                                    <fmt:formatNumber value="${bookingInfo.totalAmount}" type="currency" currencySymbol="VND"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Right column -->
                    <div class="space-y-8">
                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-r-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 15c2.946 0 5.658 1.007 7.879 2.804M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Customer</p>
                                <p class="text-gray-900 font-bold text-lg">${bookingInfo.customerName}</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-r-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Status</p>
                                <p class="text-green-600 font-extrabold text-xl">${bookingInfo.paymentStatus}</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4 bg-gradient-to-r from-orange-50 to-orange-100 p-4 rounded shadow-sm border-r-4 border-orange-400 hover:shadow-md transition-shadow duration-300 cursor-default">
                            <div class="flex items-center justify-center w-10 h-10 bg-orange-200 rounded-full text-white">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M9 15h6m-6 4h6" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-orange-600 font-semibold text-sm uppercase tracking-wide">Payment Method</p>
                                <p class="text-orange-700 font-extrabold text-xl">
                                    <c:out value="${bookingInfo.paymentMethod != null ? bookingInfo.paymentMethod : 'N/A'}"/>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <h3 class="text-xl font-bold mb-4">Tickets in this Booking</h3>

        <div class="bg-white rounded-lg shadow overflow-x-auto">
            <table class="min-w-full text-left text-sm">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-2 w-20">No.</th>
                        <th class="py-2 px-2 ">Route</th>
                        <th class="py-2 px-2">Departure</th>
                        <th class="py-2 px-2">Seat</th>
                        <th class="py-2 px-2">Driver</th>
                        <th class="py-2 px-2">Bus Type</th>
                        <th class="py-2 px-2 w-36">QR Code</th>
                        <th class="py-2 px-2 w-36">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ticket" items="${ticketDetails}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="py-2 px-4">${ticket.stt}</td>
                            <td class="py-2 px-4">${ticket.routeName}</td>
                            <td class="py-2 px-4">
                                <fmt:formatDate value="${ticket.departureTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td class="py-2 px-4">${ticket.seatCode}</td>
                            <td class="py-2 px-4">${ticket.driverName}</td>
                            <td class="py-2 px-4">${ticket.busType}</td>
                            <td class="py-2 px-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty ticket.qrCodeBase64}">
                                        <img src="data:image/png;base64,${ticket.qrCodeBase64}" alt="QR Code" style="width:100px; height:100px;"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span>QR error</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="py-2 px-4 whitespace-nowrap">
                                <button type="button" class="px-3 py-1 bg-orange-500 text-white rounded hover:bg-orange-600"
                                        onclick="downloadQRCode('${ticket.qrCodeBase64}', 'ticket_${ticket.ticketId}.png')">Download</button>
                                <button type="button" class="px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 ml-2"
                                        onclick="shareTicket('${ticket.ticketId}')">Share</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty ticketDetails}">
                        <tr>
                            <td colspan="10" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">No tickets found for this booking.</span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination component using custom tag -->
        <div class="flex justify-center space-x-3 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${numOfPages}"
                url="${baseUrlWithSearch}" />
        </div>

    </div>
    <script>
        function downloadQRCode(base64Data, filename) {
            if (!base64Data) {
                alert('QR Code not available');
                return;
            }
            var link = document.createElement('a');
            link.href = 'data:image/png;base64,' + base64Data;
            link.download = filename;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function shareTicket(ticketId) {
            const text = 'Here is my ticket ID: ' + ticketId;
            if (navigator.share) {
                navigator.share({
                    title: 'Ticket',
                    text: text
                }).catch(console.error);
            } else {
                navigator.clipboard.writeText(text).then(() => {
                    alert('Ticket ID copied to clipboard: ' + ticketId);
                });
            }
        }
    </script>

    <%@ include file="/WEB-INF/include/staff/staff-footer.jsp" %>
</body>