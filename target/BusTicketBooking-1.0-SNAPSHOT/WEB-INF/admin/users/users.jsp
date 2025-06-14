<%-- 
    Document   : users
    Created on : Jun 10, 2025, 1:53:23 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="neon" uri="/WEB-INF/tags/implicit.tld" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>
<c:set var="baseUrl" value="${pageContext.request.contextPath}/admin/users"/>

<c:if test="${not empty param.search}">
    <c:set var="baseUrl"
           value="${baseUrl}?search=${fn:escapeXml(param.search)}"/>
</c:if>

<c:if test="${not empty param.role}">
    <c:set var="baseUrl"
           value="${baseUrl}${not empty param.search ? '&' : '?'}role=${fn:escapeXml(param.role)}"/>
</c:if>

<body class="bg-gray-50">
    <div class="px-4 py-8">
        <!-- Title + Filters -->
        <h1 class="text-3xl font-bold text-orange-600 mb-4">Manage Accounts</h1>
        <div class="flex flex-wrap items-center gap-2 mb-6">
            <a href="${pageContext.servletContext.contextPath}/admin/users" class="px-4 py-1 ${empty param.role ? 'bg-orange-500 text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">All</a>
            <a href="${pageContext.servletContext.contextPath}/admin/users?role=Admin" class="px-4 py-1 ${param.role == 'Admin' ? 'bg-orange-500 text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">Admin</a>
            <a href="${pageContext.servletContext.contextPath}/admin/users?role=Driver" class="px-4 py-1 ${param.role == 'Driver' ? 'bg-orange-500 text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">Driver</a>
            <a href="${pageContext.servletContext.contextPath}/admin/users?role=Staff" class="px-4 py-1 ${param.role == 'Staff' ? 'bg-orange-500 text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">Staff</a>
            <a href="${pageContext.servletContext.contextPath}/admin/users?role=Customer" class="px-4 py-1 ${param.role == 'Customer' ? 'bg-orange-500 text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">Customer</a>
        </div>

        <!-- Search + Create -->
        <form class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4" action="${pageContext.servletContext.contextPath}/admin/users" method="get">
            <div class="relative flex-1">
                <input
                    type="text"
                    name="search"
                    value="${fn:escapeXml(param.search)}"
                    placeholder="Search by name or email"
                    class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-orange-300"
                    />
                <svg class="w-5 h-5 text-gray-400 absolute right-3 top-1/2 transform -translate-y-1/2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z" />
                </svg>
            </div>
            <div class="flex items-center gap-2">
                <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">Search</button>
                <a href="${pageContext.servletContext.contextPath}/admin/users?add" class="flex items-center gap-2 bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Create New Account
                </a>
            </div>
        </form>

        <!-- Table -->
        <div class="overflow-x-auto bg-white rounded-2xl shadow">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-orange-50">
                    <tr>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">ID</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Name</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Email</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Phone</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Role</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Status</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Created At</th>
                        <th class="px-4 py-2 text-left text-orange-600 font-medium">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:forEach var="user" items="${users}">
                        <tr class="align-middle">
                            <td class="px-4 py-2">${user.user_id}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.name)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.email)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.phone)}</td>
                            <td class="px-4 py-2">${user.role}</td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${user.status == 'Active'}">
                                        <span class="inline-block px-2 py-1 bg-green-100 text-green-800 rounded-full text-sm">Active</span>
                                    </c:when>
                                    <c:when test="${user.status == 'Inactive'}">
                                        <span class="inline-block px-2 py-1 bg-red-100 text-red-600 rounded-full text-sm">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-block px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm">${fn:escapeXml(user.status)}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-2">${user.created_at}</td>
                            <td class="px-4 py-2">
                                <a href="${pageContext.request.contextPath}/admin/users?editId=${user.user_id}" class="text-blue-600 hover:underline">Edit</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <neon:adminpagination
                currentPage="${currentPage}"
                totalPages="${numOfPages}"
                url="${baseUrl}" />
        </div>

    </div>
</body>

<%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
