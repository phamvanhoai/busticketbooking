<%-- 
    Document   : routes
    Created on : Jun 11, 2025, 1:33:50 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
    <!-- Header + Create Button -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-3xl font-bold text-orange-600">Manage Routes</h2>
      <a href="${pageContext.servletContext.contextPath}/admin/routes?add"><button class="bg-[#EF5222] hover:bg-orange-600 text-white px-4 py-2 rounded-lg flex items-center gap-2">
        <i class="fas fa-plus"></i>
        Create New Route
          </button></a>
    </div>

    <div class="overflow-x-auto">
      <table class="min-w-full border text-left">
        <thead class="bg-orange-100 text-[#EF5222]">
          <tr>
            <th class="py-2 px-4">Route ID</th>
            <th class="py-2 px-4">Origin</th>
            <th class="py-2 px-4">Destination</th>
            <th class="py-2 px-4">Estimated Time</th>
            <th class="py-2 px-4">Distance</th>
            <th class="py-2 px-4">Vehicle Type</th>
            <th class="py-2 px-4">Plate Number</th>
            <th class="py-2 px-4">Status</th>
            <th class="py-2 px-4">Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Sample Row 1 -->
          <tr class="border-t hover:bg-gray-50">
            <td class="py-2 px-4">ROUTE001</td>
            <td class="py-2 px-4">Ho Chi Minh City</td>
            <td class="py-2 px-4">Can Tho</td>
            <td class="py-2 px-4">180 mins</td>
            <td class="py-2 px-4">170km</td>
            <td class="py-2 px-4">Limousine</td>
            <td class="py-2 px-4">51A-123.45</td>
            <td class="py-2 px-4">
              <span class="px-3 py-1 text-sm rounded-full bg-green-100 text-green-600">
                Active
              </span>
            </td>
            <td class="py-2 px-4">
              <div class="flex items-center gap-4">
                <button class="flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                  <i class="fas fa-eye"></i> View
                </button>
                <a href="${pageContext.servletContext.contextPath}/admin/routes?editId=1"><button class="flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                  <i class="fas fa-edit"></i> Edit
                    </button></a>
                <a href="${pageContext.servletContext.contextPath}/admin/routes?delete=1"><button class="flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                  <i class="fas fa-trash"></i> Delete
                    </button></a>
              </div>
            </td>
          </tr>
          <!-- Sample Row 2 -->
          <tr class="border-t hover:bg-gray-50">
            <td class="py-2 px-4">ROUTE002</td>
            <td class="py-2 px-4">Can Tho</td>
            <td class="py-2 px-4">Chau Doc</td>
            <td class="py-2 px-4">120 mins</td>
            <td class="py-2 px-4">90km</td>
            <td class="py-2 px-4">Seat</td>
            <td class="py-2 px-4">62B-456.78</td>
            <td class="py-2 px-4">
              <span class="px-3 py-1 text-sm rounded-full bg-red-100 text-red-600">
                Inactive
              </span>
            </td>
            <td class="py-2 px-4">
              <div class="flex items-center gap-4">
                <button class="flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                  <i class="fas fa-eye"></i> View
                </button>
                <a href="${pageContext.servletContext.contextPath}/admin/routes?editId=1"><button class="flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                  <i class="fas fa-edit"></i> Edit
                    </button></a>
                <a href="${pageContext.servletContext.contextPath}/admin/routes?delete=1"><button class="flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                  <i class="fas fa-trash"></i> Delete
                    </button></a>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center gap-2 mt-6">
      <button
        class="px-4 py-2 rounded-lg border bg-[#EF5222] text-white"
      >
        1
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        2
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        3
      </button>
      <button
        class="px-4 py-2 rounded-lg border bg-white text-orange-600 border-orange-300 hover:bg-orange-100"
      >
        4
      </button>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>