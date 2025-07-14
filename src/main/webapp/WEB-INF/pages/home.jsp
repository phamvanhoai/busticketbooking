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


    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const switchIcon = document.getElementById('switch-icon');
            const originSelect = document.getElementById('origin');
            const destinationSelect = document.getElementById('destination');

            // Lắng nghe sự kiện khi nhấn vào icon switch
            switchIcon.addEventListener('click', () => {
                // Lấy giá trị hiện tại của origin và destination
                const originValue = originSelect.value;
                const destinationValue = destinationSelect.value;

                // Hoán đổi giá trị
                originSelect.value = destinationValue;
                destinationSelect.value = originValue;
            });
        });

    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>