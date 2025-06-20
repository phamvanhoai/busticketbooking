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

            <!-- Route Stops -->
            <div>
                <h3 class="text-xl font-semibold mb-2">Route Stops</h3>
                <table id="stops-table" class="w-full table-auto border-collapse mb-4">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="px-4 py-2 text-left">#</th>
                            <th class="px-4 py-2 text-left">Location</th>
                            <th class="px-4 py-2 text-left">Dwell (min)</th>
                            <th class="px-4 py-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sp" items="${empty stops ? fn:split('0',',') : stops}" varStatus="ss">
                            <tr class="stop-row">
                                <td class="px-4 py-2 stop-index">${ss.index + 1}</td>
                                <td class="px-4 py-2">
                                    <select name="stops[${ss.index}].locationId" class="w-full border rounded px-2 py-1">
                                        <option value="" disabled ${not empty stops ? '' : 'selected'}>Select</option>
                                        <c:forEach var="loc" items="${locations}">
                                            <option value="${loc.locationId}"
                                                    ${not empty stops && loc.locationId == sp.locationId ? 'selected' : ''}>
                                                ${loc.locationName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td class="px-4 py-2">
                                    <input type="number" name="stops[${ss.index}].dwellMinutes" min="0"
                                           class="w-full border rounded px-2 py-1"
                                           value="${not empty stops ? sp.dwellMinutes : ''}" />
                                </td>
                                <td class="px-4 py-2 text-right space-x-2">
                                    <button type="button" class="move-up">↑</button>
                                    <button type="button" class="move-down">↓</button>
                                    <button type="button" class="remove-stop text-red-600">✕</button>
                                </td>
                            </tr>
                            <c:if test="${not empty stops} == false">
                                <c:set var="_" value="${fn:substring('',0,0)}" />
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
                <button type="button" id="addStop" class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
                    + Add Stop
                </button>
            </div>

            <!-- Route Prices -->
            <div>
                <h3 class="text-xl font-semibold mb-2">Route Prices</h3>
                <table id="prices-table" class="w-full table-auto border-collapse mb-4">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="px-4 py-2 text-left">#</th>
                            <th class="px-4 py-2 text-left">Vehicle Class</th>
                            <th class="px-4 py-2 text-left">Price (₫)</th>
                            <th class="px-4 py-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Existing or placeholder rows -->
                        <c:forEach var="pr" items="${empty prices ? fn:split('0',',') : prices}" varStatus="ps">
                            <tr class="price-row">
                                <td class="px-4 py-2 price-index">${ps.index + 1}</td>
                                <td class="px-4 py-2">
                                    <select name="prices[${ps.index}].busTypeId" required class="w-full border rounded px-2 py-1">
                                        <option value="" disabled ${not empty prices ? '' : 'selected'}>Select</option>
                                        <c:forEach var="bt" items="${busTypes}">
                                            <option value="${bt.busTypeId}"
                                                    ${not empty prices && bt.busTypeId == pr.busTypeId ? 'selected' : ''}>
                                                ${bt.busTypeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td class="px-4 py-2">
                                    <input type="number" name="prices[${ps.index}].price" step="0.01" required
                                           class="w-full border rounded px-2 py-1" placeholder="e.g. 500000"
                                           value="${not empty prices ? fn:substringBefore(pr.price, '.') : ''}"/>
                                </td>
                                <td class="px-4 py-2 text-right space-x-2">
                                    <button type="button" class="remove-price text-red-600">✕</button>
                                </td>
                            </tr>
                            <c:if test="${not empty prices} == false">
                                <!-- only one placeholder, break after first -->
                                <c:set var="_" value="${fn:substring('',0,0)}" />
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
                <button type="button" id="addPrice" class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
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
        // Price handlers
        const priceTbody = document.querySelector('#prices-table tbody');
        function updatePrices() {
            priceTbody.querySelectorAll('.price-row').forEach((row, i) => {
                row.querySelector('.price-index').textContent = i + 1;
                row.querySelector('select').name = `prices[${i}].busTypeId`;
                row.querySelector('input').name = `prices[${i}].price`;
            });
        }
        function attachPriceEvents(row) {
            row.querySelector('.remove-price').addEventListener('click', () => {
                row.remove();
                updatePrices()
            });
        }
        priceTbody.querySelectorAll('.price-row').forEach(attachPriceEvents);
        document.getElementById('addPrice').addEventListener('click', () => {
            const clone = priceTbody.querySelector('.price-row').cloneNode(true);
            attachPriceEvents(clone);
            priceTbody.appendChild(clone);
            updatePrices();
        });

        // Stop handlers
        const stopTbody = document.querySelector('#stops-table tbody');
        function updateStops() {
            stopTbody.querySelectorAll('.stop-row').forEach((row, i) => {
                row.querySelector('.stop-index').textContent = i + 1;
                row.querySelector('select').name = `stops[${i}].locationId`;
                row.querySelector('input').name = `stops[${i}].dwellMinutes`;
            });
        }
        function attachStopEvents(row) {
            row.querySelector('.remove-stop').addEventListener('click', () => {
                row.remove();
                updateStops()
            });
            row.querySelector('.move-up').addEventListener('click', () => {
                const prev = row.previousElementSibling;
                if (prev) {
                    stopTbody.insertBefore(row, prev);
                    updateStops()
                }
            });
            row.querySelector('.move-down').addEventListener('click', () => {
                const nxt = row.nextElementSibling;
                if (nxt) {
                    stopTbody.insertBefore(nxt, row);
                    updateStops()
                }
            });
        }
        stopTbody.querySelectorAll('.stop-row').forEach(attachStopEvents);
        document.getElementById('addStop').addEventListener('click', () => {
            const clone = stopTbody.querySelector('.stop-row').cloneNode(true);
            attachStopEvents(clone);
            stopTbody.appendChild(clone);
            updateStops();
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>