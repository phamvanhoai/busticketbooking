<%-- 
    Document   : request-trip-change
    Created on : Jun 13, 2025, 10:49:13 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-gray-100 py-10">

    <div class="bg-white p-8 rounded-2xl shadow-lg">
        <h1 class="text-2xl font-bold text-orange-600 mb-6">Request Cancel Trip</h1>

        <!-- Display error messages if there are any -->
        <c:choose>
            <c:when test="${not empty success}">
                <div class="bg-green-100 text-green-700 p-4 rounded mb-4">
                    ${success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:when>
            <c:when test="${not empty error}">
                <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
                    ${error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:when>
        </c:choose>

        <form action="${pageContext.request.contextPath}/driver/trip-change" method="post" class="space-y-6">
            <!-- Chọn chuyến đi -->
            <div>
                <label for="tripId" class="block text-sm font-medium text-gray-700 mb-2">Select Trip</label>
                <select id="tripId" name="tripId" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                    <option value="">Select a trip</option>
                    <c:forEach var="trip" items="${assignedTrips}">
                        <option value="${trip.tripId}">${trip.tripId} - ${trip.route} - ${trip.date} ${trip.time}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Lý do đổi chuyến -->
            <div>
                <label for="reason" class="block text-sm font-medium text-gray-700 mb-2">Reason for change</label>
                <textarea id="reason" name="reason" rows="4" required
                          placeholder="Describe the reason for changing the trip..."
                          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none"></textarea>
            </div>

            <!-- Thao tác -->
            <div class="flex justify-end gap-4">
                <button type="reset" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                    Reset
                </button>
                <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn gửi yêu cầu hủy chuyến?')" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                    Submit Request
                </button>
            </div>
        </form>
    </div>

    <div class="mt-10 px-4">

        <h1 class="text-3xl font-bold text-orange-600">Cancel Trip Requests</h1><br>
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">

            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Request ID</th>
                        <th class="px-4 py-2">Trip ID</th>
                        <th class="px-4 py-2">Route</th>
                        <th class="px-4 py-2">Request Reason</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Request Date</th>
                        <th class="px-4 py-2">Approval Date</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Duyệt qua danh sách yêu cầu hủy chuyến -->
                    <c:forEach var="request" items="${cancelledTrips}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2">${request.requestId}</td>
                            <td class="px-4 py-2">${request.tripId}</td>
                            <td class="px-4 py-2">${request.route}</td>
                            <td class="px-4 py-2">${request.requestReason}</td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${request.status == 'Pending'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-yellow-100 text-yellow-700">
                                            ${request.status}
                                        </span>
                                    </c:when>
                                    <c:when test="${request.status == 'Approved'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                            ${request.status}
                                        </span>
                                    </c:when>
                                    <c:when test="${request.status == 'Rejected'}">
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                            ${request.status}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 text-sm rounded-full font-semibold bg-gray-100 text-gray-700">Unknown</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-2"><fmt:formatDate value="${request.requestDate}" pattern="yyyy-MM-dd" /></td>
                            <td class="px-4 py-2"><fmt:formatDate value="${request.approvalDate}" pattern="yyyy-MM-dd" /></td>
                        </tr>
                    </c:forEach>
                    <!-- No data case if list is empty -->
                    <c:if test="${empty cancelledTrips}">
                        <tr>
                            <td colspan="8" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">
                                        No cancelled trips found.
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        <!-- Pagination if needed -->
        <div class="flex justify-center mt-6 space-x-2">
            <fbus:adminpagination 
                currentPage="${currentPage}" 
                totalPages="${totalPages}" 
                url="${baseUrl}" />
        </div>

    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>