<%-- 
    Document   : view-trip-status
    Created on : Jun 14, 2025, 11:28:48 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="p-8">
        <h1 class="text-3xl font-bold text-orange-600 mb-6">View Trip Status</h1>

        <!-- Search and Filters -->
        <div class="flex flex-wrap items-center gap-4 mb-4">
            <input
                type="text"
                placeholder="Enter Trip ID or Route"
                class="border p-2 rounded-md w-64"
                />
            <button class="bg-orange-500 text-white px-4 py-2 rounded-md inline-flex items-center gap-2">
                
                Search Customer
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
                    <th class="p-2 text-left">Trip ID</th>
                    <th class="p-2 text-left">Route</th>
                    <th class="p-2 text-left">Departure</th>
                    <th class="p-2 text-left">Arrival</th>
                    <th class="p-2 text-left">Driver</th>
                    <th class="p-2 text-left">Bus Type</th>
                    <th class="p-2 text-left">Status</th>
                    <th class="p-2 text-left">Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Trip Row 1 -->
                <tr class="border-t">
                    <td class="p-2">TRIP1000</td>
                    <td class="p-2">HCM → Can Tho</td>
                    <td class="p-2">10/06/2025 08:00</td>
                    <td class="p-2">10/06/2025 12:30</td>
                    <td class="p-2">Driver 1</td>
                    <td class="p-2">Seat</td>
                    <td class="p-2">
                        <span class="px-2 py-1 text-sm rounded-full bg-yellow-100 text-yellow-700">Scheduled</span>
                    </td>
                    <td class="p-2 text-red-600">
                        <button class="inline-flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="text-red-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg> Passengers
                        </button>
                    </td>
                </tr>

                <!-- Trip Row 2 -->
                <tr class="border-t">
                    <td class="p-2">TRIP1001</td>
                    <td class="p-2">Can Tho → Chau Doc</td>
                    <td class="p-2">11/06/2025 09:00</td>
                    <td class="p-2">11/06/2025 13:30</td>
                    <td class="p-2">Driver 2</td>
                    <td class="p-2">Limousine</td>
                    <td class="p-2">
                        <span class="px-2 py-1 text-sm rounded-full bg-blue-100 text-blue-700">Departed</span>
                    </td>
                    <td class="p-2 text-red-600">
                        <button class="inline-flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="text-red-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg> Passengers
                        </button>
                    </td>
                </tr>

                <!-- Trip Row 3 -->
                <tr class="border-t">
                    <td class="p-2">TRIP1002</td>
                    <td class="p-2">HCM → Vung Tau</td>
                    <td class="p-2">12/06/2025 10:00</td>
                    <td class="p-2">12/06/2025 14:30</td>
                    <td class="p-2">Driver 3</td>
                    <td class="p-2">Bunk</td>
                    <td class="p-2">
                        <span class="px-2 py-1 text-sm rounded-full bg-green-100 text-green-700">Arrived</span>
                    </td>
                    <td class="p-2 text-red-600">
                        <button class="inline-flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="text-red-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg> Passengers
                        </button>
                    </td>
                </tr>

                <!-- Trip Row 4 -->
                <tr class="border-t">
                    <td class="p-2">TRIP1003</td>
                    <td class="p-2">Da Nang → Hue</td>
                    <td class="p-2">13/06/2025 11:00</td>
                    <td class="p-2">13/06/2025 15:30</td>
                    <td class="p-2">Driver 4</td>
                    <td class="p-2">Seat</td>
                    <td class="p-2">
                        <span class="px-2 py-1 text-sm rounded-full bg-red-100 text-red-700">Cancelled</span>
                    </td>
                    <td class="p-2 text-red-600">
                        <button class="inline-flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="text-red-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg> Passengers
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="flex justify-center mt-4 gap-2">
            <button class="px-3 py-1 rounded-md border bg-orange-500 text-white">1</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">2</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">3</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">4</button>
        </div>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>