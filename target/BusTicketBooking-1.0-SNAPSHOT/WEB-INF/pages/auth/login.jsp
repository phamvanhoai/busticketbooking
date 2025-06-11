<%-- 
    Document   : login
    Created on : Jun 11, 2025, 12:49:57 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>
<%--<%@include file="/WEB-INF/include/sidebar.jsp" %>--%>

<%@include file="/WEB-INF/include/banner.jsp" %>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">

    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10 mx-auto">
        <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
            Log in account
        </h2>



        <c:if test="${not empty requestScope.error}">
            <div style="color: red;">
                <p>${requestScope.error}</p>
            </div>
        </c:if>

        <!-- Tabs -->
        <div class="flex justify-center mb-8 border-b border-gray-200">
            <button class="px-6 py-2 font-semibold text-sm border-b-2 text-[#ef5222] border-[#ef5222]">
                LOG IN
            </button>
            <a href="signup" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent">
                REGISTER
            </a>
        </div>

        <!-- LOG IN Form -->
        <form  action="${pageContext.servletContext.contextPath}/login" method="POST" class="space-y-5">
            <div class="relative">
                <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
            </div>
            <div class="relative">
                <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
                <input type="password" name="password" placeholder="Password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
                <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
            </div>
            <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
                Login
            </button>
            <div class="text-right">
                <a href="forgot-password" class="text-[#ef5222] text-sm font-medium hover:underline">
                    Forgot password
                </a>
            </div>
        </form>
    </div>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>