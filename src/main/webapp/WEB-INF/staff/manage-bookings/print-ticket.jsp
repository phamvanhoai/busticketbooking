<%-- 
    Document   : print-ticket
    Created on : Jun 22, 2025, 5:25:47 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Invoice ${bookingInfo.invoiceCode}</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            @media print {
                body {
                    margin: 10mm 10mm;
                    background: white !important;
                    color: #000 !important;
                    font-size: 12pt;
                    font-family: "Times New Roman", Times, serif !important;
                }
                .no-print {
                    display: none !important;
                }
                table {
                    width: 100% !important;
                    border-collapse: collapse !important;
                    font-size: 9pt !important;
                    font-family: "Times New Roman", Times, serif !important;
                    box-shadow: none !important;
                }
                th, td {
                    border: 1px solid #000 !important;
                    padding: 6px 10px !important;
                    white-space: normal !important;
                    word-break: break-word !important;
                    vertical-align: middle !important;
                    font-family: "Times New Roman", Times, serif !important;
                }
                tr:hover {
                    background-color: transparent !important;
                }
                .shadow, .bg-orange-50 {
                    box-shadow: none !important;
                    background-color: transparent !important;
                }
                .invoice-info {
                    display: block !important;
                }
                .invoice-info > div {
                    width: 100% !important;
                    margin-bottom: 0.5rem;
                }
            }
        </style>


    </head>
    <body class="bg-white text-gray-900 font-sans p-10">

        <header class="flex justify-between items-center mb-8 border-b-4 border-orange-600 pb-2">
            <h1 class="text-4xl font-extrabold text-orange-600">FBus Ticketing</h1>
            <h2 class="text-2xl font-semibold text-gray-700">Invoice: ${bookingInfo.invoiceCode}</h2>
        </header>

        <div class="invoice-info bg-orange-50 rounded-lg shadow p-6 mb-10 grid grid-cols-1 md:grid-cols-2 gap-4 text-base text-gray-800">
            <div>
                <p class="mb-1"><strong class="text-orange-700 inline-block w-40">Customer:</strong> ${bookingInfo.customerName}</p>
                <p class="mb-1"><strong class="text-orange-700 inline-block w-40">Booking Date:</strong> <fmt:formatDate value="${bookingInfo.bookingDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                <p class="mb-1"><strong class="text-orange-700 inline-block w-40">Total Amount:</strong> <fmt:formatNumber value="${bookingInfo.totalAmount}" type="currency" currencySymbol="VND"/></p>
            </div>
            <div>
                <p class="mb-1"><strong class="text-orange-700 inline-block w-40">Status:</strong> <span class="text-green-700 font-semibold">${bookingInfo.paymentStatus}</span></p>
                <p class="mb-1"><strong class="text-orange-700 inline-block w-40">Payment Method:</strong> ${bookingInfo.paymentMethod != null ? bookingInfo.paymentMethod : 'N/A'}</p>
            </div>
        </div>

        <table class="w-full border border-gray-300 rounded-lg shadow-sm text-gray-700">
            <thead class="bg-orange-200 text-orange-900 font-bold uppercase text-sm select-none">
                <tr>
                    <th class="border border-gray-300 px-5 py-3 text-center whitespace-nowrap">No.</th>
                    <th class="border border-gray-300 px-5 py-3 max-w-[180px] break-words whitespace-normal">Route</th>
                    <th class="border border-gray-300 px-5 py-3 text-center whitespace-nowrap">Departure</th>
                    <th class="border border-gray-300 px-5 py-3 text-center whitespace-nowrap">Seat</th>
                    <th class="border border-gray-300 px-5 py-3 max-w-[180px] break-words whitespace-normal">Driver</th>
                    <th class="border border-gray-300 px-5 py-3 text-center whitespace-nowrap">Bus Type</th>
                    <th class="border border-gray-300 px-5 py-3 text-center whitespace-nowrap">QR Code</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ticket" items="${ticketDetails}" varStatus="status">
                    <tr class="odd:bg-white even:bg-orange-50">
                        <td class="border border-gray-300 px-5 py-3 text-center">${status.index + 1}</td>
                        <td class="border border-gray-300 px-5 py-3 max-w-[180px] break-words whitespace-normal">${ticket.routeName}</td>
                        <td class="border border-gray-300 px-5 py-3 text-center"><fmt:formatDate value="${ticket.departureTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="border border-gray-300 px-5 py-3 text-center">${ticket.seatCode}</td>
                        <td class="border border-gray-300 px-5 py-3 max-w-[180px] break-words whitespace-normal">${ticket.driverName}</td>
                        <td class="border border-gray-300 px-5 py-3 text-center">${ticket.busType}</td>
                        <td class="border border-gray-300 px-5 py-3 text-center">
                            <c:if test="${not empty ticket.qrCodeBase64}">
                                <img src="data:image/png;base64,${ticket.qrCodeBase64}" alt="QR Code" class="mx-auto w-20 h-20 object-contain" />
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <button class="no-print mt-6 px-6 py-3 bg-[#EF5222] hover:bg-orange-700 text-white font-bold rounded shadow float-right"
                onclick="window.print()">Print</button>

    </body>
</html>
