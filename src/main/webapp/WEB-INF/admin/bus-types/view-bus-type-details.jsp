<%-- 
    Document   : view-bus-type-details
    Created on : Jun 25, 2025, 11:07:04 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50 min-h-screen p-6">
    <div class="bg-white rounded-2xl shadow-lg p-8">

        <!-- Heading -->
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Bus Type Details</h1>

        <!-- Basic Info -->
        <div class="space-y-4 text-gray-800">
            <p><span class="font-semibold">ID:</span> ${busType.busTypeId}</p>
            <p><span class="font-semibold">Name:</span> ${busType.busTypeName}</p>
            <p><span class="font-semibold">Description:</span> ${busType.busTypeDescription}</p>
        </div>

        <hr class="my-6"/>

        <!-- Configuration -->
        <div class="grid grid-cols-2 gap-6 text-gray-800">
            <div>
                <h2 class="font-semibold mb-2">Downstairs Configuration</h2>
                <ul class="list-disc list-inside">
                    <li>Rows: ${busType.rowsDown}</li>
                    <li>Columns: ${busType.colsDown}</li>
                    <li>Prefix: ${busType.prefixDown}</li>
                </ul>
            </div>
            <div>
                <h2 class="font-semibold mb-2">Upstairs Configuration</h2>
                <ul class="list-disc list-inside">
                    <li>Rows: ${busType.rowsUp}</li>
                    <li>Columns: ${busType.colsUp}</li>
                    <li>Prefix: ${busType.prefixUp}</li>
                </ul>
            </div>
        </div>

        
        <!-- Seat Grids Side by Side -->
        <c:if test="${not empty seatsDown or not empty seatsUp}">
            <hr class="my-6"/>
            <div class="grid grid-cols-2 gap-6 text-gray-800">
                <!-- Downstairs -->
                <div>
                    <h2 class="font-semibold mb-2 text-gray-800">Downstairs Seats</h2>
                    <div class="flex space-x-8 mb-6">
                        <c:forEach var="col" begin="1" end="${busType.colsDown}">
                            <div class="space-y-4">
                                <c:forEach var="row" begin="1" end="${busType.rowsDown}">
                                    <c:set var="code" value="" />
                                    <c:forEach var="seat" items="${seatsDown}">
                                        <c:if test="${seat.row == row && seat.col == col}">
                                            <c:set var="code" value="${seat.code}" />
                                        </c:if>
                                    </c:forEach>
                                    <div class="relative w-12 h-12">
                                        <c:choose>
                                            <c:when test="${not empty code}">
                                                <img src="${pageContext.request.contextPath}/assets/images/icons/seat_active.svg" alt="Seat ${code}" class="w-full h-full" />
                                                <span class="absolute inset-0 flex items-center justify-center text-sm font-medium text-blue-800">
                                                    ${code}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Upstairs -->
                <div>
                    <h2 class="font-semibold mb-2 text-gray-800">Upstairs Seats</h2>
                    <div class="flex space-x-8 mb-6">
                        <c:forEach var="col" begin="1" end="${busType.colsUp}">
                            <div class="space-y-4">
                                <c:forEach var="row" begin="1" end="${busType.rowsUp}">
                                    <c:set var="codeUp" value="" />
                                    <c:forEach var="seat" items="${seatsUp}">
                                        <c:if test="${seat.row == row && seat.col == col}">
                                            <c:set var="codeUp" value="${seat.code}" />
                                        </c:if>
                                    </c:forEach>
                                    <div class="relative w-12 h-12">
                                        <c:choose>
                                            <c:when test="${not empty codeUp}">
                                                <img src="${pageContext.request.contextPath}/assets/images/icons/seat_active.svg" alt="Seat ${codeUp}" class="w-full h-full" />
                                                <span class="absolute inset-0 flex items-center justify-center text-sm font-medium text-blue-800">
                                                    ${codeUp}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- No seats fallback -->
        <c:if test="${empty seatsDown and empty seatsUp}">
            <p class="text-gray-500 italic">No seat configuration available.</p>
        </c:if>

        <!-- Actions -->
        <div class="flex justify-end gap-4 mt-8">
            <a href="${pageContext.request.contextPath}/admin/bus-types" class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition">Back</a>
            <a href="${pageContext.request.contextPath}/admin/bus-types?editId=${busType.busTypeId}" class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition">Edit</a>
            <a href="${pageContext.request.contextPath}/admin/bus-types?delete=${busType.busTypeId}" class="px-6 py-3 bg-red-500 text-white rounded-xl hover:bg-opacity-90 transition">Delete</a>
        </div>

    </div>

    <%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
