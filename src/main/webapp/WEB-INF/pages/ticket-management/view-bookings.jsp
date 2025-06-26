<%-- 
    Document   : view-bookings
    Created on : Jun 13, 2025, 9:18:21 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#fff6f3] min-h-screen">

    <!-- Header + Buy button -->
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
        <div>
            <h1 class="text-3xl font-bold">Ticket purchase history</h1>
            <p class="text-gray-500">Track and manage your ticket purchase history</p>
        </div>
        <button class="bg-orange-500 hover:bg-orange-600 text-white px-6 py-2 rounded-full">
            Buy Ticket
        </button>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-xl shadow p-6 mb-6 grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
        <!-- Ticket Code -->
        <div>
            <label class="block text-sm font-medium mb-1">Ticket Code</label>
            <input
                type="text"
                placeholder="Enter Ticket Code"
                class="w-full border rounded-lg px-3 py-2 placeholder-orange-300 focus:ring-2 focus:ring-orange-200"
                />
        </div>
        <!-- Time -->
        <div>
            <label class="block text-sm font-medium mb-1">Time</label>
            <input
                type="date"
                class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200"
                />
        </div>
        <!-- Route -->
        <div>
            <label class="block text-sm font-medium mb-1">Route</label>
            <input
                type="text"
                placeholder="Enter Route"
                class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200"
                />
        </div>
        <!-- Status -->
        <div>
            <label class="block text-sm font-medium mb-1">Status</label>
            <select class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-orange-200">
                <option value="">All</option>
                <option>Paid</option>
                <option>Expires</option>
                <option>Cancelled</option>
            </select>
        </div>
        <!-- Find -->
        <div>
            <button class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg">
                Find
            </button>
        </div>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="min-w-full bg-white rounded-xl overflow-hidden">
            <thead class="bg-orange-100 text-left">
                <tr>
                    <th class="px-4 py-3 font-medium">Ticket Code</th>
                    <th class="px-4 py-3 font-medium">Tickets</th>
                    <th class="px-4 py-3 font-medium">Route</th>
                    <th class="px-4 py-3 font-medium">Date of departure</th>
                    <th class="px-4 py-3 font-medium">Amount of money</th>
                    <th class="px-4 py-3 font-medium">Payment</th>
                    <th class="px-4 py-3 font-medium">Status</th>
                    <th class="px-4 py-3 font-medium">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y">
                <!-- Row 1 -->
                <tr>
                    <td class="px-4 py-3">I84OMS</td>
                    <td class="px-4 py-3">2</td>
                    <td class="px-4 py-3">Cà Mau → Miền Tây</td>
                    <td class="px-4 py-3">19:30 12-06-2025</td>
                    <td class="px-4 py-3">520.000₫</td>
                    <td class="px-4 py-3">Credit Card</td>
                    <td class="px-4 py-3">
                        <span class="bg-red-500 text-white text-xs px-2 py-1 rounded-full">Expires</span>
                    </td>
                    <td class="px-4 py-3">
                        <button class="bg-gray-200 hover:bg-gray-300 text-gray-700 text-sm px-3 py-1 rounded-full">
                            Cancel
                        </button>
                    </td>
                </tr>
                <!-- Row 2 -->
                <tr class="bg-red-50">
                    <td class="px-4 py-3">X0FATQ</td>
                    <td class="px-4 py-3">1</td>
                    <td class="px-4 py-3">Cà Mau → Miền Tây</td>
                    <td class="px-4 py-3">23:58 08-06-2025</td>
                    <td class="px-4 py-3">260.000₫</td>
                    <td class="px-4 py-3">Cash</td>
                    <td class="px-4 py-3">
                        <span class="bg-red-500 text-white text-xs px-2 py-1 rounded-full">Expires</span>
                    </td>
                    <td class="px-4 py-3">
                        <button class="bg-gray-200 hover:bg-gray-300 text-gray-700 text-sm px-3 py-1 rounded-full">
                            Cancel
                        </button>
                    </td>
                </tr>
                <!-- Row 3 -->
                <tr>
                    <td class="px-4 py-3">8XIS7S</td>
                    <td class="px-4 py-3">2</td>
                    <td class="px-4 py-3">Cà Mau → Miền Đông Mới</td>
                    <td class="px-4 py-3">08:00 27-05-2025</td>
                    <td class="px-4 py-3">520.000₫</td>
                    <td class="px-4 py-3">Credit Card</td>
                    <td class="px-4 py-3">
                        <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">Paid</span>
                    </td>
                    <td class="px-4 py-3">—</td>
                </tr>
                <!-- ... thêm các dòng dữ liệu khác tương tự ... -->
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="mt-6 flex justify-center gap-2">
        <button class="px-4 py-2 bg-orange-500 text-white rounded-lg">1</button>
        <button class="px-4 py-2 border border-orange-500 text-orange-500 rounded-lg">2</button>
        <button class="px-4 py-2 border border-orange-500 text-orange-500 rounded-lg">3</button>
        <button class="px-4 py-2 border border-orange-500 text-orange-500 rounded-lg">4</button>
    </div>


    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>