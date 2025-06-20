<%-- 
    Document   : view-location-details
    Created on : Jun 20, 2025, 2:53:30 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<c:set var="loc" value="${location}" />

<body class="bg-gray-100 min-h-screen p-6">
    <div class="bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-[#EF5222] mb-6">Location Details</h1>

        <div class="space-y-4 text-gray-700">
            <div class="flex">
                <span class="w-32 font-semibold">Name:</span>
                <span>${loc.locationName}</span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Address:</span>
                <div>${loc.address}</div>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Description:</span>
                <span>${loc.locationDescription}</span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Created On:</span>
                <span><fmt:formatDate value="${loc.locationCreatedAt}" pattern="dd-MM-yyyy" /></span>
            </div>
            <div class="flex">
                <span class="w-32 font-semibold">Status:</span>
                <span class="${loc.locationStatus == 'Active' ? 'text-green-600 font-medium' : 'text-red-600 font-medium'}">
                    ${loc.locationStatus}
                </span>
            </div>
        </div>

        <!-- Map Preview -->
        <div class="mt-6">
            <iframe
                width="100%" height="300" frameborder="0" style="border:0"
                src="https://maps.google.com/maps?q=${loc.latitude},${loc.longitude}&z=15&output=embed"
                allowfullscreen>
            </iframe>
        </div>


        <!-- Action buttons -->
        <div class="flex justify-end gap-4 pt-4">
            <a href="${pageContext.request.contextPath}/admin/locations?editId=${loc.locationId}">
                <button class="bg-orange-500 hover:bg-orange-600 text-white font-medium px-6 py-2 rounded-lg">Edit</button>
            </a>
            <a href="${pageContext.request.contextPath}/admin/locations?delete=${loc.locationId}"
               onclick="return confirm('Bạn có chắc muốn xóa không?');">
                <button class="bg-red-500 hover:bg-red-600 text-white font-medium px-6 py-2 rounded-lg">Delete</button>
            </a>
            <a href="${pageContext.request.contextPath}/admin/locations">
                <button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-6 py-2 rounded-lg">Back</button>
            </a>
        </div>
    </div>
    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>