<%-- 
    Document   : edit-location
    Created on : Jun 20, 2025, 2:52:53 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-[#f3f3f5] min-h-screen p-6">

    <div class="bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-boldtext-[#EF5222] text-gray-800 mb-6">Edit Location</h1>
        <form class="space-y-6">
            <!-- Location Name -->
            <div>
                <label for="loc-name" class="block text-sm font-medium text-gray-700 mb-1">Location Name</label>
                <input
                    type="text"
                    id="loc-name"
                    name="name"
                    value="Downtown Station"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    required
                    />
            </div>
            <!-- Address -->
            <div>
                <label for="loc-address" class="block text-sm font-medium text-gray-700 mb-1">Address</label>
                <input
                    type="text"
                    id="loc-address"
                    name="address"
                    value="123 Main St, District 1"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    required
                    />
            </div>
            <!-- City / State -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="loc-city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                    <input
                        type="text"
                        id="loc-city"
                        name="city"
                        value="Ho Chi Minh City"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required
                        />
                </div>
                <div>
                    <label for="loc-state" class="block text-sm font-medium text-gray-700 mb-1">State/Province</label>
                    <input
                        type="text"
                        id="loc-state"
                        name="state"
                        value="HCMC"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        />
                </div>
            </div>
            <!-- Postal Code -->
            <div>
                <label for="loc-zip" class="block text-sm font-medium text-gray-700 mb-1">Postal Code</label>
                <input
                    type="text"
                    id="loc-zip"
                    name="postal"
                    value="700000"
                    class="w-1/2 border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    />
            </div>
            <!-- Description -->
            <div>
                <label for="loc-desc" class="block text-sm font-medium text-gray-700 mb-1">Description (optional)</label>
                <textarea
                    id="loc-desc"
                    name="description"
                    rows="3"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none"
                    >Main drop-off and pick-up point in the city center.</textarea>
            </div>
            <!-- Action Buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.servletContext.contextPath}/admin/locations"><button
                        type="button"
                        class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-6 py-2 rounded-lg transition"
                        >
                        Cancel
                    </button></a>
                <button
                    type="submit"
                    class="bg-orange-500 hover:bg-orange-600 text-white font-medium px-6 py-2 rounded-lg transition"
                    >
                    Update Location
                </button>
            </div>
        </form>
    </div>

    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>