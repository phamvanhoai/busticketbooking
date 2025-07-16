<%-- 
    Document   : header
    Created on : May 21, 2025, 3:20:18 PM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="user" value="${sessionScope.currentUser}"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>FBus Lines</title>
        <!-- Link tới CDN TailwindCSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Font Awesome -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all.min.css">

        <style>
            style>
            .nav-link {
                transition: all 0.2s ease;
            }
            .nav-link:hover {
                text-decoration: none;
                font-weight: bold;
            }
            .nav-link.active {
                color: #ffffff; /* Màu trắng để nổi bật */
                font-weight: bold;
                border-radius: 4px; /* Bo góc */
                border-bottom: 4px solid #ffffff; /* Đường viền dưới trắng */
                transition: all 0.2s ease;
            }
            .nav-link.active:hover {
                text-decoration: none; /* Bỏ gạch chân khi hover trên active */
                filter: brightness(1.1); /* Làm sáng khi hover */
            }
            
        </style>
    </style>
</head>
<body class="bg-[#fff6f3] min-h-screen">

    <!-- Header -->
    <header class="bg-gradient-to-b from-[#EF5222] to-[#ff7e38] shadow-md">
        <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center text-white">
            <div class="font-bold text-lg">
                <img src="<%= getServletContext().getContextPath()%>/assets/images/logo.png" alt="FBus Lines" class="h-10 inline-block">
            </div>
            <nav class="flex gap-6 text-sm font-medium">
                <a href="${pageContext.request.contextPath}/" class="nav-link <%= request.getRequestURI().endsWith("home.jsp") ? "active" : ""%>">Home</a>
                <a href="${pageContext.request.contextPath}/schedule" class="nav-link <%= request.getRequestURI().endsWith("schedule.jsp") ? "active" : ""%>">Schedule</a>
                <a href="${pageContext.request.contextPath}/search-ticket" class="nav-link <%= request.getRequestURI().endsWith("search-ticket.jsp") ? "active" : ""%>">Search Ticket</a>
                <c:choose>
                    <c:when test="${not empty user}">
                        <!-- Admin Panel Link -->
                        <c:if test="${user.role eq 'Admin'}">
                            <a href="${pageContext.servletContext.contextPath}/admin/users" class="nav-link">
                                <span>Admin Panel</span>
                            </a>
                        </c:if>

                        <!-- Staff Panel Link -->
                        <c:if test="${user.role eq 'Staff'}">
                            <a href="${pageContext.servletContext.contextPath}/staff/booking-statistics" class="nav-link">
                                <span>Staff Dashboard</span>
                            </a>
                        </c:if>

                        <!-- Driver Panel Link -->
                        <c:if test="${user.role eq 'Driver'}">
                            <a href="${pageContext.servletContext.contextPath}/driver/dashboard" class="nav-link">
                                <span>Driver Dashboard</span>
                            </a>
                        </c:if>

                        <!-- Nếu user đã đăng nhập, hiển thị menu dropdown -->
                        <div class="relative">
                            <button id="dropdown-button" class="flex items-center gap-2 text-white">

                                <span class="font-medium">${user.name}</span>
                                <i class="fas fa-chevron-down"></i>
                            </button>

                            <!-- Dropdown Menu -->
                            <div id="dropdown-menu" class="absolute right-0 mt-2 w-48 bg-white shadow-lg rounded-md z-50 hidden">
                                <a href="${pageContext.servletContext.contextPath}/profile/view" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-user-circle text-yellow-500 mr-2"></i> Account Information
                                </a>
                                <a href="${pageContext.servletContext.contextPath}/ticket-management" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-history text-blue-500 mr-2"></i> View Bookings
                                </a>
                                <a href="${pageContext.servletContext.contextPath}/profile/change-password" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-key text-orange-500 mr-2"></i> Reset Password
                                </a>
                                <a href="${pageContext.servletContext.contextPath}/logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    <i class="fas fa-sign-out-alt text-red-500 mr-2"></i> Logout
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.servletContext.contextPath}/login" class="nav-link <%= request.getRequestURI().endsWith("login.jsp") ? "active" : ""%>"">
                            <span>Sign in</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>
</body>                
<script>
    // Get the button and menu elements
    const dropdownButton = document.getElementById('dropdown-button');
    const dropdownMenu = document.getElementById('dropdown-menu');

    // Toggle dropdown visibility when button is clicked
    dropdownButton.addEventListener('click', function () {
        dropdownMenu.classList.toggle('hidden');  // Show or hide the dropdown menu
    });
</script>
