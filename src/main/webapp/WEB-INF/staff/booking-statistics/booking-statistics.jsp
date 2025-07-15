<%-- 
    Document   : booking-statistics
    Created on : Jun 19, 2025, 1:45:51 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="mt-12 px-4">

    <!-- Booking Statistics Title -->
    <h2 class="text-2xl font-bold text-orange-600 mb-4">Booking Statistics</h2>

    <!-- Export Button -->
    <div class="flex justify-end mb-4">
        <a href="${pageContext.request.contextPath}/staff/booking-statistics/export?format=excel"
           class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded flex items-center gap-2">
            <i class="fas fa-file-excel"></i> Export to Excel
        </a>
    </div>

    <!-- Dashboard Grid-->
    <div class="grid grid-cols-12 gap-4 mb-8">
        <!-- Total Bookings -->
        <div class="col-span-3 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Total Bookings</p>
            <p class="text-xl font-bold text-orange-600">${totalRecords}</p>
        </div>
        <!-- Avg Revenue / Booking -->
        <div class="col-span-3 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Avg Revenue / Booking</p>
            <p class="text-xl font-bold text-purple-600">
                <fmt:formatNumber value="${avgRevenue}" type="currency" currencySymbol=" VND" />
            </p>
        </div>
        <!-- Total Revenue -->
        <div class="col-span-3 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Total Revenue</p>
            <p class="text-xl font-bold text-green-600">
                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol=" VND" />
            </p>
        </div>
        <!-- Paid Ratio -->
        <div class="col-span-3 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Paid Ratio</p>
            <p class="text-xl font-bold text-blue-600">
                <fmt:formatNumber value="${paidPercentage}" type="number" maxFractionDigits="2" />%
            </p>
        </div>

        <!-- Booking Status -->
        <div class="col-span-4 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500 mb-1">Booking Status</p>
            <p class="text-green-600">
                <span class="font-bold">Paid:</span> ${paidCount} (<fmt:formatNumber value="${paidRatio}" type="number" maxFractionDigits="2" />%)
            </p>
            <p class="text-red-500">
                <span class="font-bold">Unpaid:</span> ${unpaidCount} (<fmt:formatNumber value="${unpaidRatio}" type="number" maxFractionDigits="2" />%)
            </p>
        </div>


        <!-- Total Tickets -->
        <div class="col-span-4 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Total Tickets Sold</p>
            <p class="text-xl font-bold text-indigo-600">${totalTickets}</p>
        </div>

        <!-- Avg Tickets / Trip -->
        <div class="col-span-4 bg-white rounded shadow px-4 py-3">
            <p class="text-sm text-gray-500">Avg Tickets / Trip</p>
            <p class="text-xl font-bold text-indigo-600">${avgTicketsPerTrip}</p>
        </div>
    </div>


    <!-- Revenue Breakdown -->
    <h3 class="text-xl font-semibold text-gray-800 mb-4">Revenue Breakdown</h3>
    <div class="grid grid-cols-6 gap-6 mb-10">
        <!-- Bar Chart -->
        <div class="col-span-4 bg-white p-4 rounded-lg shadow">
            <canvas id="revenueBreakdownChart" height="120"></canvas>
        </div>

        <!-- Top Routes -->
        <div class="col-span-2 bg-white p-4 rounded-lg shadow">
            <h4 class="text-md font-semibold mb-3">Top Routes by Revenue</h4>

            <!-- Bar Chart -->
            <div class="h-[320px]">
                <canvas id="topRoutesChart" class="w-full h-full"></canvas>
            </div>

            <!-- List View -->
            <ul class="divide-y">
                <c:forEach var="entry" items="${routeRevenueMap}">
                    <li class="py-2 flex justify-between">
                        <span>${entry.key}</span>
                        <span class="font-semibold text-green-600">${entry.value}VND</span>
                    </li>
                </c:forEach>
            </ul>
        </div>

    </div>

    <!-- Additional Statistics Section -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-8">

        <!-- Top Customers -->
        <div class="bg-white rounded shadow px-4 py-3">
            <h3 class="text-lg font-semibold mb-2">Top Customers</h3>
            <table class="min-w-full text-sm">
                <thead class="bg-gray-100 text-gray-600">
                    <tr>
                        <th class="text-left px-3 py-2">#</th>
                        <th class="text-left px-3 py-2">Customer</th>
                        <th class="text-center px-3 py-2">Invoices</th>
                        <th class="text-right px-3 py-2">Total Spent</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                        <tr class="border-t">
                            <td class="px-3 py-2">${status.index + 1}</td>
                            <td class="px-3 py-2">${customer.customerName}</td>
                            <td class="px-3 py-2 text-center">${customer.invoiceCount}</td>
                            <td class="px-3 py-2 text-right">
                                <fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol=" VND" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Booking Trends Chart -->
        <div class="bg-white rounded shadow px-4 py-3">
            <h3 class="text-lg font-semibold mb-2">Booking Trends (Last 7 Days)</h3>
            <canvas id="bookingTrendsChart" height="200"></canvas>
        </div>
    </div>



