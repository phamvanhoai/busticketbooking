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
    <div class="mt-10 p-6 bg-white rounded-2xl shadow-lg">
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
        <div class="overflow-x-auto">
            <table class="min-w-full bg-white rounded-lg overflow-hidden">
                <thead class="bg-[#FFF3EB]">
                    <tr>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Bus ID</th> 
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Bus Code</th>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Plate Number</th>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Type</th>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Capacity</th>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Status</th>
                        <th class="text-left text-[#EF5222] font-medium px-6 py-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bus" items="${busesList}">
                        <tr class="border-b last:border-none">
                            <td class="px-6 py-4">${bus.busId}</td>
                            <td class="px-6 py-4">${bus.busCode}</td>
                            <td class="px-6 py-4">${bus.plateNumber}</td>
                            <td class="px-6 py-4">${bus.busTypeName}</td>
                            <td class="px-6 py-4">${bus.capacity}</td>
                            <td class="px-6 py-4">
                                <c:choose>
                                    <c:when test="${bus.busStatus == 'Active'}">
                                        <span class="px-2 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4 space-x-4">
                                <a href="${pageContext.servletContext.contextPath}/admin/buses?viewId=${bus.busId}" class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                                    <i class="fas fa-eye"></i> View
                                </a>
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