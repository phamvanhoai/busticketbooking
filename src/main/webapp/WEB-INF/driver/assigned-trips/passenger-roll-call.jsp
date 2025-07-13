<%-- 
    Document   : passenger-roll-call
    Created on : Jun 19, 2025, 10:35:55 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>


<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-lg p-8 relative">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Passenger Roll Call</h1>

        <!-- Form to submit data -->
        <c:if test="${tripStatus != 'Ongoing'}">
            <div class="bg-yellow-100 text-yellow-800 p-4 rounded-lg mb-4">
                <c:choose>
                    <c:when test="${tripStatus == 'Scheduled'}">
                        This trip is scheduled and has not started yet. Check-in and check-out are not allowed.
                    </c:when>
                    <c:when test="${tripStatus == 'Completed'}">
                        This trip has been completed. Check-in and check-out cannot be modified.
                    </c:when>
                    <c:when test="${tripStatus == 'Cancelled'}">
                        This trip has been cancelled. Check-in and check-out are not allowed.
                    </c:when>
                    <c:otherwise>
                        This trip is not in progress. Check-in and check-out are only allowed during Ongoing trips.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Form to submit data -->
        <form action="${pageContext.request.contextPath}/driver/assigned-trips" method="post">
            <input type="hidden" name="tripId" value="${tripId}">
            <div class="space-y-4 mb-8">
                <c:forEach var="passenger" items="${passengers}">
                    <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                        <div class="w-10 text-center font-medium">${passenger.seat}</div>
                        <div class="flex-1 text-sm text-gray-700">
                            ${passenger.name}
                            <div class="text-xs text-gray-500">Phone: ${passenger.phone}</div>
                            <div class="text-xs text-gray-500">Pick-up location: ${passenger.pickupLocation}</div>
                            <div class="text-xs text-gray-500">Drop-off location: ${passenger.dropoffLocation}</div>
                        </div>
                        <div class="flex items-center gap-4">
                            <!-- Check-in Checkbox -->
                            <label class="inline-flex items-center gap-2">
                                <input type="hidden" name="checkInStatus-${passenger.ticketId}" value="off">
                                <input type="checkbox" name="checkInStatus-${passenger.ticketId}" class="check-status" 
                                       data-seat="${passenger.seat}" data-ticket-id="${passenger.ticketId}" 
                                       value="on"
                                       <c:if test="${not empty passenger.checkInTime}">checked</c:if>
                                       <c:if test="${tripStatus != 'Ongoing'}">disabled</c:if> />
                                <span>Check-in</span>
                            </label>

                            <!-- Check-out Checkbox -->
                            <label class="inline-flex items-center gap-2">
                                <input type="hidden" name="checkOutStatus-${passenger.ticketId}" value="off">
                                <input type="checkbox" name="checkOutStatus-${passenger.ticketId}" class="check-status" 
                                       data-seat="${passenger.seat}" data-ticket-id="${passenger.ticketId}" 
                                       value="on"
                                       <c:if test="${not empty passenger.checkOutTime}">checked</c:if>
                                       <c:if test="${tripStatus != 'Ongoing'}">disabled</c:if> />
                                <span>Check-out</span>
                            </label>
                        </div>
                        <div class="text-sm text-gray-500 mt-2" id="status-${passenger.seat}">
                            Status: ${passenger.checkInTime != null ? (passenger.checkOutTime != null ? 'Checked-out' : 'Checked-in') : 'Not checked-in'}
                        </div>
                    </div>
                </c:forEach>
                <!-- No data case if list is empty -->
                <c:if test="${empty passengers}">
                    <div class="flex flex-col items-center justify-center gap-2 py-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <span class="text-sm text-gray-500 font-medium">
                            No passengers found.
                        </span>
                    </div>
                </c:if>
            </div>

            <!-- Action buttons -->
            <div class="p-4 bg-white border-t">
                <div class="flex justify-end gap-4">
                    <a href="${pageContext.request.contextPath}/driver/assigned-trips">
                        <button type="button" class="px-6 py-2 border rounded-lg text-gray-700 hover:bg-gray-100">
                            Cancel
                        </button>
                    </a>
                    <button type="submit" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
                            <c:if test="${tripStatus != 'Ongoing'}">disabled</c:if>>
                        Save Roll Call
                    </button>
                </div>
            </div>
        </form>


    </div>


    <script>
        document.querySelectorAll('.check-status').forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const seat = checkbox.dataset.seat;
                const ticketId = checkbox.dataset.ticketId;
                const checkinCheckbox = document.querySelector(`input[name="checkInStatus-${ticketId}"]`);
                const checkoutCheckbox = document.querySelector(`input[name="checkOutStatus-${ticketId}"]`);
                const statusText = document.getElementById(`status-${seat}`);

                if (checkoutCheckbox.checked && !checkinCheckbox.checked) {
                    statusText.textContent = 'Status: Error! Cannot check-out without check-in';
                    statusText.classList.add('text-red-600');
                    checkoutCheckbox.checked = false;
                } else {
                    statusText.classList.remove('text-red-600');
                    if (checkinCheckbox.checked && checkoutCheckbox.checked) {
                        statusText.textContent = 'Status: Checked-out';
                    } else if (checkinCheckbox.checked) {
                        statusText.textContent = 'Status: Checked-in';
                    } else {
                        statusText.textContent = 'Status: Not checked-in';
                    }
                }
            });
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
