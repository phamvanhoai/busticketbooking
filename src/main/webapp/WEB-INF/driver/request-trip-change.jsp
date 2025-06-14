<%-- 
    Document   : request-trip-change
    Created on : Jun 13, 2025, 10:49:13 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="mt-10">
        <!-- Heading -->
        <h1 class="text-3xl font-bold text-orange-600 mb-6">
            Request Trip Change
        </h1>

        <!-- Form Card -->
        <div class="bg-white border border-[#FFD8B5] rounded-2xl shadow-lg p-8">
            <form action="#" method="POST" class="space-y-6">
                <!-- Select Assigned Trip -->
                <div>
                    <label class="block text-gray-800 font-medium mb-2">
                        Select Assigned Trip
                    </label>
                    <select name="tripId" class="w-full border border-gray-300 rounded-xl px-5 py-4 bg-white focus:outline-none focus:ring">
                        <option value="" disabled selected>-- Choose Trip --</option>
                        <option value="TRIP001">Can Tho → Chau Doc</option>
                        <option value="TRIP002">HCM → Vung Tau</option>
                        <option value="TRIP003">Da Nang → Hue</option>
                    </select>
                </div>

                <!-- Reason for Change -->
                <div>
                    <label class="block text-gray-800 font-medium mb-2">
                        Reason for Change
                    </label>
                    <textarea
                        name="reason"
                        placeholder="Explain why you want to change this trip..."
                        rows="4"
                        class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring resize-none"
                        ></textarea>
                </div>

                <!-- Submit Button -->
                <button
                    type="submit"
                    class="w-full bg-[#EF5222] text-white font-medium rounded-xl px-5 py-4 hover:bg-opacity-90 transition"
                    >
                    Submit Request
                </button>
            </form>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
