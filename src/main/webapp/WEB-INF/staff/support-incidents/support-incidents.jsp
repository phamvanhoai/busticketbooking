<%-- 
    Document   : support-incidents
    Created on : Jul 24, 2025, 1:34:53 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-[#fff6f3] p-6">
    <div class="space-y-6">
        <h1 class="text-3xl font-bold text-orange-600">Support Incidents</h1>

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

        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-600">
                    <tr>
                        <th class="px-4 py-2">Report ID</th>
                        <th class="px-4 py-2">Driver ID</th>
                        <th class="px-4 py-2">Incident Type</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Created At</th>
                        <th class="px-4 py-2">Updated At</th>
                        <th class="px-4 py-2">Support Name</th>
                        <th class="px-4 py-2">Incident Note</th>
                        <th class="px-4 py-2">Details</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="incident" items="${incidents}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2">${incident.incidentId}</td>
                            <td class="px-4 py-2">${staffDAO.getDriverNameById(incident.driverId)}</td>
                            <td class="px-4 py-2">${incident.incidentType}</td>
                            <td class="px-4 py-2">
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
                            </td>
                            <td class="px-4 py-2"><fmt:formatDate value="${incident.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            <td class="px-4 py-2">${incident.updatedAt != null ? incident.updatedAt : 'N/A'}</td>
                            <td class="px-4 py-2"><c:out value="${incident.staffId != null ? staffDAO.getStaffNameById(incident.staffId) : 'N/A'}"/></td>
                            <td class="px-4 py-2">${incident.incidentNote != null ? incident.incidentNote : 'N/A'}</td>
                            <td class="px-4 py-2">
                                <a href="${pageContext.request.contextPath}/staff/incidents?detail=${incident.incidentId}" class="text-blue-600 hover:underline">View Details</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty incidents}">
                        <tr>
                            <td colspan="13" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">
                                        No incident reports found.
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 space-x-2">
            <fbus:adminpagination 
                currentPage="${currentPage}" 
                totalPages="${totalPages}" 
                url="${baseUrl}" />
        </div>
    </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>