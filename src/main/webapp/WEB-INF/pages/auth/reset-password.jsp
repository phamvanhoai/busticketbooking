<%-- 
    Document   : reset-password
    Created on : Jun 11, 2025, 10:53:42 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">

    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10 mx-auto">
        <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
            Reset your password
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

        <!-- Reset Password Form -->
        <form action="${pageContext.request.contextPath}/reset-password" method="POST" class="space-y-5">
            <input type="hidden" name="token" value="${token}">
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="password" name="newPassword" placeholder="New Password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
                <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
            </div>
            <div class="relative">
                <i class="fas fa-key absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
                <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
            </div>
            <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
                Reset Password
            </button>
            <div class="text-right">
                <a href="login" class="text-[#ef5222] text-sm font-medium hover:underline">
                    Back to login
                </a>
            </div>
        </form>
    </div>


    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>