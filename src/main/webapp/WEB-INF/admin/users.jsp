<%-- 
    Document   : users
    Created on : Jun 10, 2025, 1:53:23 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="neon" uri="/WEB-INF/tags/implicit.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="../include/admin-header.jsp" %>
<%@include file="../include/admin-sidebar.jsp" %>

<!--begin::App Main-->
<main class="app-main">
    <!--begin::App Content Header-->
    <div class="app-content-header">
        <!--begin::Container-->
        <div class="container-fluid">
            <!--begin::Row-->
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="mb-0">Users List</h3>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item"><a href="<%= getServletContext().getContextPath()%>">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Users List</li>
                    </ol>
                </div>
            </div>
            <!--end::Row-->
        </div>
        <!--end::Container-->
    </div>
    <!--end::App Content Header-->
    <!--begin::App Content-->
    <div class="app-content">
        <!--begin::Container-->
        <div class="container-fluid">
            <!--begin::Row-->
            <div class="row">
                <div class="col-md-12">
                    <div class="card mb-4">
                        <div class="card-header">
                            <form class="row row-cols-lg-auto g-3 align-items-center" action="${pageContext.servletContext.contextPath}/admin/users" method="get">
                                <div  class="col-12">
                                    <input type="text" name="search" value="${requestScope.searchQuery}" placeholder="Search for a user..." />
                                </div>
                                <div  class="col-12">
                                    <button type="submit" class="btn btn-success">Search</button>
                                    <!-- Reset Button -->
                                    <a class="btn btn-warning" href="${pageContext.servletContext.contextPath}/admin/users">Reset</a>
                                </div>
                            </form>
                                
                    <a href="?add" class="btn btn-primary float-end">Add User</a>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Create At</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr class="align-middle">
                                            <td>${user.user_id}</td>
                                            <td>${user.name}</td>
                                            <td>${user.email}</td>
                                            <td>${user.phone}</td>
                                            <td>${user.role}</td>
                                            <td>${user.status}</td>
                                            <td>${user.created_at}</td>
                                            <td>
                                                <!-- Nút Edit -->
                                                <a href="${pageContext.request.contextPath}/admin/users?editId=${user.user_id}" class="btn btn-warning btn-sm">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </c:forEach>
                            </table>
                        </div>
                        <!-- /.card-body -->
                        <!-- /.pagination -->
                        <div class="card-footer clearfix">
                            <div class="paginator">
                                ${requestScope.currentTotalUsers} from ${requestScope.totalUsers}
                            </div>

                            <c:set var="paginationUrl" value="${pageContext.servletContext.contextPath}/admin/users" />
                            <c:if test="${not empty param.search}">
                                <c:set var="paginationUrl" value="${paginationUrl}?search=${param.search}" />
                            </c:if>

                            <neon:adminpagination currentPage="${requestScope.currentPage}" totalPages="${requestScope.numOfPages}" url="${paginationUrl}" />
                        </div>

                    </div>
                    <!-- /.card -->
                </div>
                <!-- /.col -->
            </div>
            <!--end::Row-->
        </div>
        <!--end::Container-->
    </div>
    <!--end::App Content-->      
</main>
<!--end::App Main-->

<%@include file="../include/admin-footer.jsp" %>