<%-- 
    Document   : cancel-ticket
    Created on : Jun 13, 2025, 8:44:18 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>


<body class="bg-[#fff6f3] min-h-screen">

    <div class="max-w-6xl mx-auto py-8 px-4">

        <!-- Header -->
        <div class="w-full bg-[#f3f3f5] py-2">
            <h1 class="text-2xl font-bold text-[#ef5222] text-center">Cancel Order</h1>
        </div>

        <!-- Order Details -->
        <div class="p-6 bg-white rounded-xl shadow-md mt-4">
            <h2 class="text-lg font-bold text-gray-800">Order ID: #${invoice.invoiceCode}</h2>
            <div class="mt-4 text-gray-600">
                <p><span class="font-semibold">Customer:</span> ${invoice.customerName}</p>
                <p><span class="font-semibold">Date:</span> ${invoice.paidAt}</p>
                <p><span class="font-semibold">Total Amount:</span> ${invoice.invoiceTotalAmount}</p>
                <p><span class="font-semibold">Payment Status:</span> ${invoice.invoiceStatus}</p>
            </div>

            <div class="my-6">
                <h3 class="text-lg font-semibold text-gray-800">Order Items:</h3>
                <!-- List order items here -->
            </div>

            <!-- Cancellation Reason -->
            <form action="${pageContext.request.contextPath}/ticket-management" method="post">
                
                <input type="hidden" name="action" value="cancel" />
                <div class="my-6">
                    <label for="reason" class="block text-gray-800 font-medium mb-2">Reason for Cancellation</label>
                    <textarea id="reason" name="reason" rows="4" class="w-full border rounded-xl p-4 text-gray-800" placeholder="Provide a reason for cancellation..."></textarea>
                </div>

                <!-- Hidden fields to pass invoice details -->
                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />
                <input type="hidden" name="invoiceCode" value="${invoice.invoiceCode}" />
                <input type="hidden" name="customerName" value="${invoice.customerName}" />

                <!-- Action Buttons -->
                <div class="mt-6 flex justify-end gap-4">
                    <button type="button" onclick="window.history.back();" class="px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">
                        Cancel
                    </button>
                    <button type="submit" class="px-6 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition">
                        Confirm Cancellation
                    </button>
                </div>
            </form>
        </div>

    </div>
<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/footer.jsp" %>