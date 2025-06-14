<%-- 
    Document   : trips
    Created on : Jun 11, 2025, 1:19:08 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
  <div class="mt-10 px-4">
    <!-- Header + Create Button -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-3xl font-bold text-[#EF5222]">Manage Trips</h2>
      <a href="${pageContext.servletContext.contextPath}/admin/trips?add"><button
        class="bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg flex items-center gap-2"
      >
        <i class="fas fa-plus"></i>
        Create New Trip
          </button></a>
    </div>

    <!-- Filters -->
    <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-6">
      <select class="border border-gray-300 rounded-lg px-4 py-2">
        <option>All Routes</option>
        <option>HCM → Can Tho</option>
        <option>Can Tho → Chau Doc</option>
        <option>Hue → Da Nang</option>
      </select>

      <select class="border border-gray-300 rounded-lg px-4 py-2">
        <option>All Bus Types</option>
        <option>Seat</option>
        <option>Bunk</option>
        <option>Limousine</option>
      </select>

      <select class="border border-gray-300 rounded-lg px-4 py-2">
        <option>All Drivers</option>
        <option>Driver 1</option>
        <option>Driver 2</option>
        <option>Driver 3</option>
        <option>Driver 4</option>
        <option>Driver 5</option>
        <option>Driver 6</option>
        <option>Driver 7</option>
        <option>Driver 8</option>
      </select>
    </div>

    <!-- Trip Table -->
    <div class="bg-white shadow-md rounded-xl overflow-x-auto">
      <table class="min-w-full text-left">
        <thead class="bg-orange-100 text-orange-700">
          <tr>
            <th class="py-2 px-4">Trip ID</th>
            <th class="py-2 px-4">Route</th>
            <th class="py-2 px-4">Date</th>
            <th class="py-2 px-4">Time</th>
            <th class="py-2 px-4">Bus Type</th>
            <th class="py-2 px-4">Driver</th>
            <th class="py-2 px-4">Status</th>
            <th class="py-2 px-4">Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Ví dụ 3 hàng mẫu -->
          <tr class="border-t hover:bg-gray-50">
            <td class="py-2 px-4">TRIP1000</td>
            <td class="py-2 px-4">HCM → Can Tho</td>
            <td class="py-2 px-4">10/06/2025</td>
            <td class="py-2 px-4">8:00</td>
            <td class="py-2 px-4">Seat</td>
            <td class="py-2 px-4">Driver 1</td>
            <td class="py-2 px-4">
              <span
                class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700"
              >
                Scheduled
              </span>
            </td>
            <td class="py-2 px-4 flex gap-3">
              <button class="text-blue-600 hover:underline flex items-center gap-1">
                <i class="fas fa-eye"></i> View
              </button>
                <a href="${pageContext.servletContext.contextPath}/admin/trips?editId=1"><button class="text-yellow-600 hover:underline flex items-center gap-1">
                <i class="fas fa-edit"></i> Edit
                    </button></a>
              <button class="text-red-600 hover:underline flex items-center gap-1">
                <i class="fas fa-trash"></i> Delete
              </button>
            </td>
          </tr>
          <tr class="border-t hover:bg-gray-50">
            <td class="py-2 px-4">TRIP1001</td>
            <td class="py-2 px-4">Can Tho → Chau Doc</td>
            <td class="py-2 px-4">11/06/2025</td>
            <td class="py-2 px-4">9:00</td>
            <td class="py-2 px-4">Bunk</td>
            <td class="py-2 px-4">Driver 2</td>
            <td class="py-2 px-4">
              <span
                class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600"
              >
                Cancelled
              </span>
            </td>
            <td class="py-2 px-4 flex gap-3">
              <button class="text-blue-600 hover:underline flex items-center gap-1">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/trips?editId=1"><button class="text-yellow-600 hover:underline flex items-center gap-1">
                <i class="fas fa-edit"></i> Edit
                    </button></a>
              <button class="text-red-600 hover:underline flex items-center gap-1">
                <i class="fas fa-trash"></i> Delete
              </button>
            </td>
          </tr>
          <tr class="border-t hover:bg-gray-50">
            <td class="py-2 px-4">TRIP1002</td>
            <td class="py-2 px-4">Hue → Da Nang</td>
            <td class="py-2 px-4">12/06/2025</td>
            <td class="py-2 px-4">10:00</td>
            <td class="py-2 px-4">Limousine</td>
            <td class="py-2 px-4">Driver 3</td>
            <td class="py-2 px-4">
              <span
                class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700"
              >
                Scheduled
              </span>
            </td>
            <td class="py-2 px-4 flex gap-3">
              <button class="text-blue-600 hover:underline flex items-center gap-1">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/trips?editId=1"><button class="text-yellow-600 hover:underline flex items-center gap-1">
                <i class="fas fa-edit"></i> Edit
                    </button></a>
              <button class="text-red-600 hover:underline flex items-center gap-1">
                <i class="fas fa-trash"></i> Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center gap-2 mt-6">
      <button
        class="px-4 py-2 rounded-lg border bg-[#EF5222] text-white"
      >
        1
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        2
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        3
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        4
      </button>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>