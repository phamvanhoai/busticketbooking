<%-- 
    Document   : bus-types
    Created on : Jun 15, 2025, 1:53:25 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<body class="bg-gray-50">
    <div class="mt-10 px-4">
        <!-- Header + Create Button -->
        <div class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-[#EF5222]">Manage Bus Types</h1>

            

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


            <a href="${pageContext.servletContext.contextPath}/admin/bus-types?add"><button
                    type="button"
                    class="px-4 py-2 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90 flex items-center gap-1"
                    >
                    <i class="fas fa-plus"></i>
                    Create Bus Type
                </button></a>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full border text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Bus Type ID</th>
                        <th class="px-4 py-2">Name</th>
                        <th class="px-4 py-2">Description</th>
                        <th class="px-4 py-2">Seat</th>
                        <th class="px-4 py-2">Seat Type</th>
                        <th class="px-4 py-2">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bt" items="${busTypes}">
                        <tr class="border-b last:border-none">
                            <td class="px-4 py-2">${bt.busTypeId}</td>
                            <td class="px-4 py-2">${bt.busTypeName}</td>
                            <td class="px-4 py-2">${bt.busTypeDescription}</td>
                            <td class="px-4 py-2">${bt.seatCount}</td>
                            <td class="px-4 py-2">${bt.seatType}</td>
                            <td class="px-4 py-2 space-x-4">
                                <a href="${pageContext.request.contextPath}/admin/bus-types?detail=${bt.busTypeId}">
                                    <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/bus-types?editId=${bt.busTypeId}">
                                    <button class="inline-flex items-center gap-1 text-amber-600 hover:text-amber-8000 text-sm">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/bus-types?delete=${bt.busTypeId}">
                                    <button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${pageContext.request.contextPath}/admin/bus-types" />
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>