<%-- 
    Document   : edit-bus
    Created on : Jun 11, 2025, 1:32:07 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Update Bus</h1>

        <!-- Hiển thị thông báo lỗi hoặc thành công -->
        <c:choose>
            <c:when test="${not empty sessionScope.error}">
                <div class="text-red-500">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:when>
            <c:when test="${not empty sessionScope.message}">
                <div class="text-green-500">${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:when>
        </c:choose>

        <form action="${pageContext.servletContext.contextPath}/admin/buses" method="post" class="space-y-6">
            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="busId" value="${bus.busId}"/>
            <!-- Bus Code (read-only) -->
            <div>
                <label for="bus-code" class="block text-gray-800 font-medium mb-2">Bus Code</label>
                <input
                    id="bus-code"
                    type="text"
                    name="busCode"
                    value="${bus.busCode}"
                    class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
                    />
            </div>

            <!-- Plate Number -->
            <div>
                <label for="bus-plate" class="block text-gray-800 font-medium mb-2">Plate Number</label>
                <input
                    id="bus-plate"
                    type="text"
                    name="plate"
                    value="${bus.plateNumber}"
                    class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
                    />
            </div>

            <!-- Bus Type -->
            <div>
                <label for="bus-type" class="block text-gray-800 font-medium mb-2">Bus Type</label>
                <select
                    id="bus-type"
                    name="type"
                    class="w-full border border-gray-300 rounded-xl px-5 py-4 bg-white focus:outline-none focus:ring"
                    >
                    <c:forEach var="type" items="${busTypes}">
                        <option value="${type.busTypeId}" ${bus.busTypeId == type.busTypeId ? 'selected' : ''}>
                            ${type.busTypeName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Capacity -->
            <div>
                <label for="bus-capacity" class="block text-gray-800 font-medium mb-2">Capacity</label>
                <input
                    id="bus-capacity"
                    type="number"
                    name="capacity"
                    value="${bus.capacity}"
                    class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
                    />
            </div>

            <!-- Status -->
            <div>
                <label for="bus-status" class="block text-gray-800 font-medium mb-2">Status</label>
                <select
                    id="bus-status"
                    name="status"
                    class="w-full border border-gray-300 rounded-xl px-5 py-4 bg-white focus:outline-none focus:ring"
                    >
                    <option value="Active" ${bus.busStatus == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${bus.busStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-end space-x-4 mt-8">
                <button
                    type="button"
                    onclick="window.location = '${pageContext.servletContext.contextPath}/admin/buses'"
                    class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition"
                    >
                    Cancel
                </button>
                <button
                    type="submit"
                    class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition"
                    >
                    Update
                </button>
            </div>
        </form>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>