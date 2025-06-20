<%-- 
    Document   : add-route
    Created on : Jun 11, 2025, 1:34:49 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Create Route</h2>

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
            <input type="hidden" name="action" value="create" />

            <!-- Origin (Start Location) -->
            <div>
                <label for="startLocationId" class="block mb-1 font-medium">Origin</label>
                <select id="startLocationId" name="startLocationId" required
                        class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]">
                    <option value="" disabled selected>Select origin</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}">${loc.locationName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Destination (End Location) -->
            <div>
                <label for="endLocationId" class="block mb-1 font-medium">Destination</label>
                <select id="endLocationId" name="endLocationId" required
                        class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]">
                    <option value="" disabled selected>Select destination</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}">${loc.locationName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Distance (km) -->
            <div>
                <label for="distance" class="block mb-1 font-medium">Distance (km)</label>
                <input
                    id="distance"
                    name="distance"
                    type="number"
                    step="any"
                    required
                    class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"
                    placeholder="e.g. 1700"
                    />
            </div>

            <!-- Estimated Time -->
            <div class="flex space-x-4">
                <div class="flex-1">
                    <label for="hours" class="block mb-1 font-medium">Hours</label>
                    <input id="hours" name="hours" type="number" min="0" value="0" required
                           class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"/>
                </div>
                <div class="flex-1">
                    <label for="minutes" class="block mb-1 font-medium">Minutes</label>
                    <input id="minutes" name="minutes" type="number" min="0" max="59" value="0" required
                           class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]"/>
                </div>
            </div>

            <!-- Status -->
            <div>
                <label for="routeStatus" class="block mb-1 font-medium">Status</label>
                <select id="routeStatus" name="routeStatus" class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
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
                        <tr class="stop-row">
                            <td class="px-4 py-2 stop-index">1</td>
                            <td class="px-4 py-2">
                                <select name="stops[0].locationId"
                                        class="w-full border rounded px-2 py-1">
                                    <option value="" disabled selected>Select stop</option>
                                    <c:forEach var="loc" items="${locations}">
                                        <option value="${loc.locationId}">${loc.locationName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2">
                                <input type="number" name="stops[0].dwellMinutes" min="0" placeholder="e.g. 5"
                                       class="w-full border rounded px-2 py-1"/>
                            </td>
                            <td class="px-4 py-2 text-right space-x-2">
                                <button type="button" class="move-up" title="Move up">↑</button>
                                <button type="button" class="move-down" title="Move down">↓</button>
                                <button type="button" class="remove-stop text-red-600" title="Remove">✕</button>
                            </td>
                        </tr>
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
                        <tr class="price-row">
                            <td class="px-4 py-2 price-index">1</td>
                            <td class="px-4 py-2">
                                <select name="prices[0].busTypeId" required class="w-full border rounded px-2 py-1">
                                    <option value="" disabled selected>Select class</option>
                                    <c:forEach var="bt" items="${busTypes}">
                                        <option value="${bt.busTypeId}">${bt.busTypeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2">
                                <input type="number" name="prices[0].price" step="0.01" required
                                       class="w-full border rounded px-2 py-1" placeholder="e.g. 500000" />
                            </td>
                            <td class="px-4 py-2 text-right space-x-2">
                                <button type="button" class="remove-price text-red-600">✕</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="button" id="addPrice"
                        class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
                    + Add Price
                </button>
            </div>


            <!-- Actions -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.servletContext.contextPath}/admin/routes">
                    <button type="button" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-lg">
                        Cancel
                    </button>
                </a>
                <button type="submit" class="bg-[#EF5222] hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg">
                    Create
                </button>
            </div>
        </form>
    </div>
    <script>
        const priceTbody = document.querySelector('#prices-table tbody');
        const priceTemplate = document.querySelector('.price-row');

        function updatePrices() {
            priceTbody.querySelectorAll('.price-row').forEach((row, idx) => {
                row.querySelector('.price-index').textContent = idx + 1;
                row.querySelector('select').name = `prices[${idx}].busTypeId`;
                row.querySelector('input').name = `prices[${idx}].price`;
            });
        }

        document.getElementById('addPrice').addEventListener('click', () => {
            const clone = priceTemplate.cloneNode(true);
            clone.querySelector('.remove-price')
                    .addEventListener('click', () => {
                        clone.remove();
                        updatePrices();
                    });
            priceTbody.appendChild(clone);
            updatePrices();
        });

        priceTemplate.querySelector('.remove-price')
                .addEventListener('click', (e) => {
                    priceTemplate.remove();
                    updatePrices();
                });
    </script>



    <script>
        let stopIndex = 0;
        const tableBody = document.querySelector('#stops-table tbody');
        const templateRow = document.querySelector('.stop-row');

        function updateStops() {
            const rows = Array.from(tableBody.querySelectorAll('.stop-row'));
            rows.forEach((row, idx) => {
                row.querySelector('.stop-index').textContent = idx + 1;
                row.querySelector('select').name = `stops[${idx}].locationId`;
                row.querySelector('input').name = `stops[${idx}].dwellMinutes`;
            });
        }

        function addRow() {
            stopIndex++;
            const clone = templateRow.cloneNode(true);
            tableBody.appendChild(clone);
            attachRowEvents(clone);
            updateStops();
        }

        function attachRowEvents(row) {
            row.querySelector('.remove-stop').addEventListener('click', () => {
                row.remove();
                updateStops();
            });
            row.querySelector('.move-up').addEventListener('click', () => {
                const prev = row.previousElementSibling;
                if (prev) {
                    tableBody.insertBefore(row, prev);
                    updateStops();
                }
            });
            row.querySelector('.move-down').addEventListener('click', () => {
                const next = row.nextElementSibling;
                if (next) {
                    tableBody.insertBefore(next, row);
                    updateStops();
                }
            });
        }

        document.getElementById('addStop').addEventListener('click', addRow);
        document.querySelectorAll('.stop-row').forEach(attachRowEvents);
    </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>