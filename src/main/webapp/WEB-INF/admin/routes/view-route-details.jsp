<%-- 
    Document   : view-route-details
    Created on : Jun 21, 2025, 6:46:30 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<body class="bg-[#f3f3f5] p-6 min-h-screen flex items-center justify-center">
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <!-- Header -->
        <div class="bg-gradient-to-r from-orange-500 to-orange-300 p-6">
            <h1 class="text-2xl font-bold text-white">Route Details</h1>
        </div>

        <!-- Content -->
        <div class="p-6 space-y-6">
            <!-- Basic Info -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Route ID</h2>
                    <p class="mt-1 text-lg font-medium text-gray-800">${route.routeId}</p>
                </div>
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Status</h2>
                    <c:choose>
                        <c:when test="${route.routeStatus == 'Active'}">
                            <span class="inline-block mt-1 px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                                Active
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="inline-block mt-1 px-3 py-1 bg-red-100 text-red-800 rounded-full text-sm font-medium">
                                Inactive
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Start & End -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Start Point</h2>
                    <p class="mt-1 text-gray-800">${route.startLocation}</p>
                </div>
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">End Point</h2>
                    <p class="mt-1 text-gray-800">${route.endLocation}</p>
                </div>
            </div>

            <!-- Timing & Distance -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Distance</h2>
                    <p class="mt-1 text-gray-800">${route.distanceKm} km</p>
                </div>
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Duration</h2>
                    <p class="mt-1 text-gray-800">
                        <c:choose>
                            <c:when test="${routeHours > 0 and routeMinutes > 0}">
                                ${routeHours}h${routeMinutes}m
                            </c:when>
                            <c:when test="${routeHours > 0}">
                                ${routeHours}h
                            </c:when>
                            <c:otherwise>
                                ${routeMinutes}m
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div>
                    <h2 class="text-sm font-semibold text-gray-500 uppercase">Stops</h2>
                    <p class="mt-1 text-gray-800">${fn:length(stops)} stops</p>
                </div>
            </div>


            <!-- Scheduled Stops -->
            <div>
                <h2 class="text-sm font-semibold text-gray-500 uppercase mb-2">Scheduled Stops</h2>
                <ul class="space-y-2">
                    <c:forEach var="sp" items="${stops}" varStatus="st">
                        <li class="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                            <!-- Số thứ tự -->
                            <span class="font-medium text-gray-800">#${st.index + 1}</span>
                            <!-- Tên location -->
                            <span class="text-gray-600">
                                <c:forEach var="loc" items="${locations}">
                                    <c:if test="${loc.locationId == sp.locationId}">
                                        ${loc.locationName}
                                    </c:if>
                                </c:forEach>
                            </span>
                            <!-- Dwell Minutes -->
                            <span class="text-gray-500">${sp.dwellMinutes} min</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Route Prices -->
            <div>
                <h2 class="text-sm font-semibold text-gray-500 uppercase mb-2">Route Prices</h2>
                <ul class="space-y-2">
                    <c:forEach var="pr" items="${prices}">
                        <li class="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                            <span class="font-medium text-gray-800">
                                <c:forEach var="bt" items="${busTypes}">
                                    <c:if test="${bt.busTypeId == pr.busTypeId}">
                                        ${bt.busTypeName}
                                    </c:if>
                                </c:forEach>
                            </span>
                            <!-- Chỉ hiển thị phần số nguyên -->
                            <span class="text-gray-600">
                                ${fn:substringBefore(pr.price, '.')} ₫
                            </span>
                        </li>
                    </c:forEach>
                </ul>
            </div>



            <!-- Action Buttons -->
            <div class="flex justify-end gap-4 mt-4">
                <a href="${pageContext.request.contextPath}/admin/routes">
                    <button class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                        Back
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/admin/routes?editId=${route.routeId}">
                    <button class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                        Edit Route
                    </button>
                </a>
            </div>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>