<%-- 
    Document   : edit-bus-type
    Created on : Jun 15, 2025, 1:53:58 AM
    Author     : Pham Van Hoai - CE181744
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50 min-h-screen p-6">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Update Bus Type</h1>

        <c:if test="${not empty success}">
            <div class="mb-4 p-4 bg-green-100 border border-green-300 text-green-800 rounded-lg">
                ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-800 rounded-lg">
                ${error}
            </div>
        </c:if>

        <form id="busTypeForm" action="${pageContext.request.contextPath}/admin/bus-types" method="post" class="space-y-6">
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="id" value="${busType.busTypeId}" />
            <input type="hidden" id="layoutDown" name="layoutDown" />
            <input type="hidden" id="layoutUp"   name="layoutUp" />

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

            <!-- Config for each floor -->
            <div class="grid md:grid-cols-2 gap-6">
                <!-- Downstairs -->
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
                    <button type="button" id="applyDown" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                        Apply Downstairs
                    </button>
                </div>
                <!-- Upstairs -->
                <div class="space-y-2">
                    <h2 class="font-medium">Up Floor Setup</h2>
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
                    <button type="button" id="applyUp" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                        Apply Up Floor
                    </button>
                </div>
            </div>

            <!-- Dynamic Tables -->
            <div class="mt-6">
                <h2 class="font-semibold mb-2">Downstairs Layout</h2>
                <div class="overflow-auto">
                    <table id="table-down" class="table-auto border-collapse border border-gray-300 w-full text-center"></table>
                </div>
            </div>
            <div class="mt-4">
                <h2 class="font-semibold mb-2">Up Floor Layout</h2>
                <div class="overflow-auto">
                    <table id="table-up" class="table-auto border-collapse border border-gray-300 w-full text-center"></table>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex justify-end gap-4 mt-8">
                <button type="button" onclick="history.back()" class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400">
                    Cancel
                </button>
                <button type="submit" class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90">
                    Update
                </button>
            </div>
        </form>
    </div>

    <!-- JSON and Script -->
    <script>
        // Raw JSON from server
        const rawDown = JSON.parse('<c:out value="${seatsDownJson}" escapeXml="false"/>');
        const rawUp = JSON.parse('<c:out value="${seatsUpJson}"   escapeXml="false"/>');
        // Normalize to r,c,code
        const layout = {
            down: rawDown.map(x => ({r: x.row, c: x.col, code: x.code})),
            up: rawUp.map(x => ({r: x.row, c: x.col, code: x.code}))
        };
        console.log('Layout data:', layout);

        function capitalize(s) {
            return s.charAt(0).toUpperCase() + s.slice(1);
        }

        function regenTable(zone) {
            const rows = +document.getElementById('rows' + capitalize(zone)).value;
            const cols = +document.getElementById('cols' + capitalize(zone)).value;
            const prefix = document.getElementById('prefix' + capitalize(zone)).value || '';
            const arr = layout[zone];
            const table = document.getElementById('table-' + zone);
            table.innerHTML = '';

            // Header
            const thead = document.createElement('thead');
            const rowH = document.createElement('tr');
            rowH.appendChild(document.createElement('th'));
            for (let c = 1; c <= cols; c++) {
                const th = document.createElement('th');
                th.className = 'border p-2 bg-gray-100 font-medium';
                th.innerText = c;
                rowH.appendChild(th);
            }
            thead.appendChild(rowH);
            table.appendChild(thead);

            // Body
            const tbody = document.createElement('tbody');
            for (let r = 1; r <= rows; r++) {
                const tr = document.createElement('tr');
                const th = document.createElement('th');
                th.className = 'border p-2 bg-gray-100 font-medium';
                th.innerText = prefix + r;
                tr.appendChild(th);
                for (let c = 1; c <= cols; c++) {
                    const td = document.createElement('td');
                    td.className = 'border p-2 cursor-pointer hover:bg-gray-50';
                    td.dataset.r = r;
                    td.dataset.c = c;
                    td.onclick = () => toggleSeat(zone, td);
                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            }
            table.appendChild(tbody);

            // Populate existing seats
            arr.forEach(s => {
                console.log('Populate cell for', zone, s);
                const selector = '#table-' + zone + ' td[data-r="' + s.r + '"][data-c="' + s.c + '"]';
                const cell = document.querySelector(selector);
                console.log('Selector', selector, '=>', cell);
                if (cell) {
                    cell.innerText = s.code;
                    cell.classList.add('bg-[#EF5222]', 'text-white');
                }
            });
        }

        function toggleSeat(zone, td) {
            const r = +td.dataset.r;
            const c = +td.dataset.c;
            const arr = layout[zone];
            const idx = arr.findIndex(x => x.r === r && x.c === c);
            if (idx >= 0) {
                arr.splice(idx, 1);
                td.innerText = '';
                td.classList.remove('bg-[#EF5222]', 'text-white');
            } else {
                const pref = document.getElementById('prefix' + capitalize(zone)).value || '';
                const code = prompt('Seat code (e.g. ' + pref + r + '):');
                if (!code)
                    return;
                arr.push({r, c, code});
                td.innerText = code;
                td.classList.add('bg-[#EF5222]', 'text-white');
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            document.getElementById('applyDown').addEventListener('click', () => regenTable('down'));
            document.getElementById('applyUp').addEventListener('click', () => regenTable('up'));
            regenTable('down');
            regenTable('up');
            document.getElementById('busTypeForm').addEventListener('submit', () => {
                document.getElementById('layoutDown').value = JSON.stringify(layout.down);
                document.getElementById('layoutUp').value = JSON.stringify(layout.up);
            });
        });
    </script>
    <%@ include file="/WEB-INF/include/admin/admin-footer.jsp" %>
