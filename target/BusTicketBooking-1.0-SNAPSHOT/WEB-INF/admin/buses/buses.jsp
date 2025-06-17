<%-- 
    Document   : buses
    Created on : Jun 11, 2025, 1:31:40 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-gray-50">
  <div class="mt-10 p-6 bg-white rounded-2xl shadow-lg">
    <!-- Header + Create Button -->
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-3xl font-bold text-[#EF5222]">Manage Bus Fleet</h1>
      <a href="${pageContext.servletContext.contextPath}/admin/buses?add"><button class="px-4 py-2 bg-[#EF5222] text-white rounded-lg hover:bg-opacity-90 flex items-center gap-1">
        <i class="fas fa-plus"></i>
        Create New Bus
          </button></a>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
      <table class="min-w-full bg-white rounded-lg overflow-hidden">
        <thead class="bg-[#FFF3EB]">
          <tr>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Bus Code</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Plate Number</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Type</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Capacity</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Status</th>
            <th class="text-left text-[#EF5222] font-medium px-6 py-3">Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Row 1 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BUS001</td>
            <td class="px-6 py-4">51F-123.45</td>
            <td class="px-6 py-4">Seat</td>
            <td class="px-6 py-4">40</td>
            <td class="px-6 py-4">
              <span class="px-2 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                Active
              </span>
            </td>
            <td class="px-6 py-4 space-x-4">
              <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=1"><button class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 2 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BUS002</td>
            <td class="px-6 py-4">65B-678.90</td>
            <td class="px-6 py-4">Limousine</td>
            <td class="px-6 py-4">12</td>
            <td class="px-6 py-4">
              <span class="px-2 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                Inactive
              </span>
            </td>
            <td class="px-6 py-4 space-x-4">
              <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=1"><button class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 3 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BUS003</td>
            <td class="px-6 py-4">79C-999.99</td>
            <td class="px-6 py-4">Bunk</td>
            <td class="px-6 py-4">44</td>
            <td class="px-6 py-4">
              <span class="px-2 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                Active
              </span>
            </td>
            <td class="px-6 py-4 space-x-4">
              <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=1"><button class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 4 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BUS004</td>
            <td class="px-6 py-4">50D-888.88</td>
            <td class="px-6 py-4">Seat</td>
            <td class="px-6 py-4">34</td>
            <td class="px-6 py-4">
              <span class="px-2 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                Inactive
              </span>
            </td>
            <td class="px-6 py-4 space-x-4">
              <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=1"><button class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
          <!-- Row 5 -->
          <tr class="border-b last:border-none">
            <td class="px-6 py-4">BUS005</td>
            <td class="px-6 py-4">60A-456.78</td>
            <td class="px-6 py-4">Limousine</td>
            <td class="px-6 py-4">16</td>
            <td class="px-6 py-4">
              <span class="px-2 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                Active
              </span>
            </td>
            <td class="px-6 py-4 space-x-4">
              <button class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 text-sm">
                <i class="fas fa-eye"></i> View
              </button>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?editId=1"><button class="inline-flex items-center gap-1 text-yellow-600 hover:text-yellow-800 text-sm">
                <i class="fas fa-edit"></i> Edit
                  </button></a>
              <a href="${pageContext.servletContext.contextPath}/admin/buses?delete=1"><button class="inline-flex items-center gap-1 text-red-600 hover:text-red-800 text-sm">
                <i class="fas fa-trash"></i> Delete
                  </button></a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center mt-6 space-x-2">
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border bg-[#EF5222] text-white">
        1
      </button>
    </div>
  </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>