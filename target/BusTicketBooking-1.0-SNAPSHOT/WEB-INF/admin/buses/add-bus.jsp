<%-- 
    Document   : add-bus
    Created on : Jun 11, 2025, 1:31:57 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="mt-10 p-8 bg-white rounded-2xl shadow-lg border border-[#EF5222]">
    <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Create New Bus</h1>
    <form action="#" method="post" class="space-y-6">
      <!-- Bus Code -->
      <div>
        <label for="code" class="block mb-2 font-medium text-gray-800">Bus Code</label>
        <input
          id="code"
          name="code"
          type="text"
          placeholder=""
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
        />
      </div>
      <!-- License Plate -->
      <div>
        <label for="plate" class="block mb-2 font-medium text-gray-800">License Plate</label>
        <input
          id="plate"
          name="plate"
          type="text"
          placeholder=""
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
        />
      </div>
      <!-- Bus Type -->
      <div>
        <label for="type" class="block mb-2 font-medium text-gray-800">Bus Type</label>
        <select
          id="type"
          name="type"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
        >
          <option value="" disabled selected>Select type</option>
          <option value="Seat">Seat</option>
          <option value="Bunk">Bunk</option>
          <option value="Limousine">Limousine</option>
        </select>
      </div>
      <!-- Capacity -->
      <div>
        <label for="capacity" class="block mb-2 font-medium text-gray-800">Capacity</label>
        <input
          id="capacity"
          name="capacity"
          type="number"
          placeholder=""
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
        />
      </div>
      <!-- Status -->
      <div>
        <label for="status" class="block mb-2 font-medium text-gray-800">Status</label>
        <select
          id="status"
          name="status"
          class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
        >
          <option value="Active" selected>Active</option>
          <option value="Inactive">Inactive</option>
        </select>
      </div>
      <!-- Actions -->
      <div class="flex justify-end space-x-4 mt-6">
        <button
          type="button"
          onclick="document.getElementById('code').value='';document.getElementById('plate').value='';document.getElementById('type').selectedIndex=0;document.getElementById('capacity').value='';document.getElementById('status').value='Active';"
          class="px-6 py-3 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400"
        >
          Cancel
        </button>
        <button
          type="submit"
          class="px-6 py-3 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90"
        >
          Create
        </button>
      </div>
    </form>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>