<%-- 
    Document   : view-user.jsp
    Description: Display detailed information of a specific user
    Author     : Nguyen Thanh Truong - CE180140
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>

<div class="w-full px-12">
    <h2 class="text-3xl font-bold text-[#EF5222] mb-6">User Details</h2>
    <!-- Main card container -->
    <div class="bg-white shadow-xl rounded-xl p-8">

        <!-- Top section: avatar + name + role -->
        <div class="flex flex-col md:flex-row gap-10">

            <div class="w-full md:w-1/4 text-center">
                <!-- Wrap avatar & icon together to control overlay spacing -->
                <div class="relative inline-block w-28 h-28 mx-auto">
                    <!-- Role-based icon over top-right corner -->
                    <c:choose>
                        <c:when test="${user.role == 'Admin'}">
                            <!-- Admin: Security Icon -->
                            <svg
                                class="absolute -top-2 -right-2 w-6 h-6 md:w-9 md:h-9 z-10"
                                viewBox="0 0 512 512"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                >
                                <defs>
                                    <linearGradient id="adminGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#EF5222" />
                                        <stop offset="100%" stop-color="#a32107" />
                                    </linearGradient>
                                </defs>
                                <g>
                                    <path
                                        d="M256.001,0L29.89,130.537c0,47.476,4.506,88.936,12.057,125.463C88.61,481.721,256.001,512,256.001,512 s167.389-30.279,214.053-256c7.551-36.527,12.057-77.986,12.057-125.463L256.001,0z"
                                        fill="url(#adminGradient)"
                                        stroke="#7A1A00"
                                        stroke-width="3"
                                        />
                                    <path
                                        d="M256.118,466.723 c-0.035-0.012-0.082-0.028-0.117-0.039v-47.672V256H140.77H91.122c-6.67-29.738-11.109-63.506-12.394-101.93L255.999,51.728h0.002 v51.73V256h115.27h49.625C385.636,413.404,287.327,456.774,256.118,466.723z"
                                        fill="#fff1ec"
                                        stroke="#EF5222"
                                        stroke-width="2"
                                        />
                                </g>
                            </svg>



                        </c:when>
                        <c:when test="${user.role == 'Staff'}">
                            <!-- Staff: 24 Hour Call Icon -->
                            <svg class="absolute -top-2 -right-2 w-6 h-6 md:w-9 md:h-9 z-10" viewBox="0 0 612.002 612.002" xmlns="http://www.w3.org/2000/svg" fill="#0EA5E9">
                                <g>
                                    <path d="M349.457,5.595c-83.85,0-158.466,39.362-206.531,100.555c10.804,8.218,19.77,19.126,27.009,29.602 
                                          c40.681-55.016,105.99-90.775,179.522-90.775c123.055,0,223.164,100.115,223.164,223.164
                                          c0,89.692-53.205,167.136-129.697,202.574c8.618,10.371,16.166,21.916,20.459,34.032
                                          c87.94-42.421,148.62-132.428,148.62-236.606C612.003,123.143,494.461,5.595,349.457,5.595z"/>
                                    <path d="M405.15,469.257c-14.899-13.521-46.7-39.723-70.697-38.942c-7.857,0.256-14.696,3.361-20.905,7.161v-0.007
                                          c0,0-0.276,0.177-0.735,0.473c-1.385,0.866-2.75,1.772-4.063,2.711l0.013,0.013c-4.299,2.986-11.06,7.922-18.693,14.466
                                          l-0.072-0.072c-0.249,0.21-0.512,0.433-0.768,0.637c-1.588,1.359-3.203,2.875-4.831,4.45c-0.059,0.053-0.118,0.092-0.158,0.144
                                          c-0.092,0.072-0.138,0.144-0.217,0.223c-8.913,8.671-18.47,19.402-30.678,20.531c-22.441,2.054-43.97-16.153-55.581-26.799
                                          c-26.156-23.957-49.733-53.08-68.413-85.36c-8.881-15.326-19.881-36.428-12.983-57.662c3.426-10.607,13.711-16.764,23.124-22.914
                                          c0.026-0.007,0.033-0.02,0.046-0.02c7.01-4.155,15.549-10.869,21.352-15.654c9.891-8.001,21.096-18.05,22.901-32.648
                                          c2.691-21.417-11.86-50.612-23.288-69.955c-10.259-17.354-28.06-47.028-49.562-50.586c-9.983-1.654-18.326,2.625-25.729,8.388
                                          c-5.008,3.682-18.87,14.072-30.751,24.627c-0.4,0.335-0.788,0.676-1.168,1.017c-1.825,1.654-3.63,3.308-5.31,4.929
                                          c0,0.02,0,0.026,0,0.026c-26.609,25.736-48.249,62-47.98,112.678c0.387,69.653,34.164,124.611,64.704,167.858
                                          c32.365,45.834,74.327,92.836,123.449,126.383c27.377,18.687,54.734,33.809,95.455,39.388
                                          c44.593,6.117,76.42-5.231,104.165-24.22c0.164-0.112,0.309-0.171,0.466-0.276c15.753-10.508,28.716-21.325,36.139-27.849
                                          c2.166-1.798,4.306-3.695,6.308-5.73c0.249-0.236,0.433-0.414,0.433-0.414l-0.02-0.026c4.306-4.476,8.27-9.603,9.445-16.403
                                          C444.177,509.006,420.049,482.83,405.15,469.257z"/>
                                    <path d="M303.886,254.022c-3.17,4.056-7.345,8.401-12.51,13.035c-5.179,4.634-11.552,10.003-19.12,16.107
                                          c-8.5,6.872-15.641,13.127-21.437,18.765c-5.796,5.638-10.233,10.777-13.318,15.411c-6.649,10.042-9.97,22.133-9.97,36.264H345.25
                                          v-29.431h-74.615c2.008-2.317,5.08-5.343,9.215-9.097c4.129-3.741,9.045-8.054,14.768-12.917
                                          c9.655-8.113,17.82-15.392,24.495-21.844c6.688-6.445,11.683-11.992,15.004-16.626c3.551-5.021,6.216-10.331,8.001-15.93
                                          c1.772-5.599,2.658-11.683,2.658-18.247c0-7.181-1.234-13.843-3.708-19.986c-2.474-6.144-6.071-11.473-10.777-15.989
                                          c-4.719-4.516-10.541-8.067-17.499-10.659c-6.951-2.586-14.873-3.879-23.747-3.879c-8.27,0-15.818,1.359-22.645,4.056
                                          c-6.846,2.704-12.766,6.531-17.787,11.467c-5.028,4.942-9.058,10.928-12.11,17.958c-3.052,7.03-4.923,14.873-5.618,23.518h32.326
                                          c0.309-5.021,1.214-9.445,2.73-13.265c1.503-3.827,3.374-7.01,5.612-9.557c2.238-2.553,4.818-4.463,7.765-5.737
                                          c2.927-1.273,6.025-1.91,9.268-1.91c7.719,0,13.672,2.068,17.84,6.196c4.174,4.135,6.255,9.905,6.255,17.321
                                          c0,4.713-0.676,9.038-2.022,12.976C309.307,245.969,307.049,249.966,303.886,254.022z"/>
                                    <path d="M462.384,353.606v-38.581h21.778v-28.499h-21.778V179.584h-24.679L361.81,290.116v24.909h69.049v38.581H462.384z
                                          M396.341,286.519l34.525-51.557v51.557H396.341z"/>
                                </g>
                            </svg>

                        </c:when>
                        <c:when test="${user.role == 'Driver'}">
                            <!-- Driver: Steering Wheel Icon -->
                            <svg class="absolute -top-2 -right-2 w-6 h-6 md:w-9 md:h-9 z-10" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg" fill="none">
                                <g>
                                    <path 
                                        d="M437.02,74.981C388.668,26.628,324.38,0,256,0S123.333,26.628,74.98,74.981C26.628,123.333,0,187.62,0,256
                                        s26.628,132.667,74.98,181.019C123.333,485.372,187.62,512,256,512s132.667-26.628,181.02-74.981
                                        C485.372,388.668,512,324.38,512,256S485.372,123.333,437.02,74.981z"
                                        fill="#D1FAE5"/>
                                    <path 
                                        d="M256,57.263c100.782,0,184.276,75.409,197.04,172.765L329.849,218.03c-13.813-26.755-41.72-45.102-73.849-45.102
                                        s-60.036,18.347-73.849,45.102L58.96,230.028C71.724,132.672,155.218,57.263,256,57.263z"
                                        fill="#34D399"/>
                                    <path 
                                        d="M58.889,281.375l121.731,9.484c7.69,16.55,20.669,30.166,36.76,38.655l7.978,122.859
                                        C138.513,438.875,70.099,368.943,58.889,281.375z"
                                        fill="#10B981"/>
                                    <path 
                                        d="M256,281.809c-14.232,0-25.809-11.578-25.809-25.809S241.77,230.191,256,230.191
                                        S281.809,241.77,281.809,256S270.232,281.809,256,281.809z"
                                        fill="#047857"/>
                                    <path 
                                        d="M286.644,452.373l7.978-122.859c16.091-8.488,29.069-22.105,36.76-38.655l121.731-9.484
                                        C441.901,368.943,373.487,438.875,286.644,452.373z"
                                        fill="#10B981"/>
                                </g>
                            </svg>


                        </c:when>

                        <c:when test="${user.role == 'Customer'}">
                            <!-- Customer: User Icon -->
                            <svg class="absolute -top-2 -right-2 w-6 h-6 md:w-7 md:h-7 z-10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" fill="none">
                                <g stroke="#db6606">
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M8.60917 36.9866C5.3218 33.3783 3.32191 28.6146 3.32191 23.3914C3.32191 12.1271 12.6184 2.99568 24.0861 2.99568C35.5539 2.99568 44.8504 12.1271 44.8504 23.3914C44.8504 31.3561 40.2009 38.2516 33.4239 41.6092C29.2775 43.771 24.5472 44.9957 19.5258 44.9957C13.3731 44.9957 7.65739 43.157 2.91748 40.0088C2.91748 40.0088 6.09606 39.6621 8.60835 36.9874L8.60917 36.9866ZM33.8397 33.4855C39.2117 28.1137 39.2117 19.4042 33.8397 14.0322C31.3487 11.5414 28.1401 10.2063 24.8794 10.0256V10.0248C24.781 7.57835 26.0979 5.92616 26.1043 5.91811L26.1036 5.91824L26.1045 5.9171C22.3569 6.64104 18.7783 8.45409 15.8764 11.356C13.6509 13.5814 12.0663 16.205 11.1216 18.9972C11.2591 18.6329 11.4124 18.2733 11.5814 17.9193C11.3865 18.4167 11.2103 18.925 11.051 19.445C9.47775 24.2209 10.5882 29.6873 14.3864 33.4855C19.7584 38.8575 28.4679 38.8575 33.8397 33.4855Z" fill="#fbcbcb"/>
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M17.1299 22.345V24.0539V25.1922C17.1299 26.3283 18.0509 27.2494 19.1872 27.2494C20.3234 27.2494 21.2443 26.3283 21.2443 25.1922V24.0522V22.345C21.2443 21.2089 20.3234 20.2877 19.1872 20.2877C18.0509 20.2877 17.1299 21.2089 17.1299 22.345Z" fill="#fbcbcb"/>
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M27.313 22.345V24.0539V25.1922C27.313 26.3283 28.2341 27.2494 29.3702 27.2494C30.5064 27.2494 31.4275 26.3283 31.4275 25.1922V24.0522V22.345C31.4275 21.2089 30.5064 20.2877 29.3702 20.2877C28.2341 20.2877 27.313 21.2089 27.313 22.345Z" fill="#fbcbcb"/>
                                </g>
                            </svg>
                        </c:when>
                    </c:choose>

                    <!-- Avatar -->
                    <img src="https://i.pravatar.cc/120?u=${user.email}" alt="Avatar"
                         class="w-full h-full rounded-full shadow" />
                </div>

                <!-- Name -->
                <p class="mt-4 text-gray-700 font-semibold">${user.name}</p>

                <!-- Role badge -->
                <c:choose>
                    <c:when test="${user.role == 'Admin'}">
                        <span class="inline-block bg-[#EF5222] text-white text-xs font-semibold px-3 py-1 rounded-full">
                            ${user.role}
                        </span>
                    </c:when>
                    <c:when test="${user.role == 'Staff'}">
                        <span class="inline-block bg-[#EF5222]/20 text-[#EF5222] text-xs font-medium px-3 py-1 rounded-full">
                            ${user.role}
                        </span>
                    </c:when>
                    <c:when test="${user.role == 'Driver'}">
                        <span class="inline-block bg-green-100 text-green-700 text-xs font-medium px-3 py-1 rounded-full">
                            ${user.role}
                        </span>
                    </c:when>
                    <c:when test="${user.role == 'Customer'}">
                        <span class="inline-block bg-blue-100 text-blue-700 text-xs font-medium px-3 py-1 rounded-full">
                            ${user.role}
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-block bg-gray-200 text-gray-600 text-xs font-medium px-3 py-1 rounded-full">
                            ${user.role}
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>




            <!-- Right: User Info Table -->
            <div class="flex-1">
                <!-- Title + Status badge -->
                <div class="flex justify-between items-center mb-4">

                    <span class="px-3 py-1 rounded-full text-sm font-medium
                          ${user.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-gray-200 text-gray-600'}">
                        ${user.status}
                    </span>
                </div>

                <!-- Information fields in grid layout -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-4 text-gray-800 text-[15px]">
                    <div><span class="font-semibold">User ID:</span> ${user.formattedId}</div>
                    <div><span class="font-semibold">Phone:</span> ${user.phone}</div>
                    <div><span class="font-semibold">Email:</span> ${user.email}</div>
                    <div><span class="font-semibold">Gender:</span> ${user.gender}</div>
                    <div><span class="font-semibold">Role:</span> ${user.role}</div>
                    <div>
                        <span class="font-semibold">Birthdate:</span> 
                        <!-- Format birthdate to dd/MM/yyyy -->
                        <fmt:formatDate value="${user.birthdate}" pattern="dd/MM/yyyy" />
                    </div>
                    <!-- Address spans full width -->
                    <div class="md:col-span-2"><span class="font-semibold">Address:</span> ${user.address}</div>
                    <div>
                        <span class="font-semibold">Created At:</span> 
                        <!-- Format created_at with date + time -->
                        <fmt:formatDate value="${user.created_at}" pattern="dd/MM/yyyy HH:mm" />
                    </div>

                    <!-- Show placeholder for password (hashed) -->
                    <div class="flex items-center gap-2">
                        <span class="font-semibold">Password:</span>
                        <!-- Password lock icon -->
                        <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c1.1 0 2 .9 2 2v4a2 2 0 01-2 2h0a2 2 0 01-2-2v-4c0-1.1.9-2 2-2z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 7V4a4 4 0 018 0v3"/>
                        </svg>
                        <!-- Masked password display -->
                        <span class="font-mono text-gray-800 bg-gray-100 px-2 py-0.5 rounded">********</span>
                        <span class="text-xs text-gray-500 ml-1">(stored hashed)</span>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${user.role == 'Driver'}">
            <div class="mt-8">
                <h3 class="text-xl font-bold text-orange-600 mb-4">License Upgrade History</h3>
                <div class="overflow-x-auto shadow-sm border rounded-lg">
                    <table class="min-w-full text-sm text-left text-gray-700">
                        <thead class="bg-orange-100 font-semibold text-gray-800">
                            <tr>
                                <th class="px-4 py-2">Old Class</th>
                                <th class="px-4 py-2">New Class</th>
                                <th class="px-4 py-2">Upgraded By</th>
                                <th class="px-4 py-2">Reason</th>
                                <th class="px-4 py-2">Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${licenseHistory}" varStatus="loop">
                                <tr class="border-b hover:bg-orange-50 transition">
                                    <td class="px-4 py-2 text-gray-800">${log.oldLicenseClass}</td>
                                    <td class="px-4 py-2 text-green-600 font-bold">${log.newLicenseClass}</td>
                                    <td class="px-4 py-2 text-gray-800">${log.adminName}</td>
                                    <td class="px-4 py-2 text-gray-800">${log.reason}</td>
                                    <td class="px-4 py-2 text-gray-600">
                                        <fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty licenseHistory}">
                                <tr>
                                    <td colspan="6" class="py-6 px-4 text-center text-gray-500">
                                        <div class="flex flex-col items-center justify-center gap-2">
                                            <svg xmlns="http://www.w3.org/2000/svg"
                                                 class="h-12 w-12 text-gray-400" fill="none"
                                                 viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M9.75 9.75h.008v.008H9.75V9.75zm4.5 0h.008v.008h-.008V9.75zM9 13.5c.75 1 2.25 1 3 0m9 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            <span class="text-sm text-gray-500 font-medium">
                                                No license upgrade history found.
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>


        <!-- Action Buttons: Back + Edit -->
        <div class="mt-8 flex justify-center gap-4">
            <!-- Back to user list -->
            <a href="${pageContext.request.contextPath}/admin/users"
               class="px-6 py-2 bg-orange-500 text-white rounded-full font-medium hover:bg-orange-600 transition">
                Back to User List
            </a>

            <!-- Go to edit page -->
            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.user_id}"
               class="px-6 py-2 bg-gray-100 text-gray-800 rounded-full font-medium hover:bg-gray-200 transition flex items-center gap-2">
                <i class="fas fa-pen-to-square"></i> Edit
            </a>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
