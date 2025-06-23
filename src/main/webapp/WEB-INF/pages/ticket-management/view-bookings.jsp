<%-- 
    Document   : view-bookings
    Created on : Jun 13, 2025, 9:18:21 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        <div class="overflow-x-auto">
            <table class="min-w-full bg-white rounded-xl overflow-hidden">
                <thead class="bg-orange-100 text-left">
                    <tr>
                        <th class="px-4 py-3 font-medium">Ticket Code</th>
                        <th class="px-4 py-3 font-medium">Tickets</th>
                        <th class="px-4 py-3 font-medium">Route</th>
                        <th class="px-4 py-3 font-medium">Date of departure</th>
                        <th class="px-4 py-3 font-medium">Amount of money</th>
                        <th class="px-4 py-3 font-medium">Payment</th>
                        <th class="px-4 py-3 font-medium">Status</th>
                        <th class="px-4 py-3 font-medium">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <c:forEach var="invoice" items="${invoicesList}">
                        <tr>
                            <td class="px-4 py-3">${invoice.invoiceCode}</td>
                            <td class="px-4 py-3">${invoice.ticketCount}</td>
                            <td class="px-4 py-3">${invoice.route}</td>
                            <td class="px-4 py-3">${invoice.departureTime}</td> 
                            <td class="px-4 py-3">${invoice.invoiceTotalAmount}₫</td>
                            <td class="px-4 py-3">${invoice.paymentMethod}</td>
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${invoice.invoiceStatus == 'Paid'}">
                                        <span class="bg-green-100 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:when test="${invoice.invoiceStatus == 'Expires'}">
                                        <span class="bg-red-100 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:when test="${invoice.invoiceStatus == 'Cancelled'}">
                                        <span class="bg-gray-100 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bg-gray-200 text-white text-xs px-2 py-1 rounded-full">${invoice.invoiceStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3">
                                <a href="${pageContext.servletContext.contextPath}/ticket-management?cancel=${invoice.invoiceId}"><button class="bg-gray-200 hover:bg-gray-300 text-gray-700 text-sm px-3 py-1 rounded-full">
                                    Cancel
                                    </button></a>
                            </td>
                        </tr>
                    </c:forEach>
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