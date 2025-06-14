<%-- 
    Document   : add-trip
    Created on : Jun 11, 2025, 1:19:27 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
  <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
    <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Create New Trip</h2>
    <form action="#" method="post" class="space-y-6">
      <!-- Route as select -->
      <div>
        <label for="route" class="block mb-1 font-medium">Route</label>
        <select
          id="route"
          name="route"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        >
          <option value="" disabled selected>Chọn tuyến</option>
          <option value="HCM → Can Tho">HCM → Can Tho</option>
          <option value="Can Tho → Chau Doc">Can Tho → Chau Doc</option>
          <option value="Hue → Da Nang">Hue → Da Nang</option>
        </select>
      </div>

      <!-- Dates & Times -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label for="departureDate" class="block mb-1 font-medium">Departure Date</label>
          <input
            id="departureDate"
            name="departureDate"
            type="date"
            required
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
          />
        </div>
        <div>
          <label for="departureTime" class="block mb-1 font-medium">Departure Time</label>
          <input
            id="departureTime"
            name="departureTime"
            type="time"
            required
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
          />
        </div>
      </div>

      <div>
        <label for="arrivalTime" class="block mb-1 font-medium">Arrival Time</label>
        <input
          id="arrivalTime"
          name="arrivalTime"
          type="time"
          required
          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
        />
      </div>

      <!-- Driver & Bus Select -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label for="driver" class="block mb-1 font-medium">Driver</label>
          <select
            id="driver"
            name="driver"
            required
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
          >
            <option value="" disabled selected>Select driver</option>
            <option value="Driver 1">Driver 1</option>
            <option value="Driver 2">Driver 2</option>
          </select>
        </div>
        <div>
          <label for="bus" class="block mb-1 font-medium">Bus</label>
          <select
            id="bus"
            name="bus"
            required
            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
          >
            <option value="" disabled selected>Select bus</option>
            <option value="Bus A01">Bus A01</option>
            <option value="Bus B01">Bus B01</option>
          </select>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-4 pt-4">
          <a href="${pageContext.servletContext.contextPath}/admin/trips"><button
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