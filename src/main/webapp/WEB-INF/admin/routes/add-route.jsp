<%-- 
    Document   : add-route
    Created on : Jun 11, 2025, 1:34:49 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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


            <!-- Status -->
            <div>
                <label for="routeStatus" class="block mb-1 font-medium">Status</label>
                <select id="routeStatus" name="routeStatus" class="w-full border rounded-lg px-4 py-2 focus:outline-[#EF5222]" required>
                    <option value="" disabled selected>Select Status</option>
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
                            <th class="px-4 py-2 text-center">#</th>
                            <th class="px-4 py-2 text-center">Location</th>
                            <th class="px-4 py-2 text-center">Travel<br/>(h:m)</th>
                            <th class="px-4 py-2 text-center">Dwell<br/>(min)</th>
                            <th class="px-4 py-2 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="stop-row template-row" style="display:none">
                            <td class="px-4 py-2 stop-index text-center">1</td>
                            <td class="px-4 py-2 text-center">
                                <select class="w-full border rounded px-2 py-1 text-center">
                                    <option value="" disabled selected>Select stop</option>
                                    <c:forEach var="loc" items="${locations}">
                                        <option value="${loc.locationId}">${loc.locationName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2 text-center">
                                <div class="flex justify-center items-center gap-1">
                                    <input type="number" min="0" placeholder="h"
                                           class="travel-hour border rounded px-1 py-1 text-center"
                                           style="width:56px"/>
                                    <span>:</span>
                                    <input type="number" min="0" max="59" placeholder="m"
                                           class="travel-min border rounded px-1 py-1 text-center"
                                           style="width:56px"/>
                                </div>
                            </td>
                            <td class="px-4 py-2 text-center">
                                <input type="number" min="0" placeholder="e.g. 5"
                                       class="dwell-min border rounded px-2 py-1 text-center"
                                       style="width:72px"/>
                            </td>
                            <td class="px-4 py-2 text-center space-x-2">
                                <button type="button" class="move-up" title="Move up">↑</button>
                                <button type="button" class="move-down" title="Move down">↓</button>
                                <button type="button" class="remove-stop text-red-600" title="Remove">✕</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="button" id="addStop"
                        class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg">
                    + Add Stop
                </button>
            </div>


            <!-- Route Prices -->
            <div class="mt-6">
                <h3 class="text-xl font-semibold mb-2">Route Prices</h3>
                <table id="prices-table" class="w-full table-auto border-collapse mb-4">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="px-4 py-2 text-center">#</th>
                            <th class="px-4 py-2 text-center">Vehicle Class</th>
                            <th class="px-4 py-2 text-center">Price (₫)</th>
                            <th class="px-4 py-2 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="price-row template-row" style="display:none">
                            <td class="px-4 py-2 price-index text-center">1</td>
                            <td class="px-4 py-2 text-center">
                                <select class="w-full border rounded px-2 py-1 text-center">
                                    <option value="" disabled selected>Select class</option>
                                    <c:forEach var="bt" items="${busTypes}">
                                        <option value="${bt.busTypeId}">${bt.busTypeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2 text-center">
                                <input type="number" step="0.01" class="w-full border rounded px-2 py-1 text-center" placeholder="e.g. 500000"/>
                            </td>
                            <td class="px-4 py-2 text-center">
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
                <button type="submit" id="submitBtn" class="bg-[#EF5222] hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded-lg">
                    Create
                </button>

            </div>
        </form>
    </div>


    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.querySelector('form[action$="/admin/routes"]');
            const stopBody = document.querySelector('#stops-table tbody');
            const priceBody = document.querySelector('#prices-table tbody');
            const addStop = document.getElementById('addStop');
            const addPrice = document.getElementById('addPrice');

            // Cập nhật số thứ tự cho stops
            function updateStopIndices() {
                Array.from(stopBody.querySelectorAll('tr.stop-row:not(.template-row)'))
                        .forEach((row, i) => row.querySelector('.stop-index').textContent = i + 1);
            }
            // Cập nhật số thứ tự cho prices
            function updatePriceIndices() {
                Array.from(priceBody.querySelectorAll('tr.price-row:not(.template-row)'))
                        .forEach((row, i) => row.querySelector('.price-index').textContent = i + 1);
            }

            // Thêm Stop
            addStop.addEventListener('click', () => {
                const tpl = stopBody.querySelector('tr.template-row');
                const clone = tpl.cloneNode(true);
                clone.classList.remove('template-row');
                clone.style.display = '';
                stopBody.appendChild(clone);
                updateStopIndices();
            });

            // Thêm Price
            addPrice.addEventListener('click', () => {
                const tpl = priceBody.querySelector('tr.template-row');
                const clone = tpl.cloneNode(true);
                clone.classList.remove('template-row');
                clone.style.display = '';
                priceBody.appendChild(clone);
                updatePriceIndices();
            });

            // Delegate các nút trong stops (remove, move)
            stopBody.addEventListener('click', e => {
                const btn = e.target.closest('button');
                if (!btn)
                    return;
                const row = btn.closest('tr');
                if (btn.classList.contains('remove-stop')) {
                    row.remove();
                } else if (btn.classList.contains('move-up')) {
                    const prev = row.previousElementSibling;
                    if (prev && !prev.classList.contains('template-row')) {
                        stopBody.insertBefore(row, prev);
                    }
                } else if (btn.classList.contains('move-down')) {
                    const next = row.nextElementSibling;
                    if (next) {
                        stopBody.insertBefore(next, row);
                    }
                }
                updateStopIndices();
            });

            // Delegate nút remove trong prices
            priceBody.addEventListener('click', e => {
                const btn = e.target.closest('button');
                if (btn && btn.classList.contains('remove-price')) {
                    btn.closest('tr').remove();
                    updatePriceIndices();
                }
            });

            // Khởi tạo chỉ số ngay khi load
            updateStopIndices();
            updatePriceIndices();

            // Trước khi submit: tạo hidden inputs và disable originals
            form.addEventListener('submit', function () {
                // Stops
                Array.from(stopBody.querySelectorAll('tr.stop-row:not(.template-row)')).forEach(row => {
                    const sel = row.querySelector('select');
                    const trHour = row.querySelector('input.travel-hour');
                    const trMin = row.querySelector('input.travel-min');
                    const dwell = row.querySelector('input.dwell-min');
                    // Lấy value, mặc định 0 nếu bỏ trống
                    const h = parseInt(trHour.value) || 0;
                    const m = parseInt(trMin.value) || 0;
                    // locationId
                    if (sel.value) {
                        const hLoc = document.createElement('input');
                        hLoc.type = 'hidden';
                        hLoc.name = 'stopsLocationId[]';
                        hLoc.value = sel.value;
                        form.appendChild(hLoc);
                    }
                    // travelMinutes = h*60 + m
                    const hT = document.createElement('input');
                    hT.type = 'hidden';
                    hT.name = 'stopsTravelMinutes[]';
                    hT.value = (h * 60 + m);
                    form.appendChild(hT);

                    // dwellMinutes
                    if (dwell.value) {
                        const hD = document.createElement('input');
                        hD.type = 'hidden';
                        hD.name = 'stopsDwellMinutes[]';
                        hD.value = dwell.value;
                        form.appendChild(hD);
                    }
                    // Disable originals
                    sel.disabled = true;
                    trHour.disabled = true;
                    trMin.disabled = true;
                    dwell.disabled = true;
                });

                // Prices (giữ nguyên cũ)
                Array.from(priceBody.querySelectorAll('tr.price-row:not(.template-row)')).forEach(row => {
                    const sel = row.querySelector('select');
                    const inp = row.querySelector('input');
                    if (sel.value && inp.value) {
                        const h1 = document.createElement('input');
                        h1.type = 'hidden';
                        h1.name = 'pricesBusTypeId[]';
                        h1.value = sel.value;
                        form.appendChild(h1);

                        const h2 = document.createElement('input');
                        h2.type = 'hidden';
                        h2.name = 'pricesPrice[]';
                        h2.value = inp.value;
                        form.appendChild(h2);
                    }
                    sel.disabled = true;
                    inp.disabled = true;
                });
            });
        });
    </script>


    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>