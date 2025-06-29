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
  .your-trip > div { display: none; }

  <c:forEach items="${trips}" var="trip" varStatus="st">
    /* panel */
    #trip${st.index+1}:checked ~ .layout .sidebar .your-trip .trip${st.index+1} {
      display: block;
    }
    /* highlight card */
    #trip${st.index+1}:checked ~ .layout .content .card:nth-of-type(${st.index+1}) {
      border-color: #fb923c;
      box-shadow: 0 0 0 2px rgba(251,146,60,0.3);
    }
  </c:forEach>
</style>


<body class="bg-gray-100 text-gray-800">
    <div class="max-w-[1024px] mx-auto">

        <!-- Flash error if origin/destination invalid -->
        <c:if test="${not empty error}">
            <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg">
                ${error}
            </div>
        </c:if>


        <!-- Form Container -->
        <div class="relative rounded-3xl border border-[rgba(239,82,34,0.6)]
             shadow-2xl px-12 py-8 min-h-[190px] bg-white backdrop-blur-md">
            <form method="get" action="${pageContext.request.contextPath}/view-trips">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                    <!-- Origin & Destination -->
                    <div class="relative flex gap-6 w-full">
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Origin</label>
                            <select name="origin" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <option value="">Select origin</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc}" <c:if test="${param.origin == loc}">selected</c:if>>
                                        ${loc}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="absolute top-[60px] left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 rotate-180">
                            <img src="${pageContext.request.contextPath}/assets/images/icons/switch_location.svg"
                                 alt="switch" class="w-12 h-12" />
                        </div>
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Destination</label>
                            <select name="destination" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <option value="">Select destination</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc}" <c:if test="${param.destination == loc}">selected</c:if>>
                                        ${loc}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Date & Tickets -->
                    <div class="flex gap-6 w-full">
                        <div class="flex-1">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Departure Date</label>
                            <input type="date" name="departureDate" value="${param.departureDate}"
                                   class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6 text-lg
                                   font-medium bg-white focus:border-[#fc7b4c] focus:ring-4
                                   focus:ring-orange-100 transition-all duration-300
                                   appearance-none hover:shadow-md"/>
                        </div>
                        <div class="flex-1 relative">
                            <label class="block text-base font-semibold text-[#ef5222] mb-2">Tickets</label>
                            <select name="tickets" class="w-full h-14 border-2 border-[#ef5222] rounded-xl px-6">
                                <c:forEach begin="1" end="8" var="i">
                                    <option value="${i}" <c:if test="${param.tickets == i}">selected</c:if>>
                                        ${i}
                                    </option>
                                </c:forEach>
                            </select>
                            <span class="absolute top-1/2 right-3 -translate-y-1/2 pointer-events-none">
                                <img src="${pageContext.request.contextPath}/assets/images/icons/arrow_down_select.svg"
                                     alt="dropdown" class="w-8 h-8" />
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Search Button -->
                <div class="absolute -bottom-6 left-1/2 transform -translate-x-1/2">
                    <button type="submit"
                            class="bg-gradient-to-r from-[#ef5222] to-[#fc7b4c]
                            hover:from-[#fc7b4c] hover:to-[#ef5222]
                            text-white text-lg font-bold px-16 py-4 rounded-full
                            shadow-xl hover:shadow-2xl transform hover:scale-105
                            transition-all duration-300 flex items-center gap-3">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2"
                              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                        View Trips
                    </button>
                </div>
            </form>
        </div>

        <!-- Radios for “YOUR TRIP” panels -->
        <c:choose>
            <c:when test="${not empty trips}">
                <c:forEach items="${trips}" var="trip" varStatus="st">
                    <input type="radio" name="selected" id="trip${st.index+1}" hidden
                           <c:if test="${st.first}">checked</c:if> />
                </c:forEach>
            </c:when>
            <c:otherwise>
                <input type="radio" name="selected" id="trip1" hidden checked/>
                <input type="radio" name="selected" id="trip2" hidden/>
                <input type="radio" name="selected" id="trip3" hidden/>
            </c:otherwise>
        </c:choose>

        <div class="layout flex max-w-6xl mx-auto py-8 px-4 gap-6">

            <!-- Sidebar: YOUR TRIP -->
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
                                            <c:set var="et" value="${trip.duration}" />
                                            <c:set var="h"  value="${fn:substringBefore(et / 60, '.')}"/>
                                            <c:set var="m"  value="${et % 60}"/>

                                            <c:choose>
                                                <c:when test="${h > 0 && m > 0}">
                                                    ${h}h${m}m
                                                </c:when>
                                                <c:when test="${h > 0}">
                                                    ${h}h
                                                </c:when>
                                                <c:otherwise>
                                                    ${m}m
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
                            <div class="trip2 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
                                <h3 class="font-semibold">YOUR TRIP</h3>
                                <p class="text-sm text-gray-600">No upcoming trip</p>
                            </div>
                            <div class="trip3 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
                                <h3 class="font-semibold">YOUR TRIP</h3>
                                <p class="text-sm text-gray-600">No upcoming trip</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- *** Your original Search Filters, exactly as you wrote them *** -->
                    <div class="bg-white rounded-xl shadow p-4 space-y-6">
                        <div class="flex justify-between items-center">
                            <h3 class="font-semibold uppercase">Search Filters</h3>
                            <button class="text-red-500 text-sm">Clear filter 🗑️</button>
                        </div>

                        <div>
                            <p class="font-medium mb-2">Departure time</p>
                            <div class="space-y-2 text-sm">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Midnight 00:00 – 06:00 (0)
                                </label>
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Morning 06:00 – 12:00 (9)
                                </label>
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Afternoon 12:00 – 18:00 (3)
                                </label>
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Evening 18:00 – 24:00 (10)
                                </label>
                            </div>
                        </div>

                        <div>
                            <p class="font-medium mb-2">Vehicle kind</p>
                            <div class="flex gap-2">
                                <button class="px-3 py-1 border rounded-full text-sm">Seat</button>
                                <button class="px-3 py-1 border rounded-full text-sm">Bunk</button>
                                <button class="px-3 py-1 border rounded-full text-sm">Limousine</button>
                            </div>
                        </div>

                        <div>
                            <p class="font-medium mb-2">Row of seats</p>
                            <div class="flex gap-2">
                                <button class="px-3 py-1 border rounded-full text-sm">Top row</button>
                                <button class="px-3 py-1 border rounded-full text-sm">Middle row</button>
                                <button class="px-3 py-1 border rounded-full text-sm">Bottom row</button>
                            </div>
                        </div>

                        <div>
                            <p class="font-medium mb-2">Floor</p>
                            <div class="flex gap-2">
                                <button class="px-3 py-1 border rounded-full text-sm">Up floor</button>
                                <button class="px-3 py-1 border rounded-full text-sm">Downstairs</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content (trip cards) -->
            <div class="content flex-1 space-y-6">
                <c:choose>
                    <c:when test="${not empty trips}">
                        <c:forEach items="${trips}" var="trip" varStatus="st">
                            <div class="card bg-white rounded-xl border border-gray-200 shadow overflow-hidden">
                                <label for="trip${st.index+1}" class="block p-4 cursor-pointer hover:shadow-lg transition">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <p class="text-lg font-bold">${trip.tripTime}</p>
                                            <p class="text-sm text-gray-600">${trip.origin}</p>
                                        </div>
                                        <div class="text-center text-sm text-gray-500">
                                            <c:choose>
                                                <c:when test="${trip.duration < 60}">
                                                    ${trip.duration}m
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="hflt" value="${trip.duration div 60}" />
                                                    <c:set var="h"    value="${fn:substringBefore(hflt, '.')}"/>
                                                    <c:set var="m"    value="${trip.duration mod 60}" />
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
                                    <button data-tab="seat"     class="px-3 py-1 hover:text-orange-500">Choose seat</button>
                                    <button data-tab="schedule" class="px-3 py-1 hover:text-orange-500">Schedule</button>
                                    <button data-tab="trans"    class="px-3 py-1 hover:text-orange-500">Transshipment</button>
                                    <button data-tab="policy"   class="px-3 py-1 hover:text-orange-500">Policy</button>
                                    <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">
                                        Select trip
                                    </button>
                                </div>
                                <!-- your original tab-content blocks, unchanged -->
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

    <!-- JS to toggle tabs (unchanged) -->
    <script>
        document.querySelectorAll('.card').forEach(card => {
            card.querySelectorAll('[data-tab]').forEach(tab => {
                tab.addEventListener('click', e => {
                    e.stopPropagation();
                    const name = tab.dataset.tab;
                    const content = card.querySelector(`.tab-content[data-content="${name}"]`);
                    const wasHidden = content.classList.contains('hidden');
                    card.querySelectorAll('.tab-content').forEach(c => c.classList.add('hidden'));
                    card.querySelectorAll('[data-tab]').forEach(t =>
                        t.classList.remove('text-orange-500', 'border-b-2', 'border-orange-500')
                    );
                    if (wasHidden) {
                        content.classList.remove('hidden');
                        tab.classList.add('text-orange-500', 'border-b-2', 'border-orange-500');
                    }
                });
            });
        });
    </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>