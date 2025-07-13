<%-- 
    Document   : driver-trip
    Created on : Jun 14, 2025, 12:26:31 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/staff/support-driver-trip" />


<body class="bg-[#f9fafb]">
    <div class="p-6 space-y-6">
        <h2 class="text-3xl font-bold text-orange-600">Driver Cancel Trip Requests</h2>

        <!-- Table -->
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Request ID</th>
                        <th class="px-4 py-2">Driver</th>
                        <th class="px-4 py-2">Trip</th>
                        <th class="px-4 py-2">Reason</th>
                        <th class="px-4 py-2">Date</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${driverRequests}">
                        <tr class="border-b hover:bg-gray-50">
                            <td class="px-4 py-2">DRVREQ${req.requestId}</td>
                            <td class="px-4 py-2">${req.driverName}</td>
                            <td class="px-4 py-2">Trip ${req.tripId}</td>
                            <td class="px-4 py-2">${req.changeReason}</td>
                            <td class="px-4 py-2">
                                <fmt:formatDate value="${req.requestDate}" pattern="dd/MM/yyyy" />
                            </td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${req.requestStatus == 'Pending'}">
                                        <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-700">Pending</span>
                                    </c:when>
                                    <c:when test="${req.requestStatus == 'Approved'}">
                                        <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-700">Approved</span>
                                    </c:when>
                                    <c:when test="${req.requestStatus == 'Rejected'}">
                                        <span class="inline-block px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-700">Rejected</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td class="px-4 py-2">
                                <c:if test="${req.requestStatus == 'Pending'}">
                                    <form action="${pageContext.request.contextPath}/staff/support-driver-trip" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="approve" />
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <button type="submit" class="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded-lg mr-2">Approve</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/staff/support-driver-trip" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="reject" />
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <button type="submit" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded-lg">Reject</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- Pagination -->
        <div class="flex justify-center space-x-2 mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>

    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>