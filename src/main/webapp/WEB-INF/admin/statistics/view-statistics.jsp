<%-- 
    Document   : view-statistics
    Created on : Jun 15, 2025, 2:11:27 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
    <div class="p-6 space-y-10">
        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <!-- Debug info -->
        <div class="text-gray-500 text-sm">
            DEBUG: period=<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>, 
            dateValue=<c:out value="${statistics.dateValue != null ? statistics.dateValue : '2025'}"/>,
            displayDateValue=<c:out value="${displayDateValue != null ? displayDateValue : '2025'}"/>
        </div>

        <div class="flex justify-between items-center">
            <h2 class="text-3xl font-bold text-[#ef5222]">Admin Dashboard – Booking Statistics</h2>
            <div class="space-x-3">
                <button class="bg-[#ef5222] text-white px-4 py-2 rounded-xl hover:bg-[#fc7b4c]" onclick="exportToPDF()">Export (PDF)</button>
                <button class="bg-white border border-[#ef5222] text-[#ef5222] px-4 py-2 rounded-xl hover:bg-[#ffedd5]" onclick="exportToExcel()">Export (Excel)</button>
            </div>
        </div>

        <!-- Time Period Filter -->
        <div class="bg-white shadow-xl rounded-2xl p-5 mb-6">
            <h3 class="font-semibold mb-3">Filter Statistics</h3>
            <form id="filterForm" method="post" action="${pageContext.request.contextPath}/admin/statistics">
                <div class="flex flex-wrap gap-4 items-center">
                    <label class="text-gray-700 font-medium mr-2">Select Time Frame:</label>
                    <input type="hidden" name="period" id="periodInput" value="${statistics.period}">
                    <button type="button" onclick="setPeriod('day')" class="px-4 py-2 rounded-lg ${statistics.period == 'day' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Day</button>
                    <button type="button" onclick="setPeriod('week')" class="px-4 py-2 rounded-lg ${statistics.period == 'week' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Week</button>
                    <button type="button" onclick="setPeriod('month')" class="px-4 py-2 rounded-lg ${statistics.period == 'month' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Month</button>
                    <button type="button" onclick="setPeriod('quarter')" class="px-4 py-2 rounded-lg ${statistics.period == 'quarter' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Quarter</button>
                    <button type="button" onclick="setPeriod('year')" class="px-4 py-2 rounded-lg ${statistics.period == 'year' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Year</button>
                    <button type="button" onclick="toggleCustomInput()" class="px-4 py-2 rounded-lg ${statistics.period == 'custom' ? 'bg-[#ef5222] text-white' : 'bg-gray-200 text-gray-700'} hover:bg-[#fc7b4c] hover:text-white transition">Custom</button>
                    <div id="customInput" class="flex gap-2" style="display: ${statistics.period == 'custom' ? 'flex' : 'none'}">
                        <select id="customPeriod" name="customPeriod" onchange="updateCustomInput()" class="border rounded-lg p-2 bg-white text-gray-700" ${statistics.period != 'custom' ? 'disabled' : ''}>
                            <option value="day" ${customPeriod == 'day' ? 'selected' : ''}>Day</option>
                            <option value="month" ${customPeriod == 'month' ? 'selected' : ''}>Month</option>
                            <option value="quarter" ${customPeriod == 'quarter' ? 'selected' : ''}>Quarter</option>
                            <option value="year" ${customPeriod == 'year' ? 'selected' : ''}>Year</option>
                        </select>
                        <input type="date" id="customDateValueDay" name="dateValue" class="border rounded-lg p-2 bg-white text-gray-700" value="${customPeriod == 'day' ? statistics.dateValue : ''}" style="display: ${customPeriod == 'day' ? 'block' : 'none'}" ${statistics.period != 'custom' ? 'disabled' : ''}>
                        <input type="month" id="customDateValueMonth" name="dateValue" class="border rounded-lg p-2 bg-white text-gray-700" value="${customPeriod == 'month' ? statistics.dateValue : ''}" style="display: ${customPeriod == 'month' ? 'block' : 'none'}" ${statistics.period != 'custom' ? 'disabled' : ''}>
                        <select id="customDateValueQuarter" name="dateValue" class="border rounded-lg p-2 bg-white text-gray-700" style="display: ${customPeriod == 'quarter' ? 'block' : 'none'}" ${statistics.period != 'custom' ? 'disabled' : ''}>
                            <c:forEach var="year" begin="2020" end="2025">
                                <c:forEach var="quarter" begin="1" end="4">
                                    <c:set var="quarterValue" value="${year}-${quarter}"/>
                                    <option value="${quarterValue}" ${customPeriod == 'quarter' && statistics.dateValue == quarterValue ? 'selected' : ''}>Q${quarter} ${year}</option>
                                </c:forEach>
                            </c:forEach>
                        </select>
                        <select id="customDateValueYear" name="dateValue" class="border rounded-lg p-2 bg-white text-gray-700" style="display: ${customPeriod == 'year' ? 'block' : 'none'}" ${statistics.period != 'custom' ? 'disabled' : ''}>
                            <c:forEach var="year" begin="2020" end="2025">
                                <option value="${year}" ${customPeriod == 'year' && statistics.dateValue == year.toString() ? 'selected' : ''}>${year}</option>
                            </c:forEach>
                        </select>
                        <button type="button" onclick="applyCustomPeriod()" class="px-4 py-2 rounded-lg bg-[#ef5222] text-white hover:bg-[#fc7b4c] transition">Apply</button>
                    </div>
                    <button type="button" onclick="resetFilters()" class="text-sm px-4 py-2 border border-[#ef5222] text-[#ef5222] rounded-lg hover:bg-[#ffedd5] transition flex items-center gap-2">
                        <i class="fas fa-sync-alt"></i>
                        Reset Filters
                    </button>
                </div>
            </form>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Revenue (<c:out value="${displayDateValue}"/>)</h3>
                <c:choose>
                    <c:when test="${empty statistics.revenue}">
                        <p class="text-gray-500">No revenue data available for <c:out value="${displayDateValue}"/></p>
                    </c:when>
                    <c:otherwise>
                        <canvas id="revenueChart"></canvas>
                        <script>
                            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                            new Chart(revenueCtx, {
                                type: 'bar',
                                data: {
                                    labels: [<c:forEach var="label" items="${timeLabels}" varStatus="status">"${label}"${status.last ? '' : ','}</c:forEach>],
                                    datasets: [{
                                        label: 'Revenue (VND)',
                                        data: [${statistics.revenue != null ? statistics.revenue : 0}],
                                        backgroundColor: 'rgba(255, 159, 64, 0.6)',
                                        borderColor: 'rgba(255, 159, 64, 1)',
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: { legend: { display: false } },
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: { callback: function(value) { return value + ' VND'; } }
                                        }
                                    }
                                }
                            });
                        </script>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Occupancy Rate (<c:out value="${displayDateValue}"/>)</h3>
                <c:choose>
                    <c:when test="${empty statistics.occupancyRate}">
                        <p class="text-gray-500">No occupancy data available for <c:out value="${displayDateValue}"/></p>
                    </c:when>
                    <c:otherwise>
                        <canvas id="occupancyChart"></canvas>
                        <script>
                            const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
                            new Chart(occupancyCtx, {
                                type: 'line',
                                data: {
                                    labels: [<c:forEach var="rate" items="${statistics.occupancyRate}" varStatus="status">"${rate.route_name}"${status.last ? '' : ','}</c:forEach>],
                                    datasets: [{
                                        label: 'Occupancy Rate (%)',
                                        data: [<c:forEach var="rate" items="${statistics.occupancyRate}" varStatus="status">${rate.occupancy_rate != null ? rate.occupancy_rate : 0}${status.last ? '' : ','}</c:forEach>],
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
                        </script>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Ticket Type Breakdown (<c:out value="${displayDateValue}"/>)</h3>
                <c:choose>
                    <c:when test="${empty statistics.ticketTypeBreakdown}">
                        <p class="text-gray-500">No ticket type data available for <c:out value="${displayDateValue}"/></p>
                    </c:when>
                    <c:otherwise>
                        <canvas id="ticketTypeChart"></canvas>
                        <script>
                            const ticketTypeCtx = document.getElementById('ticketTypeChart').getContext('2d');
                            new Chart(ticketTypeCtx, {
                                type: 'pie',
                                data: {
                                    labels: [<c:forEach var="ticket" items="${statistics.ticketTypeBreakdown}" varStatus="status">"${ticket.seat_number}"${status.last ? '' : ','}</c:forEach>],
                                    datasets: [{
                                        data: [<c:forEach var="ticket" items="${statistics.ticketTypeBreakdown}" varStatus="status">${ticket.ticket_count != null ? ticket.ticket_count : 0}${status.last ? '' : ','}</c:forEach>],
                                        backgroundColor: ['#ff6384', '#36a2eb', '#cc65fe', '#ffce56', '#4bc0c0']
                                    }]
                                },
                                options: { responsive: true }
                            });
                        </script>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Top Routes & Driver Performance -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Top 5 Routes by Revenue (<c:out value="${displayDateValue}"/>)</h3>
                <c:choose>
                    <c:when test="${empty statistics.topRoutesRevenue}">
                        <p class="text-gray-500">No route revenue data available for <c:out value="${displayDateValue}"/></p>
                    </c:when>
                    <c:otherwise>
                        <canvas id="topRoutesChart"></canvas>
                        <script>
                            const topRoutesCtx = document.getElementById('topRoutesChart').getContext('2d');
                            new Chart(topRoutesCtx, {
                                type: 'bar',
                                data: {
                                    labels: [<c:forEach var="route" items="${statistics.topRoutesRevenue}" varStatus="status">"${route.route_name}"${status.last ? '' : ','}</c:forEach>],
                                    datasets: [{
                                        label: 'Top Routes Revenue (VND)',
                                        data: [<c:forEach var="route" items="${statistics.topRoutesRevenue}" varStatus="status">${route.total_revenue != null ? route.total_revenue : 0}${status.last ? '' : ','}</c:forEach>],
                                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: { legend: { display: false } },
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: { callback: function(value) { return value + ' VND'; } }
                                        }
                                    }
                                }
                            });
                        </script>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Driver Performance (<c:out value="${displayDateValue}"/>)</h3>
                <ul class="space-y-3 text-sm text-gray-700">
                    <c:choose>
                        <c:when test="${empty statistics.driverPerformance}">
                            <li>No data available</li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="driver" items="${statistics.driverPerformance}">
                                <li><c:out value="${driver}"/></li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <!-- Detailed Statistics Table -->
        <div class="bg-white shadow-xl rounded-2xl p-5 overflow-auto">
            <h3 class="font-semibold mb-3">Detailed Statistics (<c:out value="${displayDateValue}"/>)</h3>
            <table class="w-full text-sm text-left" id="statistics-table">
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
                    <c:choose>
                        <c:when test="${empty statistics.detailedStatistics}">
                            <tr><td colspan="5" class="px-4 py-2 text-center">No data available for <c:out value="${displayDateValue}"/></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="stat" items="${statistics.detailedStatistics}">
                                <tr class="border-b hover:bg-orange-50">
                                    <td class="px-4 py-2"><c:out value="${stat.stat_date}"/></td>
                                    <td class="px-4 py-2"><c:out value="${stat.route_name}"/></td>
                                    <td class="px-4 py-2"><c:out value="${stat.tickets_sold}"/></td>
                                    <td class="px-4 py-2"><c:out value="${stat.revenue}"/> VND</td>
                                    <td class="px-4 py-2"><c:out value="${stat.occupancy_rate}"/>%</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <style>
        #customInput select, #customInput input {
            display: block !important;
            min-width: 150px;
            color: #333 !important;
            font-size: 14px !important;
        }
        #customInput option {
            color: #333 !important;
            background-color: #fff !important;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function setPeriod(period) {
            const form = document.getElementById('filterForm');
            const periodInput = document.getElementById('periodInput');
            periodInput.value = period;

            const customPeriod = document.getElementById('customPeriod');
            const customDateValueDay = document.getElementById('customDateValueDay');
            const customDateValueMonth = document.getElementById('customDateValueMonth');
            const customDateValueQuarter = document.getElementById('customDateValueQuarter');
            const customDateValueYear = document.getElementById('customDateValueYear');
            const customInput = document.getElementById('customInput');

            if (period !== 'custom') {
                customPeriod.disabled = true;
                customDateValueDay.disabled = true;
                customDateValueMonth.disabled = true;
                customDateValueQuarter.disabled = true;
                customDateValueYear.disabled = true;
                customInput.style.display = 'none';
                customPeriod.value = 'day';
                customDateValueDay.value = '';
                customDateValueMonth.value = '';
                customDateValueQuarter.value = '';
                customDateValueYear.value = '';
                form.submit();
            } else {
                customPeriod.disabled = false;
                customDateValueDay.disabled = customPeriod.value !== 'day';
                customDateValueMonth.disabled = customPeriod.value !== 'month';
                customDateValueQuarter.disabled = customPeriod.value !== 'quarter';
                customDateValueYear.disabled = customPeriod.value !== 'year';
                customInput.style.display = 'flex';
            }

            document.querySelectorAll('#filterForm button').forEach(button => {
                if (button.textContent.trim() === 'Apply' || button.textContent.includes('Reset Filters')) return;
                button.classList.remove('bg-[#ef5222]', 'text-white');
                button.classList.add('bg-gray-200', 'text-gray-700');
                if (button.textContent.trim() === periodToText(period)) {
                    button.classList.remove('bg-gray-200', 'text-gray-700');
                    button.classList.add('bg-[#ef5222]', 'text-white');
                }
            });
        }

        function applyCustomPeriod() {
            const form = document.getElementById('filterForm');
            const customPeriod = document.getElementById('customPeriod').value;
            const customDateValueDay = document.getElementById('customDateValueDay');
            const customDateValueMonth = document.getElementById('customDateValueMonth');
            const customDateValueQuarter = document.getElementById('customDateValueQuarter');
            const customDateValueYear = document.getElementById('customDateValueYear');

            let dateValue = '';
            if (customPeriod === 'day' && customDateValueDay.value) {
                dateValue = customDateValueDay.value;
            } else if (customPeriod === 'month' && customDateValueMonth.value) {
                dateValue = customDateValueMonth.value;
            } else if (customPeriod === 'quarter' && customDateValueQuarter.value) {
                dateValue = customDateValueQuarter.value;
            } else if (customPeriod === 'year' && customDateValueYear.value) {
                dateValue = customDateValueYear.value;
            }

            if (!dateValue) {
                alert('Vui lòng chọn ngày hoặc khoảng thời gian hợp lệ.');
                return;
            }

            setPeriod('custom');
            form.submit();
        }

        function toggleCustomInput() {
            const customInput = document.getElementById('customInput');
            if (customInput.style.display === 'none') {
                setPeriod('custom');
            } else {
                setPeriod('year');
            }
            updateCustomInput();
        }

        function updateCustomInput() {
            const customPeriod = document.getElementById('customPeriod').value;
            const customDateValueDay = document.getElementById('customDateValueDay');
            const customDateValueMonth = document.getElementById('customDateValueMonth');
            const customDateValueQuarter = document.getElementById('customDateValueQuarter');
            const customDateValueYear = document.getElementById('customDateValueYear');

            customDateValueDay.style.display = customPeriod === 'day' ? 'block' : 'none';
            customDateValueMonth.style.display = customPeriod === 'month' ? 'block' : 'none';
            customDateValueQuarter.style.display = customPeriod === 'quarter' ? 'block' : 'none';
            customDateValueYear.style.display = customPeriod === 'year' ? 'block' : 'none';

            customDateValueDay.disabled = customPeriod !== 'day';
            customDateValueMonth.disabled = customPeriod !== 'month';
            customDateValueQuarter.disabled = customPeriod !== 'quarter';
            customDateValueYear.disabled = customPeriod !== 'year';
        }

        function resetFilters() {
            const form = document.getElementById('filterForm');
            const periodInput = document.getElementById('periodInput');
            const customPeriod = document.getElementById('customPeriod');
            const customDateValueDay = document.getElementById('customDateValueDay');
            const customDateValueMonth = document.getElementById('customDateValueMonth');
            const customDateValueQuarter = document.getElementById('customDateValueQuarter');
            const customDateValueYear = document.getElementById('customDateValueYear');
            const customInput = document.getElementById('customInput');

            periodInput.value = 'year';
            customPeriod.value = 'day';
            customDateValueDay.value = '';
            customDateValueMonth.value = '';
            customDateValueQuarter.value = '';
            customDateValueYear.value = '';

            customPeriod.disabled = true;
            customDateValueDay.disabled = true;
            customDateValueMonth.disabled = true;
            customDateValueQuarter.disabled = true;
            customDateValueYear.disabled = true;
            customInput.style.display = 'none';

            document.querySelectorAll('#filterForm button').forEach(button => {
                if (button.textContent.trim() === 'Apply' || button.textContent.includes('Reset Filters')) return;
                button.classList.remove('bg-[#ef5222]', 'text-white');
                button.classList.add('bg-gray-200', 'text-gray-700');
                if (button.textContent.trim() === 'Year') {
                    button.classList.remove('bg-gray-200', 'text-gray-700');
                    button.classList.add('bg-[#ef5222]', 'text-white');
                }
            });

            form.submit();
        }

        function periodToText(period) {
            switch (period) {
                case 'day': return 'Day';
                case 'week': return 'Week';
                case 'month': return 'Month';
                case 'quarter': return 'Quarter';
                case 'year': return 'Year';
                case 'custom': return 'Custom';
                default: return '';
            }
        }

        function exportToPDF() {
            alert("PDF export not implemented yet.");
        }

        function exportToExcel() {
            alert("Excel export not implemented yet.");
        }

        window.addEventListener('load', () => {
            updateCustomInput();
            if ('${statistics.period}' !== 'custom') {
                document.getElementById('customPeriod').disabled = true;
                document.getElementById('customDateValueDay').disabled = true;
                document.getElementById('customDateValueMonth').disabled = true;
                document.getElementById('customDateValueQuarter').disabled = true;
                document.getElementById('customDateValueYear').disabled = true;
            }
        });

        // Debug chart data
        console.log('Chart Data Debug:');
        console.log('period: ${statistics.period}');
        console.log('customPeriod: ${customPeriod}');
        console.log('dateValue: ${statistics.dateValue}');
        console.log('displayDateValue: ${displayDateValue}');
        console.log('revenue: ${statistics.revenue}');
        console.log('occupancyRate: [<c:forEach var="rate" items="${statistics.occupancyRate}" varStatus="status">{ route: "${rate.route_name}", value: ${rate.occupancy_rate != null ? rate.occupancy_rate : 0} }${status.last ? '' : ','}</c:forEach>]');
        console.log('ticketTypeBreakdown: [<c:forEach var="ticket" items="${statistics.ticketTypeBreakdown}" varStatus="status">{ seat: "${ticket.seat_number}", count: ${ticket.ticket_count != null ? ticket.ticket_count : 0} }${status.last ? '' : ','}</c:forEach>]');
        console.log('topRoutesRevenue: [<c:forEach var="route" items="${statistics.topRoutesRevenue}" varStatus="status">{ route: "${route.route_name}", revenue: ${route.total_revenue != null ? route.total_revenue : 0} }${status.last ? '' : ','}</c:forEach>]');
        console.log('driverPerformance: [<c:forEach var="driver" items="${statistics.driverPerformance}" varStatus="status">"${driver}"${status.last ? '' : ','}</c:forEach>]');
        console.log('timeLabels: [<c:forEach var="label" items="${timeLabels}" varStatus="status">"${label}"${status.last ? '' : ','}</c:forEach>]');
    </script>


    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>