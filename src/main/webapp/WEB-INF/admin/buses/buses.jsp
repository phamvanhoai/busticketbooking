<%-- 
    Document   : buses
    Created on : Jun 11, 2025, 1:31:40 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/buses" />

<body class="bg-gray-50">
    <div class="mt-10 px-4">
        <!-- Header + Create Button -->
        <div class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-[#EF5222]">Manage Bus Fleet</h1>
            <a href="${pageContext.servletContext.contextPath}/admin/buses?add">
                <button class="px-4 py-2 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90 flex items-center gap-1">
                    <i class="fas fa-plus"></i>
                    Create New Bus
                </button>
            </a>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full border text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-4">Bus ID</th> 
                        <th class="py-2 px-4">Bus Code</th>
                        <th class="py-2 px-4">Plate Number</th>
                        <th class="py-2 px-4">Type</th>
                        <th class="py-2 px-4">Capacity</th>
                        <th class="py-2 px-4">Status</th>
                        <th class="py-2 px-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bus" items="${busesList}">
                        <tr class="border-b last:border-none">
                            <td class="py-2 px-4">${bus.busId}</td>
                            <td class="py-2 px-4">${bus.busCode}</td>
                            <td class="py-2 px-4">${bus.plateNumber}</td>
                            <td class="py-2 px-4">${bus.busTypeName}</td>
                            <td class="py-2 px-4">${bus.capacity}</td>
                            <td class="py-2 px-4">
                                <c:choose>
                                    <c:when test="${bus.busStatus == 'Active'}">
                                        <span class="px-2 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="py-2 px-4 space-x-4">
                                <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=${bus.busId}" class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=${bus.busId}" class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
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