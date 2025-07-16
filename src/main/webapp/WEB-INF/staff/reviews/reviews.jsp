<%-- 
    Document   : reviews
    Created on : Jul 16, 2025, 10:15:30 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>
<%@ include file="/WEB-INF/include/staff/staff-header.jsp" %>

<body class="bg-gray-50">
    <div class="mt-10 px-4">
        <!-- Header + Create Button -->
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-[#EF5222]">Invoice Reviews</h2>
        </div>

        <!-- Reviews Table -->
        <div class="overflow-x-auto bg-white rounded-xl shadow-md">
            <table class="min-w-full text-left table-auto">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="px-4 py-2">Review ID</th>
                        <th class="px-4 py-2">Invoice Code</th>
                        <th class="px-4 py-2">Route</th>
                        <th class="px-4 py-2">Rating</th>
                        <th class="px-4 py-2">Review Text</th>
                        <th class="px-4 py-2">Review Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="review" items="${reviews}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2">${review.reviewId}</td>
                            <td class="px-4 py-2">${review.invoiceCode}</td>
                            <td class="px-4 py-2">${review.route}</td> 
                            <td class="px-4 py-2">
                                <!-- Rating -->
                                <div class="flex items-center space-x-1">
                                    <c:forEach var="i" begin="1" end="5">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 <c:if test='${review.rating >= i}'>text-yellow-500</c:if>" fill="currentColor" viewBox="0 0 20 20">
                                                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
                                            </svg>
                                    </c:forEach>
                                </div>
                            </td>
                            <td class="px-4 py-2">${review.reviewText}</td>
                            <td class="px-4 py-2"><fmt:formatDate value="${review.createdAt}" pattern="dd-MM-yyyy" /></td>
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

    <%@ include file="/WEB-INF/include/staff/staff-footer.jsp" %>
