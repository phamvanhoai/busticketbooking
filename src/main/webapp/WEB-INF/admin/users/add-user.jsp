<%-- 
    Document   : add-user
    Created on : Jun 11, 2025, 12:25:46 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Create New Account</h2>

        <!-- Display success message if it exists in the request scope -->
        <c:if test="${not empty requestScope.message}">
            <div class="flex items-center justify-between bg-green-100 border border-green-300 text-green-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
                <div class="flex items-center gap-2">
                    <!-- Green check icon -->
                    <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" stroke-width="2"
                         viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                    </svg>
                    <span><strong>Success:</strong> ${message}</span>
                </div>
                <!-- Dismiss button -->
                <button onclick="this.parentElement.style.display = 'none'" class="text-green-600 hover:text-green-800 text-lg font-bold">&times;</button>
            </div>
        </c:if>

        <!-- Display single error message -->
        <c:if test="${not empty requestScope.error}">
            <div class="flex items-center justify-between bg-red-100 border border-red-300 text-red-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
                <div class="flex items-center gap-2">
                    <!-- Red cross icon -->
                    <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" stroke-width="2"
                         viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                    <span><strong>Error:</strong> ${error}</span>
                </div>
                <button onclick="this.parentElement.style.display = 'none'" class="text-red-600 hover:text-red-800 text-lg font-bold">&times;</button>
            </div>
        </c:if>

        <!-- Display multiple validation errors -->
        <c:if test="${not empty requestScope.errors}">
            <div class="bg-red-100 border border-red-300 text-red-800 text-sm px-6 py-4 rounded-lg shadow mb-6">
                <strong class="block mb-2">Please fix the following errors:</strong>
                <ul class="list-disc list-inside space-y-1">
                    <!-- Iterate through error messages -->
                    <c:forEach var="error" items="${requestScope.errors}">
                        <li>${error}</li>
                        </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- User creation form -->
        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="space-y-6">
            <!-- Hidden field to indicate the action type -->
            <input type="hidden" name="action" value="add">

            <!-- Full Name input -->
            <div>
                <label class="block mb-1 font-medium">Full Name</label>
                <input
                    type="text"
                    name="name"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                    required
                    />
            </div>

            <!-- Email input -->
            <div>
                <label class="block mb-1 font-medium">Email</label>
                <input
                    type="email"
                    name="email"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                    required
                    />
            </div>

            <!-- Password and Confirm Password fields -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-medium">Password</label>
                    <input
                        type="password"
                        name="password"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        required
                        />
                </div>

                <div>
                    <label class="block mb-1 font-medium">Confirm Password</label>
                    <input
                        type="password"
                        name="confirmPassword"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        required
                        />
                </div>
            </div>

            <!-- Role and Status dropdowns -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-medium">Role</label>
                    <!-- When changed, shows/hides driver-specific fields -->
                    <select
                        name="role"
                        id="role-select"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        onchange="toggleDriverFields()"
                        required>
                        <option value="" disabled selected>Select role</option>
                        <option value="Admin">Admin</option>
                        <option value="Staff">Staff</option>
                        <option value="Driver">Driver</option>
                        <option value="Customer">Customer</option>
                    </select>
                </div>

                <div>
                    <label class="block mb-1 font-medium">Status</label>
                    <select
                        name="status"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
            </div>

            <!-- Driver-specific fields (only shown when role = Driver) -->
            <div id="driver-fields" class="hidden border border-orange-200 p-4 rounded-lg bg-orange-50">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block font-medium">License Number</label>
                        <input type="text" name="licenseNumber"
                               class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"/>
                    </div>
                    <div>
                        <label class="block font-medium">License Class</label>
                        <select name="licenseClass"
                                class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500">
                            <option value="D">D</option>
                            <option value="D2">D2</option>
                        </select>
                    </div>
                    <div>
                        <label class="block font-medium">Hire Date</label>
                        <input type="date" name="hireDate"
                               class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"/>
                    </div>
                    <div>
                        <label class="block font-medium">Driver Status</label>
                        <select name="driverStatus"
                                class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Form buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <!-- Cancel button: go back to previous page -->
                <button type="button" onclick="history.back()"
                        class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-lg">
                    Cancel
                </button>

                <!-- Submit button -->
                <button
                    type="submit"
                    class="bg-[#EF5222] hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg">
                    Submit
                </button>
            </div>
        </form>
    </div>

    <!-- JavaScript to toggle visibility of driver-specific fields -->
    <script>
        function toggleDriverFields() {
            const role = document.getElementById("role-select").value;
            const driverFields = document.getElementById("driver-fields");
            driverFields.classList.toggle("hidden", role !== "Driver");
        }
    </script>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>