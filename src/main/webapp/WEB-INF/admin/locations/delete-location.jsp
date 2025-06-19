<%-- 
    Document   : delete-location
    Created on : Jun 20, 2025, 3:28:51 AM
    Author     : Pham Van Hoai - CE181744
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#fff6f3] flex items-center justify-center min-h-screen p-4">
  <div class="bg-white shadow-lg rounded-xl w-full p-8">
    <!-- Title -->
    <h1 class="text-3xl font-bold text-orange-600 mb-6">Delete Location</h1>

    <!-- Location Details -->
    <div class="space-y-3 text-gray-800">
      <div><span class="font-semibold">Location ID:</span> LOC12345</div>
      <div><span class="font-semibold">Name:</span> Central Station</div>
      <div><span class="font-semibold">City:</span> Ho Chi Minh City</div>
      <div><span class="font-semibold">Address:</span> 123 Nguyen Hue Blvd</div>
      <div><span class="font-semibold">Coordinates:</span> 10.77689, 106.70098</div>
    </div>

    <!-- Warning -->
    <div class="mt-6 flex items-start gap-3 bg-red-100 border border-red-300 text-red-800 px-4 py-3 rounded-lg">
      <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd"
              d="M8.257 3.099c.765-1.36 2.72-1.36 3.485 0l5.516 9.814A1.75 1.75 0 0116.516 15H3.484a1.75 1.75 0 01-1.742-2.087L8.257 3.1zM11 13a1 1 0 10-2 0 1 1 0 002 0zm-.25-2.75a.75.75 0 00-1.5 0v1.5a.75.75 0 001.5 0v-1.5z"
              clip-rule="evenodd" />
      </svg>
      <p class="text-sm">
        Are you sure you want to delete this location? This action cannot be undone.
      </p>
    </div>

    <!-- Actions -->
    <div class="mt-6 flex justify-end gap-4">
      <a href="${pageContext.servletContext.contextPath}/admin/locations">
        <button type="button"
                class="px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">
          Cancel
        </button>
      </a>
      <form method="POST" action="${pageContext.servletContext.contextPath}/admin/locations/delete">
        <input type="hidden" name="locationId" value="" />
        <button type="submit"
                class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
          Delete
        </button>
      </form>
    </div>
  </div>
<%-- CONTENT HERE--%>
<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>