<%-- 
    Document   : change-password
    Created on : Jun 13, 2025, 9:40:11 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10 mx-auto">
        <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
            Change Password
        </h2>

<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
        <!-- Display error messages if there are any -->
>>>>>>> Stashed changes
=======
        <!-- Display error messages if there are any -->
>>>>>>> Stashed changes
        <c:if test="${not empty requestScope.errors}">
            <div style="color: red;">
                <c:forEach var="error" items="${requestScope.errors}">
                    <p>${error}</p>
                </c:forEach>
            </div>
        </c:if>

<<<<<<< Updated upstream
<<<<<<< Updated upstream
        <!-- Tabs -->
=======
        <!-- Tabs for login/register -->
>>>>>>> Stashed changes
=======
        <!-- Tabs for login/register -->
>>>>>>> Stashed changes
        <div class="flex justify-center mb-8 border-b border-gray-200">
            <a href="login" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent">
                LOG IN
            </a>
            <button class="px-6 py-2 font-semibold text-sm border-b-2 text-[#ef5222] border-[#ef5222]">
                CHANGE PASSWORD
            </button>
        </div>

        <!-- Change Password Form -->
        <form action="${pageContext.servletContext.contextPath}/profile/change-password" method="POST" class="space-y-5">
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            <!-- Old Password -->
=======
            <!-- Current Password -->
>>>>>>> Stashed changes
=======
            <!-- Current Password -->
>>>>>>> Stashed changes
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
<<<<<<< Updated upstream
<<<<<<< Updated upstream
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

=======
=======
>>>>>>> Stashed changes
                    name="currentPassword"
                    id="currentPassword"
                    placeholder="Current Password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
            </div>
            
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
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
=======
    <!-- Toggle Password Visibility Script -->
    <script>
>>>>>>> Stashed changes
=======
    <!-- Toggle Password Visibility Script -->
    <script>
>>>>>>> Stashed changes
        const toggleNewPassword = document.getElementById("toggleNewPassword");
        const newPasswordInput = document.getElementById("newPassword");

        toggleNewPassword.addEventListener("click", function () {
            const isHidden = newPasswordInput.type === "password";
            newPasswordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });

<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // Toggle visibility for Confirm New Password
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
        const confirmPasswordInput = document.getElementById("confirmPassword");

        toggleConfirmPassword.addEventListener("click", function () {
            const isHidden = confirmPasswordInput.type === "password";
            confirmPasswordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });
    </script>
</body>
