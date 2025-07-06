<%-- 
    Document   : schedule
    Created on : Jul 7, 2025, 1:02:16 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<body class="min-h-screen bg-white py-14 px-6">
    <div class="max-w-[1024px] mx-auto">
        <div class="layout px-4 py-8">
            <!-- Input form for origin and destination -->
            <div class="schedule-input-form relative flex justify-center gap-4 mb-6">
                <!-- Origin Input -->
                <div class="relative w-1/3">
                    <input type="text" placeholder="Enter origin" class="w-full py-2 px-4 border rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
                </div>

                <!-- Switch location icon -->
                <img class="switch-location" src="${pageContext.request.contextPath}/assets/images/icons/switch_location.svg" alt="switch location icon">

                <!-- Destination Input -->
                <div class="relative w-1/3">
                    <input type="text" placeholder="Enter destination" class="w-full py-2 px-4 border rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
                </div>
            </div>

            <!-- Schedule list -->
            <div class="flex flex-col gap-4 overflow-auto">
                <!-- Header Row -->
                <div class="schedule-card flex w-full bg-gray-200 py-2 px-4 text-sm font-medium">
                    <div class="w-6/12">Route</div>
                    <div class="w-2/12">Car</div>
                    <div class="w-3/12">Distance</div>
                    <div class="w-3/12">Time</div>
                    <div class="w-2/12">Price</div>
                </div>

                <!-- Schedule Entries -->
                <!-- Trip 1 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Hữu (Tiền Giang)</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Limousine</div>
                    <div class="w-3/12">123km</div>
                    <div class="w-3/12">2 hours</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 2 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Khê (Gia Lai)</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Limousine</div>
                    <div class="w-3/12">640km</div>
                    <div class="w-3/12">13 hours</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 3 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Khê (Gia Lai)</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Limousine</div>
                    <div class="w-3/12">690km</div>
                    <div class="w-3/12">14 hours</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 4 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Minh (Kiên Giang)</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Limousine</div>
                    <div class="w-3/12">295km</div>
                    <div class="w-3/12">7 hours</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 5 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Nhơn</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Bunk</div>
                    <div class="w-3/12">639km</div>
                    <div class="w-3/12">11 hours 30 minutes</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 6 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4 border-b">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Nhơn</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">Bunk</div>
                    <div class="w-3/12">660km</div>
                    <div class="w-3/12">13 hours 46 minutes</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>

                <!-- Trip 7 -->
                <div class="schedule-card flex items-center bg-white py-2 px-4">
                    <div class="w-6/12 flex items-center gap-2">
                        <span class="font-medium text-orange">An Nhơn</span>
                        <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" alt="arrow">
                        <span>TP.Hồ Chí Minh</span>
                    </div>
                    <div class="w-2/12">---</div>
                    <div class="w-3/12">627km</div>
                    <div class="w-3/12">10 hours 7 minutes</div>
                    <div class="w-2/12">---</div>
                    <div class="flex justify-end w-2/12">
                        <button type="button" class="bg-red-500 text-white py-2 px-4 rounded-md">
                            <span>Search trip</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>