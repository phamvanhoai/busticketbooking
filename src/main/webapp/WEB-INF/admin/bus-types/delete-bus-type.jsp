<%-- 
    Document   : delete-bus-type
    Created on : Jun 15, 2025, 1:54:17 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<body class="bg-gray-50 min-h-screen p-6">
  <div class="mt-10">
    <!-- Heading -->
    <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Delete Bus Type</h1>

    <!-- Card -->
    <div class="bg-white border border-red-200 rounded-2xl shadow-lg p-8">
      <!-- Details -->
      <div class="space-y-3 text-gray-800">
        <p><span class="font-medium">Bus Type ID:</span> ${busType.busTypeId}</p>
        <p><span class="font-medium">Name:</span> ${busType.busTypeName}</p>
        <p><span class="font-medium">Description:</span> ${busType.busTypeDescription}</p>
      </div>

      <!-- Warning -->
      <div class="mt-6 p-4 bg-yellow-100 rounded-lg flex items-center text-yellow-800">
        <i class="fas fa-exclamation-triangle mr-2"></i>
        <span>Deleting this bus type will remove all its seat configurations.</span>
      </div>

      <!-- Actions -->
      <div class="flex justify-end space-x-4 mt-8">
        <button type="button" onclick="history.back()"
                class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition">
          Cancel
        </button>
        <form method="post" action="${pageContext.request.contextPath}/admin/bus-types" class="inline">
          <input type="hidden" name="action" value="delete" />
          <input type="hidden" name="id" value="${busType.busTypeId}" />
          <button type="submit"
                  class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition">
            Delete
          </button>
        </form>
      </div>
    </div>
  </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>