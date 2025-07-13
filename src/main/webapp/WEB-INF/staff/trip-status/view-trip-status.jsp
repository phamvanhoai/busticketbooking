<%-- 
    Document   : view-trip-status
    Created on : Jun 14, 2025, 11:28:48 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<body class="bg-[#f9fafb]">
    <div class="p-8">
        <h1 class="text-3xl font-bold text-orange-600 mb-6">View Trip Status</h1>

        <!-- Filter Form -->
        <div class="flex flex-wrap items-center gap-4 mb-4">
            <form action="${pageContext.request.contextPath}/staff/trip-status" method="get" class="flex gap-4">
                <!-- Route Filter -->
                <select name="route" class="border p-2 rounded-md w-64">
                    <option value="">All Routes</option>
                    <c:forEach var="location" items="${locations}">
                        <option value="${location}" ${location == param.route ? 'selected' : ''}>${location}</option>
                    </c:forEach>
                </select>

                <!-- Status Filter -->
                <select name="status" class="border p-2 rounded-md w-64">
                    <option value="">All Statuses</option>
                    <option value="Scheduled" ${'Scheduled' == param.status ? 'selected' : ''}>Scheduled</option>
                    <option value="Departed" ${'Departed' == param.status ? 'selected' : ''}>Departed</option>
                    <option value="Arrived" ${'Arrived' == param.status ? 'selected' : ''}>Arrived</option>
                    <option value="Cancelled" ${'Cancelled' == param.status ? 'selected' : ''}>Cancelled</option>
                </select>

                <!-- Driver Filter -->
                <select name="driver" class="border p-2 rounded-md w-64">
                    <option value="">All Drivers</option>
                    <c:forEach var="driver" items="${drivers}">
                        <option value="${driver.userName}" ${driver.userName == param.driver ? 'selected' : ''}>${driver.userName}</option>
                    </c:forEach>
                </select>

                <!-- Submit Button -->
                <button type="submit" class="bg-orange-500 text-white px-4 py-2 rounded-md inline-flex items-center gap-2">
                    Search
                </button>
            </form>
        </div>

        <!-- Trip Table -->
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-4">Trip ID</th>
                        <th class="py-2 px-4">Route</th>
                        <th class="py-2 px-4">Date</th>
                        <th class="py-2 px-4">Time</th>
                        <th class="py-2 px-4">Bus Type</th>
                        <th class="py-2 px-4">Driver</th>
                        <th class="py-2 px-4">Status</th>
                        <th class="py-2 px-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="trip" items="${trips}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="py-2 px-4">${trip.tripId}</td>
                            <td class="py-2 px-4">${trip.route}</td>
                            <td class="py-2 px-4">${trip.tripDate}</td>
                            <td class="py-2 px-4">${trip.tripTime}</td>
                            <td class="py-2 px-4">${trip.busType}</td>
                            <td class="py-2 px-4">${trip.driver}</td>
                            <td class="py-2 px-4">
                                
                                <c:choose>
                                    <c:when test="${trip.status == 'Cancelled'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                            Cancelled
                                        </span>
                                    </c:when>
                                    <c:when test="${trip.status == 'Ongoing'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-blue-100 text-blue-700">
                                            Ongoing
                                        </span>
                                    </c:when>
                                    <c:when test="${trip.status == 'Completed'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                            Completed
                                        </span>
                                    </c:when>
                                    <c:when test="${trip.status == 'Pending'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-yellow-100 text-yellow-700">
                                            Pending
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-gray-100 text-gray-700">
                                            ${trip.status}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4 flex items-center gap-3">
                                <a href="${pageContext.request.contextPath}/staff/trip-status?detail=${trip.tripId}" class="text-blue-600 hover:underline flex items-center gap-1">
                                    <i class="fas fa-eye"></i> View</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>