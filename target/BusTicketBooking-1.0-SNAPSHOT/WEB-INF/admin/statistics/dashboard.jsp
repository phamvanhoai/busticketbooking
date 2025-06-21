<%-- 
    Document   : dashboard
    Created on : Jun 6, 2025, 10:19:40 PM
    Author     : Pham Van Hoai - CE181744
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50 text-gray-800">

  <div class="max-w-7xl mx-auto px-6 py-8 space-y-8">
    <!-- Title + Export Buttons -->
    <div class="flex items-center justify-between">
      <h1 class="text-3xl font-bold text-orange-600">View Statistics</h1>
      <div class="space-x-2">
        <button class="px-4 py-2 bg-orange-500 hover:bg-orange-600 text-white rounded-lg">Export (PDF)</button>
        <button class="px-4 py-2 border border-orange-500 text-orange-500 hover:bg-orange-50 rounded-lg">Export (Excel)</button>
      </div>
    </div>

    <!-- Top Row: 3 Charts -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Monthly Revenue -->
      <div class="bg-white rounded-2xl shadow p-6">
        <h2 class="font-semibold mb-4">Monthly Revenue</h2>
        <canvas id="chart-monthly-revenue" class="h-48 w-full"></canvas>
      </div>
      <!-- Occupancy Rate -->
      <div class="bg-white rounded-2xl shadow p-6">
        <h2 class="font-semibold mb-4">Occupancy Rate</h2>
        <canvas id="chart-occupancy-rate" class="h-48 w-full"></canvas>
      </div>
      <!-- Ticket Type Breakdown -->
      <div class="bg-white rounded-2xl shadow p-6">
        <h2 class="font-semibold mb-4">Ticket Type Breakdown</h2>
        <canvas id="chart-ticket-breakdown" class="h-48 w-full"></canvas>
      </div>
    </div>

    <!-- Middle Row: Bar Chart + Driver Performance -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Top 5 Routes by Revenue (span 2 cols on lg) -->
      <div class="lg:col-span-2 bg-white rounded-2xl shadow p-6">
        <h2 class="font-semibold mb-4">Top 5 Routes by Revenue</h2>
        <canvas id="chart-top5-routes" class="h-48 w-full"></canvas>
      </div>
      <!-- Driver Performance -->
      <div class="bg-white rounded-2xl shadow p-6">
        <h2 class="font-semibold mb-4">Driver Performance</h2>
        <ul class="space-y-3">
          <li class="flex justify-between items-center bg-orange-50 rounded-full px-4 py-2">
            <span class="font-medium text-orange-600">Driver A</span>
            <span class="text-sm text-gray-700">20 trips – 540 tickets – 12,500,000 VND</span>
          </li>
          <li class="flex justify-between items-center bg-orange-50 rounded-full px-4 py-2">
            <span class="font-medium text-orange-600">Driver B</span>
            <span class="text-sm text-gray-700">15 trips – 460 tickets – 10,100,000 VND</span>
          </li>
        </ul>
      </div>
    </div>

    <!-- Detailed Daily Statistics -->
    <div class="bg-white rounded-2xl shadow p-6">
      <h2 class="font-semibold mb-4">Detailed Daily Statistics</h2>
      <div class="overflow-x-auto">
        <table class="min-w-full text-left divide-y divide-gray-200">
          <thead class="bg-orange-50">
            <tr>
              <th class="px-4 py-2 font-medium">Date</th>
              <th class="px-4 py-2 font-medium">Route</th>
              <th class="px-4 py-2 font-medium">Tickets Sold</th>
              <th class="px-4 py-2 font-medium">Revenue</th>
              <th class="px-4 py-2 font-medium">Occupancy (%)</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr>
              <td class="px-4 py-2">01/06/2025</td>
              <td class="px-4 py-2">HCM → Can Tho</td>
              <td class="px-4 py-2">30</td>
              <td class="px-4 py-2">3.600.000 VND</td>
              <td class="px-4 py-2">60%</td>
            </tr>
            <tr>
              <td class="px-4 py-2">02/06/2025</td>
              <td class="px-4 py-2">HCM → Can Tho</td>
              <td class="px-4 py-2">33</td>
              <td class="px-4 py-2">4.200.000 VND</td>
              <td class="px-4 py-2">64%</td>
            </tr>
            <tr>
              <td class="px-4 py-2">03/06/2025</td>
              <td class="px-4 py-2">HCM → Can Tho</td>
              <td class="px-4 py-2">36</td>
              <td class="px-4 py-2">4.800.000 VND</td>
              <td class="px-4 py-2">68%</td>
            </tr>
            <tr>
              <td class="px-4 py-2">04/06/2025</td>
              <td class="px-4 py-2">HCM → Can Tho</td>
              <td class="px-4 py-2">39</td>
              <td class="px-4 py-2">5.400.000 VND</td>
              <td class="px-4 py-2">72%</td>
            </tr>
            <tr>
              <td class="px-4 py-2">05/06/2025</td>
              <td class="px-4 py-2">HCM → Can Tho</td>
              <td class="px-4 py-2">42</td>
              <td class="px-4 py-2">6.000.000 VND</td>
              <td class="px-4 py-2">76%</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- Pagination -->
      <div class="flex justify-center mt-4 space-x-2">
        <button class="px-4 py-1 bg-orange-500 text-white rounded">1</button>
        <button class="px-4 py-1 border border-orange-500 text-orange-500 rounded hover:bg-orange-50">2</button>
      </div>
    </div>
  </div>



<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>