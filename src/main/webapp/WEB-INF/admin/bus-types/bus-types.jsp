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

            <c:if test="${not empty success}">
                <div class="mb-4 p-4 bg-green-100 border border-green-300 text-green-800 rounded-lg">
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg">
                    ${error}
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
                        <th class="px-4 py-2">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bt" items="${busTypes}">
                        <tr class="border-b last:border-none">
                            <td class="px-4 py-2">${bt.busTypeId}</td>
                            <td class="px-4 py-2">${bt.busTypeName}</td>
                            <td class="px-4 py-2">${bt.busTypeDescription}</td>
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