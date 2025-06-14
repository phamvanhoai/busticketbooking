<%-- 
    Document   : add-route
    Created on : Jun 11, 2025, 1:34:49 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>



<body class="bg-gray-50">
  <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
    <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Create Route</h2>
    <form action="#" method="post" class="space-y-6">
      <!-- Origin -->
      <div>
        <label for="origin" class="block mb-1 font-medium">Origin</label>
        <input
          id="origin"
          name="origin"
          type="text"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        />
      </div>

      <!-- Destination -->
      <div>
        <label for="destination" class="block mb-1 font-medium">Destination</label>
        <input
          id="destination"
          name="destination"
          type="text"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        />
      </div>

      <!-- Estimated Time -->
      <div>
        <label for="estimatedTime" class="block mb-1 font-medium">
          Estimated Time (minutes)
        </label>
        <input
          id="estimatedTime"
          name="estimatedTime"
          type="number"
          min="1"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        />
      </div>

      <!-- Vehicle Type -->
      <div>
        <label for="vehicleType" class="block mb-1 font-medium">Vehicle Type</label>
        <select
          id="vehicleType"
          name="vehicleType"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        >
          <option value="" disabled selected>Select vehicle type</option>
          <option value="Seat">Seat</option>
          <option value="Bunk">Bunk</option>
          <option value="Limousine">Limousine</option>
        </select>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-4 pt-4">
          <a href="${pageContext.servletContext.contextPath}/admin/routes"><button
          type="button"
          class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-lg"
        >
          Cancel
              </button></a> 
        <button
          type="submit"
          class="bg-[#EF5222] hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg"
        >
          Create
        </button>
      </div>
    </form>
  </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>