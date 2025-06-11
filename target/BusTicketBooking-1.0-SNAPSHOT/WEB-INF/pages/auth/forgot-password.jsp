<%-- 
    Document   : forgot-password
    Created on : Jun 11, 2025, 12:52:52 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">

    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10 mx-auto">
        <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
            Forgot Password
        </h2>

        <!-- Hiển thị thông báo nếu có -->
        <c:choose>
            <c:when test="${not empty message}">
                <div style="color: green;">${message}</div>
            </c:when>
            <c:when test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:when>
        </c:choose>

        <!-- Tabs -->
        <div class="flex justify-center mb-8 border-b border-gray-200">
            <a href="login" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent">
                LOG IN
            </a>
            <a href="signup" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent">
                REGISTER
            </a>
        </div>

        <!-- Forgot Password Form -->
        <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="space-y-5">
            <div class="relative">
                <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
            </div>
            <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
                Reset Password
            </button>
        </form>
    </div>

    <script>
        function handleForgotPasswordSubmit(event) {
            event.preventDefault();
            alert("Password reset link sent!");
        }
    </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>