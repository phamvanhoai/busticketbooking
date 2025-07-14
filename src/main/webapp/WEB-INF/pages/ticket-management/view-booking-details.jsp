<%-- 
    Document   : view-booking-details
    Created on : Jul 14, 2025, 11:50:53 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>


<body class="bg-[#fff6f3] min-h-screen">
    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <!-- Header -->
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
            <div>
                <h1 class="text-3xl text-orange-600 font-bold">Ticket details</h1>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/ticket-management"
           class="bg-gray-200 text-gray-700 px-2 py-1 rounded hover:bg-gray-300 flex items-center gap-2 w-40">
            <i class="fas fa-arrow-left"></i> Back to list
        </a><br>


        <h2 class="text-lg font-bold text-gray-800">Order ID: #${invoice.invoiceCode}</h2>
        <div class="mt-4 text-gray-600">
            <p><span class="font-semibold">Customer:</span> ${invoice.customerName}</p>
            <p><span class="font-semibold">Customer Phone</span>  ${invoice.customerPhone}</p>
            <p><span class="font-semibold">Date:</span> 
                <fmt:formatDate value="${invoice.paidAt}" pattern="yyyy-MM-dd HH:mm" />
            </p>
            <p><span class="font-semibold">Total Amount:</span> ${invoice.invoiceTotalAmount} ₫</p>
            <p><span class="font-semibold">Payment Status:</span> ${invoice.invoiceStatus}</p>
            <p><span class="font-semibold">Route:</span> ${invoice.route}</p>
            <p><span class="font-semibold">Departure Time:</span> 
                <fmt:formatDate value="${invoice.departureTime}" pattern="yyyy-MM-dd HH:mm" />
            </p>
        </div><br>

        <!-- Table -->
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Ticket Code</th>
                        <th class="px-4 py-2">Seat Number</th>
                        <th class="px-4 py-2">Ticket Status</th>
                        <th class="px-4 py-2">Departure Time</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="ticket" items="${tickets}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2">${ticket.ticketCode}</td>
                            <td class="px-4 py-2">${ticket.seatNumber}</td>
                            <td class="px-4 py-2">${ticket.ticketStatus}</td>
                            <td class="px-4 py-2"><fmt:formatDate value="${ticket.departureTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
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
                                    <span class="text-sm text-gray-500 font-medium">No invoices found.</span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>