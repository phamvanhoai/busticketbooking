<%-- 
    Document   : view-bookings
    Created on : Jun 13, 2025, 9:18:21 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-5xl mx-auto px-4 py-10">
        <h2 class="text-3xl font-bold text-[#ef5222] mb-8 text-center">
            View My Bookings
        </h2>

        <div class="space-y-6">
            <!-- Booking 1 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition mb-4">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Can Tho → Chau Doc</p>
                        <p class="text-sm text-gray-600">Seat: <b>A12</b> | Code: <span class="font-mono">TKT10001</span></p>
                        <p class="text-sm text-gray-600">Fare: <b>180,000 VND</b></p>
                        <p class="text-sm text-gray-600">Departure: 2025-06-15 14:00</p>
                        <span class="inline-block px-3 py-1 text-xs rounded-full text-white bg-green-500">Confirmed</span>
                    </div>
                </div>

                <div class="mt-4 md:mt-0 text-right">
                    <button class="px-4 py-2 border text-sm rounded-lg hover:bg-gray-100">
                        View Details
                    </button>
                </div>
            </div>

            <!-- Booking 2 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition mb-4">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">HCM → Vung Tau</p>
                        <p class="text-sm text-gray-600">Seat: <b>B05</b> | Code: <span class="font-mono">TKT10002</span></p>
                        <p class="text-sm text-gray-600">Fare: <b>200,000 VND</b></p>
                        <p class="text-sm text-gray-600">Departure: 2025-06-16 08:00</p>
                        <span class="inline-block px-3 py-1 text-xs rounded-full text-white bg-yellow-500">Pending</span>
                    </div>
                </div>

                <div class="mt-4 md:mt-0 text-right">
                    <button class="px-4 py-2 border text-sm rounded-lg hover:bg-gray-100">
                        View Details
                    </button>
                </div>
            </div>

            <!-- Booking 3 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition mb-4">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Da Nang → Hue</p>
                        <p class="text-sm text-gray-600">Seat: <b>A03</b> | Code: <span class="font-mono">TKT10003</span></p>
                        <p class="text-sm text-gray-600">Fare: <b>150,000 VND</b></p>
                        <p class="text-sm text-gray-600">Departure: 2025-06-17 09:15</p>
                        <span class="inline-block px-3 py-1 text-xs rounded-full text-white bg-gray-400">Cancelled</span>
                    </div>
                </div>

                <div class="mt-4 md:mt-0 text-right">
                    <button class="px-4 py-2 border text-sm rounded-lg hover:bg-gray-100">
                        View Details
                    </button>
                </div>
            </div>

        </div>
    </div>



    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>