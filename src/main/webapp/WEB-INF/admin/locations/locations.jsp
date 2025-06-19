<%-- 
    Document   : locations
    Created on : Jun 20, 2025, 2:51:08 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#f3f3f5] min-h-screen p-6">

    <div class="space-y-6">
        <!-- Title + Search/Add -->
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <h1 class="text-3xl font-bold text-[#EF5222]">Manage Locations</h1>
            <div class="flex gap-2 w-full md:w-auto">
                <input
                    type="text"
                    placeholder="Search locations..."
                    class="flex-1 md:flex-none px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-400"
                    />
                <a href="${pageContext.servletContext.contextPath}/admin/locations?add"><button
                        class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg transition"
                        >
                        + Add Location
                    </button></a>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-3">ID</th>
                        <th class="px-4 py-3">Name</th>
                        <th class="px-4 py-3">Address</th>
                        <th class="px-4 py-3">City</th>
                        <th class="px-4 py-3 text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <tr class="hover:bg-gray-50">
                        <td class="px-4 py-3">LOC001</td>
                        <td class="px-4 py-3">Downtown Station</td>
                        <td class="px-4 py-3">123 Main St</td>
                        <td class="px-4 py-3">HCM City</td>
                        <td class="px-4 py-3 text-right flex justify-end gap-2">
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?detail=">
                                <button class="text-blue-600 hover:underline text-sm">View</button></a>
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?editId=">
                                <button class="text-blue-600 hover:underline text-sm">Edit</button></a>
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?delete=">
                                <button class="text-red-600 hover:underline text-sm">Delete</button></a>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50">
                        <td class="px-4 py-3">LOC002</td>
                        <td class="px-4 py-3">East Depot</td>
                        <td class="px-4 py-3">456 East Blvd</td>
                        <td class="px-4 py-3">HCM City</td>
                        <td class="px-4 py-3 text-right flex justify-end gap-2">
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?detail=">
                                <button class="text-blue-600 hover:underline text-sm">View</button></a>
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?editId=">
                                <button class="text-blue-600 hover:underline text-sm">Edit</button></a>
                            <a href="${pageContext.servletContext.contextPath}/admin/locations?delete=">
                                <button class="text-red-600 hover:underline text-sm">Delete</button></a>
                        </td>
                    </tr>
                    <!-- Thêm nhiều dòng tương tự -->
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center items-center gap-2">
            <button class="px-3 py-1 bg-white text-orange-600 border border-orange-300 rounded-lg hover:bg-orange-50">
                ‹
            </button>
            <button class="px-4 py-1 bg-orange-500 text-white rounded-lg">1</button>
            <button class="px-4 py-1 bg-white text-orange-600 border border-orange-300 rounded-lg hover:bg-orange-50">2</button>
            <button class="px-3 py-1 bg-white text-orange-600 border border-orange-300 rounded-lg hover:bg-orange-50">
                ›
            </button>
        </div>
    </div>
    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>