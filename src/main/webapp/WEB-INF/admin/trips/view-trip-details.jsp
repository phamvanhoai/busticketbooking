<%-- 
    Document   : view-trip-details
    Created on : Jun 16, 2025, 4:41:29 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-100 min-h-screen">
    <div class="px-4 py-8 space-y-6">

        <!-- Header -->
        <header class="flex flex-col md:flex-row justify-between items-start md:items-center bg-white p-6 rounded-xl shadow">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Trip Details</h1>
                <p class="text-gray-600 mt-1">
                    Trip ID: <span class="font-medium">${trip.tripId}</span>
                </p>
            </div>
            <span class="mt-4 md:mt-0 inline-block px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-medium">
                ${trip.status}
            </span>
        </header>

        <!-- Basic Information -->
        <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Route</p>
                <p class="font-semibold text-gray-800">${trip.route}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Departure</p>
                <p class="font-semibold text-gray-800">
                    ${trip.tripDate} ${trip.tripTime}
                </p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Arrival Time</p>
                <p class="font-semibold text-gray-800">${trip.arrivalDate} ${trip.arrivalTime}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Duration</p>
                <p class="font-semibold text-gray-800">
                    <c:set var="et" value="${trip.duration}" />
                    <c:set var="h" value="${fn:substringBefore(et / 60, '.')}" />
                    <c:set var="m" value="${et % 60}" />
                    <c:choose>
                        <c:when test="${h > 0 && m > 0}">
                            ${h}h${m}m
                        </c:when>
                        <c:when test="${h > 0}">
                            ${h}h
                        </c:when>
                        <c:otherwise>
                            ${m}m
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Driver</p>
                <p class="font-semibold text-gray-800">${trip.driver != null ? trip.driver : 'Not Assigned'}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Bus Type</p>
                <p class="font-semibold text-gray-800">${trip.busType}</p>
            </div>
            
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Plate Number</p>
                <p class="font-semibold text-gray-800">${trip.plateNumber}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Bus Code</p>
                <p class="font-semibold text-gray-800">${trip.busCode}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Seats</p>
                <p class="font-semibold text-gray-800">${trip.bookedSeats} / ${trip.capacity}</p>
            </div>
            <div class="bg-white p-4 rounded-xl shadow">
                <p class="text-xs text-gray-500">Status</p>
                <p class="font-semibold text-gray-800">${trip.status}</p>
            </div>
        </section>

        <!-- Route Stops: Full List -->
        <section class="bg-white p-6 rounded-xl shadow">
            <h2 class="text-lg font-semibold text-gray-800 mb-4">Route Stops</h2>
            <div class="space-y-6">
                <c:if test="${empty stops}">
                    <div class="p-4 bg-red-100 text-red-700 rounded mb-4">
                        Không có dữ liệu Route Stops (stops rỗng/null)!<br>
                        Hãy kiểm tra lại Controller truyền stops xuống.
                    </div>
                </c:if>
                <c:forEach var="stop" items="${stops}" varStatus="status">
                    <div class="flex items-start">
                        <div class="flex flex-col items-center">
                            <div class="w-3 h-3
                                 <c:choose>
                                     <c:when test="${status.first}">bg-orange-500</c:when>
                                     <c:when test="${status.last}">bg-gray-400</c:when>
                                     <c:otherwise>bg-green-400</c:otherwise>
                                 </c:choose>
                                 rounded-full mt-1"></div>
                            <c:if test="${!status.last}">
                                <div class="flex-1 border-l-2 border-gray-200"></div>
                            </c:if>
                        </div>
                        <div class="ml-4">
                            <p class="font-medium text-gray-800">
                                ${stopTimes[status.index]} – ${stop.locationName}
                            </p>
                            <p class="text-sm text-gray-500">
                                ${stop.address}
                            </p>
                            <c:if test="${stop.dwellMinutes > 0}">
                                <p class="text-sm text-gray-500">
                                    Dwell: ${stop.dwellMinutes}m
                                </p>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Passenger List -->
        <section class="bg-white p-6 rounded-xl shadow">
            <h2 class="text-lg font-semibold text-gray-800 mb-4">Passenger List</h2>
            <ul class="divide-y divide-gray-200">
                <c:forEach var="p" items="${passengers}">
                    <li class="py-3 flex justify-between items-center">
                        <span class="text-gray-700">${p.name}</span>
                        <span class="text-gray-500">Seat: ${p.seatNumber}</span>
                        <a href="${pageContext.request.contextPath}/admin/users/view?id=${p.user_id}"
                           class="text-blue-600 text-sm hover:underline">View Profile</a>
                    </li>
                </c:forEach>
            </ul>
        </section>

        <!-- Actions -->
        <div class="mt-6 flex justify-end gap-4">
            <a href="${pageContext.request.contextPath}/admin/trips">
                <button type="button"
                        class="px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">
                    Back to trips
                </button>
            </a>
        </div>

    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>