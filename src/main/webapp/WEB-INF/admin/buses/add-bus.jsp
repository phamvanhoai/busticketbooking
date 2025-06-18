<%-- 
    Document   : add-bus
    Created on : Jun 11, 2025, 1:31:57 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
    <div class="mt-10 p-8 bg-white rounded-2xl shadow-lg border border-[#EF5222]">
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Create New Bus</h1>

        <!-- Display error messages if there are any -->
        <c:choose>
            <c:when test="${not empty message}">
                <div style="color: green;">${message}</div>
            </c:when>
            <c:when test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:when>
        </c:choose>

        <!-- form action trỏ về servlet xử lý POST -->
        <form action="${pageContext.servletContext.contextPath}/admin/buses" method="post" class="space-y-6">
            <input type="hidden" name="action" value="add"/>
            <!-- Bus Code -->
            <div>
                <label for="code" class="block mb-2 font-medium text-gray-800">Bus Code</label>
                <input
                    id="code"
                    name="busCode"
                    type="text"
                    "
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
                    />
            </div>
            <!-- Plate Number -->
            <div>
                <label for="plate" class="block mb-2 font-medium text-gray-800">Plate Number</label>
                <input
                    id="plate"
                    name="plateNumber"
                    type="text"
                    value="${param.plateNumber}"
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
                    />
            </div>
            <!-- Bus Type -->
            <div>
                <label for="type" class="block mb-2 font-medium text-gray-800">Bus Type</label>
                <select
                    id="type"
                    name="busTypeId"
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
                    >
                    <option value="" disabled ${empty param.busTypeId ? 'selected' : ''}>Select type</option>
                    <c:forEach var="type" items="${busTypes}">
                        <option value="${type.busTypeId}" ${param.busTypeId == type.busTypeId ? 'selected' : ''}>
                            ${type.busTypeName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <!-- Capacity -->
            <div>
                <label for="capacity" class="block mb-2 font-medium text-gray-800">Capacity</label>
                <input
                    id="capacity"
                    name="capacity"
                    type="number"
                    required
                    class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
                    />
            </div>
            <!-- Status -->
            <div>
                <label for="status" class="block mb-2 font-medium text-gray-800">Status</label>
                <select
                    id="busStatus"
                    name="busStatus"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:outline-none focus:ring"
                    >
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>
            <!-- Actions -->
            <div class="flex justify-end space-x-4 mt-6">
                <button
                    type="button"
                    onclick="window.location = '${pageContext.servletContext.contextPath}/admin/buses'"
                    class="px-6 py-3 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400"
                    >
                    Cancel
                </button>
                <button
                    type="submit"
                    class="px-6 py-3 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90"
                    >
                    Create
                </button>
            </div>
        </form>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>