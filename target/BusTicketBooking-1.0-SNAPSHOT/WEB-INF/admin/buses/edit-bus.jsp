<%-- 
    Document   : edit-bus
    Created on : Jun 11, 2025, 1:32:07 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="mt-10">
    <!-- Heading -->
    <h1 class="text-3xl font-bold text-[#EF5222] mb-6">
      Update Bus
    </h1>

    <!-- Form Card -->
    <div class="bg-white border border-[#EF5222] rounded-2xl shadow-lg p-8">
      <form action="#" method="post" class="space-y-6">
        <!-- Bus Code (read-only) -->
        <div>
          <label for="bus-id" class="block text-gray-800 font-medium mb-2">Bus Code</label>
          <input
            id="bus-id"
            type="text"
            name="id"
            value="BUS001"
            disabled
            class="w-full bg-gray-100 border border-gray-300 rounded-xl px-5 py-4 text-gray-700 cursor-not-allowed"
          />
        </div>

        <!-- Plate Number -->
        <div>
          <label for="bus-plate" class="block text-gray-800 font-medium mb-2">Plate Number</label>
          <input
            id="bus-plate"
            type="text"
            name="plate"
            value="51F-123.45"
            class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
          />
        </div>

        <!-- Bus Type -->
        <div>
          <label for="bus-type" class="block text-gray-800 font-medium mb-2">Bus Type</label>
          <select
            id="bus-type"
            name="type"
            class="w-full border border-gray-300 rounded-xl px-5 py-4 bg-white focus:outline-none focus:ring"
          >
            <option value="Seat">Seat</option>
            <option value="Bunk">Bunk</option>
            <option value="Limousine" selected>Limousine</option>
          </select>
        </div>

        <!-- Capacity -->
        <div>
          <label for="bus-capacity" class="block text-gray-800 font-medium mb-2">Capacity</label>
          <input
            id="bus-capacity"
            type="number"
            name="capacity"
            value="40"
            class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
          />
        </div>

        <!-- Status -->
        <div>
          <label for="bus-status" class="block text-gray-800 font-medium mb-2">Status</label>
          <select
            id="bus-status"
            name="status"
            class="w-full border border-gray-300 rounded-xl px-5 py-4 bg-white focus:outline-none focus:ring"
          >
            <option value="Active" selected>Active</option>
            <option value="Inactive">Inactive</option>
          </select>
        </div>

        <!-- Action Buttons -->
        <div class="flex justify-end space-x-4 mt-8">
          <button
            type="button"
            class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition"
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>