<%-- 
    Document   : add-bus-type
    Created on : Jun 15, 2025, 1:53:45 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<body class="bg-gray-50 min-h-screen p-6">
    <div class="p-8 bg-white rounded-xl shadow-lg mt-10">

        <!-- Heading -->
        <h1 class="text-3xl font-bold text-[#EF5222] mb-6">Create Bus Type</h1>

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


        <form action="${pageContext.request.contextPath}/admin/bus-types" method="post" class="space-y-6">

            <input type="hidden" name="action" value="add" />
            <!-- hidden JSON layouts -->
            <input type="hidden" id="layoutDown" name="layoutDown" />
            <input type="hidden" id="layoutUp"   name="layoutUp" />

            <!-- Name & Description -->
            <div>
                <label class="block text-gray-800 font-medium mb-2">Name</label>
                <input name="name" type="text" required
                       class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring"
                       placeholder="Enter bus type name"/>
            </div>
            <div>
                <label class="block text-gray-800 font-medium mb-2">Description</label>
                <textarea name="description" rows="3"
                          class="w-full border border-gray-300 rounded-xl px-5 py-4 focus:outline-none focus:ring resize-none"
                          placeholder="Optional description..."></textarea>
            </div>

            <!-- config for each floor -->
            <div class="grid md:grid-cols-2 gap-6">
                <!-- Downstairs -->
                <div class="space-y-2">
                    <h2 class="font-medium">Downstairs Setup</h2>
                    <div class="flex gap-2 items-center">
                        <label>Rows×Cols:</label>
                        <input id="rowsDown"   name="rowsDown"   type="number" value="6" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                        <span>×</span>
                        <input id="colsDown"   name="colsDown"   type="number" value="3" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                    </div>
                    <div class="flex gap-2 items-center">
                        <label>Row Prefix:</label>
                        <!-- thêm name để Servlet có thể lấy prefixDown -->
                        <input id="prefixDown" name="prefixDown" type="text" value="A" maxlength="2" class="w-16 border rounded px-2 py-1"/>
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
                        <input id="rowsUp"   name="rowsUp"   type="number" value="6" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                        <span>×</span>
                        <input id="colsUp"   name="colsUp"   type="number" value="3" min="1" max="10" class="w-16 border rounded px-2 py-1"/>
                    </div>
                    <div class="flex gap-2 items-center">
                        <label>Row Prefix:</label>
                        <!-- thêm name để Servlet có thể lấy prefixUp -->
                        <input id="prefixUp" name="prefixUp" type="text" value="B" maxlength="2" class="w-16 border rounded px-2 py-1"/>
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
                <button type="button" onclick="history.back()"
                        class="px-6 py-3 bg-gray-300 text-gray-800 rounded-xl hover:bg-gray-400">
                    Cancel
                </button>
                <button type="submit"
                        class="px-6 py-3 bg-[#EF5222] text-white rounded-xl hover:bg-opacity-90">
                    Create
                </button>
            </div>
        </form>
    </div>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>

    <script>
        const layout = {down: [], up: []};

        function regenTable(zone) {
            const rows = +document.getElementById('rows' + capitalize(zone)).value;
            const cols = +document.getElementById('cols' + capitalize(zone)).value;
            const prefix = document.getElementById('prefix' + capitalize(zone)).value;
            const table = document.getElementById('table-' + zone);

            table.innerHTML = '';
            layout[zone] = [];

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
            el.className = isHdr
                    ? 'border p-2 bg-gray-100 font-medium'
                    : 'border p-2 cursor-pointer hover:bg-gray-50';
            el.innerText = text;
            return el;
        }

        function toggleSeat(zone, el) {
            const {r, c} = el.dataset;
            const arr = layout[zone];
            const idx = arr.findIndex(s => s.r == r && s.c == c);
            if (idx >= 0) {
                arr.splice(idx, 1);
                el.innerText = '';
                el.classList.remove('bg-[#EF5222]', 'text-white');
            } else {
                const code = prompt(
                        'Seat code (eg ' +
                        document.getElementById('prefix' + capitalize(zone)).value +
                        r +
                        '):'
                        );
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

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>