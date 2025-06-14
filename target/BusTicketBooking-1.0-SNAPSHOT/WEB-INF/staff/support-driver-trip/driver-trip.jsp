<%-- 
    Document   : driver-trip
    Created on : Jun 14, 2025, 12:26:31 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-7xl mx-auto p-6 space-y-6">
        <h2 class="text-2xl font-bold text-orange-600">Support Change Trip for Driver</h2>

        <!-- Search & Filter -->
        <div class="flex flex-wrap items-center gap-4">
            <div class="flex flex-1 max-w-md">
                <input
                    type="text"
                    placeholder="Search by Request ID or Driver"
                    class="flex-1 border border-gray-300 rounded-l-lg px-4 py-2 focus:outline-none"
                    />
                <button class="bg-orange-500 hover:bg-orange-600 text-white px-4 rounded-r-lg">
                    Search
                </button>
            </div>
            <select class="border border-gray-300 rounded-lg px-4 py-2">
                <option value="All">All Statuses</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Rejected">Rejected</option>
            </select>
        </div>

        <!-- Table -->
        <div class="overflow-x-auto bg-white rounded-2xl shadow">
            <table class="min-w-full">
                <thead class="bg-orange-50">
                    <tr>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Request ID</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Driver</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Old Trip</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">New Trip</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Date</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Status</th>
                        <th class="px-6 py-3 text-left font-medium text-orange-600">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Row 1 -->
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-6 py-4">DRVREQ1</td>
                        <td class="px-6 py-4">Driver 1</td>
                        <td class="px-6 py-4">HCM → Can Tho</td>
                        <td class="px-6 py-4">Can Tho → Da Nang</td>
                        <td class="px-6 py-4">10/06/2025</td>
                        <td class="px-6 py-4">
                            <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-700">Pending</span>
                        </td>
                        <td class="px-6 py-4">
                            <button class="flex items-center gap-1 text-blue-600 hover:underline">
                                <svg xmlns="http://www.w3.org/2000/svg" class="text-blue-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                </svg> View
                            </button>
                        </td>
                    </tr>

                    <!-- Row 2 -->
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-6 py-4">DRVREQ2</td>
                        <td class="px-6 py-4">Driver 2</td>
                        <td class="px-6 py-4">Chau Doc → HCM</td>
                        <td class="px-6 py-4">Hue → HCM</td>
                        <td class="px-6 py-4">11/06/2025</td>
                        <td class="px-6 py-4">
                            <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-700">Approved</span>
                        </td>
                        <td class="px-6 py-4">
                            <button class="flex items-center gap-1 text-blue-600 hover:underline">
                                <svg xmlns="http://www.w3.org/2000/svg" class="text-blue-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                </svg> View
                            </button>
                        </td>
                    </tr>

                    <!-- Row 3 -->
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-6 py-4">DRVREQ3</td>
                        <td class="px-6 py-4">Driver 3</td>
                        <td class="px-6 py-4">HCM → Can Tho</td>
                        <td class="px-6 py-4">Can Tho → Da Nang</td>
                        <td class="px-6 py-4">12/06/2025</td>
                        <td class="px-6 py-4">
                            <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-700">Rejected</span>
                        </td>
                        <td class="px-6 py-4">
                            <button class="flex items-center gap-1 text-blue-600 hover:underline">
                                <svg xmlns="http://www.w3.org/2000/svg" class="text-blue-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                </svg> View
                            </button>
                        </td>
                    </tr>

                    <!-- Row 4 -->
                    <tr class="border-b hover:bg-gray-50">
                        <td class="px-6 py-4">DRVREQ4</td>
                        <td class="px-6 py-4">Driver 4</td>
                        <td class="px-6 py-4">Chau Doc → HCM</td>
                        <td class="px-6 py-4">Hue → HCM</td>
                        <td class="px-6 py-4">13/06/2025</td>
                        <td class="px-6 py-4">
                            <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-700">Pending</span>
                        </td>
                        <td class="px-6 py-4">
                            <button class="flex items-center gap-1 text-blue-600 hover:underline">
                                <svg xmlns="http://www.w3.org/2000/svg" class="text-blue-600 text-xl" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                </svg> View
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <button class="w-10 h-10 rounded-lg border bg-orange-500 text-white">1</button>
            <button class="w-10 h-10 rounded-lg border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">2</button>
            <button class="w-10 h-10 rounded-lg border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">3</button>
            <button class="w-10 h-10 rounded-lg border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">4</button>
        </div>

    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>