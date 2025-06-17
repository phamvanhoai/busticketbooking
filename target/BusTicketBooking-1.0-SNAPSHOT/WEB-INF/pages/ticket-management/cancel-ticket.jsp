<%-- 
    Document   : cancel-ticket
    Created on : Jun 13, 2025, 8:44:18 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-5xl mx-auto px-4 py-10">
        <h2 class="text-3xl font-bold text-[#ef5222] mb-8 text-center">
            Cancel Ticket Request
        </h2>
        
        <div class="space-y-6">
            <!-- Trip 1 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Can Tho → HCM</p>
                        <p class="text-sm text-gray-600">Bus Type: Limousine (29/30 available)</p>
                        <div class="flex flex-wrap gap-2">
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#48BB78] text-white">Top row</span>
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#A0AEC0] text-white">Downstairs</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-[#ef5222] font-bold text-lg mb-2">150,000 VND</p>
                    <button class="px-4 py-2 bg-[#ef5222] text-white rounded-lg text-sm hover:bg-[#d74314]" onclick="alert('Cancellation requested for: Can Tho → HCM')">
                        Cancel Ticket
                    </button>
                </div>
            </div>

            <!-- Trip 2 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Da Nang → Hue</p>
                        <p class="text-sm text-gray-600">Bus Type: Bunk (20/40 available)</p>
                        <div class="flex flex-wrap gap-2">
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#F6AD55] text-white">Middle row</span>
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#4299E1] text-white">Up floor</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-[#ef5222] font-bold text-lg mb-2">220,000 VND</p>
                    <button class="px-4 py-2 bg-[#ef5222] text-white rounded-lg text-sm hover:bg-[#d74314]" onclick="alert('Cancellation requested for: Da Nang → Hue')">
                        Cancel Ticket
                    </button>
                </div>
            </div>

            <!-- Trip 3 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Ha Noi → Hai Phong</p>
                        <p class="text-sm text-gray-600">Bus Type: Seat (18/34 available)</p>
                        <div class="flex flex-wrap gap-2">
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#F56565] text-white">Bottom row</span>
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#4299E1] text-white">Up floor</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-[#ef5222] font-bold text-lg mb-2">180,000 VND</p>
                    <button class="px-4 py-2 bg-[#ef5222] text-white rounded-lg text-sm hover:bg-[#d74314]" onclick="alert('Cancellation requested for: Ha Noi → Hai Phong')">
                        Cancel Ticket
                    </button>
                </div>
            </div>

            <!-- Trip 4 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">HCM → Long An</p>
                        <p class="text-sm text-gray-600">Bus Type: Seat (12/34 available)</p>
                        <div class="flex flex-wrap gap-2">
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#F6AD55] text-white">Middle row</span>
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#A0AEC0] text-white">Downstairs</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-[#ef5222] font-bold text-lg mb-2">120,000 VND</p>
                    <button class="px-4 py-2 bg-[#ef5222] text-white rounded-lg text-sm hover:bg-[#d74314]" onclick="alert('Cancellation requested for: HCM → Long An')">
                        Cancel Ticket
                    </button>
                </div>
            </div>

            <!-- Trip 5 -->
            <div class="flex flex-col md:flex-row justify-between items-center border rounded-2xl shadow px-6 py-4 bg-white hover:bg-gray-50 transition">
                <div class="flex items-start gap-4">
                    <div class="text-[#ef5222] text-xl mt-1">
                        <span>🚍</span>
                    </div>
                    <div class="space-y-1">
                        <p class="font-semibold text-lg text-gray-800">Can Tho → Vinh Long</p>
                        <p class="text-sm text-gray-600">Bus Type: Limousine (10/11 available)</p>
                        <div class="flex flex-wrap gap-2">
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#48BB78] text-white">Top row</span>
                            <span class="text-xs px-2 py-1 rounded-full font-medium bg-[#A0AEC0] text-white">Downstairs</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-[#ef5222] font-bold text-lg mb-2">150,000 VND</p>
                    <button class="px-4 py-2 bg-[#ef5222] text-white rounded-lg text-sm hover:bg-[#d74314]" onclick="alert('Cancellation requested for: Can Tho → Vinh Long')">
                        Cancel Ticket
                    </button>
                </div>
            </div>
        </div>
    </div>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/footer.jsp" %>