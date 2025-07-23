<%-- 
    Document   : support-incident-details
    Created on : Jul 24, 2025, 2:10:54 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

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
                    <p><strong>Driver:</strong> <c:out value="${staffDAO.getDriverNameById(incident.driverId)}"/></p>
                    <p><strong>Trip:</strong> <c:out value="${incident.tripId != null ? staffDAO.getTripNameById(incident.tripId) : 'N/A'}"/></p>
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
                    <p><strong>Staff ID:</strong> ${incident.staffId != null ? incident.staffId : 'N/A'}</p>
                    <p><strong>Staff Name:</strong> ${incident.staffId != null ? staffDAO.getStaffNameById(incident.staffId) : 'N/A'}</p>
                    <p><strong>Incident Note:</strong> ${incident.incidentNote != null ? incident.incidentNote : 'N/A'}</p>
                </div>
            </div>

            <div class="mt-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Update Incident</h3>
                <form action="${pageContext.request.contextPath}/staff/incidents" method="post" class="space-y-4">
                    <input type="hidden" name="action" value="updateIncident">
                    <input type="hidden" name="incidentId" value="${incident.incidentId}">
                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                        <select id="status" name="status" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                            <option value="Pending" ${incident.status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Resolved" ${incident.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                            <option value="Escalated" ${incident.status == 'Escalated' ? 'selected' : ''}>Escalated</option>
                        </select>
                    </div>
                    <div>
                        <label for="incidentNote" class="block text-sm font-medium text-gray-700 mb-2">Incident Note</label>
                        <textarea id="incidentNote" name="incidentNote" rows="4" placeholder="Add note..." class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none">${incident.incidentNote != null ? incident.incidentNote : ''}</textarea>
                    </div>
                    <div class="flex justify-end gap-4">
                        <a href="${pageContext.request.contextPath}/staff/incidents" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">Back to List</a>
                        <button type="submit" onclick="return confirm('Are you sure you want to update this incident?')" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                            Update Incident
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>