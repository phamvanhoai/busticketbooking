<%-- 
    Document   : booking-payment
    Created on : Jul 5, 2025, 1:07:42 PM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<c:set var="booking" value="${requestScope.booking}" />
<c:set var="trip" value="${requestScope.trip}" />
<c:set var="totalAmount" value="${requestScope.totalAmount}" />
<c:set var="now" value="${requestScope.now}" />
<c:set var="expiryTime" value="${requestScope.expiryTime}" />
<!-- Toastify CSS -->
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">

<!-- Toastify JS -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

<style>
    /* CSS for tooltip */
    .trip-note-tooltip {
        z-index: 99999;
    }
    .ant-tooltip-placement-top, .ant-tooltip-placement-topLeft, .ant-tooltip-placement-topRight {
        padding-bottom: 14.3137085px;
    }
    .ant-tooltip-hidden {
        display: none !important; /* Ensure completely hidden */
    }
    .ant-tooltip {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        color: rgba(0, 0, 0, .85);
        font-size: 14px;
        font-variant: tabular-nums;
        line-height: 1.5715;
        list-style: none;
        font-feature-settings: "tnum";
        position: absolute;
        z-index: 1070;
        display: block;
        width: -moz-max-content;
        width: max-content;
        width: intrinsic;
        max-width: 250px;
        visibility: visible;
    }
    .trip-note-tooltip .ant-tooltip-inner {
        background-color: #fbeae4;
        color: #ef5222;
        font-weight: 400;
        border-radius: 16px;
        padding: 12px 8px;
        width: -moz-max-content;
        width: max-content;
        text-align: justify;
    }
    .ant-tooltip-inner {
        min-width: 30px;
        min-height: 32px;
        padding: 6px 8px;
        color: #fff;
        text-align: left;
        text-decoration: none;
        word-wrap: break-word;
        background-color: rgba(0, 0, 0, .75);
        border-radius: 2px;
        box-shadow: 0 3px 6px -4px rgba(0, 0, 0, .12), 0 6px 16px 0 rgba(0, 0, 0, .08), 0 9px 28px 8px rgba(0, 0, 0, .05);
    }
    .icon-orange img {
        filter: invert(47%) sepia(42%) saturate(6373%) hue-rotate(349deg) brightness(96%) contrast(94%);
    }
    .ant-radio-group .ant-radio-wrapper {
        border: none;
    }
    .round-ss {
        border-radius: 4px;
    }
    .text-orange {
        color: #EF5222;
    }
    .text-green {
        color: #00613D;
    }
    .payment-expiry {
        color: #dc2626;
        font-weight: bold;
    }
    .three-column-layout {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 20px;
        max-width: 1100px;
        margin: 0 auto;
    }
    @keyframes fade-in-down {
        from {
            opacity: 0;
            transform: translateY(-30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .animate-fade-in-down {
        animation: fade-in-down 0.4s ease-out;
    }
    .has-bullet ul {
        list-style-type: disc;
        padding-left: 1.25rem; /* Equivalent to pl-5 */
    }
    .has-bullet ul li p {
        display: list-item;
        list-style-type: inherit;
        margin-left: 0;
    }
</style>

<body class="bg-[#f3f3f5] min-h-screen text-black-800">
    <h1 class="text-3xl font-bold text-[#EF5222] text-center mb-6">Payment</h1>
    <div class="three-column-layout">
        <!-- Payment method list -->
        <div class="w-full">
            <div class="text-xl font-medium mb-2">Choose payment method</div>
            <div class="ant-radio-group ant-radio-group-outline">
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="VietQr">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/goopay.svg" alt="VietQr">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">VietQr Payment</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper ant-radio-wrapper-checked m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio ant-radio-checked">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="FUTAPay" checked>
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/futapay.svg" alt="FUTAPay">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">FPTUPay</span>
                                </div>
                                <span class="text-xs font-medium text-orange">
                                    Wallet balance: <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" /> VND
                                </span>

                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="ZaloPay">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/zalopay.svg" alt="ZaloPay">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">ZaloPay</span>
                                </div>
                                <span class="text-xs font-medium text-orange">Enter code ZLPBUS10 - 10k discount for orders from 300k; Enter code "BANIU" - New customers up to 50k</span>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="ShopeePay">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/shopeepay_logo.png" alt="ShopeePay">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">ShopeePay</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="MoMo">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/momo.svg" alt="MoMo">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">MoMo</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="VNPay">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/vnpay.svg" alt="VNPay">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">VNPay</span>
                                </div>
                                <span class="text-xs font-medium text-orange">Enter code: VNPAYFUTA50 - up to 50k discount</span>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="ViettelMoney">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/viettelpay.svg" alt="Viettel Money">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">Viettel Money</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="MBBank">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="round-ss ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/vietQR.png" alt="MB Bank">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">MB Bank</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
            </div>
            <div class="ant-radio-group ant-radio-group-outline mt-3 border-t pt-3">
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="Atm">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/atn_logo.png" alt="Atm">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">Atm</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
                <label class="ant-radio-wrapper m-0 flex items-center border-b py-3" style="border: none;">
                    <span class="ant-radio">
                        <input type="radio" class="ant-radio-input" name="paymentMethod" value="VisaMasterJCB">
                        <span class="ant-radio-inner"></span>
                    </span>
                    <span>
                        <div class="flex w-full items-center">
                            <img class="ml-4 mr-4 w-[40px]" src="${pageContext.request.contextPath}/assets/images/icons/visa_logo.png" alt="Visa/Master/JCB">
                            <div class="flex w-full flex-col">
                                <div class="flex w-52 items-end justify-between">
                                    <span class="text-base text-black">Visa/Master/JCB</span>
                                </div>
                            </div>
                        </div>
                    </span>
                </label>
            </div>
        </div>

        <!-- Payment details and QR -->
        <div class="w-full flex flex-col items-center text-center">
            <div class="text-gray text-base font-medium">Total payment</div>
            <div class="mb-6 text-5xl font-semibold text-orange">
                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" /> VND
            </div>
            <div class="rounded-2xl bg-[#FAFAFC] p-2">
                <span class="text-[13px] text-[#EF5222]">Remaining ticket payment time
                    <span class="font-medium" id="payment-countdown"></span>
                </span>

                <div class="relative mt-4 aspect-square w-80 rounded-lg bg-white">
                    <img alt="qr code" class="w-full h-full" src="https://api.futabus.vn/ticket-online/api/qrcode?Content=https%3A%2F%2Ffutacustomer.page.link%2FWVP65cfQxQLfQfCS6&Size=180&Color=Black&Logo=futapay.png" />
                </div>
                <div class="mt-2 mt-6 flex flex-col items-start gap-3">
                    <div class="text-green font-medium">Instructions to pay with FPTUPay</div>
                    <div class="flex gap-2  text-sm"><div class="h-6 rounded-full bg-gray-500 px-2 pt-1 text-white">1</div>Open the FPTUPay application on your phone</div>
                    <div class="flex gap-2  text-sm"><div class="rounded-full bg-gray-500 px-2 pt-1 text-white">2</div>Use the <img src="${pageContext.request.contextPath}/assets/images/icons/icon_scan.svg" alt="scan"> icon to scan the QR code</div>
                    <div class="flex gap-2  text-sm"><div class="rounded-full bg-gray-500 px-2 pt-1 text-white">3</div>Scan the code on this page and pay</div>
                </div>
            </div>
            <div class="mt-6 w-full flex justify-center">
                <form method="post" action="${pageContext.request.contextPath}/book-ticket" class="inline-block">
                    <input type="hidden" name="action" value="confirm-payment" />
                    <input type="hidden" name="tripId" value="${trip.tripId}" />
                    <input type="hidden" name="selectedSeats" value="${selectedSeatsString}" />
                    <input type="hidden" name="fullName" value="${booking.fullName}" />
                    <input type="hidden" name="phoneNumber" value="${booking.phoneNumber}" />
                    <input type="hidden" name="email" value="${booking.email}" />
                    <input type="hidden" name="pickupLocationId" value="${booking.ticket.pickupLocationId}" />
                    <input type="hidden" name="dropoffLocationId" value="${booking.ticket.dropoffLocationId}" />

                    <button type="submit" id="payment-button"
                            class="bg-[#EF5222] text-white py-2 px-6 rounded-xl">
                        Payment
                    </button>
                </form>
            </div>

        </div>

        <!-- Passenger & Trip info -->
        <div class="flex w-full">
            <div class="mx-auto flex min-w-[345px] flex-col gap-6">
                <div class="rounded-xl border border-[#DDE2E8] bg-white px-4 py-3">
                    <p class="text-xl font-medium">Passenger information</p>
                    <div class="mt-4 flex justify-between"><span>Full name</span><span>${booking.fullName}</span></div>
                    <div class="mt-1 flex justify-between"><span>Phone number</span><span>${booking.phoneNumber}</span></div>
                    <div class="mt-1 flex justify-between"><span>Email</span><span>${booking.email}</span></div>
                </div>

                <div class="rounded-xl border border-[#DDE2E8] bg-white px-4 py-3">
                    <p class="icon-orange flex gap-2 text-xl font-medium">
                        Trip information
                        <img class="w-6 cursor-pointer" src="${pageContext.request.contextPath}/assets/images/icons/info_white.svg" alt="info" id="trip-note-trigger">
                    </p>

                    <div class="mt-4 flex justify-between"><span>Routes</span><span>${trip.origin} - ${trip.destination}</span></div>
                    <div class="mt-1 flex justify-between"><span>Departure time</span><span class="text-green">${trip.tripTime} <fmt:formatDate value="${trip.tripDate}" pattern="dd/MM/yyyy" /></span></div>
                    <div class="mt-1 flex justify-between"><span>Number of seats</span><span>${fn:length(booking.seatCodes)} Seat(s)</span></div>
                    <div class="mt-1 flex justify-between"><span>Seat</span><span>
                            <c:forEach var="code" items="${booking.seatCodes}" varStatus="loop">
                                ${code}<c:if test="${!loop.last}">, </c:if>
                            </c:forEach>
                        </span></div>
                    <div class="mt-1 flex justify-between"><span>Pickup point</span><span>${pickupLocationName}</span></div>
                    <div class="mt-1 flex justify-between"><span>Time to board</span><span class="text-red-500">Before ${trip.tripTime} <fmt:formatDate value="${trip.tripDate}" pattern="dd/MM/yyyy" /></span></div>
                    <div class="mt-1 flex justify-between"><span>Dropoff</span><span>${dropoffLocationName}</span></div>
                    <div class="mt-1 flex justify-between font-semibold"><span>Total trip amount</span><span class="text-green"><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VND" groupingUsed="true"/></span></div>
                </div>

                <div class="rounded-xl border border-[#DDE2E8] bg-white px-4 py-3">
                    <p class="icon-orange flex gap-2 text-xl font-medium">
                        Price details
                        <img class="w-6 cursor-pointer" src="${pageContext.request.contextPath}/assets/images/icons/info_white.svg" alt="info" id="price-note-trigger">
                    </p>

                    <div class="mt-4 flex justify-between"><span>Trip fare</span><span class="text-orange"><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VND" groupingUsed="true"/></span></div>
                    <div class="mt-1 flex justify-between"><span>Payment fees</span><span>0 VND</span></div>
                    <div class="border-t my-3"></div>
                    <div class="flex justify-between font-semibold"><span>Total amount</span><span class="text-orange"><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VND" groupingUsed="true"/>
                        </span></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Trip Information Tooltip -->
    <div id="trip-note-tooltip" class="ant-tooltip trip-note-tooltip ant-tooltip-placement-top ant-tooltip-hidden">
        <div class="ant-tooltip-content">
            <div class="ant-tooltip-arrow"><span class="ant-tooltip-arrow-content"></span></div>
            <div class="ant-tooltip-inner" role="tooltip">
                <div class="w-[90vw] sm:max-w-sm">
                    <p style="column-count: 1"><strong>Door-to-door pickup/dropoff:</strong></p>
                    <p style="column-count: 1">
                        <span style="color: rgb(29, 28, 29)">- Time to receive guests :</span>
                        <em><span style="color: rgb(29, 28, 29)">4 hours before.</span><br></em>
                        <span style="color: rgb(29, 28, 29)">- Pick up time :</span>
                        <em><span style="color: rgb(29, 28, 29)"> Prepare 2-3 hours in advance, due to the high traffic density in the city and will combine pick up at many different points, the specific pick up time will be contacted by the driver.</span></em><br>
                        - Small alleys can't turn around : <em>Cars pick up passengers at the beginning of the alley/street.</em><br>
                        - Do not accept areas with no parking signs : <em>The car will pick up at the nearest location possible.</em><br>
                        - Luggage: <em>Compact luggage under 20kg, do not transport attached pets, </em>no carrying items with odors or that leak on the vehicle.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Ticket Price Information Tooltip -->
    <div id="price-note-tooltip" class="ant-tooltip trip-note-tooltip ant-tooltip-placement-top ant-tooltip-hidden">
        <div class="ant-tooltip-content">
            <div class="ant-tooltip-arrow"><span class="ant-tooltip-arrow-content"></span></div>
            <div class="ant-tooltip-inner" role="tooltip">
                <div class="flex w-[90vw] flex-col sm:max-w-md">
                    <div class="pb-2 text-lg font-medium">Cancellation Policy</div>
                    <div class="content-editor has-bullet no-margin">
                        <ul>
                            <li><p>Tickets can only be exchanged once.</p></li>
                            <li><p>The cost of ticket cancellation is from 10% to 30% of the fare depending on the cancellation time compared to the departure time indicated on the ticket and the number of individual/group tickets applicable under current regulations.</p></li>
                            <li><p>If you need to change or cancel a paid ticket, you need to contact the Call Center 1900 6067 or the ticket counter at the latest 24 hours before the departure time indicated on the ticket, on email or text message. further instructions.</p></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            console.log("DOM fully loaded");

            // Payment method warning
            const allPaymentRadios = document.querySelectorAll("input[name='paymentMethod']");
            allPaymentRadios.forEach(radio => {
                radio.addEventListener("change", () => {
                    if (radio.value !== "FPTUPay") {
                        Toastify({
                            text: "This feature is being updated. Please select FPTUPAY to continue!",
                            duration: 3500,
                            close: true,
                            gravity: "top",
                            position: "center",
                            style: {
                                background: "#EF5222",
                                color: "#fff",
                                fontWeight: "500",
                                borderRadius: "8px",
                                padding: "12px 16px",
                            },
                            stopOnFocus: true
                        }).showToast();
                        document.querySelector("input[name='paymentMethod'][value='FPTUPay']").checked = true;
                    }
                });
            });

            // Countdown Logic
            let hasClickedPayment = false;
            const expiryTimeMillis = ${expiryTime};
            const expiryTime = new Date(expiryTimeMillis);
            const paymentCountdown = document.getElementById("payment-countdown");

            if (!paymentCountdown) {
                console.error("payment-countdown element not found");
                return;
            }

            if (isNaN(expiryTime.getTime())) {
                console.error("Invalid expiryTimeMillis:", expiryTimeMillis);
                paymentCountdown.textContent = "Error: Invalid expiry time";
                return;
            }

            function updateCountdown() {
                const now = new Date();
                const distance = expiryTime - now;

                if (distance <= 0) {
                    paymentCountdown.textContent = "Expired";
                    clearInterval(countdownInterval);
                    if (!hasClickedPayment) {
                        Toastify({
                            text: "Payment session has expired. Redirecting...",
                            duration: 3000,
                            gravity: "top",
                            position: "center",
                            style: {
                                background: "#EF5222",
                                color: "#fff",
                                borderRadius: "8px",
                            }
                        }).showToast();
                        setTimeout(() => {
                            window.location.href = "${pageContext.request.contextPath}/view-trips";
                        }, 3000);
                    }
                    return;
                }

                const totalSeconds = Math.max(0, Math.floor(distance / 1000));
                const minutes = Math.floor(totalSeconds / 60);
                const seconds = totalSeconds % 60;
                const timeStr = [minutes, seconds].map(num => String(num).padStart(2, '0')).join(':');
                paymentCountdown.textContent = timeStr;
            }

            updateCountdown();
            const countdownInterval = setInterval(updateCountdown, 1000);

            // Payment Button Logic
            const paymentButton = document.getElementById("payment-button");
//            if (paymentButton) {
//                paymentButton.addEventListener("click", function () {
//                    hasClickedPayment = true;
//                    Toastify({
//                        text: "Processing your payment...",
//                        duration: 3000,
//                        close: false,
//                        gravity: "top",
//                        position: "right",
//                        style: {
//                            background: "#EF5222",
//                            color: "#fff",
//                            fontWeight: "500",
//                            borderRadius: "8px",
//                            padding: "12px 16px",
//                        },
//                        stopOnFocus: false
//                    }).showToast();
//                    // Không dùng e.preventDefault(), để form submit
//                });
//            }
            if (paymentButton) {
                paymentButton.addEventListener("click", function () {
                    hasClickedPayment = true;

                    Toastify({
                        text: "Your payment was successful! Thank you for choosing our service.",
                        duration: 5000,
                        close: false,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: "#16a34a",
                            color: "#fff",
                            fontWeight: "500",
                            borderRadius: "8px",
                            padding: "12px 16px",
                        },
                        stopOnFocus: false
                    }).showToast();

                    setTimeout(() => {
                        window.location.href = "${pageContext.request.contextPath}/ticket-management";
                    }, 1000);
                });
            }

            // Update seat info and total
            const selectedSeats = "${selectedSeatsString}".split(",").filter(s => s.trim());
            const seatCount = selectedSeats.length > 0 ? selectedSeats.length : 0;
            let totalAmount = "${totalAmount != null ? totalAmount : '0'}".replace(/[^0-9.]/g, "");
            totalAmount = parseFloat(totalAmount) || 0;

            const tripSeatCountElement = document.getElementById("trip-seat-count");
            if (tripSeatCountElement) {
                tripSeatCountElement.textContent = seatCount + " Seat(s)";
            }

            const tripSeatLabelsElement = document.getElementById("trip-seat-labels");
            if (tripSeatLabelsElement) {
                tripSeatLabelsElement.textContent = selectedSeats.length > 0 ? selectedSeats.join(", ") : "-";
            }

            const formattedTotal = totalAmount.toLocaleString("vi-VN") + "đ";
            const totalAmountElements = document.querySelectorAll("#fare-amount, #price-total, #payment-total, #trip-total");
            totalAmountElements.forEach(el => {
                if (el) {
                    el.textContent = formattedTotal;
                }
            });

            const tripDropoffElement = document.getElementById("trip-dropoff");
            if (tripDropoffElement) {
                tripDropoffElement.textContent = "${dropoffLocationName}" || "-";
            }
        });
    </script>

    <script>
        const tooltipHandler = (trigger, tooltip) => {
            if (!trigger || !tooltip) {
                console.error("Tooltip trigger or tooltip element not found.");
                return;
            }

            let showTimeout, hideTimeout;

            const showTooltip = () => {
                clearTimeout(hideTimeout);
                showTimeout = setTimeout(() => {
                    const rect = trigger.getBoundingClientRect();
                    const tooltipWidth = tooltip.offsetWidth || 250;
                    tooltip.style.left = (rect.left + window.scrollX - (tooltipWidth / 2) + (trigger.offsetWidth / 2)) + "px";
                    tooltip.style.top = (rect.top + window.scrollY - 14.3 - tooltip.offsetHeight) + "px";
                    tooltip.classList.remove("ant-tooltip-hidden");
                }, 200);
            };

            const hideTooltip = () => {
                clearTimeout(showTimeout);
                hideTimeout = setTimeout(() => {
                    tooltip.classList.add("ant-tooltip-hidden");
                }, 300);
            };

            trigger.addEventListener("mouseenter", showTooltip);
            trigger.addEventListener("mouseleave", hideTooltip);
            tooltip.addEventListener("mouseenter", () => clearTimeout(hideTimeout));
            tooltip.addEventListener("mouseleave", hideTooltip);
            tooltip.classList.add("ant-tooltip-hidden");
        };

        document.addEventListener("DOMContentLoaded", () => {
            tooltipHandler(
                    document.getElementById("trip-note-trigger"),
                    document.getElementById("trip-note-tooltip")
                    );
            tooltipHandler(
                    document.getElementById("price-note-trigger"),
                    document.getElementById("price-note-tooltip")
                    );
        });
    </script>
    <%@include file="/WEB-INF/include/footer.jsp" %>
</body>