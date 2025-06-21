<%-- 
    Document   : edit-route
    Created on : Jun 11, 2025, 1:33:58 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
  <div class="p-10 bg-white rounded-3xl shadow-xl mt-8">
    <h1 class="text-3xl font-bold text-orange-600 mb-8">Update Route</h1>

    <form action="#" method="post" class="space-y-8">
      <!-- Origin -->
      <div>
        <label for="origin" class="block mb-2 font-medium">Origin</label>
        <input
          id="origin"
          name="origin"
          type="text"
          value="Ho Chi Minh City"
          required
          class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
        />
      </div>

      <!-- Destination -->
      <div>
        <label for="destination" class="block mb-2 font-medium">Destination</label>
        <input
          id="destination"
          name="destination"
          type="text"
          value="Da Nang"
          required
          class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
        />
      </div>

      <!-- Estimated Time & Distance -->
      <div class="grid md:grid-cols-2 gap-6">
        <div>
          <label for="estimatedTime" class="block mb-2 font-medium">Estimated Time (mins)</label>
          <input
            id="estimatedTime"
            name="estimatedTime"
            type="number"
            value="900"
            required
            class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
          />
        </div>
        <div>
          <label for="distance" class="block mb-2 font-medium">Distance</label>
          <input
            id="distance"
            name="distance"
            type="text"
            value="960km"
            required
            class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
          />
        </div>
      </div>

      <!-- Vehicle Type & Plate Number -->
      <div class="grid md:grid-cols-2 gap-6">
        <div>
          <label for="vehicleType" class="block mb-2 font-medium">Vehicle Type</label>
          <select
            id="vehicleType"
            name="vehicleType"
            required
            class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
          >
            <option value="">Select type</option>
            <option value="Seat">Seat</option>
            <option value="Bunk">Bunk</option>
            <option value="Limousine" selected>Limousine</option>
          </select>
        </div>
        <div>
          <label for="plateNumber" class="block mb-2 font-medium">Plate Number</label>
          <input
            id="plateNumber"
            name="plateNumber"
            type="text"
            value="51F-123.45"
            required
            class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
          />
        </div>
      </div>

      <!-- Status -->
      <div>
        <label for="status" class="block mb-2 font-medium">Status</label>
        <select
          id="status"
          name="status"
          class="w-full border rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-500"
        >
          <option value="Active" selected>Active</option>
          <option value="Inactive">Inactive</option>
        </select>
      </div>

      <!-- Action Buttons -->
      <div class="flex justify-end gap-4 pt-2">
        <a href="${pageContext.servletContext.contextPath}/admin/routes"><button
          type="button"
          class="bg-gray-300 text-gray-800 px-8 py-3 rounded-lg hover:bg-gray-400"
        >
          Cancel
            </button></a>
        <button
          type="submit"
          class="bg-orange-600 text-white px-8 py-3 rounded-lg hover:bg-orange-700"
        >
          Update
        </button>
      </div>
    </form>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>