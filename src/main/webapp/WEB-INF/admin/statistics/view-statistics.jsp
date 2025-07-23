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
<body class="bg-[#f9fafb]">

    <div class="px-4 py-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-orange-600 mb-4">Admin Statistics Dashboard</h2>
        </div>

        <!-- Time Frame Selector -->
        <div class="mb-6">
            <form id="timeFrameForm" method="get" action="${pageContext.servletContext.contextPath}/admin/statistics" class="flex flex-wrap gap-4 items-center">
                <label class="text-gray-700 font-medium mr-2">Select Time Frame:</label>
                <input type="hidden" name="timeFrame" id="timeFrameInput" value="${timeFrame}">
                <button type="button" onclick="setTimeFrame('all')" class="px-4 py-2 rounded-lg ${timeFrame == 'all' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">All</button>
                <button type="button" onclick="setTimeFrame('today')" class="px-4 py-2 rounded-lg ${timeFrame == 'today' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">Today</button>
                <button type="button" onclick="setTimeFrame('last7days')" class="px-4 py-2 rounded-lg ${timeFrame == 'last7days' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">Last 7 Days</button>
                <button type="button" onclick="setTimeFrame('thismonth')" class="px-4 py-2 rounded-lg ${timeFrame == 'thismonth' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">This Month</button>
                <button type="button" onclick="setTimeFrame('thisquarter')" class="px-4 py-2 rounded-lg ${timeFrame == 'thisquarter' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">This Quarter</button>
                <button type="button" onclick="setTimeFrame('thisyear')" class="px-4 py-2 rounded-lg ${timeFrame == 'thisyear' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">This Year</button>
                <button type="button" onclick="toggleCustomInput()" class="px-4 py-2 rounded-lg ${timeFrame == 'custom' ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700'} hover:bg-orange-600 hover:text-white transition">Custom</button>
                <div id="customInput" class="flex gap-2" style="display: ${timeFrame == 'custom' ? 'flex' : 'none'}">
                    <select id="customTimeFrame" name="customTimeFrame" onchange="updateCustomInput()" class="border rounded-lg p-2 bg-white text-gray-700" ${timeFrame != 'custom' ? 'disabled' : ''}>
                        <option value="day" <c:if test="${customTimeFrame == 'day'}">selected</c:if>>Day</option>
                        <option value="month" <c:if test="${customTimeFrame == 'month'}">selected</c:if>>Month</option>
                        <option value="quarter" <c:if test="${customTimeFrame == 'quarter'}">selected</c:if>>Quarter</option>
                        <option value="year" <c:if test="${customTimeFrame == 'year'}">selected</c:if>>Year</option>
                    </select>
                    <input type="date" id="customTimeValueDay" name="timeValue" class="border rounded-lg p-2 bg-white text-gray-700" value="${customTimeFrame == 'day' ? timeValue : ''}" style="display: ${customTimeFrame == 'day' ? 'block' : 'none'}" ${timeFrame != 'custom' ? 'disabled' : ''}>
                    <input type="month" id="customTimeValueMonth" name="timeValue" class="border rounded-lg p-2 bg-white text-gray-700" value="${customTimeFrame == 'month' ? timeValue : ''}" style="display: ${customTimeFrame == 'month' ? 'block' : 'none'}" ${timeFrame != 'custom' ? 'disabled' : ''}>
                    <select id="customTimeValueQuarter" name="timeValue" class="border rounded-lg p-2 bg-white text-gray-700" style="display: ${customTimeFrame == 'quarter' ? 'block' : 'none'}" ${timeFrame != 'custom' ? 'disabled' : ''}>
                        <c:forEach var="year" begin="2024" end="2025" step="1">
                            <c:forEach var="quarter" begin="1" end="4" step="1">
                                <c:set var="quarterValue" value="${year}-${5 - quarter}"/>
                                <option value="${quarterValue}" <c:if test="${timeValue == quarterValue}">selected</c:if>>Q${5 - quarter} ${year}</option>
                            </c:forEach>
                        </c:forEach>
                    </select>
                    <select id="customTimeValueYear" name="timeValue" class="border rounded-lg p-2 bg-white text-gray-700" style="display: ${customTimeFrame == 'year' ? 'block' : 'none'}" ${timeFrame != 'custom' ? 'disabled' : ''}>
                        <c:forEach begin="2020" end="2025" var="year">
                            <option value="${year}" <c:if test="${timeValue == year.toString()}">selected</c:if>>${year}</option>
                        </c:forEach>
                    </select>
                    <button type="button" onclick="applyCustomTimeFrame()" class="px-4 py-2 rounded-lg bg-orange-500 text-white hover:bg-orange-600 transition">Apply</button>
                </div>
                <!-- Reset button -->
                <button type="button" onclick="resetFilters()" class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                    <i class="fas fa-sync-alt"></i>
                    Reset Filters
                </button>
            </form>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800">Total Revenue</h3>
                <p class="text-2xl font-bold text-orange-600">${totalRevenue} VND</p>
            </div>
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800">Total Trips</h3>
                <p class="text-2xl font-bold text-orange-600">${totalTrips}</p>
            </div>
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800">Completion Rate</h3>
                <p class="text-2xl font-bold text-orange-600">${completionRate}%</p>
            </div>
        </div>

        <!-- Statistics Charts -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <!-- Bar Chart: Trip Statistics -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Trip Statistics (<c:out value="${displayTimeValue}"/>)</h3>
                <canvas id="tripStatsChart" width="300" height="150"></canvas>
            </div>

            <!-- Pie Chart: Completion Rate -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Completion Rate (<c:out value="${displayTimeValue}"/>)</h3>
                <canvas id="completionRateChart" width="300" height="150"></canvas>
            </div>

            <!-- Doughnut Chart: Cancelled Trips -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Cancelled Trips (<c:out value="${displayTimeValue}"/>)</h3>
                <canvas id="cancelledTripsChart" width="300" height="150"></canvas>
            </div>

            <!-- Bar Chart: Tickets and Passengers -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Tickets and Passengers (<c:out value="${displayTimeValue}"/>)</h3>
                <canvas id="ticketsPassengersChart" width="300" height="150"></canvas>
            </div>

            <!-- Line Chart: Tickets Sold Over Time -->
            <div class="bg-white rounded-xl shadow-lg p-6 md:col-span-2">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Tickets Sold (<c:out value="${displayTimeValue}"/>)</h3>
                <canvas id="ticketsChart" width="600" height="200"></canvas>
            </div>
        </div>
    </div>

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function setTimeFrame(timeFrame) {
            const form = document.getElementById('timeFrameForm');
            const timeFrameInput = document.getElementById('timeFrameInput');
            timeFrameInput.value = timeFrame;

            const customTimeFrame = document.getElementById('customTimeFrame');
            const customTimeValueDay = document.getElementById('customTimeValueDay');
            const customTimeValueMonth = document.getElementById('customTimeValueMonth');
            const customTimeValueQuarter = document.getElementById('customTimeValueQuarter');
            const customTimeValueYear = document.getElementById('customTimeValueYear');
            const customInput = document.getElementById('customInput');

            if (timeFrame !== 'custom') {
                customTimeFrame.disabled = true;
                customTimeValueDay.disabled = true;
                customTimeValueMonth.disabled = true;
                customTimeValueQuarter.disabled = true;
                customTimeValueYear.disabled = true;
                customInput.style.display = 'none';
                customTimeFrame.value = 'day';
                customTimeValueDay.value = '';
                customTimeValueMonth.value = '';
                customTimeValueQuarter.value = '';
                customTimeValueYear.value = '';
                form.submit();
            } else {
                customTimeFrame.disabled = false;
                customTimeValueDay.disabled = customTimeFrame.value !== 'day';
                customTimeValueMonth.disabled = customTimeFrame.value !== 'month';
                customTimeValueQuarter.disabled = customTimeFrame.value !== 'quarter';
                customTimeValueYear.disabled = customTimeFrame.value !== 'year';
                customInput.style.display = 'flex';
            }

            document.querySelectorAll('#timeFrameForm button').forEach(button => {
                if (button.textContent.trim() === 'Apply' || button.textContent.includes('Reset Filters')) return;
                button.classList.remove('bg-orange-500', 'text-white');
                button.classList.add('bg-gray-200', 'text-gray-700');
                if (button.textContent.trim() === timeFrameToText(timeFrame)) {
                    button.classList.remove('bg-gray-200', 'text-gray-700');
                    button.classList.add('bg-orange-500', 'text-white');
                }
            });
        }

        function applyCustomTimeFrame() {
            const form = document.getElementById('timeFrameForm');
            const customTimeFrame = document.getElementById('customTimeFrame').value;
            const customTimeValueDay = document.getElementById('customTimeValueDay');
            const customTimeValueMonth = document.getElementById('customTimeValueMonth');
            const customTimeValueQuarter = document.getElementById('customTimeValueQuarter');
            const customTimeValueYear = document.getElementById('customTimeValueYear');

            let timeValue = '';
            if (customTimeFrame === 'day' && customTimeValueDay.value) {
                timeValue = customTimeValueDay.value;
            } else if (customTimeFrame === 'month' && customTimeValueMonth.value) {
                timeValue = customTimeValueMonth.value;
            } else if (customTimeFrame === 'quarter' && customTimeValueQuarter.value) {
                timeValue = customTimeValueQuarter.value;
            } else if (customTimeFrame === 'year' && customTimeValueYear.value) {
                timeValue = customTimeValueYear.value;
            }

            if (!timeValue) {
                alert('Please select a valid time value for the custom time frame.');
                return;
            }

            setTimeFrame('custom');
            form.submit();
        }

        function toggleCustomInput() {
            const customInput = document.getElementById('customInput');
            if (customInput.style.display === 'none') {
                setTimeFrame('custom');
            } else {
                setTimeFrame('all');
            }
            updateCustomInput();
        }

        function updateCustomInput() {
            const customTimeFrame = document.getElementById('customTimeFrame').value;
            const customTimeValueDay = document.getElementById('customTimeValueDay');
            const customTimeValueMonth = document.getElementById('customTimeValueMonth');
            const customTimeValueQuarter = document.getElementById('customTimeValueQuarter');
            const customTimeValueYear = document.getElementById('customTimeValueYear');

            customTimeValueDay.style.display = customTimeFrame === 'day' ? 'block' : 'none';
            customTimeValueMonth.style.display = customTimeFrame === 'month' ? 'block' : 'none';
            customTimeValueQuarter.style.display = customTimeFrame === 'quarter' ? 'block' : 'none';
            customTimeValueYear.style.display = customTimeFrame === 'year' ? 'block' : 'none';

            customTimeValueDay.disabled = customTimeFrame !== 'day';
            customTimeValueMonth.disabled = customTimeFrame !== 'month';
            customTimeValueQuarter.disabled = customTimeFrame !== 'quarter';
            customTimeValueYear.disabled = customTimeFrame !== 'year';
        }

        function resetFilters() {
            const form = document.getElementById('timeFrameForm');
            const timeFrameInput = document.getElementById('timeFrameInput');
            const customTimeFrame = document.getElementById('customTimeFrame');
            const customTimeValueDay = document.getElementById('customTimeValueDay');
            const customTimeValueMonth = document.getElementById('customTimeValueMonth');
            const customTimeValueQuarter = document.getElementById('customTimeValueQuarter');
            const customTimeValueYear = document.getElementById('customTimeValueYear');
            const customInput = document.getElementById('customInput');

            timeFrameInput.value = 'all';
            customTimeFrame.value = 'day';
            customTimeValueDay.value = '';
            customTimeValueMonth.value = '';
            customTimeValueQuarter.value = '';
            customTimeValueYear.value = '';

            customTimeFrame.disabled = true;
            customTimeValueDay.disabled = true;
            customTimeValueMonth.disabled = true;
            customTimeValueQuarter.disabled = true;
            customTimeValueYear.disabled = true;
            customInput.style.display = 'none';

            document.querySelectorAll('#timeFrameForm button').forEach(button => {
                if (button.textContent.trim() === 'Apply' || button.textContent.includes('Reset Filters')) return;
                button.classList.remove('bg-orange-500', 'text-white');
                button.classList.add('bg-gray-200', 'text-gray-700');
                if (button.textContent.trim() === 'All') {
                    button.classList.remove('bg-gray-200', 'text-gray-700');
                    button.classList.add('bg-orange-500', 'text-white');
                }
            });

            form.submit();
        }

        function timeFrameToText(timeFrame) {
            switch (timeFrame) {
                case 'all': return 'All';
                case 'today': return 'Today';
                case 'last7days': return 'Last 7 Days';
                case 'thismonth': return 'This Month';
                case 'thisquarter': return 'This Quarter';
                case 'thisyear': return 'This Year';
                case 'custom': return 'Custom';
                default: return '';
            }
        }

        // Render charts with initial data
        const tripStatsChart = new Chart(document.getElementById('tripStatsChart'), {
            type: 'bar',
            data: {
                labels: ['Completed Trips', 'Ongoing Trips', 'Cancelled Trips'],
                datasets: [{
                    label: 'Count',
                    data: [${completedTrips}, ${ongoingTrips}, ${cancelledTrips}],
                    backgroundColor: ['#10b981', '#3b82f6', '#ef4444'],
                    borderColor: ['#10b981', '#3b82f6', '#ef4444'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: { y: { beginZero: true, title: { display: true, text: 'Count' } } },
                plugins: { legend: { display: false } }
            }
        });

        const completionRateChart = new Chart(document.getElementById('completionRateChart'), {
            type: 'pie',
            data: {
                labels: ['Completed', 'Not Completed'],
                datasets: [{
                    data: [${completedTrips}, ${totalTrips - completedTrips}],
                    backgroundColor: ['#10b981', '#d1d5db'],
                    borderColor: ['#10b981', '#d1d5db'],
                    borderWidth: 1
                }]
            },
            options: { plugins: { legend: { position: 'bottom' } } }
        });

        const cancelledTripsChart = new Chart(document.getElementById('cancelledTripsChart'), {
            type: 'doughnut',
            data: {
                labels: ['Cancelled', 'Non-Cancelled'],
                datasets: [{
                    data: [${cancelledTrips}, ${totalTrips - cancelledTrips}],
                    backgroundColor: ['#ef4444', '#d1d5db'],
                    borderColor: ['#ef4444', '#d1d5db'],
                    borderWidth: 1
                }]
            },
            options: { plugins: { legend: { position: 'bottom' } } }
        });

        const ticketsPassengersChart = new Chart(document.getElementById('ticketsPassengersChart'), {
            type: 'bar',
            data: {
                labels: ['Total Tickets Sold', 'Checked-In Passengers'],
                datasets: [{
                    label: 'Count',
                    data: [${totalTicketsSold}, ${checkedInPassengers}],
                    backgroundColor: ['#8b5cf6', '#10b981'],
                    borderColor: ['#8b5cf6', '#10b981'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: { y: { beginZero: true, title: { display: true, text: 'Count' } } },
                plugins: { legend: { display: false } }
            }
        });

        const ticketsChart = new Chart(document.getElementById('ticketsChart'), {
            type: 'line',
            data: {
                labels: [
                    <c:forEach items="${timeLabels}" var="label" varStatus="status">
                        '${label}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Tickets Sold',
                    data: [<c:forEach items="${ticketsSoldByTimeFrame}" var="count">${count},</c:forEach>],
                    fill: false,
                    borderColor: '#f59e0b',
                    tension: 0.1
                }]
            },
            options: {
                scales: {
                    y: { beginZero: true, title: { display: true, text: 'Tickets' } },
                    x: { title: { display: true, text: 'Time' } }
                }
            }
        });

        // Debug chart data
        console.log('Chart Data Debug:');
        console.log('timeFrame: ${timeFrame}');
        console.log('customTimeFrame: ${customTimeFrame}');
        console.log('timeValue: ${timeValue}');
        console.log('totalTrips: ${totalTrips}');
        console.log('completedTrips: ${completedTrips}');
        console.log('ongoingTrips: ${ongoingTrips}');
        console.log('cancelledTrips: ${cancelledTrips}');
        console.log('totalTicketsSold: ${totalTicketsSold}');
        console.log('checkedInPassengers: ${checkedInPassengers}');
        console.log('totalRevenue: ${totalRevenue}');
        console.log('completionRate: ${completionRate}');
        console.log('ticketsSoldByTimeFrame: [<c:forEach items="${ticketsSoldByTimeFrame}" var="count">${count},</c:forEach>]');
        console.log('timeLabels: [<c:forEach items="${timeLabels}" var="label">${label},</c:forEach>]');

        window.onload = function() {
            updateCustomInput();
            if ('${timeFrame}' !== 'custom') {
                document.getElementById('customTimeFrame').disabled = true;
                document.getElementById('customTimeValueDay').disabled = true;
                document.getElementById('customTimeValueMonth').disabled = true;
                document.getElementById('customTimeValueQuarter').disabled = true;
                document.getElementById('customTimeValueYear').disabled = true;
            }
        };
    </script>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>