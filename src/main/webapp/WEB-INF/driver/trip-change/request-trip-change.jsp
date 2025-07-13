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
    
  </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>

