<%-- 
    Document   : edit-bus-type
    Created on : Jun 15, 2025, 1:53:58 AM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
    <div class="mt-10">
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Update Bus Type</h1>
        <div class="bg-white border border-[#EF5222] rounded-2xl shadow-lg p-8">
            <form action="${pageContext.request.contextPath}/admin/bus-types" method="post" class="space-y-6">
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" name="id" value="${busType.busTypeId}" />
                <input type="hidden" id="layoutDown" name="layoutDown" />
                <input type="hidden" id="layoutUp" name="layoutUp" />

                <!-- Name & Description -->
                <div>
                    <label class="block text-gray-800 font-medium mb-2">Name</label>
                    <input name="name" type="text" value="${busType.busTypeName}" required
                           class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring" />
                </div>
                <div>
                    <label class="block text-gray-800 font-medium mb-2">Description</label>
                    <textarea name="description" rows="3"
                              class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring resize-none">${busType.busTypeDescription}</textarea>
                </div>

                <!-- Config inputs -->
                <div class="grid md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <h2 class="font-medium">Downstairs Setup</h2>
                        <div class="flex gap-2 items-center">
                            <label>Rows×Cols:</label>
                            <input id="rowsDown" name="rowsDown" type="number" value="${rowsDown}" min="1" max="10" class="w-16 border rounded px-2 py-1" />
                            <span>×</span>
                            <input id="colsDown" name="colsDown" type="number" value="${colsDown}" min="1" max="10" class="w-16 border rounded px-2 py-1" />
                        </div>
                        <div class="flex gap-2 items-center">
                            <label>Prefix:</label>
                            <input id="prefixDown" name="prefixDown" type="text" value="${prefixDown}" maxlength="2" class="w-16 border rounded px-2 py-1" />
                        </div>
                        <button type="button" onclick="regenTable('down')" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                            Apply Downstairs
                        </button>
                    </div>
                    <div class="space-y-2">
                        <h2 class="font-medium">Up floor Setup</h2>
                        <div class="flex gap-2 items-center">
                            <label>Rows×Cols:</label>
                            <input id="rowsUp" name="rowsUp" type="number" value="${rowsUp}" min="1" max="10" class="w-16 border rounded px-2 py-1" />
                            <span>×</span>
                            <input id="colsUp" name="colsUp" type="number" value="${colsUp}" min="1" max="10" class="w-16 border rounded px-2 py-1" />
                        </div>
                        <div class="flex gap-2 items-center">
                            <label>Prefix:</label>
                            <input id="prefixUp" name="prefixUp" type="text" value="${prefixUp}" maxlength="2" class="w-16 border rounded px-2 py-1" />
                        </div>
                        <button type="button" onclick="regenTable('up')" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                            Apply Up floor
                        </button>
                    </div>
                </div>

                <!-- Downstairs Layout -->
                <div class="mt-6">
                    <h2 class="font-semibold mb-2">Downstairs Layout</h2>
                    <div class="overflow-auto">
                        <table class="table-auto border-collapse border border-gray-300 w-full text-center">
                            <thead>
                                <tr>
                                    <th class="border p-2 bg-gray-100 font-medium"></th>
                                        <c:forEach var="c" begin="1" end="${colsDown}">
                                        <th class="border p-2 bg-gray-100 font-medium">${c}</th>
                                        </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" begin="1" end="${rowsDown}">
                                    <tr>
                                        <th class="border p-2 bg-gray-100 font-medium">${prefixDown}${r}</th>
                                            <c:forEach var="c" begin="1" end="${colsDown}">
                                                <c:set var="found" value="" />
                                                <c:forEach var="seat" items="${seatsDown}">
                                                    <c:if test="${seat.row == r && seat.col == c}">
                                                        <c:set var="found" value="${seat.code}" />
                                                    </c:if>
                                                </c:forEach>
                                            <td class="border p-2 ${found ne '' ? 'bg-[#EF5222] text-white' : ''}">
                                                ${found}
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Up floor Layout -->
                <div class="mt-4">
                    <h2 class="font-semibold mb-2">Up floor Layout</h2>
                    <div class="overflow-auto">
                        <table class="table-auto border-collapse border border-gray-300 w-full text-center">
                            <thead>
                                <tr>
                                    <th class="border p-2 bg-gray-100 font-medium"></th>
                                        <c:forEach var="c" begin="1" end="${colsUp}">
                                        <th class="border p-2 bg-gray-100 font-medium">${c}</th>
                                        </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" begin="1" end="${rowsUp}">
                                    <tr>
                                        <th class="border p-2 bg-gray-100 font-medium">${prefixUp}${r}</th>
                                            <c:forEach var="c" begin="1" end="${colsUp}">
                                                <c:set var="found" value="" />
                                                <c:forEach var="seat" items="${seatsUp}">
                                                    <c:if test="${seat.row == r && seat.col == c}">
                                                        <c:set var="found" value="${seat.code}" />
                                                    </c:if>
                                                </c:forEach>
                                            <td class="border p-2 ${found ne '' ? 'bg-[#EF5222] text-white' : ''}">
                                                ${found}
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>


                <!-- Actions -->
                <div class="flex justify-end gap-4 mt-8">
                    <button type="button" onclick="history.back()" class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400 transition">
                        Cancel
                    </button>
                    <button type="submit" class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90 transition">
                        Update
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- JSON data from server --%>
    <script>
        // JSON data from server, embed safely using JSTL
        const layout = {
            down: JSON.parse('<c:out value="${seatsDownJson}" escapeXml="false"/>'),
            up: JSON.parse('<c:out value="${seatsUpJson}" escapeXml="false"/>')
        };

        function regenTable(zone) {
            const rows = +document.getElementById('rows' + capitalize(zone)).value;
            const cols = +document.getElementById('cols' + capitalize(zone)).value;
            const prefix = document.getElementById('prefix' + capitalize(zone)).value || '';
            const arr = layout[zone];
            const table = document.getElementById('table-' + zone);
            table.innerHTML = '';

            // header
            const thead = document.createElement('thead');
            const hr = document.createElement('tr');
            hr.appendChild(createCell('th', '', true));
            for (let c = 1; c <= cols; c++)
                hr.appendChild(createCell('th', c, true));
            thead.appendChild(hr);
            table.appendChild(thead);

            // body
            const tbody = document.createElement('tbody');
            for (let r = 1; r <= rows; r++) {
                const tr = document.createElement('tr');
                tr.appendChild(createCell('th', prefix + r, true));
                for (let c = 1; c <= cols; c++) {
                    const td = createCell('td', '', false);
                    td.dataset.r = r;
                    td.dataset.c = c;
                    td.onclick = () => toggleSeat(zone, td);
                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            }
            table.appendChild(tbody);

            // populate existing codes
            arr.forEach(s => {
                const sel = `#table-${zone} td[data-r="${s.r}"][data-c="${s.c}"]`;
                const td = document.querySelector(sel);
                if (td) {
                    td.innerText = s.code;
                    td.classList.add('bg-[#EF5222]', 'text-white');
                }
            });
        }

        function createCell(tag, text, isHdr) {
            const el = document.createElement(tag);
            if (isHdr) {
                el.outerHTML = `<th class="border p-2 bg-gray-100 font-medium">${text}</th>`;
            } else {
                el.className = 'border p-2 cursor-pointer hover:bg-gray-50';
                el.innerText = text;
            }
            return el;
        }

        function toggleSeat(zone, td) {
            const r = +td.dataset.r, c = +td.dataset.c;
            const arr = layout[zone];
            const idx = arr.findIndex(s => s.r === r && s.c === c);
            if (idx >= 0) {
                arr.splice(idx, 1);
                td.innerText = '';
                td.classList.remove('bg-[#EF5222]', 'text-white');
            } else {
                const prefix = document.getElementById('prefix' + capitalize(zone)).value || '';
                const code = prompt(`Seat code (e.g. ${prefix}${r}):`);
                if (!code)
                    return;
                arr.push({r, c, code});
                td.innerText = code;
                td.classList.add('bg-[#EF5222]', 'text-white');
            }
        }

        function capitalize(s) {
            return s.charAt(0).toUpperCase() + s.slice(1);
        }

        // init
        regenTable('down');
        regenTable('up');

        document.querySelector('form').onsubmit = () => {
            document.getElementById('layoutDown').value = JSON.stringify(layout.down);
            document.getElementById('layoutUp').value = JSON.stringify(layout.up);
        };
    </script>

    <%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
