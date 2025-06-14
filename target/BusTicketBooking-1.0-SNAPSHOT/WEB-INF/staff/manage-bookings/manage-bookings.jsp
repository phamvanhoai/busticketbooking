<%-- 
    Document   : manage-bookings
    Created on : Jun 14, 2025, 1:46:51 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>



<body class="bg-[#f9fafb]">

    <div class="max-w-6xl mx-auto mt-12 px-4">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Manage Bookings</h2>

        <!-- Search and Filter -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
            <div class="flex gap-2 flex-1">
                <input
                    type="text"
                    placeholder="Search by Booking ID or Customer Name"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                />
                <button class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-white text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3a8 8 0 118 8 8 8 0 01-8-8zm0 0v6m0 0l3-3m-3 3l-3-3"></path>
                    </svg>
                </button>
            </div>

            <select class="border border-gray-300 rounded-lg px-4 py-2">
                <option value="All">All Status</option>
                <option value="Paid">Paid</option>
                <option value="Unpaid">Unpaid</option>
            </select>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow-lg overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-4">Booking ID</th>
                        <th class="py-2 px-4">Customer</th>
                        <th class="py-2 px-4">Trip</th>
                        <th class="py-2 px-4">Date</th>
                        <th class="py-2 px-4">Seat</th>
                        <th class="py-2 px-4">Driver</th>
                        <th class="py-2 px-4">Bus Type</th>
                        <th class="py-2 px-4">Payment</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Booking Row 1 -->
                    <tr class="border-t hover:bg-gray-50 transition">
                        <td class="py-2 px-4">BKG001</td>
                        <td class="py-2 px-4">Customer 1</td>
                        <td class="py-2 px-4">HCM → Can Tho</td>
                        <td class="py-2 px-4">15/06/2025</td>
                        <td class="py-2 px-4">A1</td>
                        <td class="py-2 px-4">Driver 1</td>
                        <td class="py-2 px-4">Limousine</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full font-medium bg-green-100 text-green-700">
                                Paid
                            </span>
                        </td>
                    </tr>
                    <!-- Booking Row 2 -->
                    <tr class="border-t hover:bg-gray-50 transition">
                        <td class="py-2 px-4">BKG002</td>
                        <td class="py-2 px-4">Customer 2</td>
                        <td class="py-2 px-4">Can Tho → Chau Doc</td>
                        <td class="py-2 px-4">16/06/2025</td>
                        <td class="py-2 px-4">B5</td>
                        <td class="py-2 px-4">Driver 2</td>
                        <td class="py-2 px-4">Sleeper Bus</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full font-medium bg-red-100 text-red-600">
                                Unpaid
                            </span>
                        </td>
                    </tr>
                    <!-- Booking Row 3 -->
                    <tr class="border-t hover:bg-gray-50 transition">
                        <td class="py-2 px-4">BKG003</td>
                        <td class="py-2 px-4">Customer 3</td>
                        <td class="py-2 px-4">Can Tho → Long Xuyen</td>
                        <td class="py-2 px-4">17/06/2025</td>
                        <td class="py-2 px-4">C3</td>
                        <td class="py-2 px-4">Driver 3</td>
                        <td class="py-2 px-4">Seater Bus</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full font-medium bg-green-100 text-green-700">
                                Paid
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 gap-2">
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

<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>