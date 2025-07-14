<%-- 
    Document   : view-bookings
    Created on : Jun 13, 2025, 9:18:21 PM
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
                <h1 class="text-3xl font-bold">Ticket purchase history</h1>
                <p class="text-gray-500">Track and manage your ticket purchase history</p>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
                ${errorMessage}
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="bg-green-100 text-green-700 p-4 rounded mb-4">
                ${successMessage}
            </div>
        </c:if>

        <!-- Filters Form -->
        <form action="${pageContext.servletContext.contextPath}/ticket-management" method="get" class="bg-white rounded-xl shadow p-6 mb-6 grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
            <!-- Ticket Code -->
            <div>
                <label class="block text-sm font-medium mb-1">Ticket Code</label>
                <input
                    type="text"
                    placeholder="Enter Ticket Code"
                    class="w-full border rounded-lg px-3 py-2 placeholder-orange-300 focus:ring-2 focus:ring-orange-200"
                    name="ticketCode" value="${ticketCode}" />
            </div>

            <!-- Route -->
            <div>
                <label class="block text-sm font-medium mb-1">Route</label>
                <select name="route" class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200">
                    <option value="">All Routes</option>
                    <c:forEach var="location" items="${locations}">
                        <option value="${location}" ${location == param.route ? 'selected' : ''}>${location}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Status -->
            <div>
                <label class="block text-sm font-medium mb-1">Status</label>
                <select name="status" class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200">
                    <option value="">All</option>
                    <option value="Paid" ${status == 'Paid' ? 'selected' : ''}>Paid</option>
                    <option value="Expires" ${status == 'Expires' ? 'selected' : ''}>Expires</option>
                    <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>

            <!-- Find Button -->
            <div>
                <button type="submit" class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg">
                    Find
                </button>
            </div>
        </form>

        <!-- Table -->
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Ticket Code</th>
                        <th class="px-4 py-2">Tickets</th>
                        <th class="px-4 py-2">Route</th>
                        <th class="px-4 py-2">Date of departure</th>
                        <th class="px-4 py-2">Amount of money</th>
                        <th class="px-4 py-2">Payment</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Actions</th>
                    </tr>
                </thead>

                <tbody>

                    <c:forEach var="invoice" items="${invoicesList}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2"><a href="${pageContext.servletContext.contextPath}/ticket-management?detail=${invoice.invoiceId}">${invoice.invoiceCode}</a></td>
                            <td class="px-4 py-2">${invoice.ticketCount}</td>
                            <td class="px-4 py-2">${invoice.route}</td>
                            <td class="px-4 py-2">${invoice.departureTime}</td> 
                            <td class="px-4 py-2"><fmt:formatNumber value="${invoice.invoiceTotalAmount}" pattern="#,##0 ₫"/></td>
                            <td class="px-4 py-2">${invoice.paymentMethod}</td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${invoice.invoiceStatus == 'Paid'}">
                                        <span class="bg-green-500 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:when test="${invoice.invoiceStatus == 'Expires'}">
                                        <span class="bg-red-500 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:when test="${invoice.invoiceStatus == 'Cancelled'}">
                                        <span class="bg-gray-500 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bg-gray-500 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-2">
                                <c:if test="${invoice.invoiceStatus == 'Paid' && invoice.departureTime != null && invoice.departureTime.time <= now.time}">
                                    <a href="${pageContext.request.contextPath}/ticket-management?review=${invoice.invoiceId}">
                                        <button class="inline-block px-2 py-1 rounded-full bg-orange-500 hover:bg-orange-600 text-white text-sm font-semibold transition">
                                            ${invoice.reviewed ? "Edit Review" : "Review"}
                                        </button>
                                    </a>
                                </c:if>

                                <c:if test="${invoice.invoiceStatus == 'Paid' && (invoice.departureTime != null && (invoice.departureTime.time - now.time) > 86400000)}">
                                    <a href="${pageContext.servletContext.contextPath}/ticket-management?cancel=${invoice.invoiceId}">
                                        <button class="inline-block px-2 py-1 rounded-full bg-gray-300 hover:bg-gray-400 text-gray-800 text-sm font-semibold transition">
                                            Cancel
                                        </button>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                        <c:if test="${empty invoicesList}">
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


        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination currentPage="${currentPage}" totalPages="${totalPages}" url="${baseUrl}" />
        </div>

    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>