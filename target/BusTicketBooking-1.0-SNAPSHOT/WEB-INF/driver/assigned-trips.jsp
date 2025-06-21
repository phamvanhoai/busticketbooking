<%-- 
    Document   : assigned-trips
    Created on : Jun 13, 2025, 10:48:20 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <!-- Tiêu đề -->
        <h1 class="text-3xl font-bold text-orange-600">Assigned Trips</h1>

        <!-- Bộ lọc -->
        <div class="flex flex-col md:flex-row gap-4">
            <input
                type="date"
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                placeholder="Select date"
                />
            <select
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                >
                <option>All Routes</option>
                <option>HCM → Cần Thơ</option>
                <option>Cần Thơ → Châu Đốc</option>
                <option>Huế → Đà Nẵng</option>
            </select>
            <select
                class="w-full md:w-1/4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200"
                >
                <option>All Status</option>
                <option>Scheduled</option>
                <option>Ongoing</option>
                <option>Completed</option>
                <option>Cancelled</option>
            </select>
            <button
                class="w-full md:w-auto bg-orange-500 text-white rounded-lg px-6 py-2 hover:bg-orange-600"
                >
                Filter
            </button>
        </div>

        <!-- Bảng Assigned Trips -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-600">
                    <tr>
                        <th class="px-6 py-3">Trip ID</th>
                        <th class="px-6 py-3">Date</th>
                        <th class="px-6 py-3">Time</th>
                        <th class="px-6 py-3">Route</th>
                        <th class="px-6 py-3">Bus Type</th>
                        <th class="px-6 py-3">Passengers</th>
                        <th class="px-6 py-3">Status</th>
                        <th class="px-6 py-3">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <!-- Mẫu 1 -->
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4">TRIP1001</td>
                        <td class="px-6 py-4">17/06/2025</td>
                        <td class="px-6 py-4">08:00</td>
                        <td class="px-6 py-4">HCM → Cần Thơ</td>
                        <td class="px-6 py-4">Limousine</td>
                        <td class="px-6 py-4">12</td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs">Scheduled</span>
                        </td>
                        <td class="px-6 py-4 space-x-2">
                            <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?roll-call=">
                                <button class="text-blue-600 hover:underline text-sm">Roll call</button></a>
                            <button class="text-blue-600 hover:underline text-sm">View</button>
                            <button class="text-gray-600 hover:underline text-sm">Start</button>
                        </td>
                    </tr>
                    <!-- Mẫu 2 -->
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4">TRIP1002</td>
                        <td class="px-6 py-4">17/06/2025</td>
                        <td class="px-6 py-4">12:00</td>
                        <td class="px-6 py-4">Cần Thơ → Châu Đốc</td>
                        <td class="px-6 py-4">Seat</td>
                        <td class="px-6 py-4">20</td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-xs">Ongoing</span>
                        </td>
                        <td class="px-6 py-4 space-x-2">
                            <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?roll-call=">
                                <button class="text-blue-600 hover:underline text-sm">Roll call</button></a>
                            <button class="text-blue-600 hover:underline text-sm">View</button>
                            <button class="text-red-600 hover:underline text-sm">End</button>
                        </td>
                    </tr>
                    <!-- Mẫu 3 -->
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4">TRIP1003</td>
                        <td class="px-6 py-4">16/06/2025</td>
                        <td class="px-6 py-4">10:00</td>
                        <td class="px-6 py-4">Huế → Đà Nẵng</td>
                        <td class="px-6 py-4">Bunk</td>
                        <td class="px-6 py-4">8</td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 bg-gray-200 text-gray-700 rounded-full text-xs">Completed</span>
                        </td>
                        <td class="px-6 py-4 space-x-2">
                            <a href="${pageContext.servletContext.contextPath}/driver/assigned-trips?roll-call=">
                                <button class="text-blue-600 hover:underline text-sm">Roll call</button></a>
                            <button class="text-blue-600 hover:underline text-sm">View</button>

                        </td>
                    </tr>
                    <!-- … thêm các bản ghi khác … -->
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center space-x-2">
            <button class="px-3 py-1 bg-orange-500 text-white rounded">1</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">2</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">3</button>
            <button class="px-3 py-1 border rounded hover:bg-gray-100">»</button>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
