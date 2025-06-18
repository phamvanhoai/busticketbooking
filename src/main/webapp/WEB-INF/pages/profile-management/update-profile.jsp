<%-- 
    Document   : update-profile
    Created on : Jun 13, 2025, 9:40:30 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page import="busticket.model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <h1 class="text-3xl font-bold text-gray-800 mb-10 text-center">
            Edit Profile
        </h1>

        <form action="<%= request.getContextPath() %>/profile/update" method="POST">
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
                        <input type="text" name="name" value="<%= request.getAttribute("userProfile") != null ? ((Users) request.getAttribute("userProfile")).getName() : "" %>"
                               class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]" />
                    </div>

                    <!-- Phone Number -->
                    <div class="flex flex-col">
                        <label class="text-sm font-semibold text-gray-700 mb-1">Phone Number</label>
                        <input type="text" name="phone" value="<%= request.getAttribute("userProfile") != null ? ((Users) request.getAttribute("userProfile")).getPhone() : "" %>"
                               class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]" />
                    </div>

                    <!-- Gender Dropdown -->
                    <div class="flex flex-col">
                        <label class="text-sm font-semibold text-gray-700 mb-1">Gender</label>
                        <select name="gender" class="w-full rounded-xl bg-gray-100 px-4 py-3 text-base shadow-inner text-gray-800 outline-none">
                            <option value="Male" <%= ((Users) request.getAttribute("userProfile")).getGender().equals("Male") ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= ((Users) request.getAttribute("userProfile")).getGender().equals("Female") ? "selected" : "" %>>Female</option>
                        </select>
                    </div>

                    <!-- Email -->
                    <div class="flex flex-col">
                        <label class="text-sm font-semibold text-gray-700 mb-1">Email</label>
                        <input type="email" name="email" value="<%= request.getAttribute("userProfile") != null ? ((Users) request.getAttribute("userProfile")).getEmail() : "" %>"
                               class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]" />
                    </div>

                    <!-- Date of Birth -->
                    <div class="flex flex-col">
                        <label class="text-sm font-semibold text-gray-700 mb-1">Date of Birth</label>
                        <input type="date" name="birthdate" value="<%= request.getAttribute("userProfile") != null ? ((Users) request.getAttribute("userProfile")).getBirthdate().toLocalDateTime().toLocalDate().toString() : "" %>"
                               class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]" />
                    </div>

                    <!-- Address -->
                    <div class="flex flex-col">
                        <label class="text-sm font-semibold text-gray-700 mb-1">Address</label>
                        <input type="text" name="address" value="<%= request.getAttribute("userProfile") != null ? ((Users) request.getAttribute("userProfile")).getAddress() : "" %>"
                               class="px-4 py-3 bg-gray-100 rounded-xl shadow-inner text-gray-800 text-base min-h-[44px]" />
                    </div>
                </div>
            </div>

            <!-- Update Button -->
            <div class="mt-10 flex justify-center">
                <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white font-semibold py-3 px-10 rounded-full shadow-lg transition">
                    Update
                </button>
            </div>
        </form>
    </div>

    <%@include file="/WEB-INF/include/footer.jsp" %>
</body>