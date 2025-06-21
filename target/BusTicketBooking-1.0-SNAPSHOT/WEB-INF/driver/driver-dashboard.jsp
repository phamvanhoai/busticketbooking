<%-- 
    Document   : driver-dashboard
    Created on : Jun 13, 2025, 11:06:47 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="mt-12 px-6">
        <!-- Header -->
        <div class="flex items-center gap-6 mb-10">
            <img
                src="<%= getServletContext().getContextPath()%>/assets/images/avt/driver-avatar.png"
                alt="Driver Avatar"
                class="w-20 h-20 rounded-full border object-cover"
            />
            <div>
                <h2 class="text-3xl font-bold text-orange-600">Welcome, Nguyễn Thành Trương</h2>
                <p class="text-gray-500 text-sm">Here’s your summary for today</p>
            </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <!-- Upcoming Trip -->
            <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-blue-500">
                <div class="flex items-center gap-4 mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-blue-500 text-2xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3v12a4 4 0 004 4h10a4 4 0 004-4V3M3 7h18M10 20l2-2 2 2M12 3v4"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-gray-800">Upcoming Trip</h3>
                </div>
                <p class="text-gray-700 font-medium">Can Tho → Chau Doc</p>
                <p class="text-sm text-gray-600">2025-06-17 at 17:00</p>
            </div>

            <!-- Completed Trips -->
            <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-green-500">
                <div class="flex items-center gap-4 mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-green-500 text-2xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2l4-4m1 7h-6a4 4 0 01-4-4V5a4 4 0 014-4h6a4 4 0 014 4v10a4 4 0 01-4 4z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-gray-800">Completed Trips</h3>
                </div>
                <p class="text-3xl font-bold text-gray-800">9</p>
                <p class="text-sm text-gray-600">out of 12 total trips</p>
            </div>

            <!-- Trip Change Requests -->
            <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-yellow-500">
                <div class="flex items-center gap-4 mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-yellow-500 text-2xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 9l6 6l6-6M12 3v12"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-gray-800">Change Requests</h3>
                </div>
                <p class="text-3xl font-bold text-gray-800">1</p>
                <p class="text-sm text-gray-600">Pending approvals</p>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="flex flex-col md:flex-row gap-4">
            <a
                href="${pageContext.servletContext.contextPath}/driver/assigned-trips"
                class="flex-1 bg-orange-500 text-white text-center py-3 rounded-lg font-semibold hover:bg-orange-600 transition"
            >
                View Assigned Trips
            </a>
            <a
                href="${pageContext.servletContext.contextPath}/driver/trip-change"
                class="flex-1 bg-gray-100 text-orange-600 text-center py-3 rounded-lg font-semibold hover:bg-orange-200 transition border"
            >
                Request Trip Change
            </a>
        </div>
    </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
