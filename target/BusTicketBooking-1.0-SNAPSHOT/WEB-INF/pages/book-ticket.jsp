<%-- 
    Document   : book-ticket
    Created on : Jun 13, 2025, 12:39:26 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#fff6f3] min-h-screen">

    <div class="w-full bg-[#f3f3f5] py-1">
        <h1 class="text-2xl font-bold text-[#ef5222] text-center">Book Ticket</h1>
    </div>
    <div class="w-full flex justify-center px-2 py-6 bg-[#f3f3f5]">
        <div class="flex flex-col lg:flex-row w-full max-w-[1100px] gap-6">
            <!-- Left Column - Main Form with border -->
            <div class="w-full lg:w-2/3 border rounded-xl bg-white">
                <div class="p-6">
                    <!-- Choose Seats -->
                    <h2 class="text-lg font-bold text-gray-800">Choose Seat</h2>
                    <table class="w-full mt-4">
                        <tbody>
                            <tr>
                                <td>
                                    <img src="/images/icons/seat_active.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    01
                                </td>
                                <td>
                                    <img src="/images/icons/seat_active.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    02
                                </td>
                                <td>
                                    <img src="/images/icons/seat_disabled.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    03
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="/images/icons/seat_active.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    04
                                </td>
                                <td>
                                    <img src="/images/icons/seat_selecting.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    05
                                </td>
                                <td>
                                    <img src="/images/icons/seat_active.svg" alt="seat" class="w-8 h-8 mx-auto" />
                                    06
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="divide py-[2px]"></div>

                <div class="p-6 space-y-6">
                    <h2 class="text-lg font-bold text-gray-800">
                        Customer information
                    </h2>
                    <form class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <div class="flex flex-col gap-4">
                            <div>
                                <label class="text-sm font-medium">Full name *</label>
                                <input type="text" class="w-full rounded border p-2 mt-1" value="Nguyễn Thành Trương" />
                            </div>
                            <div>
                                <label class="text-sm font-medium">Phone number *</label>
                                <input type="text" class="w-full rounded border p-2 mt-1" value="0973898830" />
                            </div>
                            <div>
                                <label class="text-sm font-medium">Email *</label>
                                <input type="email" class="w-full rounded border p-2 mt-1" value="truongtn.dev@gmail.com" />
                            </div>
                        </div>

                        <div class="text-sm text-gray-600">
                            <p class="font-bold text-orange-600 mb-2">TERMS AND POLICIES</p>
                            <p class="mb-2">
                                (*) Please be at the departure station of the bus at least 30 minutes before departure time, bring the confirmed email which contains the reservation code in order from the FBUS system. Please contact Hotline <span class="text-orange-600 font-medium">1900 6067</span> for support.
                            </p>
                            <p>
                                (*) Please call <span class="text-orange-600 font-medium">1900 6918</span> for shuttle bus service. Shuttle bus services range is limited, therefore, we will not pick passengers who are outside the range of service. Thank you!
                            </p>
                        </div>

                        <div class="lg:col-span-2">
                            <label class="text-sm text-gray-600 flex items-center gap-2 mt-2">
                                <input type="checkbox" />
                                <span>
                                    Accept <span class="underline text-orange-500">terms</span> ticket
                                    booking & information privacy policy of FBUS Bus Lines
                                </span>
                            </label>
                        </div>
                    </form>
                </div>

                <div class="divide py-[2px]"></div>

                <div class="p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <h2 class="text-lg font-bold text-black">Pickup-Dropoff information</h2>
                        <img src="/images/icons/info_white.svg" alt="info" class="w-5 h-5 icon-orange" />
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 divide-x">
                        <div class="pr-6">
                            <label class="block text-xs font-bold text-gray-700 mb-1 tracking-wide uppercase">Pickup Point</label>
                                <!-- Pickup Point Select Dropdown -->
                                <select class="w-full bg-white border rounded-md py-2 px-4 text-sm">
                                    <option value="can-tho">Cần Thơ</option>
                                    <option value="ho-chi-minh">Hồ Chí Minh</option>
                                    <option value="da-nang">Đà Nẵng</option>
                                    <!-- Add more options as needed -->
                                </select>
                                <img src="/images/icons/arrow_down_select.svg" alt="dropdown" class="w-5 h-5 absolute right-4 top-1/2 transform -translate-y-1/2" />
                            
                            <p class="text-sm mt-2 text-gray-700">
                                Please be present at <span class="font-medium">Cần Thơ</span><br />
                                <span class="text-red-600 font-medium">Before 03:45 10/06/2025</span><br />
                                for transportation or check information before boarding.
                            </p>
                        </div>

                        <div class="pl-6 mt-6 sm:mt-0">
                            <label class="block text-xs font-bold text-gray-700 mb-1 tracking-wide uppercase">Dropoff Point</label>
                                <!-- Dropoff Point Select Dropdown -->
                                <select class="w-full bg-white border rounded-md py-2 px-4 text-sm">
                                    <option value="chau-doc">Châu Đốc</option>
                                    <option value="can-tho">Cần Thơ</option>
                                    <option value="long-an">Long An</option>
                                    <!-- Add more options as needed -->
                                </select>
                                <img src="/images/icons/arrow_down_select.svg" alt="dropdown" class="w-5 h-5 absolute right-4 top-1/2 transform -translate-y-1/2" />
                        </div>
                    </div>

                </div>

                <div class="divide py-[2px]"></div>

                <div class="p-6 flex items-center justify-between">
                    <div class="flex flex-col">
                        <span class="w-16 text-xs text-center rounded-xl bg-[#00613D] py-1 text-white">FPTUPAY</span>
                        <span class="text-2xl font-medium text-black mt-2">150,000 VND</span>
                    </div>
                    <div class="flex gap-4">
                        <button class="w-28 border border-gray-400 rounded-full py-2 font-semibold hover:bg-gray-100">Cancel</button>
                        <button class="w-28 bg-orange-500 text-white rounded-full py-2 font-semibold hover:bg-orange-600">Payment</button>
                    </div>
                </div>
            </div>

            <!-- Right Column - Trip Info / Price Detail -->
            <div class="flex flex-col w-full lg:w-1/3 gap-6">
                <div class="rounded-xl border bg-white px-4 py-3 text-[15px]">
                    <p class="text-xl font-medium text-black">Trip information</p>
                    <div class="mt-4 flex justify-between">
                        <span class="text-gray-600">Routes</span>
                        <span class="text-right">Can Tho – Chau Doc</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Departure time</span>
                        <span class="text-green-700">04:00 10/06/2025</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Number of seats</span>
                        <span>2 Seat</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Seat</span>
                        <span class="text-green-700">A01, A02</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Dropoff</span>
                        <span>Châu Đốc</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Total trip amount</span>
                        <span class="text-orange-600">150,000 VND</span>
                    </div>
                </div>

                <div class="rounded-xl border bg-white px-4 py-3 text-[15px]">
                    <p class="text-xl font-medium text-black">Price details</p>
                    <div class="mt-4 flex justify-between">
                        <span class="text-gray-600">Trip fare</span>
                        <span class="text-orange-600">150,000 VND</span>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <span class="text-gray-600">Payment fees</span>
                        <span class="text-black">0 VND</span>
                    </div>
                    <div class="my-2 border-t"></div>
                    <div class="flex justify-between">
                        <span class="text-gray-600">Total amount</span>
                        <span class="text-orange-600">150,000 VND</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>