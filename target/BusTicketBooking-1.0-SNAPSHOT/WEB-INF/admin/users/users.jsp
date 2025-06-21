<!-- 
    Document   : users.jsp
    Description: JSP page to list and manage all user accounts
    Author     : Nguyen Thanh Truong - CE180140
-->

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<!-- Set base URL for pagination and search filter -->
<c:set var="baseUrlWithSearch" value="${pageContext.request.contextPath}/admin/users" />
<c:if test="${not empty param.search}">
    <!-- Append search parameter to base URL if present -->
    <c:set var="baseUrlWithSearch"
           value="${baseUrlWithSearch}?search=${fn:escapeXml(param.search)}" />
</c:if>

<body class="bg-gray-50">

    <!-- Success alert if user was updated -->
    <c:if test="${param.message == 'updated'}">
        <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
                <span><strong>Success:</strong> User updated successfully!</span>
            </div>
            <button onclick="this.parentElement.style.display = 'none'" class="text-green-500 hover:text-green-700 text-lg font-bold"></button>
        </div>
    </c:if>

    <div class="px-4 py-8">
        <!-- Page Title and Role Filters -->
        <h1 class="text-3xl font-bold text-orange-600 mb-4">Manage Accounts</h1>
        <div class="flex flex-wrap items-center gap-2 mb-6">
            <!-- "All" filter button (active if no role param) -->
            <a href="${pageContext.servletContext.contextPath}/admin/users"
               class="px-4 py-1 ${empty param.role ? 'bg-[#EF5222] text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">All</a>

            <!-- Dynamic role filter buttons -->
            <c:forEach var="r" items="${['Admin','Driver','Staff','Customer']}">
                <a href="${baseUrlWithSearch}${not empty param.search ? '&' : '?'}role=${r}"
                   class="px-4 py-1 ${param.role == r ? 'bg-[#EF5222] text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">${r}</a>
            </c:forEach>
        </div>

        <!-- Search box and Add button -->
        <form class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4" 
              action="${pageContext.servletContext.contextPath}/admin/users" method="get">
            <div class="relative flex-1">
                <input
                    type="text"
                    name="search"
                    value="${fn:escapeXml(param.search)}"
                    placeholder="Search by name or email"
                    class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-orange-300"
                    />
                <!-- Search icon -->
                <svg class="w-5 h-5 text-gray-400 absolute right-3 top-1/2 transform -translate-y-1/2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z" />
                </svg>
            </div>

            <!-- Create new user button -->
            <a href="${pageContext.servletContext.contextPath}/admin/users/add"
               class="flex items-center gap-2 bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Create New Account
            </a>
        </form>

        <!-- User Table -->
        <div class="overflow-x-auto bg-white rounded-2xl shadow">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-orange-50">
                    <tr>
                        <!-- Table headers -->
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
                    <!-- Loop through each user and render a row -->
                    <c:forEach var="user" items="${users}">
                        <tr class="align-middle">
                            <td class="px-4 py-2">${user.user_id}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.name)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.email)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.phone)}</td>
                            <td class="px-4 py-2">${user.role}</td>

                            <!-- Status badge based on user.status -->
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

                            <!-- Format created_at to dd/MM/yyyy -->
                            <td class="px-4 py-2">
                                <fmt:formatDate value="${user.created_at}" pattern="dd/MM/yyyy"/>
                            </td>

                            <!-- View and Edit actions -->
                            <td class="px-4 py-2 whitespace-nowrap text-sm text-gray-700 flex gap-4">
                                <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.user_id}"
                                   class="text-blue-600 hover:text-indigo-800 flex items-center gap-1">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.user_id}"
                                   class="text-amber-600 hover:text-amber-800 flex items-center gap-1">
                                    <i class="fas fa-pen-to-square"></i> Edit
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination component using custom tag -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${numOfPages}"
                url="${baseUrlWithSearch}" />
        </div>
    </div>
</body>

<!@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
