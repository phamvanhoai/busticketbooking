<%-- 
    Document   : request-trip-change
    Created on : Jun 13, 2025, 10:49:13 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-gray-100 py-10">

  <div class="bg-white p-8 rounded-2xl shadow-lg">
    <h1 class="text-2xl font-bold text-orange-600 mb-6">Request Cancel Trip</h1>

    <form class="space-y-6">
      <!-- Chọn chuyến đã được phân công -->
      <div>
        <label for="tripSelect" class="block text-sm font-medium text-gray-700 mb-2">Chọn chuyến</label>
        <select id="tripSelect" name="tripId" required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
          <option value="" disabled selected>-- Chọn chuyến --</option>
          <option value="TRIP001">TRIP001 — HCM → Cần Thơ (15/06/2025 08:00)</option>
          <option value="TRIP002">TRIP002 — Cần Thơ → Châu Đốc (16/06/2025 09:30)</option>
          <option value="TRIP003">TRIP003 — HCM → Vũng Tàu (17/06/2025 07:45)</option>
        </select>
      </div>

      <!-- Lý do đổi chuyến -->
      <div>
        <label for="reason" class="block text-sm font-medium text-gray-700 mb-2">Lý do đổi chuyến</label>
        <textarea id="reason" name="reason" rows="4" required
          placeholder="Mô tả lý do bạn muốn đổi chuyến..."
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none"></textarea>
      </div>

      <!-- Thao tác -->
      <div class="flex justify-end gap-4">
        <button type="reset"
          class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
          Hủy
        </button>
        <button type="submit"
          class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
          Gửi yêu cầu
        </button>
      </div>
    </form>
  </div>
    
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
