<%-- 
    Document   : booking-statistics
    Created on : Jun 19, 2025, 1:45:51 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<div class="max-w-7xl mx-auto px-4 py-6">

    <h1 class="text-2xl font-bold mb-4 text-orange-600">Booking Statistics</h1>

    <!-- Filter form -->
    <form method="get" action="booking-statistics" class="flex flex-wrap items-center gap-4 mb-6">

        <!-- Keyword search -->
        <input type="text" name="q" value="${fn:escapeXml(q)}" placeholder="Search by Booking ID or Customer"
               class="flex-grow min-w-[250px] border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />

        <!-- Route filter -->
        <select name="route" class="w-[200px] border rounded-lg px-4 py-2 focus:outline-orange-500">
            <option value="">All Routes</option>
            <c:forEach var="route" items="${allRoutes}">
                <option value="${route}" <c:if test="${route == routeKeyword}">selected</c:if>>${route}</option>
            </c:forEach>
        </select>

        <!-- Driver -->
        <input type="text" name="driver" value="${fn:escapeXml(driver)}" placeholder="Driver Name"
               class="w-[180px] border rounded-lg px-4 py-2 focus:outline-orange-500" />

        <!-- Date -->
        <input type="date" name="date" value="${date}" class="w-[160px] border rounded-lg px-4 py-2 focus:outline-orange-500" />

        <!-- Status -->
        <select name="status" class="w-[160px] border rounded-lg px-4 py-2 focus:outline-orange-500">
            <option value="">All Statuses</option>
            <option value="PAID" <c:if test="${status == 'PAID'}">selected</c:if>>PAID</option>
            <option value="UNPAID" <c:if test="${status == 'UNPAID'}">selected</c:if>>UNPAID</option>
        </select>

        <!-- Button -->
        <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
            <i class="fas fa-search"></i> Filter
        </button>

        <a href="booking-statistics" class="text-sm text-orange-600 underline hover:opacity-80">Reset</a>
    </form>

    <!-- Loading spinner (optional) -->
    <div id="loading-spinner" class="flex justify-center items-center py-4 hidden">
        <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
        </svg>
        <span class="ml-3 text-gray-600">Loading statistics...</span>
    </div>

    <!-- Statistics Table -->
    <div class="overflow-x-auto shadow-sm border rounded-lg">
        <table class="min-w-full text-sm text-left text-gray-700">
            <thead class="bg-orange-100 font-semibold text-gray-800">
                <tr>
                    <th class="px-4 py-2">#</th>
                    <th class="px-4 py-2">Booking ID</th>
                    <th class="px-4 py-2">Customer</th>
                    <th class="px-4 py-2">Route</th>
                    <th class="px-4 py-2">Departure</th>
                    <th class="px-4 py-2">Seat</th>
                    <th class="px-4 py-2">Driver</th>
                    <th class="px-4 py-2">Amount</th>
                    <th class="px-4 py-2">Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${stats}" varStatus="loop">
                    <tr class="border-b hover:bg-orange-50 transition">
                        <td class="px-4 py-2">${(currentPage - 1) * 10 + loop.index + 1}</td>
                        <td class="px-4 py-2 font-medium">${s.invoiceCode}</td>
                        <td class="px-4 py-2">${s.customerName}</td>
                        <td class="px-4 py-2">${s.routeName}</td>
                        <td class="px-4 py-2">
                            <fmt:formatDate value="${s.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                        <td class="px-4 py-2">${s.seatCode}</td>
                        <td class="px-4 py-2">${s.driverName}</td>
                        <td class="px-4 py-2 text-right font-semibold">
                            <fmt:formatNumber value="${s.invoiceAmount}" type="currency" currencySymbol="VND" />
                        </td>
                        <td class="px-4 py-2">
                            <span class="px-2 py-1 rounded-full text-xs font-medium
                                ${s.paymentStatus == 'PAID' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                                ${s.paymentStatus}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stats}">
                    <tr><td colspan="9" class="text-center py-6 text-gray-500">No booking statistics found.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Summary -->
    <div class="flex justify-between mt-4 text-sm text-gray-700">
        <div>Total records: <span class="font-semibold">${totalRecords}</span></div>
        <div>Total amount: 
            <span class="font-semibold text-orange-600">
                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VND" />
            </span>
        </div>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center mt-6">
        <fbus:adminpagination 
            currentPage="${currentPage}" 
            totalPages="${totalPages}" 
            url="booking-statistics?q=${q}&route=${route}&driver=${driver}&status=${status}&date=${date}" />
    </div>

</div>

            <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>