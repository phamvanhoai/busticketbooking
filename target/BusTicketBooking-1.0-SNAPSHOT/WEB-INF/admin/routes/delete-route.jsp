<%-- 
    Document   : delete-route
    Created on : Jun 11, 2025, 1:34:37 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="bg-gray-50 p-10 rounded-3xl shadow-xl mt-8">
    <!-- Title -->
    <h1 class="text-3xl font-bold mb-8" style="color: #EF5222;">
      Delete Route
    </h1>

    <!-- Details Box -->
    <div class="border-2 rounded-2xl p-8" style="border-color: #EF5222;">
      <p class="mb-4 font-semibold">
        Origin: <span class="font-normal text-gray-800">Ho Chi Minh City</span>
      </p>
      <p class="mb-4 font-semibold">
        Destination: <span class="font-normal text-gray-800">Da Nang</span>
      </p>
      <p class="mb-4 font-semibold">
        Distance: <span class="font-normal text-gray-800">960km</span>
      </p>
      <p class="mb-4 font-semibold">
        Estimated Time: <span class="font-normal text-gray-800">900 minutes</span>
      </p>
      <p class="mb-4 font-semibold">
        Vehicle Type: <span class="font-normal text-gray-800">Limousine</span>
      </p>
      <p class="mb-8 font-semibold">
        Plate Number: <span class="font-normal text-gray-800">51F-123.45</span>
      </p>

      <!-- Warning -->
      <div class="bg-yellow-100 border border-yellow-200 text-yellow-700 rounded-lg p-4 mb-12 flex items-start gap-2">
        <i class="fas fa-exclamation-triangle mt-0.5"></i>
        <span>
          This route is linked to existing trips. Deleting it may affect trip data.
        </span>
      </div>

      <!-- Action Buttons -->
      <div class="flex justify-end gap-4">
        <button
          class="px-8 py-3 rounded-lg text-white font-semibold"
          style="background-color: #EF5222;"
        >
          Delete
        </button>
          <a href="${pageContext.servletContext.contextPath}/admin/routes"><button
          class="px-8 py-3 rounded-lg bg-gray-300 text-gray-800 font-semibold hover:bg-gray-400"
        >
          Cancel
              </button></a>
      </div>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>