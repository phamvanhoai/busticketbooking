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


            <!-- Flash messages -->
            <c:if test="${not empty success}">
                <div class="flex items-center gap-2 p-3 mb-4 bg-green-50 border-l-4 border-green-400 text-green-700 rounded">
                    <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd"
                          d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 
                          10.586 7.707 9.293a1 1 0 10-1.414 
                          1.414L9 13.414l4.707-4.707z"
                          clip-rule="evenodd"/>
                    </svg>
                    <span class="text-sm font-medium">${success}</span>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="flex items-center gap-2 p-3 mb-4 bg-red-50 border-l-4 border-red-400 text-red-700 rounded">
                    <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd"
                          d="M8.257 3.099c.765-1.36 2.72-1.36 
                          3.485 0l5.516 9.814A1.75 1.75 
                          0 0116.516 15H3.484a1.75 1.75 
                          0 01-1.742-2.087L8.257 3.1zM11 
                          13a1 1 0 10-2 0 1 1 0 002 
                          0zm-.25-2.75a.75.75 0 
                          00-1.5 0v1.5a.75.75 0 
                          001.5 0v-1.5z"
                          clip-rule="evenodd"/>
                    </svg>
                    <span class="text-sm font-medium">${error}</span>
                </div>
            </c:if>

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