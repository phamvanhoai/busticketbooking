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
                <div class="p-4 mb-4 bg-green-100 border border-green-400 text-green-800 rounded">
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="p-4 mb-4 bg-red-100 border border-red-400 text-red-800 rounded">
                    ${error}
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
                        <th class="px-4 py-3">City</th>
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