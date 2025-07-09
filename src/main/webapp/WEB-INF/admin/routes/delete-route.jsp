<%-- 
    Document   : delete-route
    Created on : Jun 11, 2025, 1:34:37 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<body class="bg-gray-50">
    <form action="${pageContext.request.contextPath}/admin/routes" method="post">
        <input type="hidden" name="action" value="delete" />
        <input type="hidden" name="routeId" value="${route.routeId}" />

        <div class="bg-gray-50 p-10 rounded-3xl shadow-xl mt-8">
            <h1 class="text-3xl font-bold mb-8" style="color: #EF5222;">
                Delete Route
            </h1>

            <p class="mb-4 font-semibold">
                Origin: <span class="font-normal text-gray-800">${route.startLocation}</span>
            </p>
            <p class="mb-4 font-semibold">
                Destination: <span class="font-normal text-gray-800">${route.endLocation}</span>
            </p>
            <p class="mb-4 font-semibold">
                Distance: <span class="font-normal text-gray-800">${route.distanceKm} km</span>
            </p>
            <p class="mb-4 font-semibold">
                Estimated Time: <span class="font-normal text-gray-800">
                    <c:set var="et" value="${route.estimatedTime}" />
                    <c:set var="h" value="${fn:substringBefore(et / 60, '.')}" />
                    <c:set var="m" value="${et % 60}" />
                    <c:choose>
                        <c:when test="${h > 0 && m > 0}">
                            ${h}h${m}m
                        </c:when>
                        <c:when test="${h > 0}">
                            ${h}h
                        </c:when>
                        <c:otherwise>
                            ${m}m
                        </c:otherwise>
                    </c:choose>
                </span>
            </p>
            <div class="bg-yellow-100 border border-yellow-200 text-yellow-700 rounded-lg p-4 mb-12 flex items-start gap-2">
                <i class="fas fa-exclamation-triangle mt-0.5"></i>
                <span>This route is linked to existing trips. Deleting it may affect trip data.</span>
            </div>

            <div class="flex justify-end gap-4">
                <a href="${pageContext.servletContext.contextPath}/admin/routes">
                    <button type="button" class="px-8 py-3 rounded-lg bg-gray-300 text-gray-800 font-semibold hover:bg-gray-400">Cancel</button>
                </a>
                <button type="submit" class="px-8 py-3 rounded-lg text-white font-semibold" style="background-color: #EF5222;">Delete</button>

            </div>
        </div>
    </form>
</body>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>
