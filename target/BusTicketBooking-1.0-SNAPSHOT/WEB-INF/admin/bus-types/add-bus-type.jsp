<%-- 
    Document   : add-bus-type
    Created on : Jun 15, 2025, 1:53:45 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
  <div class="mt-10">
    <!-- Heading -->
    <h1 class="text-3xl font-bold text-[#EF5222] mb-6">
      Create Bus Type
    </h1>

    <!-- Form Card -->
    <div class="bg-white border border-[#EF5222] rounded-2xl shadow-lg p-8">
      <form action="#" method="post" class="space-y-6">
        <!-- Bus Type ID (read-only) -->
        <div>
          <label for="bus-type-id" class="block text-gray-800 font-medium mb-2">
            Bus Type ID
          </label>
          <input
            id="bus-type-id"
            name="id"
            type="text"
            value="BT8710"
            disabled
            class="w-full bg-gray-100 border border-gray-300 rounded-xl px-5 py-4 text-gray-700 cursor-not-allowed"
          />
        </div>

        <!-- Name -->
        <div>
          <label for="bus-type-name" class="block text-gray-800 font-medium mb-2">
            Name
          </label>
          <input
            id="bus-type-name"
            name="name"
            type="text"
            placeholder="Enter bus type name"
            required
            class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
          />
        </div>

        <!-- Description -->
        <div>
          <label for="bus-type-desc" class="block text-gray-800 font-medium mb-2">
            Description
          </label>
          <textarea
            id="bus-type-desc"
            name="description"
            placeholder="Optional description..."
            rows="4"
            class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring resize-none"
          ></textarea>
        </div>

        <!-- Action Buttons -->
        <div class="flex justify-end space-x-4 mt-8">
          <button
            type="button"
            onclick="history.back()"
            class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition"
          >
            Create
          </button>
        </div>
      </form>
    </div>
  </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>