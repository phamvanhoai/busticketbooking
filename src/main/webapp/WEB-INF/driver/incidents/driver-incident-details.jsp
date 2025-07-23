<%-- 
    Document   : driver-incident-details
    Created on : Jul 24, 2025, 1:37:08 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <h1 class="text-3xl font-bold text-orange-600">Incident Details</h1>

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
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Incident ID: ${incident.incidentId}</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <p><strong>Driver:</strong> <c:out value="${driverDAO.getDriverNameById(incident.driverId)}"/></p>
                    <p><strong>Trip:</strong> <c:out value="${incident.tripId != null ? driverDAO.getTripNameById(incident.tripId) : 'N/A'}"/></p>
                    <p><strong>Description:</strong> ${incident.description}</p>
                    <p><strong>Location:</strong> ${incident.location != null ? incident.location : 'N/A'}</p>
                    <p><strong>Incident Type:</strong> ${incident.incidentType}</p>
                </div>
                <div>
                    <p><strong>Status:</strong> 
                        <c:choose>
                            <c:when test="${incident.status == 'Pending'}">
                                <span class="px-3 py-1 text-sm rounded-full font-semibold bg-yellow-100 text-yellow-700">
                                    ${incident.status}
                                </span>
                            </c:when>
                            <c:when test="${incident.status == 'Resolved'}">
                                <span class="px-3 py-1 text-sm rounded-full font-semibold bg-green-100 text-green-700">
                                    ${incident.status}
                                </span>
                            </c:when>
                            <c:when test="${incident.status == 'Escalated'}">
                                <span class="px-3 py-1 text-sm rounded-full font-semibold bg-red-100 text-red-600">
                                    ${incident.status}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="px-3 py-1 text-sm rounded-full font-semibold bg-gray-100 text-gray-700">
                                    ${incident.status}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Created At:</strong> <fmt:formatDate value="${incident.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
                    <p><strong>Updated At:</strong> ${incident.updatedAt != null ? incident.updatedAt : 'N/A'}</p>
                    <p><strong>Photo:</strong> 
                        <c:if test="${not empty incident.photoUrl}">
                            <a href="${pageContext.request.contextPath}${incident.photoUrl}" target="_blank" class="text-blue-600 hover:underline">View Photo</a>
                        </c:if>
                        <c:if test="${empty incident.photoUrl}">N/A</c:if>
                    </p>
                    <p><strong>Staff:</strong> <c:out value="${incident.staffId != null ? driverDAO.getStaffNameById(incident.staffId) : 'N/A'}"/></p>
                    <p><strong>Incident Note:</strong> ${incident.incidentNote != null ? incident.incidentNote : 'N/A'}</p>
                </div>
            </div>
            <div class="mt-6 flex justify-end">
                <a href="${pageContext.request.contextPath}/driver/incidents" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">Back to List</a>
            </div>
        </div>
    </div>

<%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>