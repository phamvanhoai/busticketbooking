<%-- 
    Document   : locations
    Created on : Jun 20, 2025, 2:51:08 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/locations"/>
<c:if test="${not empty param.search}">
    <c:set var="baseUrl"
           value="${baseUrl}?search=${fn:escapeXml(param.search)}"/>
</c:if>

<body class="bg-[#f3f3f5] min-h-screen p-6">
    <div class="space-y-6">
        <!-- Title + Search/Add -->
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <h1 class="text-3xl font-bold text-[#EF5222]">Manage Locations</h1>

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


            <div class="flex gap-2 w-full md:w-auto">
                <form action="${pageContext.request.contextPath}/admin/locations" method="get" class="flex gap-2">
                    <input type="text" name="search" placeholder="Search locations..."
                           value="${fn:escapeXml(search)}"
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-400"/>
                    <button type="submit"
                            class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                        Search
                    </button>
                </form>
                <a href="${pageContext.request.contextPath}/admin/locations?add">
                    <button class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                        + Add Location
                    </button>
                </a>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-3">ID</th>
                        <th class="px-4 py-3">Name</th>
                        <th class="px-4 py-3">Address</th>
                        <th class="px-4 py-3">Location Type</th>
                        <th class="px-4 py-3">Status</th>
                        <th class="px-4 py-3">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <c:forEach var="loc" items="${locations}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3">${loc.locationId}</td>
                            <td class="px-4 py-3">${loc.locationName}</td>
                            <td class="px-4 py-3">${loc.address}</td>
                            <td class="px-4 py-3">${loc.locationType}</td>
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${loc.locationStatus == 'Inactive'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                            Inactive
                                        </span>
                                    </c:when>
                                    <c:when test="${loc.locationStatus == 'Active'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                            Active
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-gray-100 text-gray-700">
                                            ${loc.locationStatus}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3">
                                <div class="flex items-center gap-4">
                                    <a href="${pageContext.request.contextPath}/admin/locations?detail=${loc.locationId}">
                                        <button class="text-blue-600 hover:underline text-sm"><i class="fas fa-eye"></i> View</button>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/locations?editId=${loc.locationId}">
                                        <button class="text-blue-600 hover:underline text-sm"><i class="fas fa-edit"></i> Edit</button>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/locations?delete=${loc.locationId}">
                                        <button class="text-red-600 hover:underline text-sm"><i class="fas fa-trash-alt"></i> Delete</button>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty locations}">
                        <tr>
                            <td colspan="5" class="px-4 py-3 text-center text-gray-500">
                                Không tìm thấy kết quả.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center items-center gap-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>
    </div>
</div>
<%-- CONTENT HERE--%>
<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>