<%-- 
    Document   : edit-trip
    Created on : Jun 11, 2025, 1:19:40 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Update Trip</h2>
        <form action="${pageContext.request.contextPath}/admin/trips" method="post" class="space-y-6">
            <!-- hidden fields -->
            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="tripId" value="${trip.tripId}"/>

            <!-- Route -->
            <div>
                <label for="route" class="block mb-1 font-medium">Route</label>
                <select
                    id="route"
                    name="route"
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                    >
                    <option value="" disabled>Chọn tuyến</option>
                    <c:forEach var="r" items="${routes}">
                        <option value="${r.routeId}"
                                <c:if test="${r.routeId == trip.routeId}">selected</c:if>
                                    >
                                ${r.startLocation} → ${r.endLocation}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Departure Date & Time -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="departureDate" class="block mb-1 font-medium">Departure Date</label>
                    <input
                        id="departureDate"
                        name="departureDate"
                        type="date"
                        value="${trip.tripDate}"
                        required
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                        />
                </div>
                <div>
                    <label for="departureTime" class="block mb-1 font-medium">Departure Time</label>
                    <input
                        id="departureTime"
                        name="departureTime"
                        type="time"
                        value="${trip.tripTime}"
                        required
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                        />
                </div>
            </div>



            <!-- Status -->
            <div>
                <label for="status" class="block mb-1 font-medium">Status</label>
                <select
                    id="status"
                    name="status"
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                    >
                    <option value="Scheduled"  <c:if test="${trip.status == 'Scheduled'}">selected</c:if>>Scheduled</option>
                    <option value="Cancelled"  <c:if test="${trip.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                    <option value="Completed"  <c:if test="${trip.status == 'Completed'}">selected</c:if>>Completed</option>
                    </select>
                </div>

                <!-- Driver & Bus -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="driver" class="block mb-1 font-medium">Driver</label>
                        <select
                            id="driver"
                            name="driver"
                            required
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                            >
                            <option value="" disabled>Select Driver</option>
                        <c:forEach var="d" items="${drivers}">
                            <option value="${d.driverId}"
                                    <c:if test="${d.driverId == trip.driverId}">selected</c:if>
                                        >
                                    ${d.userName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label for="bus" class="block mb-1 font-medium">Bus</label>
                    <select
                        id="bus"
                        name="bus"
                        required
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                        >
                        <option value="" disabled>Chọn xe</option>
                        <c:forEach var="b" items="${buses}">
                            <option value="${b.busId}"
                                    <c:if test="${b.busId == trip.busId}">selected</c:if>
                                        >
                                    ${b.plateNumber}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.request.contextPath}/admin/trips">
                    <button
                        type="button"
                        class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-lg"
                        >
                        Cancel
                    </button>
                </a>
                <button
                    type="submit"
                    class="bg-[#EF5222] hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg"
                    >
                    Update
                </button>
            </div>
        </form>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>