<%-- 
    Document   : view-trips
    Created on : Jun 15, 2025, 10:53:46 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fbus" uri="/WEB-INF/tags/implicit.tld" %>


<%@include file="/WEB-INF/include/banner.jsp" %>

<c:set var="baseUrl" value="${pageContext.request.contextPath}/view-trips" />

<!-- Thêm tham số 'origin' nếu có -->
<c:if test="${not empty param.origin}">
    <c:set var="baseUrl" value="${baseUrl}?origin=${fn:escapeXml(param.origin)}"/>
</c:if>

<!-- Thêm tham số 'destination' nếu có -->
<c:if test="${not empty param.destination}">
    <c:set var="baseUrl"
           value="${baseUrl}${param.origin != null ? '&' : '?'}destination=${fn:escapeXml(param.destination)}"/>
</c:if>

<!-- Thêm tham số 'departureDate' nếu có -->
<c:if test="${not empty param.departureDate}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.origin != null || param.destination != null) ? '&' : '?'}departureDate=${fn:escapeXml(param.departureDate)}"/>
</c:if>

<!-- Thêm tham số 'ticket' nếu có -->
<c:if test="${not empty param.ticket}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.origin != null || param.destination != null || param.departureDate != null) ? '&' : '?'}ticket=${fn:escapeXml(param.ticket)}"/>
</c:if>

<!-- Thêm tham số 'page' cho phân trang, kiểm tra nếu tham số 'page' không tồn tại trong URL -->
<c:if test="${empty param.page}">
    <c:set var="baseUrl"
           value="${baseUrl}${(param.origin != null || param.destination != null || param.departureDate != null || param.ticket != null) ? '&' : '?'}page=${currentPage}"/>
</c:if>

<!-- Đảm bảo URL có đầy đủ tham số phân trang -->



<style>
    /* Ẩn tất cả panels Your Trip mặc định */
    .your-trip > div {
        display: none;
    }
    /* CSS để thêm hiệu ứng active cho tab */
    button[data-tab].active {
        color: rgb(239, 82, 34);
        text-shadow: 0 0 .25px rgb(239, 82, 34);
    }


    /* Sinh CSS highlight và hiển thị panel tương ứng */
    <c:forEach items="${trips}" var="trip" varStatus="st">
        #trip${st.index+1}:checked ~ .layout .sidebar .your-trip .trip${st.index+1} {
            display: block;
        }
        #trip${st.index+1}:checked ~ .layout .content .card:nth-of-type(${st.index+1}) {
            border-color: #fb923c;
            box-shadow: 0 0 0 2px rgba(251,146,60,0.3);
        }
    </c:forEach>
</style>

