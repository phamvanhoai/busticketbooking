
<%-- 
    Document   : staff-dashboard
    Created on : Jun 15, 2025, 2:29:53 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>




<body class="bg-[#f9fafb]">

    <div class="min-h-screen bg-white py-10 px-6">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">View Booking Statistics</h2>

        <!-- Filters -->
        <div class="flex flex-wrap items-center gap-4 mb-8">
            <input
                type="text"
                placeholder="Enter Trip ID or Route"
                class="border p-2 rounded-md w-64"
            />
            <button class="bg-orange-500 text-white px-4 py-2 rounded-md inline-flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="text-white text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3a8 8 0 118 8 8 8 0 01-8-8zm0 0v6m0 0l3-3m-3 3l-3-3"></path>
                </svg>
                Search
            </button>
            <select class="border p-2 rounded-md">
                <option>All Statuses</option>
                <option>Scheduled</option>
                <option>Departed</option>
                <option>Arrived</option>
                <option>Cancelled</option>
            </select>
            <select class="border p-2 rounded-md">
                <option>All Bus Types</option>
                <option>Seat</option>
                <option>Limousine</option>
                <option>Bunk</option>
            </select>
            <select class="border p-2 rounded-md">
                <option>All Drivers</option>
                <option>Driver 1</option>
                <option>Driver 2</option>
                <option>Driver 3</option>
            </select>
        </div>

        <!-- Table -->
        <table class="w-full border rounded-xl overflow-hidden">
            <thead class="bg-orange-50 text-gray-800 font-semibold">
                <tr>
                    <th class="p-2 text-left">Date</th>
                    <th class="p-2 text-left">Route</th>
                    <th class="p-2 text-left">Tickets Sold</th>
                    <th class="p-2 text-left">Occupancy (%)</th>
                    <th class="p-2 text-left">Driver</th>
                </tr>
            </thead>
            <tbody>
                <!-- Row 1 -->
                <tr class="border-t hover:bg-gray-50">
                    <td class="p-2">10/06/2025</td>
                    <td class="p-2">HCM → Can Tho</td>
                    <td class="p-2">57</td>
                    <td class="p-2">92%</td>
                    <td class="p-2">Nguyen Van A</td>
                </tr>

                <!-- Row 2 -->
                <tr class="border-t hover:bg-gray-50">
                    <td class="p-2">10/06/2025</td>
                    <td class="p-2">HCM → Can Tho</td>
                    <td class="p-2">57</td>
                    <td class="p-2">92%</td>
                    <td class="p-2">Nguyen Van A</td>
                </tr>

                <!-- Row 3 -->
                <tr class="border-t hover:bg-gray-50">
                    <td class="p-2">10/06/2025</td>
                    <td class="p-2">HCM → Vung Tau</td>
                    <td class="p-2">54</td>
                    <td class="p-2">84%</td>
                    <td class="p-2">Tran Van C</td>
                </tr>

                <!-- Row 4 -->
                <tr class="border-t hover:bg-gray-50">
                    <td class="p-2">10/06/2025</td>
                    <td class="p-2">Can Tho → Rach Gia</td>
                    <td class="p-2">48</td>
                    <td class="p-2">68%</td>
                    <td class="p-2">Pham Thi D</td>
                </tr>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 gap-2">
            <button class="px-3 py-1 rounded-md border bg-orange-500 text-white">1</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">2</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">3</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">4</button>
        </div>

        <!-- Top Drivers Podium -->
        <div class="mt-12">
            <h3 class="text-2xl font-bold text-[#EF5222] text-center mb-8 flex items-center justify-center gap-2">
                🏆 Top Drivers
            </h3>

            <div class="flex justify-center items-end gap-8">
                <!-- Driver 1 -->
                <div class="flex flex-col items-center">
                    <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-lg font-bold shadow-md">
                        N
                    </div>
                    <div class="font-medium mt-1">Nguyen Van A</div>
                    <div class="text-sm text-gray-500">10 trips</div>
                    <div class="w-20 h-32 bg-[#FF9F75] text-white text-center flex items-center justify-center font-bold rounded-t-lg shadow">
                        1
                    </div>
                    <FaCrown class="text-xl mt-1 text-yellow-400" />
                </div>

                <!-- Driver 2 -->
                <div class="flex flex-col items-center">
                    <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-lg font-bold shadow-md">
                        T
                    </div>
                    <div class="font-medium mt-1">Tran Van C</div>
                    <div class="text-sm text-gray-500">8 trips</div>
                    <div class="w-20 h-32 bg-[#EF5222] text-white text-center flex items-center justify-center font-bold rounded-t-lg shadow">
                        2
                    </div>
                    <FaCrown class="text-xl mt-1 text-gray-400" />
                </div>

                <!-- Driver 3 -->
                <div class="flex flex-col items-center">
                    <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-lg font-bold shadow-md">
                        P
                    </div>
                    <div class="font-medium mt-1">Pham Thi D</div>
                    <div class="text-sm text-gray-500">6 trips</div>
                    <div class="w-20 h-24 bg-[#FFDBC7] text-white text-center flex items-center justify-center font-bold rounded-t-lg shadow">
                        3
                    </div>
                    <FaCrown class="text-xl mt-1 text-orange-400" />
                </div>
            </div>
        </div>

    </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>