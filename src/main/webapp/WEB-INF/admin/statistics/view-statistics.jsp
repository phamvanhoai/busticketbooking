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
        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <!-- Debug giá trị period và dateValue -->
        <div class="text-gray-500 text-sm">
            DEBUG: period=<c:out value="${statistics.period != null ? statistics.period : 'none'}"/>, 
            dateValue=<c:out value="${statistics.dateValue != null ? statistics.dateValue : 'none'}"/>
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
            <form method="post" action="${pageContext.request.contextPath}/admin/statistics" onsubmit="return validateForm()">
                <div class="flex space-x-4">
                    <select name="period" id="period" class="border rounded-lg p-2" onchange="toggleDateInput()">
                        <option value="day" ${statistics.period == 'day' ? 'selected' : ''}>Day</option>
                        <option value="week" ${statistics.period == 'week' ? 'selected' : ''}>Week</option>
                        <option value="month" ${statistics.period == 'month' ? 'selected' : ''}>Month</option>
                        <option value="quarter" ${statistics.period == 'quarter' ? 'selected' : ''}>Quarter</option>
                        <option value="year" ${statistics.period == 'year' ? 'selected' : ''}>Year</option>
                    </select>
                    <div id="dateInputContainer">
                        <c:choose>
                            <c:when test="${statistics.period == 'day' || statistics.period == 'week'}">
                                <input type="date" name="dateValue" id="dateValue" value="${not empty statistics.dateValue ? statistics.dateValue : '2025-07-21'}" class="border rounded-lg p-2" />
                            </c:when>
                            <c:when test="${statistics.period == 'month'}">
                                <select name="dateValue" id="dateValue" class="border rounded-lg p-2">
                                    <option value="">Select Month</option>
                                    <c:forEach var="month" begin="1" end="12">
                                        <c:set var="monthValue" value="2025-${month < 10 ? '0' : ''}${month}"/>
                                        <option value="${monthValue}" ${statistics.dateValue == monthValue ? 'selected' : ''}>${monthValue}</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:when test="${statistics.period == 'quarter'}">
                                <select name="dateValue" id="dateValue" class="border rounded-lg p-2">
                                    <option value="">Select Quarter</option>
                                    <c:forEach var="quarter" begin="1" end="4">
                                        <c:set var="quarterValue" value="2025-${quarter}"/>
                                        <option value="${quarterValue}" ${statistics.dateValue == quarterValue ? 'selected' : ''}>2025-Q${quarter}</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <select name="dateValue" id="dateValue" class="border rounded-lg p-2">
                                    <option value="">Select Year</option>
                                    <c:forEach var="year" begin="2020" end="2025">
                                        <option value="${year}" ${statistics.dateValue == year ? 'selected' : ''}>${year}</option>
                                    </c:forEach>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button type="submit" class="bg-[#ef5222] text-white px-4 py-2 rounded-xl hover:bg-[#fc7b4c]">Apply Filter</button>
                </div>
            </form>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Revenue (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
                <canvas id="chartRevenue"></canvas>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Occupancy Rate (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
                <canvas id="chartOccupancy"></canvas>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Ticket Type Breakdown (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
                <canvas id="chartTicketType"></canvas>
            </div>
        </div>

        <!-- Top Routes & Driver Performance -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Top 5 Routes by Revenue (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
                <canvas id="chartTopRoutes"></canvas>
            </div>
            <div class="bg-white shadow-xl rounded-2xl p-5">
                <h3 class="font-semibold mb-3">Driver Performance (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
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
            <h3 class="font-semibold mb-3">Detailed Statistics (<c:out value="${statistics.period != null ? statistics.period : 'year'}"/>)</h3>
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
                            <tr><td colspan="5" class="px-4 py-2 text-center">No data available for <c:out value="${statistics.period != null ? statistics.period : 'year'}"/> <c:out value="${statistics.dateValue != null ? statistics.dateValue : '2025'}"/></td></tr>
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
        #dateInputContainer select, #dateInputContainer input {
            display: block !important;
            min-width: 150px;
            color: #333 !important;
            font-size: 14px !important;
        }
        #dateInputContainer option {
            color: #333 !important;
            background-color: #fff !important;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Truyền giá trị từ EL sang JavaScript
        const currentPeriod = "${statistics.period != null ? statistics.period : 'year'}";
        const currentDateValue = "${statistics.dateValue != null ? statistics.dateValue : '2025'}";

        // Hàm điều chỉnh input dựa trên period
        function toggleDateInput() {
            try {
                const period = document.getElementById("period").value;
                const dateInputContainer = document.getElementById("dateInputContainer");
                let inputHTML = "";

                console.log(`toggleDateInput called: period=${period}, currentDateValue=${currentDateValue}`);

                if (!period) {
                    console.warn("Period is undefined or empty, defaulting to year");
                    inputHTML = `<select name="dateValue" id="dateValue" class="border rounded-lg p-2"><option value="">Select Year</option>`;
                    for (let y = 2025; y >= 2020; y--) {
                        inputHTML += `<option value="${y}" ${y == currentDateValue ? 'selected' : ''}>${y}</option>`;
                    }
                    inputHTML += `</select>`;
                } else if (period === "day" || period === "week") {
                    const dateValue = (period === currentPeriod && currentDateValue && currentDateValue.match(/^\d{4}-\d{2}-\d{2}$/)) ? currentDateValue : "${java.time.LocalDate.now()}";
                    inputHTML = `<input type="date" name="dateValue" id="dateValue" value="${dateValue}" class="border rounded-lg p-2" />`;
                } else if (period === "month") {
                    inputHTML = `<select name="dateValue" id="dateValue" class="border rounded-lg p-2"><option value="">Select Month</option>`;
                    for (let m = 1; m <= 12; m++) {
                        const monthValue = `2025-${m.toString().padStart(2, '0')}`;
                        inputHTML += `<option value="${monthValue}" ${monthValue == currentDateValue ? 'selected' : ''}>${monthValue}</option>`;
                    }
                    inputHTML += `</select>`;
                } else if (period === "quarter") {
                    inputHTML = `<select name="dateValue" id="dateValue" class="border rounded-lg p-2"><option value="">Select Quarter</option>`;
                    for (let q = 1; q <= 4; q++) {
                        const quarterValue = `2025-${q}`;
                        inputHTML += `<option value="${quarterValue}" ${quarterValue == currentDateValue ? 'selected' : ''}>2025-Q${q}</option>`;
                    }
                    inputHTML += `</select>`;
                } else {
                    inputHTML = `<select name="dateValue" id="dateValue" class="border rounded-lg p-2"><option value="">Select Year</option>`;
                    for (let y = 2025; y >= 2020; y--) {
                        inputHTML += `<option value="${y}" ${y == currentDateValue ? 'selected' : ''}>${y}</option>`;
                    }
                    inputHTML += `</select>`;
                }

                dateInputContainer.innerHTML = inputHTML;
                console.log(`Updated dateInputContainer HTML: ${inputHTML}`);

                // Kiểm tra số lượng tùy chọn và nội dung
                const select = dateInputContainer.querySelector("select");
                if (select) {
                    console.log(`Select element found with ${select.options.length} options`);
                    for (let i = 0; i < select.options.length; i++) {
                        console.log(`Option ${i}: value=${select.options[i].value}, text=${select.options[i].text}`);
                    }
                    if (select.options.length <= 1) {
                        console.warn("Dropdown has no options or only 'Select' option");
                    }
                } else {
                    console.log("No select element found, likely an input element for day/week");
                }
            } catch (error) {
                console.error("Error in toggleDateInput:", error);
            }
        }

        // Hàm validate form trước khi gửi
        function validateForm() {
            const period = document.getElementById("period").value;
            const dateValue = document.getElementById("dateValue").value;

            console.log(`validateForm called: period=${period}, dateValue=${dateValue}`);

            if (!dateValue) {
                alert("Vui lòng chọn ngày hoặc khoảng thời gian hợp lệ.");
                return false;
            }

            if (period === "day" || period === "week") {
                if (!dateValue.match(/^\d{4}-\d{2}-\d{2}$/)) {
                    alert("Định dạng ngày không hợp lệ. Vui lòng sử dụng YYYY-MM-DD.");
                    return false;
                }
            } else if (period === "month") {
                if (!dateValue.match(/^\d{4}-\d{2}$/)) {
                    alert("Định dạng tháng không hợp lệ. Vui lòng sử dụng YYYY-MM.");
                    return false;
                }
            } else if (period === "quarter") {
                if (!dateValue.match(/^\d{4}-[1-4]$/)) {
                    alert("Định dạng quý không hợp lệ. Vui lòng sử dụng YYYY-Q (ví dụ: 2025-1).");
                    return false;
                }
            } else if (period === "year") {
                if (!dateValue.match(/^\d{4}$/)) {
                    alert("Định dạng năm không hợp lệ. Vui lòng sử dụng YYYY.");
                    return false;
                }
            }
            console.log(`Form validated successfully: period=${period}, dateValue=${dateValue}`);
            return true;
        }

        // Gọi toggleDateInput khi tải trang
        window.addEventListener('load', () => {
            try {
                console.log("Page loaded, calling toggleDateInput");
                toggleDateInput();
            } catch (error) {
                console.error("Error on page load:", error);
            }
        });

        // Revenue Chart (Bar Chart)
        const revenueData = ${statistics.revenue != null ? statistics.revenue : 0};
        const ctxRevenue = document.getElementById("chartRevenue").getContext("2d");
        new Chart(ctxRevenue, {
            type: 'bar',
            data: {
                labels: ["<c:out value="${statistics.period != null ? statistics.period : 'year'}"/> ${statistics.dateValue != null ? statistics.dateValue : '2025'}"],
                datasets: [{
                    label: "Revenue (VND)",
                    data: [revenueData],
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

        // Placeholder for export functions
        function exportToPDF() {
            alert("PDF export not implemented yet.");
        }

        function exportToExcel() {
            alert("Excel export not implemented yet.");
        }
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>