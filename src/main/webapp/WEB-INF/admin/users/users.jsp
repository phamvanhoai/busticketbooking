<%-- 
    Document   : users.jsp
    Description: JSP page to list and manage all user accounts
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Include common admin header -->
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<!-- Define base URL for pagination and filtering (with search if applicable) -->
<c:set var="baseUrlWithSearch" value="${pageContext.request.contextPath}/admin/users" />
<c:if test="${not empty param.search}">
    <!-- Append search query to base URL -->
    <c:set var="baseUrlWithSearch"
           value="${baseUrlWithSearch}?search=${fn:escapeXml(param.search)}" />
</c:if>

<body class="bg-gray-50">

    <c:if test="${param.message == 'created'}">
        <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
                <span><strong>Success:</strong> Account created successfully!</span>
            </div>
            <button onclick="this.parentElement.style.display = 'none'" class="text-green-500 hover:text-green-700 text-lg font-bold">&times;</button>
        </div>
    </c:if>

    <c:if test="${param.message == 'driver_created'}">
        <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
                <span><strong>Success:</strong> Driver account created successfully!</span>
            </div>
            <button onclick="this.parentElement.style.display = 'none'" class="text-green-500 hover:text-green-700 text-lg font-bold">&times;</button>
        </div>
    </c:if>
    
    <c:if test="${param.message == 'updated'}">
        
         <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
            <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                     viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
                <span><strong>Success:</strong> User updated successfully!</span>
            </div>
            <button onclick="this.parentElement.style.display = 'none'" class="text-green-500 hover:text-green-700 text-lg font-bold">&times;</button>
        </div>
</c:if>


    <div class="px-4 py-8">
        <!-- Title -->
        <h2 class="text-3xl font-bold text-orange-600 mb-4">Manage Accounts</h2>

        <!-- Loading spinner shown during filtering/searching -->
        <div id="loading-spinner" class="flex justify-center items-center py-6 hidden">
            <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span class="ml-3 text-sm text-gray-600">Loading users...</span>
        </div>

        <!-- Role filter buttons (All, Admin, Driver, Staff, Customer) -->
        <div class="flex flex-wrap items-center gap-2 mb-6">
            <!-- "All" button (active when no role is selected) -->
            <a href="${pageContext.servletContext.contextPath}/admin/users"
               class="px-4 py-1 ${empty param.role ? 'bg-[#EF5222] text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">All</a>

            <!-- Loop to generate role-specific filter buttons -->
            <c:forEach var="r" items="${['Admin','Driver','Staff','Customer']}">
                <a href="${baseUrlWithSearch}${not empty param.search ? '&' : '?'}role=${r}"
                   class="px-4 py-1 ${param.role == r ? 'bg-[#EF5222] text-white' : 'border border-orange-500 text-orange-500 hover:bg-orange-100'} rounded-full">${r}</a>
            </c:forEach>
        </div>

        <!-- Search bar and create new account button -->
        <form class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"
              action="${pageContext.servletContext.contextPath}/admin/users" method="get">

            <!-- Search input + button -->
            <div class="flex-grow flex gap-2 min-w-[250px]">
                <input
                    type="text"
                    name="search"
                    value="${fn:escapeXml(param.search)}"
                    placeholder="Search by name or email"
                    class="w-full border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />
                <button type="submit"
                        class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    <i class="fas fa-search"></i>
                </button>
            </div>

            <!-- Add new account button -->
            <a href="${pageContext.servletContext.contextPath}/admin/users/add"
               class="flex items-center gap-2 bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Create New Account
            </a>
        </form>

        <!-- User list table -->
        <div class="overflow-x-auto bg-white rounded-2xl shadow">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-orange-50">
                    <tr>
                        <!-- Table columns -->
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
                    <!-- Display each user -->
                    <c:forEach var="user" items="${users}">
                        <tr class="align-middle">
                            <td class="px-4 py-2">${user.formattedId}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.name)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.email)}</td>
                            <td class="px-4 py-2">${fn:escapeXml(user.phone)}</td>
                            <td class="px-4 py-2">${user.role}</td>

                            <!-- Show status with colored badges -->
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

                            <!-- Format creation date -->
                            <td class="px-4 py-2">
                                <fmt:formatDate value="${user.created_at}" pattern="dd/MM/yyyy"/>
                            </td>

                            <!-- View and Edit buttons -->
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

                    <!-- No data case if user list is empty -->
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">
                                        No accounts found for your search or filter.
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination using custom tag -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${numOfPages}"
                url="${baseUrlWithSearch}" />
        </div>
    </div>

    <!-- Spinner logic script -->
    <script>
        function showLoading() {
            document.getElementById("loading-spinner").classList.remove("hidden");
        }

        function hideLoading() {
            document.getElementById("loading-spinner").classList.add("hidden");
        }

        document.addEventListener("DOMContentLoaded", function () {
            const searchInput = document.querySelector("input[name='search']");
            const roleButtons = document.querySelectorAll("a[href*='role=']");

            // Show spinner on form submit
            if (searchInput) {
                searchInput.form.addEventListener("submit", () => {
                    showLoading();
                });
            }

            // Show spinner on role filter click
            roleButtons.forEach(btn => {
                btn.addEventListener("click", () => {
                    showLoading();
                });
            });
        });
    </script>
</body>

<!-- Include common admin footer -->
<%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>