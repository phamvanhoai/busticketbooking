<%-- 
    Document   : edit-bus-type
    Created on : Jun 15, 2025, 1:53:58 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>


<body class="bg-gray-50">
    <div class="mt-10">
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Update Bus Type</h1>

        <div class="bg-white border border-[#EF5222] rounded-2xl shadow-lg p-8">
            <form action="${pageContext.request.contextPath}/admin/bus-types" method="post" class="space-y-6">
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" id="bus-type-id" name="id" value="${busType.busTypeId}" />

                <!-- Name & Description -->
                <div>
                    <label class="block text-gray-800 font-medium mb-2">Name</label>
                    <input id="bus-type-name" name="name" type="text" value="${busType.busTypeName}" 
                           class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring" />
                </div>
                <div>
                    <label class="block text-gray-800 font-medium mb-2">Description</label>
                    <textarea id="bus-type-desc" name="description" rows="3"
                              class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring resize-none">${busType.busTypeDescription}</textarea>
                </div>

                <!-- Seats Configuration for each floor -->
                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Downstairs -->
                    <div class="space-y-2">
                        <h2 class="font-medium">Downstairs Setup</h2>
                        <div class="flex gap-2 items-center">
                            <label>Rows×Cols:</label>
                            <input id="rowsDown" name="rowsDown" type="number" value="${busType.rowsDown}" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                            <span>×</span>
                            <input id="colsDown" name="colsDown" type="number" value="${busType.colsDown}" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                        </div>
                        <div class="flex gap-2 items-center">
                            <label>Row Prefix:</label>
                            <input id="prefixDown" name="prefixDown" type="text" value="${busType.prefixDown}" maxlength="2" class="w-16 border rounded px-2 py-1"/>
                        </div>
                        <button type="button" onclick="regenTable('down')" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                            Apply Downstairs
                        </button>
                    </div>

                    <!-- Up floor -->
                    <div class="space-y-2">
                        <h2 class="font-medium">Up floor Setup</h2>
                        <div class="flex gap-2 items-center">
                            <label>Rows×Cols:</label>
                            <input id="rowsUp" name="rowsUp" type="number" value="${busType.rowsUp}" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                            <span>×</span>
                            <input id="colsUp" name="colsUp" type="number" value="${busType.colsUp}" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                        </div>
                        <div class="flex gap-2 items-center">
                            <label>Row Prefix:</label>
                            <input id="prefixUp" name="prefixUp" type="text" value="${busType.prefixUp}" maxlength="2" class="w-16 border rounded px-2 py-1"/>
                        </div>
                        <button type="button" onclick="regenTable('up')" class="px-4 py-2 bg-[#EF5222] text-white rounded hover:bg-opacity-90">
                            Apply Up floor
                        </button>
                    </div>
                </div>

                <!-- Tables -->
                <div class="mt-6">
                    <h2 class="font-semibold mb-2">Downstairs Layout</h2>
                    <div class="overflow-auto">
                        <table id="table-down" class="table-auto border-collapse border border-gray-300 w-full text-center"></table>
                    </div>
                </div>
                <div class="mt-4">
                    <h2 class="font-semibold mb-2">Up floor Layout</h2>
                    <div class="overflow-auto">
                        <table id="table-up" class="table-auto border-collapse border border-gray-300 w-full text-center"></table>
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

    <script>
        const layout = {down: [], up: []};

        // Passing the serialized JSON data from the backend to JavaScript
        <%
          String seatsDownJson = (String) request.getAttribute("seatsDownJson");
          String seatsUpJson = (String) request.getAttribute("seatsUpJson");
        %>

        layout.down = JSON.parse('<%= seatsDownJson %>');
        layout.up = JSON.parse('<%= seatsUpJson %>');

        function regenTable(zone) {
            const rows = +document.getElementById('rows' + capitalize(zone)).value;
            const cols = +document.getElementById('cols' + capitalize(zone)).value;
            const prefix = document.getElementById('prefix' + capitalize(zone)).value;

            const table = document.getElementById('table-' + zone);
            table.innerHTML = '';

            layout[zone] = layout[zone] || [];

            // header
            const thead = document.createElement('thead');
            const headRow = document.createElement('tr');
            headRow.appendChild(cell('th', '', true));
            for (let c = 1; c <= cols; c++) {
                headRow.appendChild(cell('th', c, true));
            }
            thead.appendChild(headRow);
            table.appendChild(thead);

            // body
            const tbody = document.createElement('tbody');
            for (let r = 1; r <= rows; r++) {
                const tr = document.createElement('tr');
                tr.appendChild(cell('th', prefix + r, true));

                for (let c = 1; c <= cols; c++) {
                    const td = cell('td', '', false);
                    td.dataset.r = r;
                    td.dataset.c = c;
                    td.onclick = () => toggleSeat(zone, td);
                    tr.appendChild(td);
                }

                tbody.appendChild(tr);
            }

            table.appendChild(tbody);
        }

        function cell(tag, text, isHdr) {
            const el = document.createElement(tag);
            el.className = `${isHdr ? 'border p-2 bg-gray-100 font-medium' : 'border p-2 cursor-pointer hover:bg-gray-50'}`;
            el.innerText = text;
            return el;
        }

        function toggleSeat(zone, el) {
            const {r, c} = el.dataset;
            const arr = layout[zone];
            const i = arr.findIndex(s => s.r == r && s.c == c);
            if (i >= 0) {
                arr.splice(i, 1);
                el.innerText = '';
                el.classList.remove('bg-[#EF5222]', 'text-white');
            } else {
                const code = prompt('Seat code (eg ' + document.getElementById('prefix' + capitalize(zone)).value + r + '):');
                if (!code)
                    return;
                arr.push({r, c, code});
                el.innerText = code;
                el.classList.add('bg-[#EF5222]', 'text-white');
            }
        }

        function capitalize(s) {
            return s.charAt(0).toUpperCase() + s.slice(1);
        }

        document.querySelector('form').onsubmit = () => {
            document.getElementById('layoutDown').value = JSON.stringify(layout.down);
            document.getElementById('layoutUp').value = JSON.stringify(layout.up);
        };

        document.addEventListener('DOMContentLoaded', () => {
            regenTable('down');
            regenTable('up');
        });
    </script>
    
    <%-- Script to render seats data in the table --%>
    <script>
        // Convert the JSON data passed from the servlet into JavaScript arrays
        var seatsDown = JSON.parse('${seatsDownJson}');
        var seatsUp = JSON.parse('${seatsUpJson}');

        // Function to generate the seat layout table dynamically
        function renderSeatTable(zone, seats) {
            const table = document.getElementById(`table-${zone}`);
            const rows = seats.reduce((acc, seat) => {
                const rowKey = seat.r;  // Nhóm ghế theo hàng
                if (!acc[rowKey]) acc[rowKey] = [];
                acc[rowKey].push(seat); // Thêm ghế vào hàng tương ứng
                return acc;
            }, {});

            // Create header row
            const headerRow = document.createElement('tr');
            headerRow.appendChild(createCell('th', ''));
            for (let c = 1; c <= 3; c++) { // Giả sử có tối đa 3 cột
                headerRow.appendChild(createCell('th', c));
            }
            table.appendChild(headerRow);

            // Create rows with seats
            for (let rowKey in rows) {
                const row = rows[rowKey];
                const rowElement = document.createElement('tr');
                rowElement.appendChild(createCell('th', rowKey));  // Hiển thị hàng

                // Duyệt qua các cột
                for (let col = 1; col <= 3; col++) {  // Giả sử mỗi hàng có 3 cột
                    const seat = row.find(s => s.c === col);  // Tìm ghế ở vị trí tương ứng
                    if (seat) {
                        rowElement.appendChild(createCell('td', seat.code || ''));
                    } else {
                        rowElement.appendChild(createCell('td', ''));  // Nếu không có ghế, để trống
                    }
                }
                table.appendChild(rowElement);
            }
        }

        // Helper function to create table cells
        function createCell(tag, text) {
            const cell = document.createElement(tag);
            cell.className = 'border p-2';
            cell.innerText = text;
            return cell;
        }

        // Render the tables for downstairs and upstairs
        renderSeatTable('down', seatsDown);
        renderSeatTable('up', seatsUp);
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>