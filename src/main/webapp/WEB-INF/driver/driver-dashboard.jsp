<%-- 
    Document   : driver-dashboard
    Created on : Jun 13, 2025, 11:06:47 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<body class="bg-[#f9fafb]">

    <div class="mt-12 px-6">
        <!-- Header -->
        <div class="flex items-center gap-6 mb-10">
            <img
                src="${pageContext.servletContext.contextPath}/assets/images/avt/driver-avatar.png"
                alt="Driver Avatar"
                class="w-20 h-20 rounded-full border object-cover"
            />
            <div>
                <h2 class="text-3xl font-bold text-orange-600">Welcome, ${driverName}</h2>
                <p class="text-gray-500 text-sm">Here’s your summary for today</p>
            </div>
        </div>

        <!-- Upcoming Trip -->
        <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Upcoming Trip</h3>
            <c:choose>
                <c:when test="${not empty upcomingTrip}">
                    <p class="text-gray-700 font-medium">${upcomingTrip.route}</p>
                    <p class="text-sm text-gray-600">
                        <fmt:formatDate value="${upcomingTrip.departureTime}" pattern="yyyy-MM-dd" /> at ${upcomingTrip.time}
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-700 font-medium">No upcoming trip</p>
                    <p class="text-sm text-gray-600">Check back later</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Statistics Charts -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <!-- Bar Chart: Trips and Change Requests -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Trip Statistics</h3>
                <canvas id="tripStatsChart" width="300" height="150"></canvas>
            </div>

            <!-- Pie Chart: Completion Rate -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Completion Rate</h3>
                <canvas id="completionRateChart" width="300" height="150"></canvas>
            </div>

            <!-- Doughnut Chart: Cancelled Trips -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Cancelled Trips</h3>
                <canvas id="cancelledTripsChart" width="300" height="150"></canvas>
            </div>

            <!-- Bar Chart: Tickets and Passengers -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Tickets and Passengers</h3>
                <canvas id="ticketsPassengersChart" width="300" height="150"></canvas>
            </div>

            <!-- Line Chart: Checked-In Passengers Over Time -->
            <div class="bg-white rounded-xl shadow-lg p-6 md:col-span-2">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Checked-In Passengers (Last 7 Days)</h3>
                <canvas id="passengersChart" width="600" height="200"></canvas>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="flex flex-col md:flex-row gap-4">
            <a
                href="${pageContext.servletContext.contextPath}/driver/assigned-trips"
                class="flex-1 bg-orange-500 text-white text-center py-3 rounded-lg font-semibold hover:bg-orange-600 transition"
            >
                View Assigned Trips
            </a>
            <a
                href="${pageContext.servletContext.contextPath}/driver/trip-change"
                class="flex-1 bg-gray-100 text-orange-600 text-center py-3 rounded-lg font-semibold hover:bg-orange-200 transition border"
            >
                Request Trip Change
            </a>
            <a
                href="${pageContext.servletContext.contextPath}/driver/driver-license"
                class="flex-1 bg-gray-100 text-orange-600 text-center py-3 rounded-lg font-semibold hover:bg-orange-200 transition border"
            >
                View Driver License
            </a>
        </div>
    </div>

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Bar Chart: Trip Statistics
        const tripStatsChart = new Chart(document.getElementById('tripStatsChart'), {
            type: 'bar',
            data: {
                labels: ['Completed Trips', 'Ongoing Trips', 'Change Requests'],
                datasets: [{
                    label: 'Count',
                    data: [${completedTrips}, ${ongoingTrips}, ${pendingChangeRequests}],
                    backgroundColor: ['#10b981', '#3b82f6', '#f59e0b'],
                    borderColor: ['#10b981', '#3b82f6', '#f59e0b'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginZero: true,
                        title: {
                            display: true,
                            text: 'Count'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Pie Chart: Completion Rate
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
            options: {
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Doughnut Chart: Cancelled Trips
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
            options: {
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Bar Chart: Tickets and Passengers
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
                scales: {
                    y: {
                        beginZero: true,
                        title: {
                            display: true,
                            text: 'Count'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Line Chart: Checked-In Passengers Over Time
        const passengersChart = new Chart(document.getElementById('passengersChart'), {
            type: 'line',
            data: {
                labels: [
                    <c:forEach items="${dateLabels}" var="label" varStatus="status">
                        '${label}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Checked-In Passengers',
                    data: [<c:forEach items="${checkedInPassengersByDate}" var="count">${count},</c:forEach>],
                    fill: false,
                    borderColor: '#f59e0b',
                    tension: 0.1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginZero: true,
                        title: {
                            display: true,
                            text: 'Passengers'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Date'
                        }
                    }
                }
            }
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
