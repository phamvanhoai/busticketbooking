<%-- 
    Document   : edit-user
    Created on : Jun 10, 2025, 10:18:50 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="p-8 bg-white rounded-xl shadow-xl mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Update Account</h2>

        <!-- Show success message if redirected -->
        <c:if test="${param.message == 'updated'}">
            <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
                <div class="flex items-center gap-2">
                    <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                         viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M5 13l4 4L19 7"/>
                    </svg>
                    <span><strong>Success:</strong> User updated successfully!</span>
                </div>
                <button onclick="this.parentElement.style.display = 'none'" class="text-green-500 hover:text-green-700 text-lg font-bold">&times;</button>
            </div>
        </c:if>


        <!-- Show list of validation errors -->
        <c:if test="${not empty requestScope.errors}">
            <div style="color: red;">
                <c:forEach var="error" items="${requestScope.errors}">
                    <p>${error}</p>
                </c:forEach>
            </div>
        </c:if>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="space-y-6">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="userId" value="${user.user_id}">

            <!-- Full Name -->
            <label class="block text-lg font-medium mb-2" for="fullName">Full Name</label>
            <input
                id="fullName"
                name="name"
                value="${user.name}"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                placeholder="Enter full name"
                required
                />

            <!-- Email -->
            <label class="block text-lg font-medium mb-2" for="email">Email</label>
            <input
                id="email"
                name="email"
                type="email"
                value="${user.email}"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                placeholder="Enter email address"
                required
                />

            <!-- Phone Number -->
            <label class="block text-lg font-medium mb-2" for="phone">Phone Number</label>
            <input
                id="phone"
                name="phone"
                value="${user.phone}"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                placeholder="Enter phone number"
                />

            <!-- Role & Status -->
            <div class="grid sm:grid-cols-2 gap-6 mb-12">
                <div>
                    <label class="block text-lg font-medium mb-2" for="role">Role</label>
                    <select
                        id="role"
                        name="role"
                        class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required
                        >
                        <option value="">Select role</option>
                        <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                        <option value="Staff" ${user.role == 'Staff' ? 'selected' : ''}>Staff</option>
                        <option value="Driver" ${user.role == 'Driver' ? 'selected' : ''}>Driver</option>
                        <option value="Customer" ${user.role == 'Customer' ? 'selected' : ''}>Customer</option>
                    </select>
                </div>

                <div>
                    <label class="block text-lg font-medium mb-2" for="status">Status</label>
                    <select
                        id="status"
                        name="status"
                        class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required
                        >
                        <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
            </div>

            <!-- Gender -->
            <label class="block text-lg font-medium mb-2" for="gender">Gender</label>
            <select
                id="gender"
                name="gender"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                >
                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
            </select>

            <!-- Birthdate -->
            <label class="block text-lg font-medium mb-2" for="birthdate">Birthdate</label>
            <input
                type="date"
                id="birthdate"
                name="birthdate"
                value="${birthdateFormatted}"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                />


            <!-- Address -->
            <label class="block text-lg font-medium mb-2" for="address">Address</label>
            <textarea
                id="address"
                name="address"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                >${user.address}</textarea>

            <!-- Action Buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.servletContext.contextPath}/admin/users"><button
                        type="button"
                        class="bg-gray-300 text-gray-700 px-8 py-3 rounded-md hover:bg-gray-400"
                        >
                        Cancel
                    </button></a>
                <button
                    type="submit"
                    class="bg-orange-500 text-white px-8 py-3 rounded-md hover:bg-orange-600"
                    >
                    Update
                </button>
            </div>
        </form>
    </div> 

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>
