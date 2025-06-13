<%-- 
    Document   : assigned-trips
    Created on : Jun 13, 2025, 10:48:20 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-6xl mx-auto mt-12 px-4">
        <h2 class="text-3xl font-bold text-orange-600 mb-8">Assigned Trips</h2>

        <!-- Trip 1 -->
        <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col md:flex-row md:items-center md:justify-between border border-orange-100 mb-6">
            <div class="mb-4 md:mb-0">
                <p class="text-lg font-semibold text-gray-800">Ho Chi Minh → Can Tho</p>
                <p class="text-sm text-gray-500">2025-06-15 • 08:00 • Limousine</p>
                <p class="text-sm font-medium mt-1 text-yellow-600">Status: Pending</p>
            </div>

            <div class="flex gap-3">
                <button class="bg-blue-100 text-blue-600 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-200">
                    👁️ View Passengers
                </button>
                <button class="bg-green-100 text-green-700 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-green-200">
                    ✔️ Mark as Completed
                </button>
            </div>
        </div>

        <!-- Trip 2 -->
        <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col md:flex-row md:items-center md:justify-between border border-orange-100 mb-6">
            <div class="mb-4 md:mb-0">
                <p class="text-lg font-semibold text-gray-800">Can Tho → Long Xuyen</p>
                <p class="text-sm text-gray-500">2025-06-16 • 13:30 • Sleeper Bus</p>
                <p class="text-sm font-medium mt-1 text-green-600">Status: Completed</p>
            </div>

            <div class="flex gap-3">
                <button class="bg-blue-100 text-blue-600 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-200">
                    👁️ View Passengers
                </button>
                <button class="bg-green-100 text-green-700 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-green-200" disabled>
                    ✔️ Mark as Completed
                </button>
            </div>
        </div>

        <!-- Trip 3 -->
        <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col md:flex-row md:items-center md:justify-between border border-orange-100 mb-6">
            <div class="mb-4 md:mb-0">
                <p class="text-lg font-semibold text-gray-800">Can Tho → Chau Doc</p>
                <p class="text-sm text-gray-500">2025-06-17 • 17:00 • Seater Bus</p>
                <p class="text-sm font-medium mt-1 text-yellow-600">Status: Pending</p>
            </div>

            <div class="flex gap-3">
                <button class="bg-blue-100 text-blue-600 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-200">
                    👁️ View Passengers
                </button>
                <button class="bg-green-100 text-green-700 px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-green-200">
                    ✔️ Mark as Completed
                </button>
            </div>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-10 gap-2">
            <button class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100">
                1
            </button>
            <button class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100">
                2
            </button>
            <button class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100">
                3
            </button>
        </div>
    </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/footer.jsp" %>
