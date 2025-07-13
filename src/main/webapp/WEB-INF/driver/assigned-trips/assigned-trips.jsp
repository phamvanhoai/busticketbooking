<%-- 
    Document   : assigned-trips
    Created on : Jun 13, 2025, 10:48:20 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/driver/assigned-trips"/>

<!-- Add route filter if exists -->
<c:if test="${not empty param.route}">
    <c:set var="baseUrl"
           value="${baseUrl}?route=${fn:escapeXml(param.route)}"/>
</c:if>

<!-- Add busType filter if exists -->
<c:if test="${not empty param.status}">
    <c:set var="baseUrl"
           value="${baseUrl}${param.route!=null?'&':'?'}status=${fn:escapeXml(param.status)}"/>
</c:if>

<!-- Add driver filter if exists -->
<c:if test="${not empty param.date}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.route!=null || param.status!=null)?'&':'?'}date=${fn:escapeXml(param.date)}"/>
</c:if>

<!-- Lấy thời gian hiện tại -->
<jsp:useBean id="now" class="java.util.Date"/>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <!-- Tiêu đề -->
        <h1 class="text-3xl font-bold text-orange-600">Assigned Trips</h1>

        <!-- Display error messages if there are any -->
        <c:choose>
            <c:when test="${not empty success}">
                <div class="bg-green-100 text-green-700 p-4 rounded mb-4">
                    ${success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:when>
            <c:when test="${not empty error}">
                <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
                    ${error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:when>
        </c:choose>

        <!-- Bộ lọc -->
        <div class="flex flex-wrap gap-4">
            <form action="${pageContext.request.contextPath}/driver/assigned-trips" method="get" class="w-full flex flex-wrap gap-4">
                <input
                    type="date"
                    name="date"
                    class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                    placeholder="Select date"
                    value="${param.date}"
                    />
                <select
                    name="route"
                    class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                    >
                    <option value="">All Routes</option>
                    <c:forEach var="location" items="${locations}">
                        <option value="${location}" ${location == param.route ? 'selected' : ''}>${location}</option>
                    </c:forEach>
                </select>
                <select
                    name="status"
                    class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                    >
                    <option value="">All Statuses</option>
                    <option value="Scheduled" ${param.status == 'Scheduled' ? 'selected' : ''}>Scheduled</option>
                    <option value="Ongoing" ${param.status == 'Ongoing' ? 'selected' : ''}>Ongoing</option>
                    <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
                <button
                    type="submit"
                    class="w-full md:w-auto bg-orange-500 text-white rounded-lg px-6 py-2 hover:bg-orange-600"
                    >
                    Filter
                </button>

                <!-- Reset button -->
                <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips">
                    <button type="button" class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                        <i class="fas fa-sync-alt"></i>
                        Reset Filters
                    </button>
                </a>
            </form>
        </div>


        <!-- Bảng Assigned Trips -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-600">
                    <tr>
                        <th class="px-6 py-3">Trip ID</th>
                        <th class="px-6 py-3">Date</th>
                        <th class="px-6 py-3">Time</th>
                        <th class="px-6 py-3">Route</th>
                        <th class="px-6 py-3">Bus Type</th>
                        <th class="px-6 py-3">Driver</th>
                        <th class="px-6 py-3">Status</th>
                        <th class="px-6 py-3">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <c:forEach var="trip" items="${assignedTrips}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4">${trip.tripId}</td>
                            <td class="px-6 py-4">${trip.date}</td>
                            <td class="px-6 py-4">${trip.time}</td>
                            <td class="px-6 py-4">${trip.route}</td>
                            <td class="px-6 py-4">${trip.busType}</td>
                            <td class="px-6 py-4">${trip.driver}</td>
                            <td class="px-6 py-4">
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
                            <td class="px-6 py-4 space-x-2">
                                <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?roll-call=${trip.tripId}">
                                    <button class="text-blue-600 hover:underline text-sm">Roll call</button>
                                </a>
                                <c:choose>
                                    <c:when test="${trip.status == 'Scheduled' && trip.departureTime <= now}">
                                        <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?start=${trip.tripId}">
                                            <button onclick="return confirm('Bạn có chắc chắn muốn bắt đầu chuyến đi?')" class="text-gray-600 hover:underline text-sm">Start</button>
                                        </a>
                                    </c:when>
                                    <c:when test="${trip.status == 'Ongoing'}">
                                        <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?end=${trip.tripId}">
                                            <button onclick="return confirm('Bạn có chắc chắn muốn kết thúc chuyến đi?')" class="text-gray-600 hover:underline text-sm">End</button>
                                        </a>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <!-- No data case if list is empty -->
                    <c:if test="${empty assignedTrips}">
                        <tr>
                            <td colspan="8" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">
                                        No trips found for your filter.
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
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

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
