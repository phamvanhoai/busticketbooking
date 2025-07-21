<%-- 
    Document   : view-statistics
    Created on : Jun 15, 2025, 2:11:27 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
    <div class="p-6 space-y-10">
        <div class="flex justify-between items-center">
            <h2 class="text-3xl font-bold text-[#ef5222]">Admin Dashboard – Booking Statistics</h2>
            <div class="space-x-3">
                <button class="bg-[#ef5222] text-white px-4 py-2 rounded-xl hover:bg-[#fc7b4c]">Export (PDF)</button>
                <button class="bg-white border border-[#ef5222] text-[#ef5222] px-4 py-2 rounded-xl hover:bg-[#ffedd5]">Export (Excel)</button>
            </div>
        </div>

        <!-- Statistics Cards -->
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

        <!-- Top Routes & Driver Performance -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Top 5 Routes by Revenue</h3>
                <canvas id="chartTopRoutes"></canvas>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Driver Performance</h3>
                <ul class="space-y-3 text-sm text-gray-700">
                    <c:forEach var="driver" items="${statistics.driverPerformance}">
                        <li>${driver}</li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        <!-- Detailed Statistics Table -->
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
                    <!-- Add dynamic data here -->
                    <tr class="border-b hover:bg-orange-50">
                        <td class="px-4 py-2">01/06/2025</td>
                        <td class="px-4 py-2">HCM → Can Tho</td>
                        <td class="px-4 py-2">30</td>
                        <td class="px-4 py-2">3.600.000 VND</td>
                        <td class="px-4 py-2">60%</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Monthly Revenue Chart (Bar Chart)
        const monthlyRevenueData = ${statistics.monthlyRevenue != null ? statistics.monthlyRevenue : 0};
        const ctxRevenue = document.getElementById("chartRevenue").getContext("2d");
        new Chart(ctxRevenue, {
            type: 'bar',
            data: {
                labels: ["Current Year"],
                datasets: [{
                    label: "Monthly Revenue (VND)",
                    data: [monthlyRevenueData],
                    backgroundColor: 'rgba(255, 159, 64, 0.6)',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: function(value) { return value + " VND"; } }
                    }
                }
            }
        });

        // Occupancy Rate Chart (Line Chart)
        const occupancyRateData = [
            <c:forEach var="rate" items="${statistics.occupancyRate}" varStatus="status">
                { route: "${rate.route_name}", value: ${rate.occupancy_rate != null ? rate.occupancy_rate : 0} }${status.last ? '' : ','}
            </c:forEach>
        ];
        const ctxOccupancy = document.getElementById("chartOccupancy").getContext("2d");
        new Chart(ctxOccupancy, {
            type: 'line',
            data: {
                labels: occupancyRateData.map(item => item.route),
                datasets: [{
                    label: "Occupancy Rate (%)",
                    data: occupancyRateData.map(item => item.value),
                    borderColor: 'rgba(75, 192, 192, 1)',
                    fill: false,
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 10 }
                    }
                }
            }
        });

        // Ticket Type Breakdown (Pie Chart)
        const ticketTypeData = [
            <c:forEach var="ticket" items="${statistics.ticketTypeBreakdown}" varStatus="status">
                { seat: "${ticket.seat_number}", count: ${ticket.ticket_count != null ? ticket.ticket_count : 0} }${status.last ? '' : ','}
            </c:forEach>
        ];
        const ctxTicketType = document.getElementById("chartTicketType").getContext("2d");
        new Chart(ctxTicketType, {
            type: 'pie',
            data: {
                labels: ticketTypeData.map(item => item.seat),
                datasets: [{
                    data: ticketTypeData.map(item => item.count),
                    backgroundColor: ['#ff6384', '#36a2eb', '#cc65fe', '#ffce56', '#4bc0c0']
                }]
            },
            options: { responsive: true }
        });

        // Top 5 Routes by Revenue (Bar Chart)
        const topRoutesData = [
            <c:forEach var="route" items="${statistics.topRoutesRevenue}" varStatus="status">
                { route: "${route.route_name}", revenue: ${route.total_revenue != null ? route.total_revenue : 0} }${status.last ? '' : ','}
            </c:forEach>
        ];
        const ctxTopRoutes = document.getElementById("chartTopRoutes").getContext("2d");
        new Chart(ctxTopRoutes, {
            type: 'bar',
            data: {
                labels: topRoutesData.map(item => item.route),
                datasets: [{
                    label: "Top Routes Revenue (VND)",
                    data: topRoutesData.map(item => item.revenue),
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: function(value) { return value + " VND"; } }
                    }
                }
            }
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>