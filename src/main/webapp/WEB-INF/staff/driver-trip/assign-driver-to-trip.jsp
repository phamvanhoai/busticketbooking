<%-- 
    Document   : assign-driver-to-trip.jsp
    Description: JSP page to list and manage all user accounts
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="busticket.model.StaffTrip"%>
<%@page import="busticket.model.Driver"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<!-- Flatpickr CSS & JS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <!-- Header layout for Staff -->
    <%@include file="/WEB-INF/include/staff/staff-header.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all.min.css">
        <body class="bg-[#f9fafb]">
            <div class="px-4 mt-10">
                <h2 class="text-3xl font-bold text-orange-600 mb-6">Assign Driver to Trip</h2>
                <!-- Success Message -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded mb-4 flex items-center gap-2">
                        <i class="fas fa-check-circle text-green-600"></i>
                        <span>${sessionScope.success}</span>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <!-- Error Message -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded mb-4 flex items-center gap-2">
                        <i class="fas fa-exclamation-triangle text-red-600"></i>
                        <span>${sessionScope.error}</span>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                <!-- Spinner while loading -->
                <div id="loading-spinner" class="flex justify-center items-center py-6 hidden">
                    <svg class="animate-spin h-6 w-6 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                    </svg>
                    <span class="ml-3 text-sm text-gray-600">Loading trips...</span>
                </div>
                <!-- Filter Form: Search / Date / Route / Status -->
                <form id="filterForm" method="get" class="flex flex-wrap items-center gap-4 mb-6">
                    <!-- Search by ID or Route -->
                    <div class="flex-grow flex gap-2 min-w-[250px]">
                        <input type="text" name="search" value="${search}" 
                               placeholder="Search by Trip ID or Route"
                               class="w-full border border-orange-400 rounded-lg px-4 py-2 focus:outline-orange-500" />
                        <button type="submit"
                                class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <!-- Date filter using flatpickr -->
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
                    <div class="relative">
                        <span class="absolute left-3 top-2.5 text-gray-400">
                            <i class="fas fa-filter"></i>
                        </span>
                        <select name="routeId" class="w-full border rounded-lg px-4 py-2 pl-10">
                            <option value="">All Routes</option>
                            <c:forEach var="route" items="${distinctRoutes}">
                                <option value="${route.routeId}" ${routeId == route.routeId ? "selected" : ""}>
                                    ${route.routeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Status filter -->
                    <div class="relative">
                        <span class="absolute left-3 top-2.5 text-gray-400">
                            <i class="fas fa-filter"></i>
                        </span>
                        <select name="status" class="w-full border rounded-lg px-4 py-2 pl-10">
                            <option value="">All Status</option>
                            <option value="Assigned" ${status == 'Assigned' ? "selected" : ""}>Assigned</option>
                            <option value="NotAssigned" ${status == 'NotAssigned' ? "selected" : ""}>Not Assigned</option>
                        </select>
                    </div>
                    <!-- Reset Filters Button -->
                    <div>
                        <button type="button"
                                onclick="resetFilters()"
                                class="text-sm px-4 py-2 border border-orange-400 text-orange-600 rounded-lg hover:bg-orange-100 transition flex items-center gap-2">
                            <i class="fas fa-sync-alt"></i>
                            Reset Filters
                        </button>
                    </div>
                </form>
                <!-- Trip Listing Table -->
                <div class="bg-white shadow-lg rounded-xl overflow-x-auto">
                    <table class="min-w-full text-left text-sm">
                        <thead class="bg-orange-100 text-orange-700">
                            <tr>
                                <th class="py-2 px-4">Trip ID</th>
                                <th class="py-2 px-4">Route</th>
                                <th class="py-2 px-4">Date</th>
                                <th class="py-2 px-4">Status</th>
                                <th class="py-2 px-4">Assigned Driver</th>
                                <th class="py-2 px-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Trip rows -->
                            <c:forEach var="trip" items="${trips}">
                                <tr class="border-t hover:bg-gray-50">
                                    <td class="py-2 px-4">${trip.formattedTripId}</td>
                                    <td class="py-2 px-4">${trip.startLocation} &rarr; ${trip.endLocation}</td>
                                    <td class="py-2 px-4">
                                        <fmt:formatDate value="${trip.departureTime}" pattern="dd/MM/yyyy hh:mm a" />
                                    </td>
                                    <td class="py-2 px-4">
                                        <c:choose>
                                            <c:when test="${trip.assignedDriver ne null}">
                                                <span class="px-3 py-1 text-sm rounded-full bg-green-100 text-green-700">Assigned</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-3 py-1 text-sm rounded-full bg-yellow-100 text-yellow-700">Not Assigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-2 px-4">
                                        <c:choose>
                                            <c:when test="${trip.assignedDriver ne null}">
                                                ${trip.assignedDriver}
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-2 px-4">
                                        <button class="text-blue-600 hover:text-blue-800 flex items-center gap-1"
                                                onclick="openAssignModal(${trip.tripId})">
                                            <i class="fas fa-user-edit text-blue-600"></i> Assign
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <!-- No data case -->
                            <c:if test="${empty trips}">
                                <tr>
                                    <td colspan="6" class="py-4 px-4 text-center text-gray-500">
                                        <div class="flex flex-col items-center justify-center gap-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            <span class="text-sm text-gray-500 font-medium">No trips found for your search.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <!-- Pagination -->
                <div class="flex justify-center space-x-2 mt-6">
                    <fbus:adminpagination currentPage="${currentPage}" totalPages="${numOfPages}" url="${baseUrlWithSearch}" />
                </div>
                <!-- Modal for assigning driver -->
                <div id="assign-modal" class="fixed inset-0 bg-black bg-opacity-40 flex justify-center items-center z-50" style="display: none;">
                    <form action="assign-driver-trip" method="post" class="bg-white p-6 rounded-xl shadow-xl w-full max-w-md relative">
                        <h3 class="text-lg font-bold mb-4" id="modal-title">Assign Driver to Trip</h3>
                        <input type="hidden" name="tripId" id="modal-trip-id" />
                        <label class="block mb-2 text-sm font-medium">Available Drivers</label>
                        <select name="driverId" id="driver-select" class="w-full border px-4 py-2 rounded-lg mb-4">
                            <option value="">-- Select Driver --</option>
                            <c:forEach var="d" items="${drivers}">
                                <option value="${d.driverId}">${d.fullName}</option>
                            </c:forEach>
                        </select>
                        <div class="flex justify-end gap-2">
                            <button type="button" onclick="closeModal()" class="px-4 py-2 rounded-lg border border-gray-300">Cancel</button>
                            <button type="submit" class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">Confirm</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- JS for Modal and Filters -->
            <script>
                function openAssignModal(tripId) {
                    document.getElementById('assign-modal').style.display = 'flex';
                    document.getElementById('modal-title').innerText = `Assign Driver to ${tripId}`;
                    document.getElementById('modal-trip-id').value = tripId;
                }

                function closeModal() {
                    document.getElementById('assign-modal').style.display = 'none';
                }

                function showLoading() {
                    document.getElementById("loading-spinner").classList.remove("hidden");
                }

                function hideLoading() {
                    document.getElementById("loading-spinner").classList.add("hidden");
                }

                // Auto-submit form on filter change
                document.querySelectorAll("#filterForm select, #filterForm input[name='date'], #filterForm input[name='search']").forEach(el => {
                    el.addEventListener("change", () => {
                        showLoading();
                        el.form.submit();
                    });
                });
            </script>
            <!-- Initialize flatpickr + reset filter logic -->
            <script>
                function resetFilters() {
                    const form = document.getElementById("filterForm");
                    form.reset();
                    const fp = flatpickrInstance;
                    if (fp)
                        fp.clear();
                    window.location.href = "<c:url value='/staff/assign-driver-trip'/>";
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
            <!-- Staff footer -->
            <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
        </body>