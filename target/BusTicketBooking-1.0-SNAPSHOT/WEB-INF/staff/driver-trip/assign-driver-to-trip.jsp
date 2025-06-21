<%-- 
    Document   : assign-driver-to-trip
    Created on : Jun 18, 2025, 10:19:55 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all.min.css">
<%@page import="java.util.List"%>
<%@page import="busticket.model.Trip"%>
<%@page import="busticket.model.Driver"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="px-4 mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Assign Driver to Trip</h2>

        <!-- Session Flash Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded mb-4 flex items-center gap-2">
                <i class="fas fa-check-circle text-green-600"></i>
                <span>${sessionScope.success}</span>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded mb-4 flex items-center gap-2">
                <i class="fas fa-exclamation-triangle text-red-600"></i>
                <span>${sessionScope.error}</span>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>


        <!-- Filters -->
        <div class="flex flex-col lg:grid lg:grid-cols-5 gap-4 items-center mb-6">
            <input
                type="text"
                placeholder="Search by Trip ID or Route"
                class="w-full border rounded-lg px-4 py-2 col-span-2"
                />

            <input
                type="date"
                class="w-full border rounded-lg px-4 py-2"
                />

            <select class="w-full border rounded-lg px-4 py-2">
                <option value="All">All Routes</option>
                <c:forEach var="trip" items="${trips}">
                    <option value="${trip.routeId}">${trip.routeId}</option>
                </c:forEach>
            </select>

            <select class="w-full border rounded-lg px-4 py-2">
                <option value="All">All Status</option>
                <option value="Assigned">Assigned</option>
                <option value="Not Assigned">Not Assigned</option>
            </select>
        </div>

        <!-- Table -->
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
                    <c:forEach var="trip" items="${trips}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="py-2 px-4">${trip.tripId}</td>
                            <td class="py-2 px-4">${trip.routeId}</td>
                            <td class="py-2 px-4">${trip.departureTime}</td>
                            <td class="py-2 px-4">
                                <span class="px-3 py-1 text-sm rounded-full bg-yellow-100 text-yellow-700">Not Assigned</span>
                            </td>
                            <td class="py-2 px-4">—</td>
                            <td class="py-2 px-4">
                                <button class="text-blue-800 hover:text-blue-600 flex items-center gap-1"
                                        onclick="openAssignModal('${trip.tripId}')">
                                    <i class="fas fa-user-plus text-blue-700"></i> Assign
                                </button>
                            </td>

                        </tr>
                    </c:forEach>
                    <c:if test="${empty trips}">
                        <tr>
                            <td colspan="6" class="py-4 px-4 text-center text-gray-500">No available trips.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center gap-2 mt-6">
            <button class="px-3 py-1 rounded-md border bg-orange-500 text-white">1</button>
        </div>

        <!-- Modal for Assign Driver -->
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
                    <button type="button" onclick="closeModal()" class="px-4 py-2 rounded-lg border border-gray-300">
                        Cancel
                    </button>
                    <button type="submit" class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                        Confirm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAssignModal(tripId) {
            document.getElementById('assign-modal').style.display = 'flex';
            document.getElementById('modal-title').innerText = `Assign Driver to ${tripId}`;
            document.getElementById('modal-trip-id').value = tripId;
        }

        function closeModal() {
            document.getElementById('assign-modal').style.display = 'none';
        }
    </script>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>
</body>
