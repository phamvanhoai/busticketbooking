<%-- 
    Document   : home
    Created on : Jun 11, 2025, 4:41:57 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>


<%@include file="/WEB-INF/include/banner.jsp" %>


<body class="min-h-screen bg-white py-14 px-6">

    <div class="max-w-[1024px] mx-auto">
        <h2 class="text-3xl font-bold text-[#ef5222] text-center mb-10">View Trip List</h2>

        <!-- Form Container -->
        <div class="relative rounded-3xl border border-[rgba(239,82,34,0.6)] shadow-2xl px-12 py-8 min-h-[190px] bg-white backdrop-blur-md">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                <!-- Origin & Destination -->
                <div class="relative flex gap-6 w-full">
                    <!-- Origin -->
                    <div class="flex-1 relative">
                        <label class="block text-base font-semibold text-[#ef5222] mb-2">Origin</label>
                        <select class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md">
                            <option value="">Select origin</option>
                            <option value="An Giang">An Giang</option>
                            <option value="Bà Rịa - Vũng Tàu">Bà Rịa - Vũng Tàu</option>
                            <option value="Bạc Liêu">Bạc Liêu</option>
                            <!-- More provinces here -->
                        </select>
                    </div>

                    <!-- Switch icon -->
                    <div class="absolute top-[60px] left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 rotate-180">
                        <img src="<%= getServletContext().getContextPath()%>/assets/images/icons/switch_location.svg" alt="switch" class="w-12 h-12" />
                    </div>

                    <!-- Destination -->
                    <div class="flex-1 relative">
                        <label class="block text-base font-semibold text-[#ef5222] mb-2">Destination</label>
                        <select class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md">
                            <option value="">Select destination</option>
                            <option value="An Giang">An Giang</option>
                            <option value="Bà Rịa - Vũng Tàu">Bà Rịa - Vũng Tàu</option>
                            <option value="Bạc Liêu">Bạc Liêu</option>
                            <!-- More provinces here -->
                        </select>
                    </div>
                </div>

                <!-- Date & Tickets -->
                <div class="flex gap-6 w-full">
                    <!-- Departure Date -->
                    <div class="flex-1">
                        <label class="block text-base font-semibold text-[#ef5222] mb-2">Departure Date</label>
                        <input type="date" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md" />
                    </div>

                    <!-- Tickets -->
                    <div class="flex-1 relative">
                        <label class="block text-base font-semibold text-[#ef5222] mb-2">Tickets</label>
                        <div class="relative">
                            <select class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg font-medium bg-white focus:border-[#fc7b4c] focus:ring-4 focus:ring-orange-100 transition-all duration-300 appearance-none hover:shadow-md">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                            </select>
                            <span class="absolute top-1/2 right-3 -translate-y-1/2 pointer-events-none">
                                <img src="<%= getServletContext().getContextPath()%>/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-8 h-8" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search Button -->
            <div class="absolute -bottom-6 left-1/2 transform -translate-x-1/2">
                <button class="bg-gradient-to-r from-[#ef5222] to-[#fc7b4c] hover:from-[#fc7b4c] hover:to-[#ef5222] text-white text-lg font-bold px-16 py-4 rounded-full shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center gap-3">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                    View Trips
                </button>
            </div>
        </div>

        <!-- Destination Filter -->
        <div class="mt-16 mb-6 flex justify-end items-center gap-3">
            <label class="text-base font-medium text-[#ef5222]">Filter by Destination:</label>
            <div class="relative">
                <select class="h-12 min-w-[200px] border border-[#ef5222] rounded-xl px-4 pr-10 text-base font-medium text-gray-700 bg-white shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-100 appearance-none">
                    <option value="">All</option>
                    <option value="Vinh Long">Vinh Long</option>
                    <option value="Long An">Long An</option>
                    <option value="Da Lat">Da Lat</option>
                    <!-- More destinations here -->
                </select>
                <span class="absolute top-1/2 right-3 -translate-y-1/2 pointer-events-none">
                    <img src="<%= getServletContext().getContextPath()%>/assets/images/icons/arrow_down_select.svg" alt="dropdown" class="w-6 h-6" />
                </span>
            </div>
        </div>

        <!-- Trip List -->
        <div class="mt-6 space-y-6">
            <!-- Repeat this block for each trip -->
            <div class="border border-orange-200 rounded-3xl shadow-lg p-6 hover:shadow-xl transition duration-300">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
                    <!-- Trip Info -->
                    <div class="flex items-center gap-4 flex-1">
                        <img src="<%= getServletContext().getContextPath()%>/assets/images/icons/bus_icon.svg" alt="bus" class="text-[#ef5222] w-8 h-8 flex-shrink-0 drop-shadow-sm" />
                        <div class="flex flex-col">
                            <p class="text-lg font-bold text-gray-800">Bus Trip No. 1</p>
                            <p class="text-sm text-gray-500">Ho Chi Minh → Long An</p>
                            <p class="text-sm text-gray-500">Departure: 09:30 - Arrival: 11:30</p>
                        </div>
                    </div>

                    <!-- Seat Info -->
                    <div class="text-sm text-gray-600 leading-relaxed flex-1">
                        <p>Bus Type: <span class="font-medium text-[#273581]">Seat (34 seats)</span></p>
                        <p>Available: 12/34</p>
                        <div class="flex flex-col gap-1 mt-2">
                            <span class="px-3 py-1 rounded-full text-white text-xs w-fit bg-green-700">Top row</span>
                            <span class="px-3 py-1 rounded-full text-white text-xs w-fit bg-orange-500">Up floor</span>
                        </div>
                    </div>

                    <!-- Price + Button -->
                    <div class="text-right flex flex-col items-end flex-shrink-0">
                        <p class="text-xl font-bold text-[#ef5222] mb-2">120,000 VND</p>
                        <a href="${pageContext.servletContext.contextPath}/book-ticket"><button class="px-6 py-2 bg-[#ef5222] text-white font-semibold rounded-full hover:bg-[#fc7b4c] transition">
                                View Details
                            </button></a>
                    </div>
                </div>
            </div>

            
            <!-- End of trip block -->
        </div>
                                </br>
                                <a class="flex justify-center" href="${pageContext.servletContext.contextPath}/view-trips"><button class="bg-gradient-to-r from-[#ef5222] to-[#fc7b4c] hover:from-[#fc7b4c] hover:to-[#ef5222] text-white text-lg font-bold px-8 py-2 rounded-full shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center gap-3">
                    View More Trips
                </button></a>
        <!-- Global Pagination -->
        <div class="flex justify-center mt-8 space-x-2">
            <button class="w-10 h-10 flex items-center justify-center border border-[#ef5222] rounded-full text-[#ef5222] font-semibold hover:bg-[#ef5222] hover:text-white transition">&lt;</button>
            <span class="w-10 h-10 flex items-center justify-center font-semibold text-[#ef5222]">1 / 4</span>
            <button class="w-10 h-10 flex items-center justify-center border border-[#ef5222] rounded-full text-[#ef5222] font-semibold hover:bg-[#ef5222] hover:text-white transition">&gt;</button>
        </div>
    </div>



    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>