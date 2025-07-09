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
                    <c:forEach var="location" items="${locations}">
                        <option value="${location}" ${location == param.route ? 'selected' : ''}>${location}</option>
                    </c:forEach>
                </select>

                <select class="border border-gray-300 rounded-lg px-4 py-2" name="busType">
                    <option value="">All Bus Types</option>
                    <c:forEach var="busType" items="${busTypes}">
                        <option value="${busType}" ${busType == param.busType ? 'selected' : ''}>${busType}</option>
                    </c:forEach>
                </select>

                <select class="border border-gray-300 rounded-lg px-4 py-2" name="driver">
                    <option value="">All Drivers</option>
                    <c:forEach var="driver" items="${drivers}">
                        <option value="${driver.userName}" ${driver.userName == param.driver ? 'selected' : ''}>${driver.userName}</option>
                    </c:forEach>
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
                            <td class="py-2 px-4">
                                <c:choose>
                                    <c:when test="${trip.status == 'Cancelled'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                            Cancelled
                                        </span>
                                    </c:when>
                                    <c:when test="${trip.status == 'Scheduled'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                            Scheduled
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
                                <a href="${pageContext.servletContext.contextPath}/admin/trips?detail=${trip.tripId}" class="text-blue-600 hover:underline flex items-center gap-1">
                                    <i class="fas fa-eye"></i> View</a>
                                <a href="${pageContext.servletContext.contextPath}/admin/trips?editId=${trip.tripId}" class="text-blue-600 hover:underline flex items-center gap-1">
                                    <i class="fas fa-edit"></i> Edit</a>
                                <a href="${pageContext.servletContext.contextPath}/admin/trips?delete=${trip.tripId}" class="text-red-600 hover:underline flex items-center gap-1">
                                    <i class="fas fa-trash-alt"></i> Delete</a>
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