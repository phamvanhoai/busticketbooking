<%-- 
    Document   : staff-header
    Created on : Jun 14, 2025, 9:20:36 PM
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
        <title>Staff Dashboard</title>
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js">
        <style>
            /* Hide the dropdown by default */
            .dropdown-content {
                display: none;
                position: absolute;
                right: 0;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
                min-width: 160px;
            }

            /* Show dropdown when hover on the profile button */
            .dropdown:hover .dropdown-content {
                display: block;
            }

            .dropdown-content a {
                padding: 12px 16px;
                text-decoration: none;
                display: block;
                color: #333;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }
        </style>
    </head>

    <body class="bg-[#f9fafb]">

        <div class=" bg-[#F7F6F3] rounded-[30px] shadow-xl overflow-hidden">
            <div class="flex text-sm text-gray-800 min-h-screen">
                <!-- Sidebar -->
                <aside class="w-60 bg-gradient-to-b from-[#FF6A2F] to-[#FA601E] text-white px-4 pt-6 pb-10 shadow-xl flex flex-col items-center">
                    <div class="mb-8 flex flex-col items-center">
                        <div class="bg-[#F7F6F3] w-12 h-12 rounded-full flex items-center justify-center text-orange-500 font-bold text-xl shadow-md">FBus</div>
                        <div class="text-xl font-bold mt-2">Staff</div>
                    </div>

                    <div class="w-full space-y-6">
                        <div class="text-xs text-gray-200 px-2 uppercase">Main</div>
                        <div class="flex flex-col gap-4">
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("staff-dashboard.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/dashboard">
                                    <span class="text-base"><i class="fas fa-tachometer-alt"></i></span>
                                    <span>Dashboard</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("view-booking-statistics.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/booking-statistics">
                                    <span class="text-base"><i class="fas fa-trophy"></i></span>
                                    <span>Booking Statistics</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("manage-bookings.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/manage-bookings">
                                    <span class="text-base"><i class="fas fa-trophy"></i></span>
                                    <span>Manage Bookings</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("view-trip-status.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/trip-status">
                                    <span class="text-base"><i class="fas fa-trophy"></i></span>
                                    <span>Trip Status</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("assign-driver-to-trip.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/assign-driver-trip">
                                    <span class="text-base"><i class="fas fa-trophy"></i></span>
                                    <span>Assign Driver</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("driver-trip.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/support-driver-trip">
                                    <span class="text-base"><i class="fas fa-table"></i></span>
                                    <span>Support Driver Trip</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("customer-trip.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="${pageContext.servletContext.contextPath}/staff/support-customer-trip">
                                    <span class="text-base"><i class="fas fa-table"></i></span>
                                    <span>Support Customer Trip</span>
                                </a>
                            </div>
                        </div>

                        <div class="text-xs text-gray-200 px-2 mt-6 uppercase">Help</div>
                        <div class="flex flex-col gap-4">
                            <div class="flex items-center gap-3 cursor-pointer px-4 py-2 <%= request.getRequestURI().endsWith("driver-dashboard.jsp") ? "bg-[#F7F6F3] text-orange-600 font-semibold pl-6 rounded-r-xl rounded-l-none shadow -ml-4" : "text-white hover:bg-orange-300/20"%>">
                                <a href="#settings">
                                    <span class="text-base"><i class="fas fa-cogs"></i></span>
                                    <span>Settings</span>
                                </a>
                            </div>
                            <div class="flex items-center gap-3 cursor-pointer text-white hover:bg-orange-300/20 px-4 py-2">
                                <a href="#support">
                                    <span class="text-base"><i class="fas fa-phone-alt"></i></span>
                                    <span>Support</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="mt-auto text-[10px] text-white text-center px-2">
                        Designed by Group 1 - SE1817 - SWP391
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="flex-1 px-4 py-6 bg-[#F7F6F3] rounded-[20px] flex flex-col gap-6">
                    <!-- Header -->
                    <header class="flex justify-between items-center bg-white p-6 rounded-2xl shadow h-[100px]">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-[#F26647] flex items-center justify-center">
                                <img src="<%= getServletContext().getContextPath()%>/assets/images/avt/avatar.png" alt="avatar" class="w-8 h-8 rounded-full" />
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-[#1E1E1E]">Hello, Team</h2>
                                <p class="text-sm text-gray-400">Have A Nice Day</p>
                            </div>
                        </div>
                        <!-- Dropdown for Panel and Profile -->
                        <div class="flex items-center gap-4">
                            <!-- Dropdown to switch Panel -->
                            <select id="panelSelector" class="bg-[#F7F6F3] text-sm text-gray-600 placeholder:text-gray-400 px-4 py-3 rounded-xl shadow-sm border border-gray-300 focus:outline-none">
                                <option value="">Select Panel</option>
                                <option value="${pageContext.servletContext.contextPath}/">Home Panel</option>
                                <option value="${pageContext.servletContext.contextPath}/admin/dashboard">Admin Panel</option>
                                <option value="${pageContext.servletContext.contextPath}/staff/dashboard">Staff Panel</option>
                                <option value="${pageContext.servletContext.contextPath}/driver/dashboard">Driver Panel</option>
                            </select>

                            <!-- Profile Dropdown -->
                            <div class="relative dropdown">
                                <button class="bg-gray-200 hover:bg-gray-300 px-4 py-2 rounded-xl text-sm text-gray-800 flex items-center gap-2">
                                    <img src="<%= getServletContext().getContextPath()%>/assets/images/avt/avatar.png" alt="avatar" class="w-6 h-6 rounded-full" />
                                    <span class="text-gray-800">Profile</span>
                                    <i class="fas fa-chevron-down"></i>
                                </button>
                                <div class="dropdown-content">
                                    <a href="${pageContext.servletContext.contextPath}/profile/view">View Profile</a>
                                    <a href="${pageContext.servletContext.contextPath}/logout">Logout</a>
                                </div>
                            </div>
                        </div>
                    </header>
