<%-- 
    Document   : edit-route
    Created on : Jun 11, 2025, 1:33:58 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<body class="bg-gray-50">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h2 class="text-3xl font-bold text-[#EF5222] mb-6">Update Route</h2>

        <form action="${pageContext.request.contextPath}/admin/routes" method="post" class="space-y-6">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="routeId" value="${route.routeId}" />

            <!-- Origin -->
            <div>
                <label class="block mb-1 font-medium">Origin</label>
                <select name="startLocationId" class="w-full border rounded-lg px-4 py-2" required>
                    <option value="" disabled>Select origin</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}"
                                ${loc.locationId == route.startLocationId ? 'selected' : ''}>
                            ${loc.locationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Destination -->
            <div>
                <label class="block mb-1 font-medium">Destination</label>
                <select name="endLocationId" class="w-full border rounded-lg px-4 py-2" required>
                    <option value="" disabled>Select destination</option>
                    <c:forEach var="loc" items="${locations}">
                        <option value="${loc.locationId}"
                                ${loc.locationId == route.endLocationId ? 'selected' : ''}>
                            ${loc.locationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Distance -->
            <div>
                <label class="block mb-1 font-medium">Distance (km)</label>
                <input type="number" name="distance" step="any" class="w-full border rounded-lg px-4 py-2"
                       required value="${route.distanceKm}" />
            </div>

            <!-- Estimated Time -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-medium">Hours</label>
                    <input type="number" name="hours" min="0" class="w-full border rounded-lg px-4 py-2"
                           required value="${routeHours}" />
                </div>
                <div>
                    <label class="block mb-1 font-medium">Minutes</label>
                    <input type="number" name="minutes" min="0" max="59" class="w-full border rounded-lg px-4 py-2"
                           required value="${routeMinutes}" />
                </div>
            </div>

            <!-- Status -->
            <div>
                <label class="block mb-1 font-medium">Status</label>
                <select name="routeStatus" class="w-full border rounded-lg px-4 py-2" required>
                    <option value="Active"   ${route.routeStatus=='Active'   ? 'selected':''}>Active</option>
                    <option value="Inactive" ${route.routeStatus=='Inactive' ? 'selected':''}>Inactive</option>
                </select>
            </div>

            <!-- Route Stops -->
            <div>
                <h3 class="text-xl font-semibold mb-2">Route Stops</h3>
                <table id="stops-table" class="table-fixed w-full border-collapse mb-4">
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="px-4 py-2">#</th>
                            <th class="px-4 py-2">Location</th>
                            <th class="px-4 py-2">Dwell (min)</th>
                            <th class="px-4 py-2">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- 1) Template-row ẨN -->
                        <tr class="stop-row template-row" style="display:none">
                            <td class="px-4 py-2 stop-index">#</td>
                            <td class="px-4 py-2">
                                <select class="w-full border rounded px-2 py-1">
                                    <option value="" disabled selected>Select</option>
                                    <c:forEach var="loc" items="${locations}">
                                        <option value="${loc.locationId}">${loc.locationName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2">
                                <input type="number" min="0" placeholder="e.g. 5"
                                       class="w-full border rounded px-2 py-1"/>
                            </td>
                            <td class="px-4 py-2 text-right space-x-2">
                                <button type="button" class="move-up">↑</button>
                                <button type="button" class="move-down">↓</button>
                                <button type="button" class="remove-stop text-red-600">✕</button>
                            </td>
                        </tr>

                        <!-- 2) Hàng dữ liệu cũ do server render -->
                        <c:choose>
                            <c:when test="${not empty stops}">
                                <c:forEach var="sp" items="${stops}" varStatus="ss">
                                    <tr class="stop-row">
                                        <td class="px-4 py-2 stop-index">${ss.index + 1}</td>
                                        <td class="px-4 py-2">
                                            <select name="stops[${ss.index}].locationId"
                                                    class="w-full border rounded px-2 py-1" required>
                                                <option value="" disabled>Select</option>
                                                <c:forEach var="loc" items="${locations}">
                                                    <option value="${loc.locationId}"
                                                            ${loc.locationId == sp.locationId ? 'selected':''}>
                                                        ${loc.locationName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td class="px-4 py-2">
                                            <input type="number" name="stops[${ss.index}].dwellMinutes"
                                                   min="0" class="w-full border rounded px-2 py-1" required
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
                                        <select name="stops[0].locationId"
                                                class="w-full border rounded px-2 py-1" required>
                                            <option value="" selected>Select</option>
                                            <c:forEach var="loc" items="${locations}">
                                                <option value="${loc.locationId}">${loc.locationName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td class="px-4 py-2">
                                        <input type="number" name="stops[0].dwellMinutes"
                                               min="0" class="w-full border rounded px-2 py-1"
                                               placeholder="0" required/>
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
            <div class="mt-6">
                <h3 class="text-xl font-semibold mb-2">Route Prices</h3>
                <table id="prices-table" class="table-fixed w-full border-collapse mb-4">
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="px-4 py-2">#</th>
                            <th class="px-4 py-2">Vehicle Class</th>
                            <th class="px-4 py-2">Price (₫)</th>
                            <th class="px-4 py-2">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- 1) Template-row ẨN -->
                        <tr class="price-row template-row" style="display:none">
                            <td class="px-4 py-2 price-index">#</td>
                            <td class="px-4 py-2">
                                <select class="w-full border rounded px-2 py-1">
                                    <option value="" disabled selected>Select</option>
                                    <c:forEach var="bt" items="${busTypes}">
                                        <option value="${bt.busTypeId}">${bt.busTypeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td class="px-4 py-2">
                                <input type="number" min="0" step="1"
                                       class="w-full border rounded px-2 py-1" placeholder="e.g. 500000"/>
                            </td>
                            <td class="px-4 py-2 text-right">
                                <button type="button" class="remove-price text-red-600">✕</button>
                            </td>
                        </tr>

                        <!-- 2) Hàng dữ liệu cũ do server render -->
                        <c:choose>
                            <c:when test="${not empty prices}">
                                <c:forEach var="pr" items="${prices}" varStatus="ps">
                                    <tr class="price-row">
                                        <td class="px-4 py-2 price-index">${ps.index + 1}</td>
                                        <td class="px-4 py-2">
                                            <select name="prices[${ps.index}].busTypeId"
                                                    class="w-full border rounded px-2 py-1" required>
                                                <option value="" disabled>Select</option>
                                                <c:forEach var="bt" items="${busTypes}">
                                                    <option value="${bt.busTypeId}"
                                                            ${bt.busTypeId == pr.busTypeId ? 'selected':''}>
                                                        ${bt.busTypeName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td class="px-4 py-2">
                                            <input type="number" name="prices[${ps.index}].price"
                                                   min="0" step="1"
                                                   class="w-full border rounded px-2 py-1" required
                                                   value="${fn:substringBefore(pr.price,'.')}"/>
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
                                        <select name="prices[0].busTypeId"
                                                class="w-full border rounded px-2 py-1" required>
                                            <option value="" selected>Select</option>
                                            <c:forEach var="bt" items="${busTypes}">
                                                <option value="${bt.busTypeId}">${bt.busTypeName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td class="px-4 py-2">
                                        <input type="number" name="prices[0].price"
                                               min="0" step="1"
                                               class="w-full border rounded px-2 py-1" required
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
                <a href="${pageContext.request.contextPath}/admin/routes">
                    <button type="button"
                            class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded">
                        Cancel
                    </button>
                </a>
                <button type="submit"
                        class="bg-[#EF5222] hover:bg-orange-600 text-white px-6 py-2 rounded">
                    Update
                </button>
            </div>
        </form>
    </div>



    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // 1) Lấy form và các tbody
            const form = document.querySelector('form[action$="/admin/routes"]');
            const stopBody = document.querySelector('#stops-table tbody');
            const priceBody = document.querySelector('#prices-table tbody');
            const addStopBtn = document.getElementById('addStop');
            const addPriceBtn = document.getElementById('addPrice');
            if (!form || !stopBody || !priceBody)
                return;

            // Mẫu row (template-row) ẩn
            const stopTpl = stopBody.querySelector('tr.template-row');
            const priceTpl = priceBody.querySelector('tr.template-row');

            // Hàm cập nhật số thứ tự
            function updateStopIndices() {
                stopBody.querySelectorAll('tr.stop-row:not(.template-row)').forEach((row, i) => {
                    row.querySelector('.stop-index').textContent = i + 1;
                });
            }
            function updatePriceIndices() {
                priceBody.querySelectorAll('tr.price-row:not(.template-row)').forEach((row, i) => {
                    row.querySelector('.price-index').textContent = i + 1;
                });
            }

            // Thêm Stop
            addStopBtn.addEventListener('click', () => {
                const clone = stopTpl.cloneNode(true);
                clone.classList.remove('template-row');
                clone.style.display = '';
                stopBody.appendChild(clone);
                updateStopIndices();
            });

            // Thêm Price
            addPriceBtn.addEventListener('click', () => {
                const clone = priceTpl.cloneNode(true);
                clone.classList.remove('template-row');
                clone.style.display = '';
                priceBody.appendChild(clone);
                updatePriceIndices();
            });

            // Xử lý click cho Stops (remove, move up/down)
            stopBody.addEventListener('click', e => {
                const btn = e.target.closest('button');
                if (!btn)
                    return;
                const row = btn.closest('tr');
                if (btn.classList.contains('remove-stop')) {
                    row.remove();
                    updateStopIndices();
                } else if (btn.classList.contains('move-up')) {
                    const prev = row.previousElementSibling;
                    if (prev && !prev.classList.contains('template-row')) {
                        stopBody.insertBefore(row, prev);
                        updateStopIndices();
                    }
                } else if (btn.classList.contains('move-down')) {
                    const next = row.nextElementSibling;
                    if (next) {
                        stopBody.insertBefore(next, row);
                        updateStopIndices();
                    }
                }
            });

            // Xử lý click cho Prices (remove)
            priceBody.addEventListener('click', e => {
                const btn = e.target.closest('button');
                if (btn && btn.classList.contains('remove-price')) {
                    const row = btn.closest('tr');
                    row.remove();
                    updatePriceIndices();
                }
            });

            // Khởi tạo chỉ số lần đầu
            updateStopIndices();
            updatePriceIndices();

            // Trước khi submit: tạo hidden inputs và disable originals
            form.addEventListener('submit', () => {
                // Stops
                stopBody.querySelectorAll('tr.stop-row:not(.template-row)').forEach(row => {
                    const sel = row.querySelector('select');
                    const inp = row.querySelector('input');
                    if (sel.value && inp.value) {
                        const hLoc = document.createElement('input');
                        hLoc.type = 'hidden';
                        hLoc.name = 'stopsLocationId[]';
                        hLoc.value = sel.value;
                        form.appendChild(hLoc);

                        const hD = document.createElement('input');
                        hD.type = 'hidden';
                        hD.name = 'stopsDwellMinutes[]';
                        hD.value = inp.value;
                        form.appendChild(hD);
                    }
                    sel.disabled = true;
                    inp.disabled = true;
                });

                // Prices
                priceBody.querySelectorAll('tr.price-row:not(.template-row)').forEach(row => {
                    const sel = row.querySelector('select');
                    const inp = row.querySelector('input');
                    if (sel.value && inp.value) {
                        const hBT = document.createElement('input');
                        hBT.type = 'hidden';
                        hBT.name = 'pricesBusTypeId[]';
                        hBT.value = sel.value;
                        form.appendChild(hBT);

                        const hP = document.createElement('input');
                        hP.type = 'hidden';
                        hP.name = 'pricesPrice[]';
                        hP.value = inp.value;
                        form.appendChild(hP);
                    }
                    sel.disabled = true;
                    inp.disabled = true;
                });
            });
        });
    </script>



    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>