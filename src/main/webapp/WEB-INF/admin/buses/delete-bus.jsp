<%-- 
    Document   : delete-bus
    Created on : Jun 11, 2025, 1:33:06 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <!-- Heading -->
        <h1 class="text-3xl font-bold text-orange-600 mb-8">Delete Bus</h1>

        <!-- Details -->
        <div class="space-y-3 text-gray-800">
            <p><span class="font-medium">Bus Code:</span> ${bus.busCode}</p>
            <p><span class="font-medium">Plate Number:</span> ${bus.plateNumber}</p>
            <p><span class="font-medium">Vehicle Type:</span> ${bus.busTypeName}</p>
            <p><span class="font-medium">Capacity:</span> ${bus.capacity} seats</p>
            <p><span class="font-medium">Status:</span> ${bus.busStatus}</p>
        </div>

        <!-- Warning -->
        <div class="mt-6 p-4 bg-yellow-100 rounded-lg flex items-center text-yellow-800">
            <i class="fas fa-exclamation-triangle mr-2"></i>
            <span>Deleting this bus may affect trip data linked to it.</span>
        </div>

        <!-- Actions -->
        <div class="flex justify-end space-x-4 mt-8">
            <button
                type="button"
                onclick="history.back()"
                class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition"
                >
                Cancel
            </button>

            <!-- Form to submit the delete request -->
            <form action="${pageContext.request.contextPath}/admin/buses" method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="busId" value="${bus.busId}"/>
                <button
                    type="submit"
                    class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition"
                    >
                    Delete
                </button>
            </form>
        </div>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>