<body class="bg-gray-100 text-gray-800">
    <div class="max-w-[1024px] mx-auto">

        <!-- Hiện lỗi nếu origin/destination không đầy đủ -->
        <c:if test="${not empty error}">
            <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg">
                ${error}
            </div>
        </c:if>

        <!-- Form tìm chuyến -->
        <div class="relative rounded-3xl border border-[rgba(239,82,34,0.6)] shadow-2xl px-12 py-8 min-h-[190px] bg-white backdrop-blur-md">
            <form method="get" action="${pageContext.request.contextPath}/view-trips">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">

                    <!-- Origin & Destination -->
                    <div class="relative flex gap-6 w-full">
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Origin</label>
                            <select name="origin" id="origin" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <option value="">Select origin</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc}" <c:if test="${param.origin == loc}">selected</c:if>>${loc}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="absolute top-[60px] left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 rotate-180">
                            <img id="switch-icon" src="${pageContext.request.contextPath}/assets/images/icons/switch_location.svg" alt="switch" class="w-12 h-12" />
                        </div>
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Destination</label>
                            <select name="destination" id="destination" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <option value="">Select destination</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc}" <c:if test="${param.destination == loc}">selected</c:if>>${loc}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Departure Date & Tickets -->
                    <div class="flex gap-6 w-full">
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Departure Date</label>
                            <input type="date" name="departureDate" value="${param.departureDate}" 
                                   class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md" />
                        </div>

                        <!-- Tickets -->
                        <div class="flex-1 relative">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Tickets</label>
                            <div class="relative">
                                <select name="ticket" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md">
                                    <c:forEach begin="1" end="8" var="i">
                                        <option value="${i}" <c:if test="${param.ticket == i}">selected</c:if>>${i}</option>
                                    </c:forEach>
                                </select>
                                <span class="absolute top-1/2 right-3 -translate-y-1/2 pointer-events-none">
                                    <img src="${pageContext.request.contextPath}/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-8 h-8" />
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="absolute -bottom-6 left-1/2 transform -translate-x-1/2">
                    <button type="submit" 
                            class="bg-gradient-to-r from-[#ef5222] to-[#fc7b4c] hover:from-[#fc7b4c] hover:to-[#ef5222] text-white text-lg font-bold px-16 py-4 rounded-full shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center gap-3">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2"
                              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                        View Trips
                    </button>
                </div>
            </form>
        </div>

        <!-- Radios điều khiển YOUR TRIP panels -->
        <c:choose>
            <c:when test="${not empty trips}">
                <c:forEach items="${trips}" varStatus="st">
                    <input type="radio" name="selected" id="trip${st.index+1}" hidden <c:if test="${st.first}">checked</c:if> />
                </c:forEach>
            </c:when>
            <c:otherwise>
                <input type="radio" name="selected" id="trip1" hidden checked />
                <input type="radio" name="selected" id="trip2" hidden />
                <input type="radio" name="selected" id="trip3" hidden />
            </c:otherwise>
        </c:choose>

        <div class="layout flex max-w-6xl mx-auto py-8 px-4 gap-6">
            <!-- Sidebar YOUR TRIP -->
            <div class="sidebar w-1/3 space-y-6">
                <div class="your-trip space-y-4">
                    <c:choose>
                        <c:when test="${not empty trips}">
                            <c:forEach items="${trips}" var="trip" varStatus="st">
                                <div class="trip${st.index+1} bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
                                    <h3 class="font-semibold">YOUR TRIP</h3>
                                    <p class="text-sm text-gray-600">${trip.tripDate}</p>
                                    <div class="flex justify-between items-center mt-2">
                                        <div>
                                            <p class="text-lg font-bold">${trip.tripTime}</p>
                                            <p class="text-xs text-gray-500">${trip.origin}</p>
                                        </div>
                                        <div class="text-center text-sm text-gray-500">
                                            <c:choose>
                                                <c:when test="${trip.duration < 60}">${trip.duration}m</c:when>
                                                <c:otherwise>
                                                    <c:set var="hflt" value="${trip.duration div 60}" />
                                                    <c:set var="h" value="${fn:substringBefore(hflt, '.')}" />
                                                    <c:set var="m" value="${trip.duration mod 60}" />
                                                    ${h}h${m}m
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <p class="text-lg font-bold">${trip.arrivalTime}</p>
                                            <p class="text-xs text-gray-500">${trip.destination}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="trip1 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
                                <h3 class="font-semibold">YOUR TRIP</h3>
                                <p class="text-sm text-gray-600">No upcoming trip</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Content: Trip Cards -->
            <div class="content flex-1 space-y-6">
                <c:choose>
                    <c:when test="${not empty trips}">
                        <c:forEach items="${trips}" var="trip" varStatus="st">
                            <div class="card bg-white rounded-xl border border-gray-200 shadow overflow-hidden"
                                 data-trip-id="${trip.tripId}"
                                 data-price="${trip.price != null ? trip.price : 0}"
                                 data-bus-type-id="${trip.busTypeId}"
                                 data-rows-down="${trip.rowsDown}" data-cols-down="${trip.colsDown}"
                                 data-rows-up="${trip.rowsUp}"     data-cols-up="${trip.colsUp}">
                                <label for="trip${st.index+1}" class="block p-4 cursor-pointer hover:shadow-lg transition">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <p class="text-2xl font-bold">${trip.tripTime}</p>
                                            <p class="text-sm text-gray-600">${trip.origin}</p>
                                        </div>
                                        <div class="text-center text-sm text-gray-600">
                                            <c:choose>
                                                <c:when test="${trip.duration < 60}">${trip.duration}m</c:when>
                                                <c:otherwise>
                                                    <c:set var="hflt" value="${trip.duration div 60}" />
                                                    <c:set var="h" value="${fn:substringBefore(hflt, '.')}" />
                                                    <c:set var="m" value="${trip.duration mod 60}" />
                                                    ${h}h${m}m
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <p class="text-2xl font-bold">${trip.arrivalTime}</p>
                                            <p class="text-sm text-gray-600">${trip.destination}</p>
                                        </div>
                                    </div>
                                    <div class="flex justify-between items-center mt-4 text-gray-600 text-sm">
                                        <span>${trip.busType} • ${trip.capacity - trip.bookedSeats} blank seat</span>
                                        <span class="text-orange-500 font-semibold">
                                            <fmt:formatNumber value="${trip.price}" pattern="#,##0 ₫"/>
                                        </span>
                                    </div>
                                </label>

                                <div class="p-4 bg-gray-50 flex gap-4 text-sm text-gray-500">
                                    <button data-tab="seat" class="px-3 py-1 hover:text-orange-500">Choose seat</button>
                                    <button data-tab="schedule" class="px-3 py-1 hover:text-orange-500">Schedule</button>
                                    <button data-tab="trans"    class="px-3 py-1 hover:text-orange-500">Transshipment</button>
                                    <button data-tab="policy"   class="px-3 py-1 hover:text-orange-500">Policy</button>
                                    <a href="${pageContext.servletContext.contextPath}/book-ticket?tripId=${trip.tripId}">
                                        <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">Select trip</button></a>


                                </div>

                                <div class="tab-content hidden p-4 border-t" data-content="seat">
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <!-- Downstairs block -->
                                        <div>
                                            <h2 class="font-semibold mb-2">Downstairs:</h2>
                                            <div class="seat-grid-down flex gap-2 mb-4"></div>
                                        </div>
                                        <!-- Upstairs block -->
                                        <div>
                                            <h2 class="font-semibold mb-2">Upstairs:</h2>
                                            <div class="seat-grid-up flex gap-2 mb-4"></div>
                                        </div>
                                    </div>

                                    <!--Display the number of tickets and total amount -->
                                    <div class="flex flex-col gap-2 mt-4">
                                        <p class="font-semibold text-gray-800 ticket-count">0 Ticket(s)</p>
                                        <p class="text-sm text-gray-600 selected-seats">No seat selected</p>  
                                    </div>

                                    <!-- Display total amount -->
                                    <div class="flex justify-between items-center mt-4 text-lg font-bold text-orange-500">
                                        <span>Total amount</span>
                                        <span class="total-amount">0₫</span>
                                    </div>

                                    <!-- Choose button -->
                                    <button class="choose-btn mt-4 bg-orange-500 text-white px-8 py-2 rounded-full disabled:opacity-50" disabled
                                            data-trip-id="${trip.tripId}">
                                        Choose
                                    </button>
                                </div>

                                <div class="tab-content hidden p-4 border-t" data-content="schedule">
                                    <!-- Route Stops: Full List -->
                                    <h2 class="text-lg font-semibold text-gray-800 mb-4">Route Stops</h2>
                                    <div class="space-y-6">
                                        <c:if test="${empty trip.routeStops}">
                                            <div class="p-4 bg-red-100 text-red-700 rounded mb-4">
                                                Không có dữ liệu Route Stops (stops rỗng/null)!<br>
                                                Hãy kiểm tra lại Controller truyền stops xuống.
                                            </div>
                                        </c:if>
                                        <c:if test="${fn:length(trip.routeStops) != fn:length(trip.stopTimes)}">
                                            <div class="p-4 bg-red-100 text-red-700 rounded mb-4">
                                                Dữ liệu stopTimes không khớp với routeStops! Hãy kiểm tra lại Controller.
                                            </div>
                                        </c:if>
                                        <c:forEach var="stop" items="${trip.routeStops}" varStatus="status">
                                            <div class="flex items-start">
                                                <div class="flex flex-col items-center">
                                                    <div class="w-3 h-3
                                                         <c:choose>
                                                             <c:when test="${status.first}">bg-orange-500</c:when>
                                                             <c:when test="${status.last}">bg-gray-400</c:when>
                                                             <c:otherwise>bg-green-400</c:otherwise>
                                                         </c:choose>
                                                         rounded-full mt-1"></div>
                                                    <c:if test="${!status.last}">
                                                        <div class="flex-1 border-l-2 border-gray-200 h-full"></div>
                                                    </c:if>
                                                </div>
                                                <div class="ml-4">
                                                    <p class="font-medium text-gray-800">
                                                        ${trip.stopTimes[status.index]} – ${stop.locationName}
                                                    </p>
                                                    <p class="text-sm text-gray-500">
                                                        ${stop.address} (Travel: ${stop.travelMinutes}m, Dwell: ${stop.dwellMinutes}m)
                                                    </p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="tab-content hidden p-4 border-t" data-content="trans">
                                    <h2 class="text-lg font-semibold text-gray-800 mb-4">Door-to-door Pickup/Dropoff:</h2>
                                    <ul class="list-disc pl-5 space-y-2 text-gray-700">
                                        <li><strong>Time to receive guests:</strong> 4 hours before.</li>
                                        <li><strong>Pick-up time:</strong> Prepare 2-3 hours in advance, due to the high traffic density in the city and will combine pick up at many different points. The specific pick-up time will be contacted by the driver.</li>
                                        <li><strong>Small alleys can't turn around:</strong> Cars pick up passengers at the beginning of the alley/street.</li>
                                        <li><strong>Do not accept areas with no parking signs:</strong> The car will pick up at the nearest location possible.</li>
                                        <li><strong>Luggage:</strong> Compact luggage under 20kg, do not transport attached pets, no carrying items with odors or that leak on the vehicle.</li>
                                    </ul>
                                </div>

                                <div class="tab-content hidden p-4 border-t" data-content="policy">
                                    <h2 class="font-semibold text-lg">Cancellation Policy</h2>
                                    <p>Tickets can only be exchanged once.</p>
                                    <p>The cost of ticket cancellation is from 10% to 30% of the fare depending on the cancellation time compared to the departure time indicated on the ticket and the number of individual/group tickets applicable under current regulations.</p>
                                    <p>If you need to change or cancel a paid ticket, you need to contact the Call Center 1900 6067 or the ticket counter at the latest 24 hours before the departure time indicated on the ticket, on email or text message. Further instructions will follow.</p>

                                    <h2 class="font-semibold text-lg">Requirements when boarding</h2>
                                    <p>Please be present at the Office/Bus Station (Direct pickup location) 30 minutes before the departure time for boarding procedures (for holidays and Tet, please arrive 60 minutes in advance).</p>
                                    <p>Present the ticket information sent via SMS/Email/Futa App or contact the ticket counter to receive ticket information before boarding.</p>
                                    <p>Do not bring food/beverages with strong odors on board.</p>
                                    <p>No smoking, consumption of alcoholic beverages, or use of stimulants on the bus.</p>
                                    <p>Do not bring flammable or explosive items on board.</p>
                                    <p>Do not litter on the bus.</p>
                                    <p>Do not bring pets on board.</p>

                                    <h2 class="font-semibold text-lg">Hand Baggage</h2>
                                    <p>The total weight of luggage must not exceed 20kg.</p>
                                    <p>Bulky goods are not allowed to be transported.</p>

                                    <h2 class="font-semibold text-lg">Children & Pregnant Passengers</h2>
                                    <p>Children under 6 years old, with a height of 1.3m or below, and weighing less than 30kg do not need to purchase a ticket.</p>
                                    <p>In case a child does not meet any of the three criteria above, they will need to purchase one ticket equivalent to an adult ticket.</p>
                                    <p>Each adult is allowed to accompany a maximum of one child.</p>
                                    <p>Pregnant passengers should ensure their health during the entire journey.</p>

                                    <h2 class="font-semibold text-lg">Pick-up ticket</h2>
                                    <p>Please contact the hotline at 19006067 to register at least 2 hours before the scheduled departure time and kindly prepare small and compact luggage (maximum 20kg).</p>
                                    <p>Please note that we only provide pick-up services at some convenient locations along the route.</p>
                                </div>

                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-gray-500 italic">No upcoming trips found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <fbus:adminpagination
                currentPage="${currentPage}"
                totalPages="${totalPages}"
                url="${baseUrl}" />
        </div>

    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const switchIcon = document.getElementById('switch-icon');
            const originSelect = document.getElementById('origin');
            const destinationSelect = document.getElementById('destination');

            // Lắng nghe sự kiện khi nhấn vào icon switch
            switchIcon.addEventListener('click', () => {
                const originValue = originSelect.value;
                const destinationValue = destinationSelect.value;
                originSelect.value = destinationValue;
                destinationSelect.value = originValue;
            });

            const activeIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_active.svg`;
            const disabledIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_disabled.svg`;
            const selectingIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_selecting.svg`;

            const ajaxBase = '${pageContext.servletContext.contextPath}/view-trips?ajax=seats';

            function closeAllTabsExceptCurrent(currentCard) {
                document.querySelectorAll('.card').forEach(card => {
                    if (card !== currentCard) {
                        card.querySelectorAll('.tab-content').forEach(tab => {
                            tab.classList.add('hidden');
                        });
                        card.querySelectorAll('button[data-tab]').forEach(btn => {
                            btn.classList.remove('active');
                        });
                    }
                });
            }

            document.querySelectorAll('.card').forEach(card => {
                let selectedSeats = [];
                const tripId = card.dataset.tripId;
                let tripPrice = Number(card.dataset.price);
                if (tripPrice <= 0) {
                    console.warn("Giá vé không hợp lệ, sử dụng giá mặc định.");
                    tripPrice = 245000;
                }
                const busTypeId = card.dataset.busTypeId;
                const rowsDown = +card.dataset.rowsDown;
                const colsDown = +card.dataset.colsDown;
                const rowsUp = +card.dataset.rowsUp;
                const colsUp = +card.dataset.colsUp;

                const seatBtn = card.querySelector('[data-tab="seat"]');
                const scheduleBtn = card.querySelector('[data-tab="schedule"]');
                const transBtn = card.querySelector('[data-tab="trans"]');
                const policyBtn = card.querySelector('[data-tab="policy"]');
                const seatPanel = card.querySelector('.tab-content[data-content="seat"]');
                const schedulePanel = card.querySelector('.tab-content[data-content="schedule"]');
                const transPanel = card.querySelector('.tab-content[data-content="trans"]');
                const policyPanel = card.querySelector('.tab-content[data-content="policy"]');
                const downWrap = card.querySelector('.seat-grid-down');
                const upWrap = card.querySelector('.seat-grid-up');

                const selectedSeatsDisplay = card.querySelector('.selected-seats');
                const totalAmountDisplay = card.querySelector('.total-amount');
                const ticketCountDisplay = card.querySelector('.ticket-count');
                const chooseButton = card.querySelector('.choose-btn');

                if (!selectedSeatsDisplay || !totalAmountDisplay || !ticketCountDisplay || !chooseButton) {
                    console.error("Các phần tử DOM cần thiết không được tìm thấy trong card.");
                    return;
                }

                // Xử lý nút Choose
                chooseButton.addEventListener('click', () => {
                    if (selectedSeats.length === 0) {
                        Toastify({
                            text: "Please select at least one seat before proceeding.",
                            duration: 4000,
                            gravity: "top",
                            position: "center",
                            backgroundColor: "#EF5222",
                            className: "rounded-xl text-white text-sm font-medium shadow-md",
                        }).showToast();
                        return;
                    }

                    const selectedSeatsParam = encodeURIComponent(selectedSeats.join(','));
                    const url = `${pageContext.servletContext.contextPath}/book-ticket?tripId=` + encodeURIComponent(tripId) + `&selectedSeats=` + selectedSeatsParam;
                                    window.location.href = url;
                                });

                                scheduleBtn.addEventListener('click', () => {
                                    setActiveTab(scheduleBtn);
                                    closeAllTabsExceptCurrent(card);
                                    schedulePanel.classList.toggle('hidden');
                                    seatPanel.classList.add('hidden');
                                    transPanel.classList.add('hidden');
                                    policyPanel.classList.add('hidden');
                                });

                                transBtn.addEventListener('click', () => {
                                    setActiveTab(transBtn);
                                    closeAllTabsExceptCurrent(card);
                                    transPanel.classList.toggle('hidden');
                                    seatPanel.classList.add('hidden');
                                    schedulePanel.classList.add('hidden');
                                    policyPanel.classList.add('hidden');
                                });

                                policyBtn.addEventListener('click', () => {
                                    setActiveTab(policyBtn);
                                    closeAllTabsExceptCurrent(card);
                                    policyPanel.classList.toggle('hidden');
                                    seatPanel.classList.add('hidden');
                                    schedulePanel.classList.add('hidden');
                                    transPanel.classList.add('hidden');
                                });

                                function setActiveTab(button) {
                                    seatBtn.classList.remove('active');
                                    scheduleBtn.classList.remove('active');
                                    transBtn.classList.remove('active');
                                    policyBtn.classList.remove('active');
                                    button.classList.add('active');
                                }

                                seatBtn.addEventListener('click', async e => {
                                    e.stopPropagation();
                                    setActiveTab(seatBtn);
                                    closeAllTabsExceptCurrent(card);
                                    if (!seatPanel.classList.contains('hidden')) {
                                        seatPanel.classList.add('hidden');
                                        return;
                                    }

                                    card.querySelectorAll('.tab-content').forEach(c => c.classList.add('hidden'));
                                    seatPanel.classList.remove('hidden');

                                    const url = ajaxBase + '&busTypeId=' + encodeURIComponent(busTypeId) + '&tripId=' + encodeURIComponent(tripId);
                                    const res = await fetch(url);
                                    if (!res.ok) {
                                        console.error('Lấy ghế thất bại:', res.statusText);
                                        return;
                                    }

                                    const {down, up} = await res.json();

                                    function renderGrid(container, seats, rows, cols) {
                                        container.innerHTML = '';
                                        for (let c = 1; c <= cols; c++) {
                                            const colDiv = document.createElement('div');
                                            colDiv.classList.add('flex', 'flex-col', 'gap-1');
                                            for (let r = 1; r <= rows; r++) {
                                                const cell = document.createElement('div');
                                                cell.classList.add('w-8', 'h-8', 'flex', 'items-center', 'justify-center');
                                                const seat = seats.find(s => s.row === r && s.col === c);
                                                if (seat && seat.code) {
                                                    let icon = seat.booked ? disabledIcon : activeIcon;
                                                    cell.classList.add(seat.booked ? 'booked' : 'available');
                                                    if (selectedSeats.includes(seat.code)) {
                                                        icon = selectingIcon;
                                                        cell.classList.add('selected');
                                                    }
                                                    cell.innerHTML =
                                                            '<div class="relative w-full h-full">' +
                                                            '<img src="' + icon + '" alt="Seat ' + seat.code + '" class="w-full h-full seat-icon" data-seat="' + seat.code + '" />' +
                                                            '<span class="absolute inset-0 flex items-center justify-center text-xs font-medium">' + seat.code + '</span>' +
                                                            '</div>';
                                                    if (!seat.booked) {
                                                        cell.addEventListener('click', () => {
                                                            if (selectedSeats.includes(seat.code)) {
                                                                selectedSeats = selectedSeats.filter(s => s !== seat.code);
                                                                cell.classList.remove('selected');
                                                                cell.querySelector('.seat-icon').src = activeIcon;
                                                            } else {
                                                                selectedSeats.push(seat.code);
                                                                cell.classList.add('selected');
                                                                cell.querySelector('.seat-icon').src = selectingIcon;
                                                            }
                                                            updateSelectionDisplay();
                                                            toggleChooseButton();
                                                            updateTotalAmount();
                                                        });
                                                    }
                                                } else {
                                                    cell.classList.add('empty');
                                                }
                                                colDiv.appendChild(cell);
                                            }
                                            container.appendChild(colDiv);
                                        }
                                    }

                                    function updateSelectionDisplay() {
                                        selectedSeatsDisplay.textContent = selectedSeats.length > 0 ? selectedSeats.join(', ') : 'No seat selected';
                                        ticketCountDisplay.textContent = `${selectedSeats.length} Ticket(s)`;
                                    }

                                    function formatNumber(number) {
                                        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
                                    }

                                    function updateTotalAmount() {
                                        const selectedSeatsCount = selectedSeats.length;
                                        const totalAmount = selectedSeatsCount * tripPrice;
                                        const formattedAmount = formatNumber(totalAmount);
                                        let finalText;
                                        if (selectedSeatsCount > 0) {
                                            finalText = formattedAmount + '₫';
                                        } else {
                                            finalText = '0₫';
                                        }
                                        totalAmountDisplay.textContent = finalText;
                                    }

                                    function toggleChooseButton() {
                                        chooseButton.disabled = selectedSeats.length === 0;
                                    }

                                    renderGrid(downWrap, down, rowsDown, colsDown);
                                    renderGrid(upWrap, up, rowsUp, colsUp);
                                    updateSelectionDisplay();
                                    toggleChooseButton();
                                    updateTotalAmount();
                                });
                            });
                        });

    </script>




    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>