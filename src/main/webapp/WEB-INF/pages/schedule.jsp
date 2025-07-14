<%-- 
    Document   : schedule
    Created on : Jul 7, 2025, 1:02:16 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<%@ include file="/WEB-INF/include/header.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/schedule" />
<body class="bg-[#fff6f3] min-h-screen">
    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <!-- Header -->
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6 gap-4">
            <div>
                <h2 class="text-2xl font-bold  text-orange-600 ">Schedule</h2>
            </div>
        </div>

        <!-- FILTER FORM -->
        <form method="get" class="schedule-input-form flex justify-center gap-4 mb-6">
            <select name="origin" class="border rounded-full px-6 py-2 shadow-sm outline-none">
                <option value="">-- Departure Point --</option>
                <c:forEach var="loc" items="${locations}">
                    <option value="${loc.locationName}"
                            <c:if test="${filterOrigin == loc.locationName}">selected</c:if>>
                        ${loc.locationName}
                    </option>
                </c:forEach>
            </select>

            <select name="destination" class="border rounded-full px-6 py-2 shadow-sm outline-none">
                <option value="">-- Destination Point --</option>
                <c:forEach var="loc" items="${locations}">
                    <option value="${loc.locationName}"
                            <c:if test="${filterDestination == loc.locationName}">selected</c:if>>
                        ${loc.locationName}
                    </option>
                </c:forEach>
            </select>

            <button type="submit" class="bg-orange-500 text-white px-4 py-2 rounded-full">
                Search Trip
            </button>
        </form>

        <c:if test="${not empty error}">
            <div class="text-red-600 text-center mb-4">${error}</div>
        </c:if>

        <c:if test="${empty schedules}">
            <div class="text-gray-500 text-center">No matching results.</div>
        </c:if>

        <!-- RESULTS LIST -->
        <c:if test="${not empty schedules}">
            <!-- Header -->
            <div class="grid grid-cols-[6fr_2fr_3fr_4fr_2fr_2fr] justify-items-center items-center
                 bg-white border border-gray-200 rounded-full px-4 py-2 text-sm font-medium">
                <div>Departure → Destination</div>
                <div>Vehicle Type</div>
                <div>Distance</div>
                <div>Duration</div>
                <div>Price</div>
                <div>Action</div>
            </div>

            <!-- Rows -->
            <c:forEach var="s" items="${schedules}">
                <div class="grid grid-cols-[6fr_2fr_3fr_4fr_2fr_2fr] justify-items-center items-center
                     mt-2 bg-white border border-gray-200 rounded-2xl overflow-hidden">
                    <div class="flex items-center gap-2 text-orange font-medium">
                        ${s.origin}
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg"
                             class="w-4 h-4 inline-block" alt="arrow icon">
                        <span>${s.destination}</span>
                    </div>
                    <div>${s.busType}</div>
                    <div>${s.distanceKm} km</div>
                    <div>${s.durationFormatted}</div>
                    <div>
                        <fmt:formatNumber value="${s.price}" pattern="#,##0 ₫"/>
                    </div>
                    <div class="flex justify-end">
                        <a href="${pageContext.request.contextPath}/view-trips?origin=${s.origin}&destination=${s.destination}">
                            <button class="bg-orange-200 text-orange-600 py-2 px-4 rounded-full">Search Trip</button>
                        </a>
                    </div>
                </div>
            </c:forEach>

            <!-- PAGINATION -->
            <div class="flex justify-center space-x-2 mt-6">
                <fbus:adminpagination
                    currentPage="${currentPage}"
                    totalPages="${totalPages}"
                    url="${baseUrl}" />
            </div>
        </c:if>

    </div>
</div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>