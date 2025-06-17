<%-- 
    Document   : delete-trip
    Created on : Jun 11, 2025, 1:21:27 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#fff6f3] flex items-center justify-center min-h-screen p-4">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <div class="p-6">
            <!-- Title -->
            <h1 class="text-3xl font-bold text-orange-600 mb-6">Delete Trip</h1>

            <!-- Trip Details -->
            <div class="space-y-4 text-gray-800">
                <div><span class="font-semibold">Trip ID:</span> ${trip.tripId}</div>
                <div><span class="font-semibold">Route:</span> ${trip.route}</div>
                <div><span class="font-semibold">Date:</span> ${trip.tripDate}</div>
                <div><span class="font-semibold">Time:</span> ${trip.tripTime}</div>
                <div><span class="font-semibold">Bus Type:</span> ${trip.busType}</div>
                <div><span class="font-semibold">Driver:</span> ${trip.driver}</div>
                <div><span class="font-semibold">Status:</span> ${trip.status}</div>
            </div>

            <!-- Warning Alert -->
            <div class="mt-6 flex items-start gap-3 bg-yellow-100 border border-yellow-300 text-yellow-800 px-4 py-3 rounded-lg">
                <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.72-1.36 3.485 0l5.516 9.814A1.75 1.75 0 0116.516 15H3.484a1.75 1.75 0 01-1.742-2.087L8.257 3.1zM11 13a1 1 0 10-2 0 1 1 0 002 0zm-.25-2.75a.75.75 0 00-1.5 0v1.5a.75.75 0 001.5 0v-1.5z" clip-rule="evenodd" />
                </svg>
                <p class="text-sm">
                    Warning: Deleting this trip will remove all related bookings. This action cannot be undone.
                </p>
            </div>

            <!-- Actions -->
            <div class="mt-6 flex justify-end gap-4">
                <a href="${pageContext.request.contextPath}/admin/trips">
                    <button type="button"
                            class="px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">
                        Cancel
                    </button>
                </a>

                <form method="post" action="${pageContext.request.contextPath}/admin/trips">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="tripId" value="${trip.tripId}"/>
                    <button type="submit"
                            class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                        Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>