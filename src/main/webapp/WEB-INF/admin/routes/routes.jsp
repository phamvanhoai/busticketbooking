<%-- 
   Document   : routes
   Created on : Jun 11, 2025, 1:33:50 PM
   Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/routes" />
<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <!-- Header + Create Button -->
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-orange-600">Manage Routes</h2>
            <a href="${pageContext.servletContext.contextPath}/admin/routes?add"><button class="bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg flex items-center gap-2">
                    <i class="fas fa-plus"></i>
                    Create New Route
                </button></a>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full border text-left">
                <thead class="bg-orange-100 text-[#EF5222]">
                    <tr>
                        <th class="py-2 px-4">Route ID</th>
                        <th class="py-2 px-4">Origin</th>
                        <th class="py-2 px-4">Destination</th>
                        <th class="py-2 px-4">Estimated Time</th>
                        <th class="py-2 px-4">Distance</th>
                        <th class="py-2 px-4">Status</th>
                        <th class="py-2 px-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loop through routes list from database -->
                    <c:forEach var="route" items="${routes}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="py-2 px-4">${route.routeId}</td>
                            <td class="py-2 px-4">${route.startLocation}</td>
                            <td class="py-2 px-4">${route.endLocation}</td>
                            <td class="py-2 px-4">
                                <c:set var="et" value="${route.estimatedTime}" />
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
                            </td>

                            <td class="py-2 px-4">${route.distanceKm} km</td>
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${route.routeStatus == 'Inactive'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                            Inactive
                                        </span>
                                    </c:when>
                                    <c:when test="${route.routeStatus == 'Active'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                            Active
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-gray-100 text-gray-700">
                                            ${route.routeStatus}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="py-2 px-4">
                                <div class="flex items-center gap-4">
                                    <a href="${pageContext.servletContext.contextPath}/admin/routes?detail=${route.routeId}">
                                        <button class="flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                    </a>
                                    <a href="${pageContext.servletContext.contextPath}/admin/routes?editId=${route.routeId}">
                                        <button class="flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                    </a>
                                    <a href="${pageContext.servletContext.contextPath}/admin/routes?delete=${route.routeId}">
                                        <button class="flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </a>
                                </div>
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

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>