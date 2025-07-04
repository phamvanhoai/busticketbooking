<%-- 
    Document   : signup
    Created on : Jun 11, 2025, 12:50:09 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10 mx-auto">
        <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
            Create new account
        </h2>

        <c:if test="${not empty requestScope.errors}">
            <div style="color: red;">
                <c:forEach var="error" items="${requestScope.errors}">
                    <p>${error}</p>
                </c:forEach>
            </div>
        </c:if>

        <!-- Tabs -->
        <div class="flex justify-center mb-8 border-b border-gray-200">
            <a href="login" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent">
                LOG IN
            </a>
            <button class="px-6 py-2 font-semibold text-sm border-b-2 text-[#ef5222] border-[#ef5222]">
                REGISTER
            </button>
        </div>

        <!-- SIGN UP Form -->
        <form action="${pageContext.servletContext.contextPath}/signup" method="POST" class="space-y-5">
            <div class="relative">
                <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="text" name="name" placeholder="Full name" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
            </div>
            <div class="relative">
                <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
            </div>
            <!-- Password -->
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
                    name="password"
                    id="password"
                    placeholder="Password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
                <i
                    id="togglePassword"
                    class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"
                    ></i>
            </div>
            <!-- Confirm Password -->
            <div class="relative">
                <i class="fas fa-key absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input
                    type="password"
                    name="confirm_password"
                    id="confirmPassword"
                    placeholder="Confirm password"
                    class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]"
                    required />
                <i
                    id="toggleConfirmPassword"
                    class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"
                    ></i>
            </div>
            <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
                Confirm
            </button>
        </form>
    </div>

    <%@include file="/WEB-INF/include/footer.jsp" %>

    <!-- Toggle Script -->
    <script>
        const togglePassword = document.getElementById("togglePassword");
        const passwordInput = document.getElementById("password");

        togglePassword.addEventListener("click", function () {
            const isHidden = passwordInput.type === "password";
            passwordInput.type = isHidden ? "text" : "password";
            this.classList.toggle("fa-eye-slash");
            this.classList.toggle("fa-eye");
        });

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