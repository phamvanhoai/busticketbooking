<%-- 
    Document   : view-profile
    Created on : Jun 13, 2025, 9:37:41 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>


<body class="bg-[#f9fafb]">

    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <h1 class="text-3xl font-bold text-gray-800 mb-10 text-center">
            View Profile
        </h1>

        <div class="flex flex-col md:flex-row items-center gap-10">
            <!-- Avatar -->
            <div class="flex flex-col items-center">
                <img
                    src="<%= getServletContext().getContextPath()%>/assets/images/avt/avatar.png"
                    alt="Avatar"
                    class="w-48 h-48 rounded-full object-cover border-4 border-orange-400 shadow-md"
                    />
                <label class="mt-4 text-center">
                    <button class="bg-orange-500 text-white py-2 px-6 rounded-full font-medium hover:bg-orange-600 transition">
                        Choose Image
                    </button>
                    <p class="text-xs text-gray-500 mt-2">
                        Maximum file size 1MB<br />Format: .JPEG, .PNG
                    </p>
                </label>
            </div>

            <!-- Profile Info -->
            <div class="flex-1 grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
                <!-- Full Name -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Full Name</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        Nguyễn Thành Trương
                    </div>
                </div>

                <!-- Phone Number -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Phone Number</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        0973898830
                    </div>
                </div>

                <!-- Gender Dropdown -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Gender</label>
                    <select
                        class="w-full rounded-xl bg-gray-100 px-4 py-3 text-base shadow-inner text-gray-800 outline-none appearance-none"
                        disabled
                        >
                        <option value="">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>

                <!-- Email -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Email</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        truongtn.dev@gmail.com
                    </div>
                </div>

                <!-- Date of Birth -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Day of Birth</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        <!-- No Date Provided in Data -->
                    </div>
                </div>

                <!-- Address -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Address</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        <!-- No Address Provided in Data -->
                    </div>
                </div>

                <!-- Career -->
                <div class="flex flex-col">
                    <label class="text-sm font-semibold text-gray-700 mb-1">Career</label>
                    <div class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]">
                        <!-- No Career Provided in Data -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Button -->
        <div class="mt-10 flex justify-center">
            <a href="${pageContext.servletContext.contextPath}/profile/update"><button class="bg-orange-500 hover:bg-orange-600 text-white font-semibold py-3 px-10 rounded-full shadow-lg transition">
                Edit
                </button></a>
        </div>
    </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>