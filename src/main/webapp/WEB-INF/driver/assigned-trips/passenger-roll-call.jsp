<%-- 
    Document   : passenger-roll-call
    Created on : Jun 19, 2025, 10:35:55 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>


<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">

    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Điểm danh hành khách</h1>

        <!-- Seat map với checkbox -->
        <div class="grid grid-cols-4 gap-4 mb-8">
            <!-- Ví dụ ghế A01 -->
            <label class="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <input type="checkbox" data-seat="A01" class="h-5 w-5 text-orange-500 rounded"/>
                <div class="w-10 text-center font-medium">A01</div>
                <div class="flex-1 text-sm text-gray-700">Nguyễn Văn A</div>
            </label>
            <label class="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <input type="checkbox" data-seat="A02" class="h-5 w-5 text-orange-500 rounded"/>
                <div class="w-10 text-center font-medium">A02</div>
                <div class="flex-1 text-sm text-gray-700">Trần Thị B</div>
            </label>
            <label class="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <input type="checkbox" data-seat="A03" class="h-5 w-5 text-orange-500 rounded"/>
                <div class="w-10 text-center font-medium">A03</div>
                <div class="flex-1 text-sm text-gray-700">Lê Văn C</div>
            </label>
            <label class="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <input type="checkbox" data-seat="A04" class="h-5 w-5 text-orange-500 rounded"/>
                <div class="w-10 text-center font-medium">A04</div>
                <div class="flex-1 text-sm text-gray-700">Phạm Thị D</div>
            </label>
            <!-- Thêm nhiều ghế tương tự... -->
        </div>

        <!-- Nút hành động -->
        <div class="flex justify-end gap-4">
            <button onclick="window.history.back()" class="px-6 py-2 border rounded-lg text-gray-700 hover:bg-gray-100">
                Hủy
            </button>
            <button id="saveBtn" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                Lưu điểm danh
            </button>
        </div>
    </div>

    <script>
        document.getElementById('saveBtn').addEventListener('click', () => {
            const checked = Array.from(document.querySelectorAll('input[type="checkbox"]'))
                    .filter(cb => cb.checked)
                    .map(cb => cb.dataset.seat);

            // TODO: gửi danh sách 'checked' lên server hoặc xử lý tiếp
            console.log('Các ghế đã điểm danh:', checked);

            alert('Đã lưu điểm danh cho: ' + (checked.length ? checked.join(', ') : 'không có'));
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
