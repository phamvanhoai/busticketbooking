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


<%@include file="/WEB-INF/include/banner.jsp" %>
<style>
    /* Ẩn tất cả panels Your Trip mặc định */
    .your-trip > div {
        display: none;
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
                            <select name="origin" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <option value="">Select origin</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc}" <c:if test="${param.origin == loc}">selected</c:if>>${loc}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="absolute top-[60px] left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 rotate-180">
                            <img src="${pageContext.request.contextPath}/assets/images/icons/switch_location.svg" alt="switch" class="w-12 h-12" />
                        </div>
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Destination</label>
                            <select name="destination" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
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
                        <div class="flex-1 relative">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Tickets</label>
                            <select name="tickets" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <c:forEach begin="1" end="8" var="i">
                                    <option value="${i}" <c:if test="${param.tickets == i}">selected</c:if>>${i}</option>
                                </c:forEach>
                            </select>
                            <span class="absolute top-1/2 right-3 -translate-y-1/2 pointer-events-none">
                                <img src="${pageContext.request.contextPath}/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-8 h-8" />
                            </span>
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
                                 data-price="${trip.price}"
                                 data-bus-type-id="${trip.busTypeId}"
                                 data-rows-down="${trip.rowsDown}" data-cols-down="${trip.colsDown}"
                                 data-rows-up="${trip.rowsUp}"     data-cols-up="${trip.colsUp}">
                                <label for="trip${st.index+1}" class="block p-4 cursor-pointer hover:shadow-lg transition">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <p class="text-lg font-bold">${trip.tripTime}</p>
                                            <p class="text-sm text-gray-600">${trip.origin}</p>
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
                                    <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">Select trip</button>
                                </div>

                                <div class="tab-content hidden p-4 border-t" data-content="seat">
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <!-- Downstairs block -->
                                        <div>
                                            <h4 class="font-semibold mb-2">Downstairs:</h4>
                                            <div class="seat-grid-down flex gap-2 mb-4"></div>
                                        </div>
                                        <!-- Upstairs block -->
                                        <div>
                                            <h4 class="font-semibold mb-2">Upstairs:</h4>
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
                                    <button class="choose-btn mt-4 bg-orange-500 text-white px-8 py-2 rounded-full disabled:opacity-50" disabled>
                                        Choose
                                    </button>
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
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const activeIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_active.svg`;
            const disabledIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_disabled.svg`;
            const selectingIcon = `${pageContext.servletContext.contextPath}/assets/images/icons/seat_selecting.svg`;

            const ajaxBase = '${pageContext.servletContext.contextPath}/view-trips?ajax=seats';

            // Lặp qua từng card/chuyến xe
            document.querySelectorAll('.card').forEach(card => {
                // Tạo biến state riêng cho từng card
                let selectedSeats = [];

                const tripId = card.dataset.tripId;
                const tripPrice = Number(card.dataset.price) || 0;
                const busTypeId = card.dataset.busTypeId;
                const rowsDown = +card.dataset.rowsDown;
                const colsDown = +card.dataset.colsDown;
                const rowsUp = +card.dataset.rowsUp;
                const colsUp = +card.dataset.colsUp;

                // Select các phần tử bên trong card này
                const seatBtn = card.querySelector('[data-tab="seat"]');
                const seatPanel = card.querySelector('.tab-content[data-content="seat"]');
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

                seatBtn.addEventListener('click', async e => {
                    e.stopPropagation();
                    if (!seatPanel.classList.contains('hidden')) {
                        seatPanel.classList.add('hidden');
                        return;
                    }

                    // Ẩn các panel khác trong card
                    card.querySelectorAll('.tab-content').forEach(c => c.classList.add('hidden'));
                    seatPanel.classList.remove('hidden');

                    // Lấy danh sách ghế qua AJAX
                    const url = ajaxBase
                            + '&busTypeId=' + encodeURIComponent(busTypeId)
                            + '&tripId=' + encodeURIComponent(tripId);

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

                                    if (selectedSeats.includes(seat.code)) {
                                        icon = selectingIcon;
                                        cell.classList.add('border-2', 'border-blue-500');
                                    }

                                    // --- GIỮ NGUYÊN ---
                                    cell.innerHTML =
                                            '<div class="relative w-full h-full">' +
                                            '<img src="' + icon + '" alt="Seat ' + seat.code + '" class="w-full h-full seat-icon" data-seat="' + seat.code + '" />' +
                                            '<span class="absolute inset-0 flex items-center justify-center text-xs font-medium text-blue-800">' +
                                            seat.code +
                                            '</span>' +
                                            '</div>';
                                    // -----------------

                                    cell.addEventListener('click', () => {
                                        if (seat.booked)
                                            return;

                                        if (selectedSeats.includes(seat.code)) {
                                            selectedSeats = selectedSeats.filter(s => s !== seat.code); // Unselect
                                        } else {
                                            selectedSeats.push(seat.code); // Select
                                        }

                                        renderGrid(downWrap, down, rowsDown, colsDown);
                                        renderGrid(upWrap, up, rowsUp, colsUp);
                                        updateSelectionDisplay();
                                        updateTotalAmount();
                                        toggleChooseButton();
                                    });
                                }
                                colDiv.appendChild(cell);
                            }
                            container.appendChild(colDiv);
                        }
                    }

                    // Update ghế đã chọn
                    function updateSelectionDisplay() {
                        selectedSeatsDisplay.textContent = selectedSeats.length > 0 ? selectedSeats.join(', ') : 'No seat selected';
                        ticketCountDisplay.textContent = `${selectedSeats.length} Ticket(s)`;
                    }

                    // Update tổng tiền (giá cứng, bạn có thể lấy từ biến JS nếu cần)
                    function updateTotalAmount() {
                        const selectedSeatsCount = selectedSeats.length;
                        const totalAmount = selectedSeatsCount * tripPrice;
                        totalAmountDisplay.textContent = `${totalAmount.toLocaleString()}₫`;
                    }

                    // Bật/tắt nút chọn
                    function toggleChooseButton() {
                        chooseButton.disabled = selectedSeats.length === 0;
                    }

                    // Lần đầu render seat
                    renderGrid(downWrap, down, rowsDown, colsDown);
                    renderGrid(upWrap, up, rowsUp, colsUp);
                    updateSelectionDisplay();
                    updateTotalAmount();
                    toggleChooseButton();
                });
            });
        });
    </script>




    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>