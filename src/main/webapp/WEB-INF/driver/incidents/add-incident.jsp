<%-- 
    Document   : add-incident
    Created on : Jul 23, 2025, 11:54:35 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <h1 class="text-3xl font-bold text-orange-600">Create Incident Report</h1>

        <c:if test="${not empty success}">
            <div class="bg-green-100 text-green-700 p-4 rounded mb-4">
                ${success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
                ${error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <div class="bg-white p-8 rounded-2xl shadow-lg">
            <form action="${pageContext.request.contextPath}/driver/incidents" method="post" enctype="multipart/form-data" class="space-y-6">
                <input type="hidden" name="action" value="createIncident">
                <input type="hidden" name="driverId" value="${sessionScope.currentUser.user_id}">
                <div>
                    <label for="tripId" class="block text-sm font-medium text-gray-700 mb-2">Trip (Optional)</label>
                    <select id="tripId" name="tripId" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                        <option value="">Not related to a trip</option>
                        <c:forEach var="trip" items="${assignedTrips}">
                            <option value="${trip.tripId}">${trip.tripId} - ${trip.route} - ${trip.date} ${trip.time}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label for="incidentDescription" class="block text-sm font-medium text-gray-700 mb-2">Incident Description</label>
                    <textarea id="incidentDescription" name="incidentDescription" rows="4" required
                              placeholder="Describe the incident in detail..."
                              class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none"></textarea>
                </div>
                <div>
                    <label for="incidentLocation" class="block text-sm font-medium text-gray-700 mb-2">Incident Location</label>
                    <input type="text" id="incidentLocation" name="incidentLocation" placeholder="GPS coordinates or address"
                           class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                </div>
                <div>
                    <label for="incidentPhoto" class="block text-sm font-medium text-gray-700 mb-2">Photo (Optional)</label>
                    <input type="file" id="incidentPhoto" name="incidentPhoto" accept="image/*"
                           class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                </div>
                <div>
                    <label for="incidentType" class="block text-sm font-medium text-gray-700 mb-2">Incident Type</label>
                    <select id="incidentType" name="incidentType" required
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                        <option value="Accident">Accident</option>
                        <option value="Breakdown">Breakdown</option>
                        <option value="Passenger Issue">Passenger Issue</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="flex justify-end gap-4">
                    <button type="reset" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                        Reset
                    </button>
                    <button type="submit" onclick="return confirm('Are you sure you want to submit the incident report?')"
                            class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                        Submit Report
                    </button>
                </div>
            </form>
        </div>

        <div class="mt-10">
            <a href="${pageContext.request.contextPath}/driver/incidents"
               class="text-orange-600 hover:underline text-lg font-medium">
                View Incident Report History
            </a>
        </div>
    </div>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>