<%-- 
    Document   : change-password
    Created on : Jun 13, 2025, 9:40:11 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<body class="bg-[#f9fafb]">

    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <h1 class="text-3xl font-bold text-gray-800 mb-10 text-center">
            Change Password
        </h1>

        <!-- Display error messages if there are any -->
        <c:choose>
            <c:when test="${not empty message}">
                <div style="color: green;">${message}</div>
            </c:when>
            <c:when test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:when>
        </c:choose>

        <!-- Change Password Form -->
        <form action="${pageContext.servletContext.contextPath}/profile/change-password" method="POST" class="space-y-5">
            <input type="hidden" name="action" value="change-password">  <!-- Hidden field for action -->

            <!-- Current Password -->
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
                    name="oldPassword"
                    id="oldPassword"
                    placeholder="Old Password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
                <i
                    id="toggleOldPassword"
                    class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"
                    ></i>
            </div>

            <!-- New Password -->
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
                    name="newPassword"
                    id="newPassword"
                    placeholder="New Password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
                <i
                    id="toggleNewPassword"
                    class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"
                    ></i>
            </div>

            <!-- Confirm New Password -->
            <div class="relative">
                <i class="fas fa-key absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
                    name="confirmPassword"
                    id="confirmPassword"
                    placeholder="Confirm New Password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
                <i
                    id="toggleConfirmPassword"
                    class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"
                    ></i>
            </div>

            <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
                Confirm Change
            </button>
        </form>

    </div>

    <%@include file="/WEB-INF/include/footer.jsp" %>

    <!-- Toggle Script -->
    <script>
        // Toggle visibility for Old Password
        const toggleOldPassword = document.getElementById("toggleOldPassword");
        const oldPasswordInput = document.getElementById("oldPassword");

        toggleOldPassword.addEventListener("click", function () {
            const isHidden = oldPasswordInput.type === "password";
            oldPasswordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });

        // Toggle visibility for New Password

        const toggleNewPassword = document.getElementById("toggleNewPassword");
        const newPasswordInput = document.getElementById("newPassword");

        toggleNewPassword.addEventListener("click", function () {
            const isHidden = newPasswordInput.type === "password";
            newPasswordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });

        // Toggle visibility for Confirm New Password
        const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
        const confirmPasswordInput = document.getElementById("confirmPassword");

        toggleConfirmPassword.addEventListener("click", function () {
            const isHidden = confirmPasswordInput.type === "password";
            confirmPasswordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });
    </script>