<%-- 
    Document   : bus-types
    Created on : Jun 15, 2025, 1:53:25 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="mt-10 p-6 bg-white rounded-2xl shadow-lg">
    <!-- Header + Create Button -->
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-3xl font-bold text-[#EF5222]">Manage Bus Types</h1>
      <a href="${pageContext.servletContext.contextPath}/admin/bus-types?add"><button
        type="button"
        class="px-4 py-2 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90 flex items-center gap-1"
      >
        <i class="fas fa-plus"></i>
        Create Bus Type
          </button></a>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
      <table class="min-w-full bg-white rounded-lg overflow-hidden">
        <thead class="bg-[#FFF3EB]">
          <tr>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Bus Type ID</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Name</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Description</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Row 1 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BT001</td>
            <td class="px-6 py-4">Seat</td>
            <td class="px-6 py-4">Standard seating configuration</td>
            <td class="px-6 py-4 space-x-4">
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?editId=1"><button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 2 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BT002</td>
            <td class="px-6 py-4">Bunk</td>
            <td class="px-6 py-4">Sleeping bunk layout</td>
            <td class="px-6 py-4 space-x-4">
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?editId=1"><button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 3 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BT003</td>
            <td class="px-6 py-4">Limousine</td>
            <td class="px-6 py-4">Luxury VIP bus</td>
            <td class="px-6 py-4 space-x-4">
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?editId=1"><button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/bus-types?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center mt-6">
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border bg-[#EF5222] text-white">
        1
      </button>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>