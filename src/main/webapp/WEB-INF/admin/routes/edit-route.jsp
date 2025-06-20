<%-- 
    Document   : edit-route
    Created on : Jun 11, 2025, 1:33:58 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Update Route</h2>

        <!-- Flash messages -->
        <c:if test="${not empty success}">
            <div class="flex items-center gap-2 p-3 mb-4 bg-green-50 border-l-4 border-green-400 text-green-700 rounded">
                <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 
                      10.586 7.707 9.293a1 1 0 10-1.414 
                      1.414L9 13.414l4.707-4.707z"
                      clip-rule="evenodd"/>
                </svg>
                <span class="text-sm font-medium">${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="flex items-center gap-2 p-3 mb-4 bg-red-50 border-l-4 border-red-400 text-red-700 rounded">
                <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd"
                      d="M8.257 3.099c.765-1.36 2.72-1.36 
                      3.485 0l5.516 9.814A1.75 1.75 
                      0 0116.516 15H3.484a1.75 1.75 
                      0 01-1.742-2.087L8.257 3.1zM11 
                      13a1 1 0 10-2 0 1 1 0 002 
                      0zm-.25-2.75a.75.75 0 
                      00-1.5 0v1.5a.75.75 0 
                      001.5 0v-1.5z"
                      clip-rule="evenodd"/>
                </svg>
                <span class="text-sm font-medium">${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/routes" method="post" class="space-y-6">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="routeId" value="${route.routeId}" />

            <!-- Origin -->
            <div>
                <label for="startLocationId" class="block mb-1 font-medium">Origin</label>
                <select id="startLocationId" name="startLocationId" required
                        class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]">
                    <option value="" disabled>Select origin</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}" ${loc.locationId == route.startLocationId ? 'selected' : ''}>
                            ${loc.locationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Destination -->
            <div>
                <label for="endLocationId" class="block mb-1 font-medium">Destination</label>
                <select id="endLocationId" name="endLocationId" required
                        class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]">
                    <option value="" disabled>Select destination</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}" ${loc.locationId == route.endLocationId ? 'selected' : ''}>
                            ${loc.locationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Distance -->
            <div>
                <label for="distance" class="block mb-1 font-medium">Distance (km)</label>
                <input id="distance" name="distance" type="number" step="any" required
                       class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                       value="${route.distanceKm}" />
            </div>

            <!-- Estimated Time -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="hours" class="block mb-1 font-medium">Hours</label>
                    <input id="hours" name="hours" type="number" min="0" required
                           class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                           value="${routeHours}" />
                </div>
                <div>
                    <label for="minutes" class="block mb-1 font-medium">Minutes</label>
                    <input id="minutes" name="minutes" type="number" min="0" max="59" required
                           class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                           value="${routeMinutes}" />
                </div>
            </div>

            <!-- Status -->
            <div>
                <label for="routeStatus" class="block mb-1 font-medium">Status</label>
                <select id="routeStatus" name="routeStatus" class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]" required>
                    <option value="Active"   ${route.routeStatus=='Active'   ? 'selected':''}>Active</option>
                    <option value="Inactive" ${route.routeStatus=='Inactive' ? 'selected':''}>Inactive</option>
                </select>
            </div>

            <!-- Route Stops -->
            <div class="mt-6">
                <h3 class="text-xl font-semibold mb-2">Route Stops</h3>
                <table id="stops-table" class="table-fixed w-full border-collapse mb-4">
                    <colgroup>
                        <col class="w-1/12"/><!-- # -->
                        <col class="w-7/12"/><!-- Location -->
                        <col class="w-2/12"/><!-- Dwell -->
                        <col class="w-2/12"/><!-- Actions -->
                    </colgroup>
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="px-4 py-2 text-left">#</th>
                            <th class="px-4 py-2 text-left">Location</th>
                            <th class="px-4 py-2 text-left">Dwell (min)</th>
                            <th class="px-4 py-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>

                            <c:when test="${not empty stops}">
                                <c:forEach var="sp" items="${stops}" varStatus="ss">
                                    <tr class="stop-row">
                                        <td class="px-4 py-2 stop-index">${ss.index + 1}</td>
                                        <td class="px-4 py-2">
                                            <select name="stops[].locationId" class="w-full border rounded px-2 py-1">
                                                <option value="" disabled>Select</option>
                                                <c:forEach var="loc" items="${locations}">
                                                    <option value="${loc.locationId}"
                                                            ${loc.locationId == sp.locationId ? 'selected' : ''}>
                                                        ${loc.locationName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td class="px-4 py-2">
                                            <input type="number" name="stops[].dwellMinutes" min="0"
                                                   class="w-full border rounded px-2 py-1"
                                                   value="${sp.dwellMinutes}"/>
                                        </td>
                                        <td class="px-4 py-2 text-right space-x-2">
                                            <button type="button" class="move-up">↑</button>
                                            <button type="button" class="move-down">↓</button>
                                            <button type="button" class="remove-stop text-red-600">✕</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr class="stop-row">
                                    <td class="px-4 py-2 stop-index">1</td>
                                    <td class="px-4 py-2">
                                        <select name="stops[].locationId" class="w-full border rounded px-2 py-1">
                                            <option value="" selected>Select</option>
                                            <c:forEach var="loc" items="${locations}">
                                                <option value="${loc.locationId}">${loc.locationName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td class="px-4 py-2">
                                        <input type="number" name="stops[].dwellMinutes" min="0"
                                               class="w-full border rounded px-2 py-1"
                                               placeholder="0"/>
                                    </td>
                                    <td class="px-4 py-2 text-right">
                                        <button type="button" class="remove-stop text-red-600">✕</button>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <button id="addStop" type="button"
                        class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
                    + Add Stop
                </button>
            </div>

            <!-- Route Prices -->
            <div class="mt-8">
                <h3 class="text-xl font-semibold mb-2">Route Prices</h3>
                <table id="prices-table" class="table-fixed w-full border-collapse mb-4">
                    <colgroup>
                        <col class="w-1/12"/><!-- # -->
                        <col class="w-7/12"/><!-- Vehicle Class -->
                        <col class="w-2/12"/><!-- Price -->
                        <col class="w-2/12"/><!-- Actions -->
                    </colgroup>
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="px-4 py-2 text-left">#</th>
                            <th class="px-4 py-2 text-left">Vehicle Class</th>
                            <th class="px-4 py-2 text-left">Price (₫)</th>
                            <th class="px-4 py-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>

                            <c:when test="${not empty prices}">
                                <c:forEach var="pr" items="${prices}" varStatus="ps">
                                    <tr class="price-row">
                                        <td class="px-4 py-2 price-index">${ps.index + 1}</td>
                                        <td class="px-4 py-2">
                                            <select name="prices[].busTypeId" class="w-full border rounded px-2 py-1">
                                                <option value="" disabled>Select</option>
                                                <c:forEach var="bt" items="${busTypes}">
                                                    <option value="${bt.busTypeId}"
                                                            ${bt.busTypeId == pr.busTypeId ? 'selected' : ''}>
                                                        ${bt.busTypeName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td class="px-4 py-2">
                                            <input type="number" name="prices[].price" step="1" min="0"
                                                   class="w-full border rounded px-2 py-1"
                                                   value="${fn:substringBefore(pr.price, '.')}"/>
                                        </td>
                                        <td class="px-4 py-2 text-right">
                                            <button type="button" class="remove-price text-red-600">✕</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr class="price-row">
                                    <td class="px-4 py-2 price-index">1</td>
                                    <td class="px-4 py-2">
                                        <select name="prices[].busTypeId" class="w-full border rounded px-2 py-1">
                                            <option value="" selected>Select</option>
                                            <c:forEach var="bt" items="${busTypes}">
                                                <option value="${bt.busTypeId}">${bt.busTypeName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td class="px-4 py-2">
                                        <input type="number" name="prices[].price" step="1" min="0"
                                               class="w-full border rounded px-2 py-1"
                                               placeholder="e.g. 500000"/>
                                    </td>
                                    <td class="px-4 py-2 text-right">
                                        <button type="button" class="remove-price text-red-600">✕</button>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <button id="addPrice" type="button"
                        class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
                    + Add Price
                </button>
            </div>


            <!-- Actions -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.servletContext.contextPath}/admin/routes">
                    <button type="button" class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded">
                        Cancel
                    </button>
                </a>
                <button type="submit" class="bg-[#EF5222] hover:bg-orange-600 text-white px-6 py-2 rounded">
                    Update
                </button>
            </div>
        </form>
    </div>

    <script>
        // Đồng bộ chỉ số cho cả hai bảng
        function syncTable(tableId, rowClass, idxClass, inputNames) {
            const tbody = document.querySelector(`#${tableId} tbody`);
            tbody.querySelectorAll(`.${rowClass}`).forEach((row, i) => {
                row.querySelector(`.${idxClass}`).textContent = i + 1;
                Object.entries(inputNames).forEach(([selector, namePattern]) => {
                    const el = row.querySelector(selector);
                    if (el)
                        el.name = namePattern.replace('[]', `[${i}]`);
                });
            });
        }

        // Price handlers
        const priceTbody = document.querySelector('#prices-table tbody');
        const priceRow = priceTbody.querySelector('.price-row');
        document.getElementById('addPrice').onclick = () => {
            const nr = priceRow.cloneNode(true);
            priceTbody.append(nr);
            nr.querySelector('.remove-price').onclick = () => {
                nr.remove();
                syncTable('prices-table', 'price-row', 'price-index', {
                    'select': 'prices[].busTypeId', 'input[type=number]': 'prices[].price'
                });
            };
            syncTable('prices-table', 'price-row', 'price-index', {
                'select': 'prices[].busTypeId', 'input[type=number]': 'prices[].price'
            });
        };
        priceTbody.querySelectorAll('.remove-price').forEach(btn =>
            btn.onclick = () => {
                btn.closest('tr').remove();
                syncTable('prices-table', 'price-row', 'price-index', {
                    'select': 'prices[].busTypeId', 'input[type=number]': 'prices[].price'
                });
            }
        );

        // Stop handlers
        const stopTbody = document.querySelector('#stops-table tbody');
        const stopRow = stopTbody.querySelector('.stop-row');
        document.getElementById('addStop').onclick = () => {
            const nr = stopRow.cloneNode(true);
            stopTbody.append(nr);
            nr.querySelector('.remove-stop').onclick = () => {
                nr.remove();
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            };
            nr.querySelector('.move-up').onclick = () => {
                const prev = nr.previousElementSibling;
                if (prev)
                    stopTbody.insertBefore(nr, prev);
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            };
            nr.querySelector('.move-down').onclick = () => {
                const next = nr.nextElementSibling;
                if (next)
                    stopTbody.insertBefore(next, nr);
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            };
            syncTable('stops-table', 'stop-row', 'stop-index', {
                'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
            });
        };
        stopTbody.querySelectorAll('.remove-stop').forEach(btn =>
            btn.onclick = () => {
                btn.closest('tr').remove();
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            }
        );
        stopTbody.querySelectorAll('.move-up').forEach(btn =>
            btn.onclick = () => {
                const row = btn.closest('tr'), prev = row.previousElementSibling;
                if (prev)
                    stopTbody.insertBefore(row, prev);
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            }
        );
        stopTbody.querySelectorAll('.move-down').forEach(btn =>
            btn.onclick = () => {
                const row = btn.closest('tr'), next = row.nextElementSibling;
                if (next)
                    stopTbody.insertBefore(next, row);
                syncTable('stops-table', 'stop-row', 'stop-index', {
                    'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
                });
            }
        );

        // Khởi tạo đồng bộ lần đầu
        syncTable('prices-table', 'price-row', 'price-index', {
            'select': 'prices[].busTypeId', 'input[type=number]': 'prices[].price'
        });
        syncTable('stops-table', 'stop-row', 'stop-index', {
            'select': 'stops[].locationId', 'input[type=number]': 'stops[].dwellMinutes'
        });
    </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>