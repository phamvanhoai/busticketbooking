<%-- 
    Document   : view-statistics
    Created on : Jun 15, 2025, 2:11:27 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>



<body class="bg-gray-50">
  <div class="p-6 max-w-[1400px] mx-auto space-y-10">
    <div class="flex justify-between items-center">
      <h2 class="text-3xl font-bold text-[#ef5222]">Admin Dashboard – Booking Statistics</h2>
      <div class="space-x-3">
        <button class="bg-[#ef5222] text-white px-4 py-2 rounded-xl hover:bg-[#fc7b4c]">Export (PDF)</button>
        <button class="bg-white border border-[#ef5222] text-[#ef5222] px-4 py-2 rounded-xl hover:bg-[#ffedd5]">Export (Excel)</button>
      </div>
    </div>

    <!-- Charts Row 1 -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
      <div class="bg-white shadow-xl rounded-2xl p-5">
        <h3 class="font-semibold mb-3">Monthly Revenue</h3>
        <canvas id="chartRevenue"></canvas>
      </div>
      <div class="bg-white shadow-xl rounded-2xl p-5">
        <h3 class="font-semibold mb-3">Occupancy Rate</h3>
        <canvas id="chartOccupancy"></canvas>
      </div>
      <div class="bg-white shadow-xl rounded-2xl p-5">
        <h3 class="font-semibold mb-3">Ticket Type Breakdown</h3>
        <canvas id="chartTicketType"></canvas>
      </div>
    </div>

    <!-- Charts Row 2 -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="bg-white shadow-xl rounded-2xl p-5">
        <h3 class="font-semibold mb-3">Top 5 Routes by Revenue</h3>
        <canvas id="chartTopRoutes"></canvas>
      </div>
      <div class="bg-white shadow-xl rounded-2xl p-5">
        <h3 class="font-semibold mb-3">Driver Performance</h3>
        <ul class="space-y-3 text-sm text-gray-700">
          <li class="flex justify-between bg-orange-50 px-4 py-2 rounded-lg shadow-sm border border-orange-200">
            <span class="font-medium text-[#ef5222]">Driver A</span>
            <span>20 trips – 540 tickets – 12,500,000 VND</span>
          </li>
          <li class="flex justify-between bg-orange-50 px-4 py-2 rounded-lg shadow-sm border border-orange-200">
            <span class="font-medium text-[#ef5222]">Driver B</span>
            <span>15 trips – 460 tickets – 10,100,000 VND</span>
          </li>
        </ul>
      </div>
    </div>

    <!-- Detailed Table -->
    <div class="bg-white shadow-xl rounded-2xl p-5 overflow-auto">
      <h3 class="font-semibold mb-3">Detailed Daily Statistics</h3>
      <table class="w-full text-sm text-left">
        <thead class="bg-orange-100 text-[#ef5222]">
          <tr>
            <th class="px-4 py-2">Date</th>
            <th class="px-4 py-2">Route</th>
            <th class="px-4 py-2">Tickets Sold</th>
            <th class="px-4 py-2">Revenue</th>
            <th class="px-4 py-2">Occupancy (%)</th>
          </tr>
        </thead>
        <tbody>
          <!-- Page 1 of 2 -->
          <tr class="border-b hover:bg-orange-50"><td class="px-4 py-2">01/06/2025</td><td class="px-4 py-2">HCM → Can Tho</td><td class="px-4 py-2">30</td><td class="px-4 py-2">3.600.000 VND</td><td class="px-4 py-2">60%</td></tr>
          <tr class="border-b hover:bg-orange-50"><td class="px-4 py-2">02/06/2025</td><td class="px-4 py-2">HCM → Can Tho</td><td class="px-4 py-2">33</td><td class="px-4 py-2">4.200.000 VND</td><td class="px-4 py-2">64%</td></tr>
          <tr class="border-b hover:bg-orange-50"><td class="px-4 py-2">03/06/2025</td><td class="px-4 py-2">HCM → Can Tho</td><td class="px-4 py-2">36</td><td class="px-4 py-2">4.800.000 VND</td><td class="px-4 py-2">68%</td></tr>
          <tr class="border-b hover:bg-orange-50"><td class="px-4 py-2">04/06/2025</td><td class="px-4 py-2">HCM → Can Tho</td><td class="px-4 py-2">39</td><td class="px-4 py-2">5.400.000 VND</td><td class="px-4 py-2">72%</td></tr>
          <tr class="border-b hover:bg-orange-50"><td class="px-4 py-2">05/06/2025</td><td class="px-4 py-2">HCM → Can Tho</td><td class="px-4 py-2">42</td><td class="px-4 py-2">6.000.000 VND</td><td class="px-4 py-2">76%</td></tr>
        </tbody>
      </table>
      <div class="flex justify-center gap-2 mt-4">
        <button class="px-3 py-1 rounded bg-[#ef5222] text-white">1</button>
        <button class="px-3 py-1 rounded bg-white text-[#ef5222] border border-[#ef5222]">2</button>
      </div>
    </div>
  </div>

  <script>
    // Chart data definitions
    const monthlyRevenue = {
      labels: ["Jan","Feb","Mar","Apr","May","Jun"],
      datasets: [{ label:"Revenue (VND)", data:[11000000,13000000,15500000,9000000,21000000,17500000], backgroundColor:"#ef5222" }]
    };
    const occupancyRate = {
      labels:["HCM → Can Tho","Can Tho → Chau Doc","HCM → Vung Tau"],
      datasets:[{ label:"Occupancy (%)", data:[72,65,78], borderColor:"#ef5222", backgroundColor:"#ef5222", tension:0.4 }]
    };
    const ticketType = {
      labels:["Seat","Bunk","Limousine"],
      datasets:[{ data:[320,240,160], backgroundColor:["#ef5222","#a855f7","#10b981"] }]
    };
    const topRoutes = {
      labels:["HCM → Vung Tau","HCM → Can Tho","Can Tho → Chau Doc"],
      datasets:[{ label:"Top 5 Route Revenue", data:[21000000,18500000,17200000], backgroundColor:["#ef5222","#fc7b4c","#fdba74"] }]
    };

    // Create charts
    new Chart(document.getElementById('chartRevenue'), { type:'bar', data:monthlyRevenue, options:{ responsive:true, plugins:{ legend:{ display:false } } } });
    new Chart(document.getElementById('chartOccupancy'), { type:'line', data:occupancyRate, options:{ responsive:true, plugins:{ legend:{ position:'top' } } } });
    new Chart(document.getElementById('chartTicketType'), { type:'pie', data:ticketType, options:{ responsive:true, plugins:{ legend:{ position:'bottom' } } } });
    new Chart(document.getElementById('chartTopRoutes'), { type:'bar', data:topRoutes, options:{ responsive:true, plugins:{ legend:{ display:false } } } });
  </script>
  
  
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>