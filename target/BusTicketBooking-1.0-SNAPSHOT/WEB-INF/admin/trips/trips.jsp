<%-- 
    Document   : trips
    Created on : Jun 11, 2025, 1:19:08 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/trips"/>

<c:if test="${not empty param.route}">
    <c:set var="baseUrl"
           value="${baseUrl}?route=${fn:escapeXml(param.route)}"/>
</c:if>
<c:if test="${not empty param.busType}">
    <c:set var="baseUrl"
           value="${baseUrl}${param.route!=null?'&':'?'}busType=${fn:escapeXml(param.busType)}"/>
</c:if>
<c:if test="${not empty param.driver}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.route!=null||param.busType!=null)?'&':'?'}driver=${fn:escapeXml(param.driver)}"/>
</c:if>


<body class="bg-gray-50">
    <div class="mt-10 px-4">
        <!-- Header + Create Button -->
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-[#EF5222]">Manage Trips</h2>
            <a href="${pageContext.servletContext.contextPath}/admin/trips?add"><button
                    class="bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg flex items-center gap-2"
                    >
                    <i class="fas fa-plus"></i>
                    Create New Trip
                </button></a>
        </div>

        <!-- Filters -->
        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-6">
            <form action="${pageContext.servletContext.contextPath}/admin/trips" method="get" class="flex gap-4">
                <select class="border border-gray-300 rounded-lg px-4 py-2" name="route">
                    <option value="">All Routes</option>
                    <option value="HCM → Can Tho">HCM → Can Tho</option>
                    <option value="Can Tho → Chau Doc">Can Tho → Chau Doc</option>
                    <option value="Hue → Da Nang">Hue → Da Nang</option>
                </select>

                <select class="border border-gray-300 rounded-lg px-4 py-2" name="busType">
                    <option value="">All Bus Types</option>
                    <option value="Seat">Seat</option>
                    <option value="Bunk">Bunk</option>
                    <option value="Limousine">Limousine</option>
                </select>

                <select class="border border-gray-300 rounded-lg px-4 py-2" name="driver">
                    <option value="">All Drivers</option>
                    <option value="Driver 1">Driver 1</option>
                    <option value="Driver 2">Driver 2</option>
                    <option value="Driver 3">Driver 3</option>
                </select>

                <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    Filter
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
                            <td class="py-2 px-4">${trip.status}</td>
                            <td class="py-2 px-4">
                                <a href="${pageContext.servletContext.contextPath}/admin/trips?editId=${trip.tripId}" class="text-blue-600 hover:underline">Edit</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>

    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>