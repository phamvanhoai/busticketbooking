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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<body class="bg-[#f9fafb]">
    <div class="p-8 bg-white rounded-xl shadow-xl mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Update Account</h2>

        <!-- Show message (error or success) -->
        <c:if test="${not empty requestScope.message}">
            <div class="flex items-center justify-between
                 ${requestScope.messageType == 'error' ? 'bg-red-100 border border-red-300 text-red-800' : 'bg-green-100 border border-green-300 text-green-800'}
                 text-sm px-6 py-4 rounded-lg shadow mb-6">

                <div class="flex items-center gap-2">
                    <!-- Icon -->
                    <svg class="w-5 h-5 ${requestScope.messageType == 'error' ? 'text-red-600' : 'text-green-600'}" 
                         fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="${requestScope.messageType == 'error' 
                               ? 'M6 18L18 6M6 6l12 12' 
                               : 'M5 13l4 4L19 7'}"/>
                    </svg>
                    <span>${requestScope.message}</span>
                </div>

                <button onclick="this.parentElement.style.display = 'none'" 
                        class="font-bold text-lg ${requestScope.messageType == 'error' ? 'text-red-600 hover:text-red-800' : 'text-green-600 hover:text-green-800'}">
                    &times;
                </button>
            </div>
        </c:if>
        <c:if test="${not empty errors}">
            <div class="flex items-start gap-3 bg-red-100 border border-red-300 text-red-800 text-sm px-5 py-4 rounded-lg shadow mb-6">
                <!-- Icon -->
                <div class="pt-1">
                    <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" stroke-width="2"
                         viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </div>

                <!-- Content -->
                <div class="flex-1">
                    <p class="font-semibold mb-1">Please correct the following issues:</p>
                    <ul class="list-disc list-inside space-y-0.5">
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                            </c:forEach>
                    </ul>
                </div>
            </div>
        </c:if>


        <!-- Edit user form -->
        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="space-y-6">
            <!-- Hidden fields to identify action and user ID -->
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

            <!-- Role and Status selection -->
            <div class="grid sm:grid-cols-2 gap-6 mb-12">
                <!-- Role -->
                <div>
                    <label class="block text-lg font-medium mb-2" for="role">Role</label>
                    <select
                        id="role"
                        name="role"
                        class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required>
                        <option value="">Select role</option>
                        <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                        <option value="Staff" ${user.role == 'Staff' ? 'selected' : ''}>Staff</option>
                        <option value="Driver" ${user.role == 'Driver' ? 'selected' : ''}>Driver</option>
                        <option value="Customer" ${user.role == 'Customer' ? 'selected' : ''}>Customer</option>
                    </select>
                </div>

                <!-- Status -->
                <div>
                    <label class="block text-lg font-medium mb-2" for="status">Status</label>
                    <select
                        id="status"
                        name="status"
                        class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required>
                        <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
            </div>


            <!-- Gender selection -->
            <label class="block text-lg font-medium mb-2" for="gender">Gender</label>
            <select
                id="gender"
                name="gender"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400">
                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
            </select>


            <!-- Birthdate -->
            <label class="block text-lg font-medium mb-2" for="birthdate">Birthdate</label>
            <div class="relative mb-8">
                <input
                    type="text"
                    id="birthdate"
                    name="birthdate"
                    value="${user.birthdate != null ? fn:substring(user.birthdate.toString(),0,10) : ''}"
                    placeholder="Select birthdate"
                    class="flatpickr w-full border rounded-md px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    />
                <button type="button" id="birthdate-icon"
                        class="absolute inset-y-0 right-3 flex items-center text-gray-400 hover:text-orange-500">
                    <i class="fas fa-calendar-alt"></i>
                </button>
            </div>


            <!-- Address textarea -->
            <label class="block text-lg font-medium mb-2" for="address">Address</label>
            <textarea
                id="address"
                name="address"
                class="w-full border rounded-md p-3 mb-8 focus:outline-none focus:ring-2 focus:ring-orange-400"
                >${user.address}</textarea>

            <!-- Driver-specific fields: shown only if role is Driver -->
            <div id="driverFields" class="p-4 rounded-md bg-orange-100 mb-8" style="display:none;">
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block text-lg font-medium mb-2" for="licenseNumber">License Number</label>
                        <input
                            id="licenseNumber"
                            name="licenseNumber"
                            value="${driverInfo != null ? driverInfo.licenseNumber : ''}"
                            class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400"
                            placeholder="Enter license number"
                            />
                    </div>

                    <div>
                        <label class="block text-lg font-medium mb-2" for="licenseClass">License Class</label>
                        <p class="w-full border rounded-md p-3 bg-white">
                            ${driverInfo != null ? driverInfo.licenseClass : 'D2'}
                        </p>
                        <input 
                            type="hidden" 
                            id="licenseClass" 
                            name="licenseClass" 
                            value="${driverInfo != null ? driverInfo.licenseClass : 'D2'}"
                            />
                    </div>
                    <div>
                        <label class="block text-lg font-medium mb-2" for="hireDate">Hire Date</label>
                        <div class="relative">
                            <input
                                id="hireDate"
                                name="hireDate"
                                type="text"
                                value="${driverInfo != null && driverInfo.hireDate != null ? fn:substring(driverInfo.hireDate.toString(),0,10) : ''}"
                                placeholder="Select hire date"
                                class="flatpickr w-full border rounded-md px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-orange-400"
                                />
                            <button type="button" id="hireDate-icon"
                                    class="absolute inset-y-0 right-3 flex items-center text-gray-400 hover:text-orange-500">
                                <i class="fas fa-calendar-alt"></i>
                            </button>
                        </div>
                    </div>

                    <div>
                        <label class="block text-lg font-medium mb-2" for="driverStatus">Driver Status</label>
                        <select
                            id="driverStatus"
                            name="driverStatus"
                            class="w-full border rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-orange-400">
                            <option value="Active" ${driverInfo != null && driverInfo.driverStatus == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${driverInfo != null && driverInfo.driverStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="mt-8 border-t border-orange-300 pt-6">
                    <h3 class="text-xl font-semibold mb-4 text-orange-600">Upgrade Driver License</h3>

                    <input type="hidden" name="oldLicenseClass" value="${driverInfo != null ? driverInfo.licenseClass : ''}" />

                    <label class="block text-lg font-medium mb-2" for="newLicenseClass">New License Class</label>
                    <select
                        id="newLicenseClass"
                        name="newLicenseClass"
                        class="w-full border rounded-md p-3 mb-6 focus:outline-none focus:ring-2 focus:ring-orange-400">
                        <option value="">Select new license class</option>
                        <option value="D">D</option>
                    </select>

                    <label class="block text-lg font-medium mb-2" for="reason">Reason (optional)</label>
                    <textarea
                        id="reason"
                        name="reason"
                        class="w-full border rounded-md p-3 mb-6 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        placeholder="E.g., Promoted after exam..."></textarea>
                </div>
            </div>


            <!-- Action buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <!-- Cancel button redirects back to user list -->
                <a href="${pageContext.servletContext.contextPath}/admin/users">
                    <button type="button" class="bg-gray-300 text-gray-700 px-8 py-3 rounded-md hover:bg-gray-400">
                        Cancel
                    </button>
                </a>
                <!-- Submit form to update user -->
                <button
                    type="submit"
                    class="bg-[#EF5222] text-white px-8 py-3 rounded-md hover:bg-orange-600">
                    Update
                </button>
            </div>
        </form>
    </div> 

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>

    <!-- JavaScript to show/hide driver-specific fields based on selected role -->
    <script>
        function toggleDriverFields() {
            const roleSelect = document.getElementById('role');
            const driverFields = document.getElementById('driverFields');
            if (roleSelect.value === 'Driver') {
                driverFields.style.display = 'block';
            } else {
                driverFields.style.display = 'none';
            }
        }

        window.addEventListener('DOMContentLoaded', () => {
            toggleDriverFields();
            document.getElementById('role').addEventListener('change', toggleDriverFields);
        });
    </script>
    <script>
        const birthInput = document.getElementById('birthdate');
        const hireInput = document.getElementById('hireDate');

        const birthInstance = flatpickr(birthInput, {
            dateFormat: "Y-m-d",
            altInput: true,
            altFormat: "d/m/Y",
            allowInput: true
        });

        const hireInstance = flatpickr(hireInput, {
            dateFormat: "Y-m-d",
            altInput: true,
            altFormat: "d/m/Y",
            allowInput: true
        });

        document.getElementById('birthdate-icon').addEventListener('click', function () {
            birthInstance.open();
        });

        document.getElementById('hireDate-icon').addEventListener('click', function () {
            hireInstance.open();
        });
    </script>