<%-- 
    Document   : customer-trip
    Created on : Jun 14, 2025, 12:16:39 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>

<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/staff/support-customer-trip"/>

<c:if test="${not empty param.search}">
    <c:set var="baseUrl"
           value="${baseUrl}?search=${fn:escapeXml(param.search)}"/>
</c:if>
<c:if test="${param.status ne 'All'}">
    <c:set var="baseUrl"
           value="${baseUrl}${param.search!=null?'&':'?'}status=${fn:escapeXml(param.status)}"/>
</c:if>
<c:if test="${not empty param.page}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.search!=null||param.status ne 'All')?'&':'?'}page=${fn:escapeXml(param.page)}"/>
</c:if>

<body class="bg-[#f9fafb]">
    <div class="p-6 space-y-6">

        <h2 class="text-2xl font-bold text-orange-600">Manage Invoice Cancel Requests</h2>

        <!-- Search & Filter -->
        <form method="get"
              action="${pageContext.request.contextPath}/staff/support-customer-trip"
              class="flex flex-wrap items-center gap-4 mb-4">
            <div class="flex flex-1 max-w-md">
                <input
                    type="text"
                    name="search"
                    value="${fn:escapeXml(search)}"
                    placeholder="Search by Request ID, Invoice Code, or Customer"
                    class="flex-1 border border-gray-300 rounded-l-lg px-4 py-2 focus:outline-none"/>
                <button type="submit"
                        class="bg-orange-500 hover:bg-orange-600 text-white px-4 rounded-r-lg">
                    Search
                </button>
            </div>
            <select name="status"
                    class="border border-gray-300 rounded-lg px-4 py-2">
                <option value="All"      ${status=='All'      ? 'selected':''}>All Statuses</option>
                <option value="Pending"  ${status=='Pending'  ? 'selected':''}>Pending</option>
                <option value="Approved" ${status=='Approved' ? 'selected':''}>Approved</option>
                <option value="Rejected" ${status=='Rejected' ? 'selected':''}>Rejected</option>
            </select>
        </form>

        <!-- Table -->
        <div class="bg-white shadow-md rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Request ID</th>
                        <th class="px-4 py-2">Invoice ID</th>
                        <th class="px-4 py-2">Invoice Code</th>
                        <th class="px-4 py-2">Customer</th>
                        <th class="px-4 py-2">Request Date</th>
                        <th class="px-4 py-2">Reason</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${requests}">
                        <tr class="border-b hover:bg-gray-50">
                            <td class="px-4 py-2">${r.requestId}</td>
                            <td class="px-4 py-2">${r.invoiceId}</td>
                            <td class="px-4 py-2">${r.invoiceCode}</td>
                            <td class="px-4 py-2">${r.customerName}</td>
                            <td class="px-4 py-2">
                                <fmt:formatDate value="${r.requestDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td class="px-4 py-2">${r.cancelReason}</td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${r.requestStatus=='Pending'}">
                                        <span class="inline-block px-3 py-1 rounded-full text-sm bg-yellow-100 text-yellow-700">Pending</span>
                                    </c:when>
                                    <c:when test="${r.requestStatus=='Approved'}">
                                        <span class="inline-block px-3 py-1 rounded-full text-sm bg-green-100 text-green-700">Approved</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-block px-3 py-1 rounded-full text-sm bg-red-100 text-red-700">Rejected</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-2">
                                <c:choose>
                                    <c:when test="${r.requestStatus == 'Pending'}">
                                        <div class="flex items-center gap-2">
                                            <form action="${pageContext.request.contextPath}/staff/support-customer-trip"
                                                  method="post" class="inline">
                                                <input type="hidden" name="requestId" value="${r.requestId}"/>
                                                <input type="hidden" name="search"    value="${fn:escapeXml(search)}"/>
                                                <input type="hidden" name="status"    value="${status}"/>
                                                <input type="hidden" name="page"      value="${currentPage}"/>
                                                <button name="action" value="approve"
                                                        class="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded-lg mr-2">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/staff/support-customer-trip"
                                                  method="post" class="inline">
                                                <input type="hidden" name="requestId" value="${r.requestId}"/>
                                                <input type="hidden" name="search"    value="${fn:escapeXml(search)}"/>
                                                <input type="hidden" name="status"    value="${status}"/>
                                                <input type="hidden" name="page"      value="${currentPage}"/>
                                                <button name="action" value="reject"
                                                        class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded-lg">Reject</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-gray-500">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-6">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>

    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>