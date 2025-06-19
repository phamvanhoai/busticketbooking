<%-- 
    Document   : view-location-details
    Created on : Jun 20, 2025, 2:53:30 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-100 min-h-screen p-6">
    <div class="bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-[#EF5222] mb-6">Location Details</h1>

        <div class="space-y-4 text-gray-700">
            <div class="flex">
                <span class="w-32 font-semibold">Name:</span>
                <span>Downtown Station</span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Address:</span>
                <div>
                    123 Main St, District 1, Ho Chi Minh City, HCMC 700000
                </div>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Description:</span>
                <span>Main drop-off and pick-up point in the city center.</span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Created On:</span>
                <span>2025-06-20</span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Status:</span>
                <span class="text-green-600 font-medium">Active</span>
            </div>
        </div>

        <!-- Map placeholder -->
        <div class="mt-6">
            <div class="w-full h-48 bg-gray-200 rounded-lg flex items-center justify-center text-gray-400">
                [Map Preview]
            </div>
        </div>

        <!-- Action buttons -->
        <div class="flex justify-end gap-4 pt-4">
            <button class="bg-orange-500 hover:bg-orange-600 text-white font-medium px-6 py-2 rounded-lg transition">
                Edit
            </button>
            <button class="bg-red-500 hover:bg-red-600 text-white font-medium px-6 py-2 rounded-lg transition">
                Delete
            </button>
            <a href="${pageContext.servletContext.contextPath}/admin/locations">
                <button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-6 py-2 rounded-lg transition">
            Back
            </button></a>
        </div>
    </div>
    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>