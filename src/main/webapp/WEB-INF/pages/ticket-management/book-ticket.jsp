<%-- 
    Document   : book-ticket
    Created on : Jun 13, 2025, 12:39:26 AM
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<c:set var="trip" value="${requestScope.trip}" />
<c:set var="selectedSeats" value="${requestScope.selectedSeats}" />
<c:set var="routeStops" value="${requestScope.routeStops}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
<script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

<style>
    .ant-popover-inner {
        border-radius: 8px;
        background-color: #fff;
        background-clip: padding-box;
        box-shadow: 0 3px 6px -4px rgba(0, 0, 0, .12),
            0 6px 16px 0 rgba(0, 0, 0, .08),
            0 9px 28px 8px rgba(0, 0, 0, .05);
    }
    .divide {
        width: 100%;
        background: rgba(0, 0, 0, .1);
        height: .5px;
    }
    .py-\[2px\] {
        padding-top: 2px !important;
        padding-bottom: 2px !important;
    }
    .icon-orange img {
        filter: invert(47%) sepia(42%) saturate(6373%) hue-rotate(349deg) brightness(96%) contrast(94%);
    }
    .terms-popup {
        position: fixed;
        top: 20%;
        right: -300px;
        width: 280px;
        padding: 1rem;
        background-color: #fef2f2;
        border-left: 4px solid #ef4444;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        color: #dc2626;
        font-size: 0.875rem;
        z-index: 50;
        transition: right 0.3s ease-in-out;
    }
    .terms-popup.show {
        right: 20px;
    }
    .seat-limit-popup {
        position: fixed;
        top: 20%;
        right: -300px;
        width: 280px;
        padding: 1rem;
        background-color: #fef2f2;
        border-left: 4px solid #ef4444;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        color: #dc2626;
        font-size: 0.875rem;
        z-index: 50;
        transition: right 0.3s ease-in-out;
    }
    .seat-limit-popup.show {
        right: 20px;
    }
    .trip-note-tooltip {
        z-index: 99999;
    }
    .ant-tooltip-placement-top, .ant-tooltip-placement-topLeft, .ant-tooltip-placement-topRight {
        padding-bottom: 14.3137085px;
    }
    .ant-tooltip-hidden {
        display: none !important;
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
    #vehicle-popover {
        max-height: 500px;
        overflow-y: auto;
    }
    .has-bullet ul {
        list-style-type: disc;
        padding-left: 1.25rem;
    }
    .has-bullet ul li p {
        display: list-item;
        list-style-type: inherit;
        margin-left: 0;
    }
    .text-gray {
        color: #666;
    }
    #vehicle-popover .p-4.border-b {
        position: sticky;
        top: 0;
        background-color: #fff;
        z-index: 30;
    }
    #tab-schedule {
        position: relative;
        padding-bottom: 80px;
    }
    #tab-schedule .w-full.bg-\[\#F7F7F7\] {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        z-index: 30;
    }
    @keyframes fade-in-up {
        0% {
            opacity: 0;
            transform: translateY(20px);
        }
        100% {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .animate-fade-in-up {
        animation: fade-in-up 0.4s ease-out;
    }
</style>

<body class="bg-[#f3f3f5] min-h-screen text-black-800">
    <div class="max-w-[1100px] mx-auto py-8 px-4">
        <h1 class="text-3xl font-bold text-[#EF5222] text-center mb-6">Book Ticket</h1>

        <div class="flex flex-col lg:flex-row gap-6">
            <!-- Seat Layout + Form -->
            <div class="w-full lg:w-2/3 border rounded-xl bg-white">
                <div class="p-6">
                    <!-- Seat Layout Heading + Vehicle Info Toggle -->
                    <div class="flex items-center justify-between mb-4">
                        <p class="text-2xl font-bold">Choose seat</p>
                        <div class="relative group">
                            <div id="vehicle-info-trigger" class="cursor-pointer text-sm text-blue-500 underline hover:text-blue-600">
                                Vehicle information
                            </div>
                            <div id="vehicle-popover" class="absolute right-0 mt-2 w-[450px] max-h-[500px] overflow-y-auto hidden z-20 ant-popover-inner">
                                <div class="p-4 border-b flex gap-2">
                                    <button class="tab-btn px-3 py-1 rounded-full text-sm font-medium bg-orange-500 text-white" data-tab="schedule">Schedule</button>
                                    <button class="tab-btn px-3 py-1 rounded-full text-sm font-medium" data-tab="images">Images/Video</button>
                                    <button class="tab-btn px-3 py-1 rounded-full text-sm font-medium" data-tab="utilities">Utilities</button>
                                    <button class="tab-btn px-3 py-1 rounded-full text-sm font-medium" data-tab="policy">Policy</button>
                                </div>
                                <div class="tab-content p-4 text-sm" id="tab-schedule">
                                    <div class="flex w-full flex-col overflow-auto pb-20">
                                        <c:forEach var="stop" items="${routeStops}" varStatus="status">
                                            <div class="relative flex items-start px-4 text-[15px] text-black">
                                                <c:if test="${!status.last}">
                                                    <div class="absolute left-[78px] top-2 h-full border-r-2 border-dotted"></div>
                                                </c:if>
                                                <span>${stopTimes[status.index]}</span>
                                                <c:choose>
                                                    <c:when test="${status.first}">
                                                        <img class="z-10 mx-4 mt-1" src="${pageContext.request.contextPath}/assets/images/icons/pickup.svg" alt="start">
                                                    </c:when>
                                                    <c:when test="${status.last}">
                                                        <img class="z-10 mx-4 mt-1" src="${pageContext.request.contextPath}/assets/images/icons/station.svg" alt="end">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img class="z-10 mx-4 mt-1" src="${pageContext.request.contextPath}/assets/images/icons/pickup_gray.svg" alt="stop">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="mb-4">
                                                    <div class="font-medium">${stop.locationName}</div>
                                                    <div class="text-gray text-[13px] leading-4">${stop.address}</div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <div class="w-full bg-[#F7F7F7] px-4 py-2 text-[13px] overflow-y-auto" style="max-height: 100px;">
                                            <span class="text-[15px] font-medium">Noted</span><br>
                                            <span>The times of landmarks are estimated times. This schedule is subject to change depending on the actual situation of early or late departure.</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-content p-4 hidden text-sm" id="tab-images"></div>
                                <div class="tab-content p-4 hidden text-sm" id="tab-utilities"></div>
                                <div class="tab-content p-4 hidden text-sm" id="tab-policy">
                                    <div class="overflow-auto">
                                        <div class="flex flex-col">
                                            <div class="px-4 py-2">
                                                <div class="pb-2 text-lg font-medium">Cancellation Policy</div>
                                                <div class="flex w-full flex-col">
                                                    <div class="content-editor has-bullet no-margin text-sm">
                                                        <ul>
                                                            <li><p>Tickets can only be exchanged once.</p></li>
                                                            <li><p>The cost of ticket cancellation is from 10% to 30% of the fare depending on the cancellation time compared to the departure time indicated on the ticket and the number of individual/group tickets applicable under current regulations.</p></li>
                                                            <li><p>If you need to change or cancel a paid ticket, you need to contact the Call Center 1900 6067 or the ticket counter at the latest 24 hours before the departure time indicated on the ticket, on email or text message. further instructions.</p></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex flex-col">
                                            <div class="divide py-[2px]"></div>
                                            <div class="px-4 py-2">
                                                <div class="pb-2 text-lg font-medium">Requirements when boarding</div>
                                                <div class="content-editor has-bullet no-margin text-sm">
                                                    <ul>
                                                        <li><p>Please be present at the Office/Bus Station (Direct pickup location) 30 minutes before the departure time for boarding procedures (for holidays and Tet, please arrive 60 minutes in advance).</p></li>
                                                        <li><p>Present the ticket information sent via SMS/Email/Futa App or contact the ticket counter to receive ticket information before boarding.</p></li>
                                                        <li><p>Do not bring food/beverages with strong odors on board.</p></li>
                                                        <li><p>No smoking, consumption of alcoholic beverages, or use of stimulants on the bus.</p></li>
                                                        <li><p>Do not bring flammable or explosive items on board.</p></li>
                                                        <li><p>Do not litter on the bus.</p></li>
                                                        <li><p>Do not bring pets on board.</p></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex flex-col">
                                            <div class="divide py-[2px]"></div>
                                            <div class="px-4 py-2">
                                                <div class="pb-2 text-lg font-medium">Hand Baggage</div>
                                                <div class="content-editor has-bullet no-margin text-sm">
                                                    <ul>
                                                        <li><p style="column-count: 1">The total weight of luggage must not exceed 20kg.</p></li>
                                                        <li><p style="text-align: start">Bulky goods are not allowed to be transported.</p></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex flex-col">
                                            <div class="divide py-[2px]"></div>
                                            <div class="px-4 py-2">
                                                <div class="pb-2 text-lg font-medium">Children & Pregnant Passengers</div>
                                                <div class="content-editor has-bullet no-margin text-sm">
                                                    <ul>
                                                        <li><p>Children under 6 years old, with a height of 1.3m or below, and weighing less than 30kg do not need to purchase a ticket.</p></li>
                                                        <li><p>In case a child does not meet any of the three criteria above, they will need to purchase one ticket equivalent to an adult ticket.</p></li>
                                                        <li><p>Each adult is allowed to accompany a maximum of one child.</p></li>
                                                        <li><p>Pregnant passengers should ensure their health during the entire journey.</p></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex flex-col">
                                            <div class="divide py-[2px]"></div>
                                            <div class="px-4 py-2">
                                                <div class="pb-2 text-lg font-medium">Pick-up ticket</div>
                                                <div class="content-editor has-bullet no-margin text-sm">
                                                    <ul>
                                                        <li><p>Please contact the hotline at 1900 6067 to register at least 2 hours before the scheduled departure time and kindly prepare small and compact luggage (maximum 20kg).</p></li>
                                                        <li><p>Please note that we only provide pick-up services at some convenient locations along the route.</p></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Seat Layout -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4">
                        <div>
                            <h3 class="font-semibold mb-2 text-center">Downstairs</h3>
                            <div id="seat-grid-down" class="flex flex-wrap justify-center gap-2"></div>
                        </div>
                        <div>
                            <h3 class="font-semibold mb-2 text-center">Up floor</h3>
                            <div id="seat-grid-up" class="flex flex-wrap justify-center gap-2"></div>
                        </div>
                    </div>

                    <div class="text-sm text-black-600 flex justify-center gap-6 pt-2">
                        <div><span class="inline-block w-5 h-5 align-middle bg-[url('${pageContext.request.contextPath}/assets/images/icons/seat_active.svg')] bg-contain bg-no-repeat"></span> Blank</div>
                        <div><span class="inline-block w-5 h-5 align-middle bg-[url('${pageContext.request.contextPath}/assets/images/icons/seat_disabled.svg')] bg-contain bg-no-repeat"></span> Sold</div>
                        <div><span class="inline-block w-5 h-5 align-middle bg-[url('${pageContext.request.contextPath}/assets/images/icons/seat_selecting.svg')] bg-contain bg-no-repeat"></span> Pending</div>
                    </div>
                </div>

                <div class="divide py-[2px]"></div>

                <!-- Customer Info + Form -->
                <div class="p-6 space-y-6">
                    <p class="text-2xl font-bold text-black-800">Customer information</p>
                    <form id="bookForm" method="post" action="${pageContext.request.contextPath}/book-ticket" class="space-y-6">
                        <input type="hidden" name="action" value="prepare-payment" />
                        <input type="hidden" name="tripId" value="${trip.tripId}" />
                        <input type="hidden" name="selectedSeats" id="selected-seats-input" value="" />

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium">Full Name *</label>
                                    <input type="text" name="fullName" class="w-full p-2 border rounded" required />
                                </div>
                                <div>
                                    <label class="block text-sm font-medium">Phone Number *</label>
                                    <input type="tel" name="phoneNumber" class="w-full p-2 border rounded" required pattern="[0-9]{10}" />
                                </div>
                                <div>
                                    <label class="block text-sm font-medium">Email *</label>
                                    <input type="email" name="email" class="w-full p-2 border rounded" required />
                                </div>
                            </div>
                            <div class="text-sm text-black-600">
                                <p class="font-bold text-[#EF5222] mb-2">TERMS AND POLICIES</p>
                                <p class="mb-2">(*) Please be at the departure station of the bus at least 30 minutes before departure time, bring the confirmed email which contain reservation code in order from the FBUS system. Please contact Hotline <span class="text-[#EF5222] font-medium">1900 6067</span> for support.</p>
                                <p>(*) Please call <span class="text-[#EF5222] font-medium">1900 6918</span> for shuttle bus service. Shuttle bus services range is limited, therefore, we will not pick passengers who are outside the range of service. Thank you!</p>
                            </div>
                        </div>

                        <div>
                            <label class="flex items-center gap-2 cursor-pointer text-black-600">
                                <input type="checkbox" name="terms" id="termsCheckbox" class="accent-[#EF5222]" />
                                <span id="termsLabel" class="transition-colors duration-200">
                                    <span class="text-[#EF5222] underline">Accept terms</span> ticket booking & information privacy policy of FBUS
                                </span>
                            </label>
                        </div>
                </div>

                <div class="divide py-[2px]"></div>
                <div class="p-6 space-y-6">
                    <div class="text-2xl font-bold flex items-center gap-2">
                        <p>Pickup-Dropoff information</p>
                        <div class="icon-orange flex gap-4 text-xl font-medium text-black">
                            <img src="${pageContext.request.contextPath}/assets/images/icons/info_white.svg" alt="info" class="w-6 cursor-pointer text-orange" id="trip-note-trigger">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Pickup Point -->
                        <div class="relative">
                            <label class="block text-sm font-medium mb-1">Pickup Point *</label>
                            <div class="relative">
                                <select name="pickupLocationId" id="pickupLocationId" class="w-full h-12 pl-3 pr-12 border rounded appearance-none" required>
                                    <c:forEach var="stop" items="${routeStops}" varStatus="status">
                                        <c:if test="${not status.last}">
                                            <option value="${stop.locationId}" data-stop-number="${stop.stopNumber}">${stop.locationName}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <div class="pointer-events-none absolute top-1/2 right-3 transform -translate-y-1/2">
                                    <img src="${pageContext.request.contextPath}/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-5 h-5" />
                                </div>
                            </div>
                        </div>

                        <!-- Dropoff Point -->
                        <div class="relative">
                            <label class="block text-sm font-medium mb-1">Dropoff Point *</label>
                            <div class="relative">
                                <select name="dropoffLocationId" id="dropoffLocationId" class="w-full h-12 pl-3 pr-12 border rounded appearance-none" required>
                                    <c:forEach var="stop" items="${routeStops}" varStatus="status">
                                        <c:if test="${not status.first}">
                                            <option value="${stop.locationId}" data-stop-number="${stop.stopNumber}" ${status.last ? 'selected' : ''}>${stop.locationName}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <div class="pointer-events-none absolute top-1/2 right-3 transform -translate-y-1/2">
                                    <img src="${pageContext.request.contextPath}/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-5 h-5">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="divide py-[2px]"></div>
                <div class="p-6 space-y-6">
                    <div class="p-6 flex items-center justify-between">
                        <div class="flex flex-col">
                            <span class="w-20 text-xs text-center rounded-xl bg-[#00613D] py-1 text-white font-semibold tracking-wide">FPTPAY</span>
                            <span class="text-2xl font-medium text-black mt-2" id="payment-total">0 VND</span>
                        </div>
                        <div class="flex gap-4">
                            <a href="${pageContext.request.contextPath}/view-trips" class="w-28 border border-gray-400 rounded-full py-2 font-semibold text-center hover:bg-gray-100">Cancel</a>
                            <button type="submit" class="w-28 bg-[#EF5222] text-white rounded-full py-2 font-semibold hover:bg-orange-600">Payment</button>
                        </div>
                    </div>
                </div>
                </form>
            </div>

            <!-- Trip Info Summary -->
            <div class="w-full lg:w-1/3 space-y-6">
                <div class="bg-white p-4 rounded-xl border text-sm">
                    <p class="text-2xl font-bold text-black mb-4">Trip information</p>
                    <div class="flex justify-between mb-2"><span>Routes</span><span>${trip.origin} – ${trip.destination}</span></div>
                    <div class="flex justify-between mb-2">
                        <span>Departure time</span>
                        <span class="text-green-700">${trip.tripTime} <fmt:formatDate value="${trip.tripDate}" pattern="dd-MM-yyyy" /></span>
                    </div>
                    <div class="flex justify-between mb-2"><span>Number of seats</span><span id="trip-seat-count">0 Seat</span></div>
                    <div class="flex justify-between mb-2"><span>Seat</span><span id="trip-seat-labels">-</span></div>
                    <div class="flex justify-between mb-2"><span>Door-to-door dropoff</span><span id="trip-dropoff"></span></div>
                    <div class="flex justify-between font-semibold text-[#EF5222]"><span>Total trip amount</span><span id="trip-total">0 VND</span></div>
                </div>
                <div class="bg-white p-4 rounded-xl border text-sm">
                    <div class="icon-orange flex items-center gap-2 text-xl font-medium text-black mb-4">
                        <p class="text-2xl font-bold text-black mb-0">Price details</p>
                        <img id="price-note-trigger" class="w-5 h-5 cursor-pointer" src="${pageContext.request.contextPath}/assets/images/icons/info_white.svg" alt="info">
                    </div>
                    <div class="flex justify-between mb-2"><span>Trip fare</span><span id="fare-amount">0 VND</span></div>
                    <div class="flex justify-between mb-2"><span>Payment fees</span><span id="payment-fees">0 VND</span></div>
                    <div class="border-t my-2"></div>
                    <div class="flex justify-between font-semibold text-[#EF5222]"><span>Total amount</span><span id="price-total">0 VND</span></div>
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
        // Define updateDropoffOptions in global scope
        function updateDropoffOptions() {
            const pickupSelect = document.getElementById("pickupLocationId");
            const dropoffSelect = document.getElementById("dropoffLocationId");
            const pickupStopNumber = parseInt(pickupSelect.options[pickupSelect.selectedIndex]?.dataset.stopNumber || 0);
            console.log("Selected Pickup Stop Number:", pickupStopNumber);

            // Store current dropoff value
            const currentDropoffValue = dropoffSelect.value;
            console.log("Current Dropoff Value:", currentDropoffValue);

            // Clear existing dropoff options
            dropoffSelect.innerHTML = '';

            // Get all route stops
            const routeStops = [
                <c:forEach var="stop" items="${routeStops}" varStatus="status">
                    { value: "${stop.locationId}", text: "${stop.locationName}", stopNumber: ${stop.stopNumber} }${status.last ? '' : ','}
                </c:forEach>
            ];
            console.log("Route Stops:", routeStops);

            // Get the locationId of the first stop to exclude it
            const firstStopId = routeStops[0]?.value;
            console.log("First Stop ID to exclude:", firstStopId);

            // Filter stops: exclude first stop and stops with stopNumber <= pickupStopNumber
            const validDropoffStops = routeStops.filter(stop => 
                stop.stopNumber > pickupStopNumber && stop.value !== firstStopId
            );
            console.log("Valid Dropoff Stops:", validDropoffStops);

            // Add valid dropoff options
            validDropoffStops.forEach(stop => {
                const option = document.createElement('option');
                option.value = stop.value;
                option.text = stop.text;
                option.dataset.stopNumber = stop.stopNumber;
                dropoffSelect.appendChild(option);
            });

            // If no valid dropoff stops, show placeholder
            if (validDropoffStops.length === 0) {
                const option = document.createElement('option');
                option.value = '';
                option.text = 'No valid dropoff points';
                option.disabled = true;
                option.selected = true;
                dropoffSelect.appendChild(option);
                console.log("No valid dropoff points available");
            } else {
                // Restore current dropoff value if valid, else select first valid stop
                const isCurrentValid = validDropoffStops.some(stop => stop.value === currentDropoffValue);
                dropoffSelect.value = isCurrentValid ? currentDropoffValue : validDropoffStops[0].value;
                console.log("Selected Dropoff Value:", dropoffSelect.value);
            }

            // Update trip-dropoff display
            const selectedDropoffText = dropoffSelect.options[dropoffSelect.selectedIndex]?.text || '-';
            document.getElementById("trip-dropoff").textContent = selectedDropoffText;
            console.log("Updated trip-dropoff text:", selectedDropoffText);
        }

        // Initialize page after DOM is fully loaded
        document.addEventListener("DOMContentLoaded", async () => {
            const tripId = parseInt("${trip.tripId}") || 0;
            const busTypeId = parseInt("${trip.busTypeId}") || 0;
            let price = "${trip.price}";
            const rowsDown = parseInt("${trip.rowsDown}") || 0;
            const colsDown = parseInt("${trip.colsDown}") || 0;
            const rowsUp = parseInt("${trip.rowsUp}") || 0;
            const colsUp = parseInt("${trip.colsUp}") || 0;

            console.log("Raw trip.price:", price);
            price = parseFloat(price.replace(/[^0-9.]/g, "")) || 0;
            console.log("Parsed price:", price);

            const initialSelectedSeats = "${selectedSeats}".split(",").filter(seat => seat.trim() !== "");
            const selectedSeats = [...initialSelectedSeats];
            console.log("Initial selected seats from server:", initialSelectedSeats);

            const seatActive = "${pageContext.request.contextPath}/assets/images/icons/seat_active.svg";
            const seatDisabled = "${pageContext.request.contextPath}/assets/images/icons/seat_disabled.svg";
            const seatSelecting = "${pageContext.request.contextPath}/assets/images/icons/seat_selecting.svg";

            const downWrap = document.getElementById("seat-grid-down");
            const upWrap = document.getElementById("seat-grid-up");
            const selectedSeatsDisplay = document.getElementById("selected-seats-display");
            const selectedSeatsInput = document.getElementById("selected-seats-input");
            const termsCheckbox = document.getElementById("termsCheckbox");
            const termsPopup = document.getElementById("terms-popup");
            const seatLimitPopup = document.getElementById("seat-limit-popup");
            const bookForm = document.getElementById("bookForm");
            const tripNoteTrigger = document.getElementById("trip-note-trigger");
            const tripNoteTooltip = document.getElementById("trip-note-tooltip");
            const pickupSelect = document.getElementById("pickupLocationId");
            const dropoffSelect = document.getElementById("dropoffLocationId");

            if (!downWrap || !upWrap) {
                console.error("Container not found:", {downWrap, upWrap});
                return;
            }

            const apiUrl = "${pageContext.request.contextPath}/book-ticket?ajax=seats&busTypeId=" + busTypeId + "&tripId=" + tripId;

            const updateSelectionDisplay = () => {
                if (selectedSeatsDisplay) {
                    selectedSeatsDisplay.textContent = selectedSeats.length > 0 ? selectedSeats.join(", ") : "None";
                }
                selectedSeatsInput.value = selectedSeats.join(",");
                document.getElementById("trip-seat-count").textContent = selectedSeats.length + " Seat(s)";
                document.getElementById("trip-seat-labels").textContent = selectedSeats.length > 0 ? selectedSeats.join(", ") : "-";
            };

            const updateTotalAmount = () => {
                const total = selectedSeats.length * price;
                console.log("Selected seats:", selectedSeats.length, "Price:", price, "Total:", total);
                const formatted = total.toLocaleString("vi-VN") + " VND";
                console.log("Formatted total:", formatted);
                const elements = [
                    "total-amount",
                    "trip-total",
                    "fare-amount",
                    "price-total",
                    "payment-total"
                ];
                elements.forEach(id => {
                    const element = document.getElementById(id);
                    if (element) {
                        element.textContent = formatted;
                    } else {
                        console.warn(`Element with ID ${id} not found`);
                    }
                });
            };

            function renderGrid(container, seats, rows, cols) {
                if (!container) {
                    console.error("Container is null");
                    return;
                }
                if (!seats || !Array.isArray(seats)) {
                    console.error("Invalid seats data:", seats);
                    container.innerHTML = '<p class="text-red-500">No seat data available</p>';
                    return;
                }
                container.innerHTML = '';
                for (let c = 1; c <= cols; c++) {
                    const colDiv = document.createElement('div');
                    colDiv.classList.add('flex', 'flex-col', 'gap-1');
                    for (let r = 1; r <= rows; r++) {
                        const seat = seats.find(s => s.row === r && s.col === c);
                        const cell = document.createElement("div");
                        cell.className = "w-10 h-10 flex items-center justify-center";

                        if (seat && seat.code) {
                            let icon = document.createElement("img");
                            icon.src = seat.booked ? seatDisabled : (selectedSeats.includes(seat.code) ? seatSelecting : seatActive);
                            icon.className = "w-full h-full seat-icon";

                            const wrapper = document.createElement("div");
                            wrapper.className = "relative w-full h-full cursor-pointer";
                            const label = document.createElement("span");
                            label.className = "absolute inset-0 flex items-center justify-center text-xs font-medium";
                            label.innerText = seat.code;

                            wrapper.appendChild(icon);
                            wrapper.appendChild(label);
                            cell.appendChild(wrapper);

                            if (!seat.booked) {
                                wrapper.addEventListener("click", () => {
                                    const index = selectedSeats.indexOf(seat.code);
                                    console.log("Seat clicked:", seat.code, "Current selected seats:", selectedSeats);

                                    if (index >= 0) {
                                        selectedSeats.splice(index, 1);
                                        icon.src = seatActive;
                                    } else {
                                        if (selectedSeats.length >= 8) {
                                            Toastify({
                                                text: "Maximum 8 seats can be selected. Please deselect some seats to proceed.",
                                                duration: 4000,
                                                gravity: "top",
                                                position: "center",
                                                backgroundColor: "#EF5222",
                                                className: "rounded-xl text-white text-sm font-medium shadow-md",
                                            }).showToast();
                                            return;
                                        }
                                        selectedSeats.push(seat.code);
                                        icon.src = seatSelecting;
                                    }

                                    wrapper.classList.toggle("text-orange-600", selectedSeats.includes(seat.code));
                                    wrapper.classList.toggle("ring-orange-400", selectedSeats.includes(seat.code));
                                    updateSelectionDisplay();
                                    updateTotalAmount();
                                });
                            } else {
                                wrapper.style.cursor = "not-allowed";
                                wrapper.style.opacity = "0.5";
                            }
                        } else {
                            cell.innerHTML = '';
                        }
                        colDiv.appendChild(cell);
                    }
                    container.appendChild(colDiv);
                }
            }

            bookForm.addEventListener("submit", (e) => {
                if (selectedSeats.length === 0) {
                    e.preventDefault();
                    Toastify({
                        text: "Please select at least one seat before payment.",
                        duration: 4000,
                        gravity: "top",
                        position: "center",
                        backgroundColor: "#EF5222",
                        className: "rounded-xl text-white text-sm font-medium shadow-md",
                    }).showToast();
                    return;
                }

                if (!termsCheckbox.checked) {
                    e.preventDefault();
                    Toastify({
                        text: "Please accept the terms and conditions before proceeding.",
                        duration: 4000,
                        gravity: "top",
                        position: "center",
                        backgroundColor: "#EF5222",
                        className: "rounded-xl text-white text-sm font-medium shadow-md",
                    }).showToast();
                    return;
                }

                if (selectedSeats.length > 8) {
                    e.preventDefault();
                    Toastify({
                        text: "Maximum 8 seats can be selected. Please deselect some seats to proceed.",
                        duration: 4000,
                        gravity: "top",
                        position: "center",
                        backgroundColor: "#DC2626",
                        className: "rounded-xl text-white text-sm font-medium shadow-md",
                    }).showToast();
                    return;
                }
            });

            termsCheckbox.addEventListener("change", () => {
                if (termsCheckbox.checked) {
                    termsPopup?.classList.remove("show");
                }
            });

            const tooltipHandler = (trigger, tooltip) => {
                if (trigger && tooltip) {
                    let timeout;
                    trigger.addEventListener("mouseover", () => {
                        timeout = setTimeout(() => {
                            const rect = trigger.getBoundingClientRect();
                            const tooltipWidth = tooltip.offsetWidth || 250;
                            tooltip.style.left = (rect.left + window.scrollX - (tooltipWidth / 2) + (trigger.offsetWidth / 2)) + "px";
                            tooltip.style.top = (rect.top + window.scrollY - 14.3137085 - tooltip.offsetHeight) + "px";
                            tooltip.classList.remove("ant-tooltip-hidden");
                        }, 400);
                    });
                    trigger.addEventListener("mouseout", () => {
                        clearTimeout(timeout);
                        tooltip.classList.add("ant-tooltip-hidden");
                    });
                    if (!tooltip.classList.contains("ant-tooltip-hidden")) {
                        tooltip.classList.add("ant-tooltip-hidden");
                    }
                } else {
                    console.error("Tooltip trigger or element not found");
                }
            };

            tooltipHandler(tripNoteTrigger, tripNoteTooltip);
            tooltipHandler(document.getElementById("price-note-trigger"), document.getElementById("price-note-tooltip"));

            // Attach onchange event listener for pickupLocationId
            pickupSelect.addEventListener("change", updateDropoffOptions);

            // Update trip-dropoff when dropoffLocationId changes
            dropoffSelect.addEventListener("change", () => {
                const selectedDropoffText = dropoffSelect.options[dropoffSelect.selectedIndex]?.text || '-';
                document.getElementById("trip-dropoff").textContent = selectedDropoffText;
                console.log("Dropoff changed, updated trip-dropoff text:", selectedDropoffText);
            });

            // Call when page loads to ensure dropoff options match default pickup
            updateDropoffOptions();

            try {
                const res = await fetch(apiUrl);
                if (!res.ok)
                    throw new Error("Unable to load seat layout.");
                const data = await res.json();
                console.log("API response:", data);
                const {down, up} = data;
                if (!down || !up || !Array.isArray(down) || !Array.isArray(up)) {
                    downWrap.innerHTML = '<p class="text-red-500">Error: No seat data available</p>';
                    upWrap.innerHTML = '<p class="text-red-500">Error: No seat data available</p>';
                    return;
                }
                renderGrid(downWrap, down, rowsDown, colsDown);
                renderGrid(upWrap, up, rowsUp, colsUp);
                updateSelectionDisplay();
                updateTotalAmount();
            } catch (err) {
                console.error("Error fetching seat layout:", err);
                downWrap.innerHTML = '<p class="text-red-500">Error: Unable to load seat layout</p>';
                upWrap.innerHTML = '<p class="text-red-500">Error: Unable to load seat layout</p>';
            }
        });

        // Vehicle info popover handling
        const trigger = document.getElementById("vehicle-info-trigger");
        const popover = document.getElementById("vehicle-popover");

        trigger.addEventListener("click", () => {
            popover.classList.toggle("hidden");
        });

        document.querySelectorAll(".tab-btn").forEach(btn => {
            btn.addEventListener("click", function () {
                const tab = this.dataset.tab;
                document.querySelectorAll(".tab-content").forEach(el => el.classList.add("hidden"));
                document.getElementById("tab-" + tab).classList.remove("hidden");
                document.querySelectorAll(".tab-btn").forEach(b => b.classList.remove("bg-orange-500", "text-white"));
                this.classList.add("bg-orange-500", "text-white");
            });
        });

        document.querySelector('.tab-btn[data-tab="schedule"]')?.click();

        document.addEventListener("click", function (e) {
            if (!trigger.contains(e.target) && !popover.contains(e.target)) {
                popover.classList.add("hidden");
            }
        });
    </script>

    <%@include file="/WEB-INF/include/footer.jsp" %>