</div>

<!-- Search & Filter Form -->
<form id="filterForm" method="post" action="${pageContext.request.contextPath}/staff/booking-statistics" class="flex flex-wrap items-center gap-4 mb-6">
    <!-- Search input -->
    <div class="flex-grow flex gap-2 min-w-[250px]">
        <input type="text" name="q" value="${fn:escapeXml(q)}" placeholder="Search by Invoice Code or Customer Name" class="w-full border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />
        <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
            <i class="fas fa-search"></i>
        </button>
    </div>

    <!-- Date filter -->
    <div class="relative">
        <input id="datepicker" name="date" type="text"
               value="${date}" 
               placeholder="Select date"
               class="w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500" />
        <span id="calendar-icon" 
              class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer">
            <i class="fas fa-calendar-alt"></i>
        </span>
    </div>

    <!-- Route filter -->
    <div class="relative w-[200px]">
        <select name="routeId"
                class="appearance-none w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500 text-sm">
            <option value="">All Routes</option>
            <c:forEach var="route" items="${distinctRoutes}">
                <option value="${route.routeId}" <c:if test="${routeId == route.routeId}">selected</c:if>>
                    ${route.routeName}
                </option>

            </c:forEach>
        </select>

        <span class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none">
            <i class="fas fa-filter text-sm"></i>
        </span>
    </div>


    <!-- Status filter -->
    <div class="relative w-[160px]">
        <select name="status"
                class="appearance-none w-full border rounded-lg px-4 py-2 pr-10 focus:outline-orange-500 text-sm">
            <option value="">All Status</option>
            <option value="Paid" <c:if test="${status == 'Paid'}">selected</c:if>>Paid</option>
            <option value="Unpaid" <c:if test="${status == 'Unpaid'}">selected</c:if>>Unpaid</option>
            </select>

            <span class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none">
                <i class="fas fa-filter text-sm"></i>
            </span>
        </div>

        <!-- Reset button -->
        <div>
            <button type="button" onclick="resetFilters()" class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                <i class="fas fa-sync-alt"></i>
                Reset Filters
            </button>
        </div>
    </form>


    <!-- Statistics Table -->
    <div class="overflow-x-auto shadow-sm border rounded-lg">
        <table class="min-w-full text-sm text-left text-gray-700">
            <thead class="bg-orange-100 font-semibold text-gray-800">
                <tr>
                    <th class="px-4 py-2">#</th>
                    <th class="px-4 py-2">Booking ID</th>
                    <th class="px-4 py-2">Customer</th>
                    <th class="px-4 py-2">Route</th>
                    <th class="px-4 py-2">Departure</th>
                    <th class="px-4 py-2">Driver</th>
                    <th class="px-4 py-2">Amount</th>
                    <th class="px-4 py-2">Status</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="s" items="${stats}" varStatus="loop">
                <tr class="border-b hover:bg-orange-50 transition">
                    <td class="px-4 py-2">${(currentPage - 1) * 10 + loop.index + 1}</td>
                    <td class="px-4 py-2 font-medium">${s.invoiceCode}</td>
                    <td class="px-4 py-2">${s.customerName}</td>
                    <td class="px-4 py-2">${s.routeName}</td>
                    <td class="px-4 py-2">
                        <fmt:formatDate value="${s.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                    <td class="px-4 py-2">${s.driverName}</td>
                    <td class="px-4 py-2 text-right font-semibold">
                        <fmt:formatNumber value="${s.invoiceAmount}" type="currency" currencySymbol="VND" />
                    </td>
                    <td class="px-4 py-2">
                        <span class="px-3 py-1 text-sm rounded-full font-medium flex items-center gap-1
                              ${fn:toLowerCase(s.paymentStatus) == 'paid' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                            <i class="fas ${fn:toLowerCase(s.paymentStatus) == 'paid' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                            ${s.paymentStatus}
                        </span>
                    </td>


                </tr>
            </c:forEach>

            <c:if test="${empty stats}">
                <tr>
                    <td colspan="10" class="py-4 px-4 text-center text-gray-500">
                        <div class="flex flex-col items-center justify-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <span class="text-sm text-gray-500 font-medium">No booking statistics found.</span>
                        </div>
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<!-- Pagination -->
<div class="flex justify-center space-x-2 mt-6">
    <fbus:adminpagination
        currentPage="${currentPage}"
        totalPages="${numOfPages}"
        url="${baseUrlWithSearch}" />
</div>

</div>

<script>
    function showLoading() {
        document.getElementById("loading-spinner").classList.remove("hidden");
    }

    function hideLoading() {
        document.getElementById("loading-spinner").classList.add("hidden");
    }

    document.querySelectorAll("#filterForm select, #filterForm input[name='date'], #filterForm input[name='q']").forEach(el => {
        el.addEventListener("change", () => {
            showLoading();
            setTimeout(() => el.form.submit(), 300);
        });
    });

    const searchInput = document.querySelector("#filterForm input[name='q']");
    if (searchInput) {
        searchInput.addEventListener("keypress", function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                showLoading();
                setTimeout(() => this.form.submit(), 300);
            }
        });
    }

    function resetFilters() {
        const form = document.getElementById("filterForm");
        form.reset();
        const fp = flatpickrInstance;
        if (fp)
            fp.clear();
        window.location.href = "<c:url value='/staff/booking-statistics'/>";
    }

    let flatpickrInstance;
    document.addEventListener("DOMContentLoaded", function () {
        flatpickrInstance = flatpickr("#datepicker", {
            altInput: true,
            altFormat: "d/m/Y",
            dateFormat: "Y-m-d",
            allowInput: true
        });

        const icon = document.getElementById("calendar-icon");
        if (icon) {
            icon.addEventListener("click", function () {
                flatpickrInstance.open();
            });
        }
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const fontFamily = 'ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"';
        const formatter = new Intl.NumberFormat('vi-VN', {
            minimumFractionDigits: 0
        });

        // === Revenue Breakdown Chart (Green) ===
        const ctxBreakdown = document.getElementById("revenueBreakdownChart").getContext("2d");
        const routeLabels = ${routeNamesJson};
        const routeData = ${routeRevenueJson};

        new Chart(ctxBreakdown, {
            type: 'bar',
            data: {
                labels: routeLabels,
                datasets: [{
                        label: 'Revenue (VND)',
                        data: routeData,
                        backgroundColor: 'rgba(34, 197, 94, 0.5)',
                        borderRadius: 6
                    }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => formatter.format(ctx.raw) + ' VND'
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => formatter.format(value) + ' VND',
                            font: {family: fontFamily}
                        }
                    },
                    x: {
                        ticks: {
                            font: {family: fontFamily}
                        }
                    }
                }
            }
        });

        // === Top Routes Chart (Orange) ===
        const ctxTopRoutes = document.getElementById("topRoutesChart").getContext("2d");

        new Chart(ctxTopRoutes, {
            type: 'bar',
            data: {
                labels: routeLabels,
                datasets: [{
                        label: 'Revenue (VND)',
                        data: routeData,
                        backgroundColor: 'rgba(255, 159, 64, 0.6)',
                        borderRadius: 5
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => formatter.format(ctx.raw)
                        }
                    }
                },
                scales: {
                    x: {
                        ticks: {
                            font: {family: fontFamily}
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            font: {family: fontFamily},
                            callback: value => formatter.format(value)
                        }
                    }
                }
            }
        });

        // === Booking Trends (Last 7 Days) Chart (Blue line) ===
        const trendCtx = document.getElementById("bookingTrendsChart").getContext("2d");
        const trendLabels = ${trendDatesJson};
        const trendData = ${trendCountsJson};

        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: trendLabels,
                datasets: [{
                        label: 'Bookings',
                        data: trendData,
                        borderColor: 'rgba(59, 130, 246, 1)',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        tension: 0.3,
                        fill: true
                    }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            font: {family: fontFamily}
                        }
                    },
                    x: {
                        ticks: {
                            font: {family: fontFamily}
                        }
                    }
                }
            }
        });
    });
</script>
<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
