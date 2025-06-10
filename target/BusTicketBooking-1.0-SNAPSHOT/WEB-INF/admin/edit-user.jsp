<%-- 
    Document   : edit-user
    Created on : Jun 10, 2025, 10:18:50 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../include/admin-header.jsp" %>
<%@include file="../include/admin-sidebar.jsp" %>

<!--begin::App Main-->
<main class="app-main">
    <!--begin::App Content Header-->
    <div class="app-content-header">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-6"><h3 class="mb-0">Edit User</h3></div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item"><a href="<%= getServletContext().getContextPath()%>">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit User</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
    <!--end::App Content Header-->

    <!--begin::App Content-->
    <div class="app-content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Edit User</h3>
                        </div>
                        <div class="card-body">
                            <!-- Kiểm tra nếu user không tồn tại -->
                            <c:choose>
                                <c:when test="${empty user}">
                                    <div class="alert alert-danger">User not found.</div>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="userId" value="${user.user_id}">

                                        <div class="mb-3">
                                            <label for="name" class="form-label">Full Name</label>
                                            <input type="text" class="form-control" id="name" name="name" value="${user.name}" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="role" class="form-label">Role</label>
                                            <select class="form-control" id="role" name="role" required>
                                                <option value="Customer" ${user.role == 'Customer' ? 'selected' : ''}>Customer</option>
                                                <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="gender" class="form-label">Gender</label>
                                            <select class="form-control" id="gender" name="gender" required>
                                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="birthdate" class="form-label">Birthdate</label>
                                            <input type="date" class="form-control" id="birthdate" name="birthdate"
                                                   value="<fmt:formatDate value="${user.birthdate}" pattern="yyyy-MM-dd" />" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select class="form-control" id="status" name="status" required>
                                                <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                                                <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Address</label>
                                            <textarea class="form-control" id="address" name="address" required>${user.address}</textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary">Update User</button>
                                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Cancel</a>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>      
</main>
<!--end::App Main-->

<%@include file="../include/admin-footer.jsp" %>
