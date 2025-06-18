<%-- 
   Document   : routes
   Created on : Jun 11, 2025, 1:33:50 PM
   Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                            <td class="py-2 px-4">${route.estimatedTime}</td>
                            <td class="py-2 px-4">${route.distanceKm} km</td>
                            <td class="py-2 px-4">
                                <div class="flex items-center gap-4">
                                    <button class="flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                                        <i class="fas fa-eye"></i> View
                                    </button>
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