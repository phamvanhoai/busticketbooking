<%-- 
    Document   : driver-license
    Created on : Jun 19, 2025, 11:04:59 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body class="bg-gray-100 min-h-screen p-6">
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-orange-600 mb-6">Driver’s License Information</h1>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-300 text-red-800 px-4 py-3 rounded-lg mb-6">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty license}">
            <div class="space-y-6 text-gray-800">
                <!-- License Number -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">License Number</label>
                    <p class="w-full border border-gray-300 rounded-lg px-4 py-2 bg-gray-50">${license.licenseNumber}</p>
                </div>
                <!-- License Class -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">License Class</label>
                    <p class="w-full border border-gray-300 rounded-lg px-4 py-2 bg-gray-50">${license.licenseClass}</p>
                </div>
                <!-- Hire Date -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Hire Date</label>
                    <p class="w-full border border-gray-300 rounded-lg px-4 py-2 bg-gray-50">${license.hireDate}</p>
                </div>
                <!-- Driver Status -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Driver Status</label>
                    <p class="w-full border border-gray-300 rounded-lg px-4 py-2 bg-gray-50">${license.driverStatus}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${empty license and empty error}">
            <div class="bg-yellow-100 border border-yellow-300 text-yellow-800 px-4 py-3 rounded-lg">
                No license information available.
            </div>
        </c:if>
    </div>

    <!-- License History -->
    <div class="mt-10 px-4">
        <h1 class="text-3xl font-bold text-orange-600">License Change History</h1><br>
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">History ID</th>
                        <th class="px-4 py-2">Old License Class</th>
                        <th class="px-4 py-2">New License Class</th>
                        <th class="px-4 py-2">Reason</th>
                        <th class="px-4 py-2">Changed By</th>
                        <th class="px-4 py-2">Changed At</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Duyệt qua danh sách lịch sử thay đổi giấy phép -->
                    <c:forEach var="history" items="${licenseHistory}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2">${history.id}</td>
                            <td class="px-4 py-2">${history.oldLicenseClass != null ? history.oldLicenseClass : 'N/A'}</td>
                            <td class="px-4 py-2">${history.newLicenseClass != null ? history.newLicenseClass : 'N/A'}</td>
                            <td class="px-4 py-2">${history.reason != null ? history.reason : 'N/A'}</td>
                            <td class="px-4 py-2">${history.userName != null ? history.userName : 'N/A'}</td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${history.changedAt != null}">
                                        <fmt:formatDate value="${history.changedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <!-- No data case if list is empty -->
                    <c:if test="${empty licenseHistory}">
                        <tr>
                            <td colspan="6" class="py-4 px-4 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <span class="text-sm text-gray-500 font-medium">
                                        No license change history found.
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
