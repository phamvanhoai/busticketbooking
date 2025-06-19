<%-- 
    Document   : driver-license
    Created on : Jun 19, 2025, 11:04:59 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>


<body class="bg-gray-100 min-h-screen p-6">
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Update Driver’s License</h1>
        <form class="space-y-6">
            <!-- License Number -->
            <div>
                <label for="license-number" class="block text-sm font-semibold text-gray-700 mb-1">
                    License Number
                </label>
                <input
                    id="license-number"
                    type="text"
                    placeholder="e.g. 0123456789"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-orange-500"
                    />
            </div>
            <!-- License Class -->
            <div>
                <label for="license-type" class="block text-sm font-semibold text-gray-700 mb-1">
                    License Class
                </label>
                <select
                    id="license-type"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-orange-500"
                    >
                    <option value="" disabled selected>Select class</option>
                    <option value="A1">Class A1</option>
                    <option value="B2">Class B2</option>
                    <option value="C">Class C</option>
                    <option value="D">Class D</option>
                </select>
            </div>
            <!-- Issue & Expiry Dates -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div>
                    <label for="issue-date" class="block text-sm font-semibold text-gray-700 mb-1">
                        Issue Date
                    </label>
                    <input
                        id="issue-date"
                        type="date"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-orange-500"
                        />
                </div>
                <div>
                    <label for="expiry-date" class="block text-sm font-semibold text-gray-700 mb-1">
                        Expiry Date
                    </label>
                    <input
                        id="expiry-date"
                        type="date"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-orange-500"
                        />
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-end gap-4 mt-8">
                <button
                    type="submit"
                    class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition"
                    >
                    Save Changes
                </button>
            </div>
        </form>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
