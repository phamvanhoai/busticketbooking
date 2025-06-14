<%-- 
    Document   : add-user
    Created on : Jun 11, 2025, 12:25:46 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<body class="bg-[#f9fafb]">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Create Account</h2>
        
        <!-- Hiển thị thông báo nếu có -->
        <c:choose>
            <c:when test="${not empty requestScope.message}">
                <div style="color: green;">${message}</div>
            </c:when>
            <c:when test="${not empty requestScope.error}">
                <div style="color: red;">${error}</div>
            </c:when>
        </c:choose>
                
                <c:if test="${not empty requestScope.errors}">
            <div style="color: red;">
                <c:forEach var="error" items="${requestScope.errors}">
                    <p>${error}</p>
                </c:forEach>
            </div>
        </c:if>
                
        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="space-y-6">
            <input type="hidden" name="action" value="add">

            <div>
                <label class="block mb-1 font-medium">Full Name</label>
                <input
                    type="text"
                    name="name"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                    required
                />
            </div>

            <div>
                <label class="block mb-1 font-medium">Email</label>
                <input
                    type="email"
                    name="email"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                    required
                />
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-medium">Password</label>
                    <input
                        type="password"
                        name="password"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        required
                    />
                </div>

                <div>
                    <label class="block mb-1 font-medium">Confirm Password</label>
                    <input
                        type="password"
                        name="confirmPassword"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        required
                    />
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-medium">Role</label>
                    <select
                        name="role"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                        required
                    >
                        <option value="" disabled>Select role</option>
                        <option value="Admin">Admin</option>
                        <option value="Staff">Staff</option>
                        <option value="Driver">Driver</option>
                        <option value="Customer">Customer</option>
                    </select>
                </div>

                <div>
                    <label class="block mb-1 font-medium">Status</label>
                    <select
                        name="status"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-orange-500"
                    >
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
            </div>

            <div class="flex justify-end gap-4 pt-4">
                <button
                    type="button"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-lg"
                >
                    Cancel
                </button>
                <button
                    type="submit"
                    class="bg-orange-500 hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg"
                >
                    Submit
                </button>
            </div>
        </form>
    </div> 

<%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>
