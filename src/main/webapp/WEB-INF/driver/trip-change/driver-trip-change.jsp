<%-- 
    Document   : driver-trip-change
    Created on : Jul 13, 2025, 10:13:36 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-gray-100 py-10">


<body class="bg-gray-100 min-h-screen p-6">
    <div class="bg-white rounded-2xl shadow p-8">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Cancelled Trips</h1>

        <table class="w-full table-auto border-collapse">
            <thead>
                <tr class="bg-orange-100 text-orange-700">
                    <th class="px-4 py-2 text-left">Trip ID</th>
                    <th class="px-4 py-2 text-left">Route</th>
                    <th class="px-4 py-2 text-left">Date</th>
                    <th class="px-4 py-2 text-left">Reason</th>
                    <th class="px-4 py-2 text-left">Cancelled By</th>
                </tr>
            </thead>
            <tbody class="divide-y">
                <!-- Ví dụ 1 dòng dữ liệu -->
                <tr class="hover:bg-gray-50">
                    <td class="px-4 py-2">TRIP1023</td>
                    <td class="px-4 py-2">HCM → Can Tho</td>
                    <td class="px-4 py-2">15/06/2025</td>
                    <td class="px-4 py-2">Vehicle breakdown</td>
                    <td class="px-4 py-2">Admin</td>
                </tr>
                <tr class="hover:bg-gray-50">
                    <td class="px-4 py-2">TRIP1045</td>
                    <td class="px-4 py-2">Can Tho → Chau Doc</td>
                    <td class="px-4 py-2">16/06/2025</td>
                    <td class="px-4 py-2">Low bookings</td>
                    <td class="px-4 py-2">Staff</td>
                </tr>
                <!-- ... thêm các dòng khác ... -->
            </tbody>
        </table>

        <!-- Pagination nếu cần -->
        <div class="flex justify-center mt-6 space-x-2">
            <button class="px-4 py-2 bg-white border border-orange-300 rounded hover:bg-orange-50">1</button>
            <button class="px-4 py-2 bg-orange-500 text-white rounded">2</button>
            <button class="px-4 py-2 bg-white border border-orange-300 rounded hover:bg-orange-50">3</button>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
