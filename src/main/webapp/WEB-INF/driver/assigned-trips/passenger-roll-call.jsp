<%-- 
    Document   : passenger-roll-call
    Created on : Jun 19, 2025, 10:35:55 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/driver/driver-header.jsp" %>


<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">

    <div class="bg-white rounded-2xl shadow-lg p-8 relative">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">Điểm danh hành khách</h1>

        <!-- Mỗi row 1 khách -->
        <div class="space-y-4 mb-8">
            <!-- Ví dụ ghế A01 -->
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <div class="w-10 text-center font-medium">A01</div>
                <div class="flex-1 text-sm text-gray-700">
                    Nguyễn Văn A
                    <div class="text-xs text-gray-500">SĐT: 0123456789</div>
                    <div class="text-xs text-gray-500">Điểm lên: Bến A</div>
                    <div class="text-xs text-gray-500">Điểm xuống: Bến C</div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- Check-in Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkin-A01" class="check-status" data-seat="A01"/>
                        <span>Check-in</span>
                    </label>

                    <!-- Check-out Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkout-A01" class="check-status" data-seat="A01"/>
                        <span>Check-out</span>
                    </label>
                </div>
                <div class="text-sm text-gray-500 mt-2" id="status-A01">Trạng thái: Chưa check-in</div>
            </div>

            <!-- Ví dụ ghế A02 -->
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <div class="w-10 text-center font-medium">A02</div>
                <div class="flex-1 text-sm text-gray-700">
                    Trần Thị B
                    <div class="text-xs text-gray-500">SĐT: 0987654321</div>
                    <div class="text-xs text-gray-500">Điểm lên: Bến B</div>
                    <div class="text-xs text-gray-500">Điểm xuống: Bến D</div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- Check-in Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkin-A02" class="check-status" data-seat="A02"/>
                        <span>Check-in</span>
                    </label>

                    <!-- Check-out Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkout-A02" class="check-status" data-seat="A02"/>
                        <span>Check-out</span>
                    </label>
                </div>
                <div class="text-sm text-gray-500 mt-2" id="status-A02">Trạng thái: Chưa check-in</div>
            </div>

            <!-- Ví dụ ghế A03 -->
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <div class="w-10 text-center font-medium">A03</div>
                <div class="flex-1 text-sm text-gray-700">
                    Lê Văn C
                    <div class="text-xs text-gray-500">SĐT: 0912345678</div>
                    <div class="text-xs text-gray-500">Điểm lên: Bến C</div>
                    <div class="text-xs text-gray-500">Điểm xuống: Bến E</div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- Check-in Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkin-A03" class="check-status" data-seat="A03"/>
                        <span>Check-in</span>
                    </label>

                    <!-- Check-out Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkout-A03" class="check-status" data-seat="A03"/>
                        <span>Check-out</span>
                    </label>
                </div>
                <div class="text-sm text-gray-500 mt-2" id="status-A03">Trạng thái: Chưa check-in</div>
            </div>

            <!-- Ví dụ ghế A04 -->
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <div class="w-10 text-center font-medium">A04</div>
                <div class="flex-1 text-sm text-gray-700">
                    Phạm Thị D
                    <div class="text-xs text-gray-500">SĐT: 0934567890</div>
                    <div class="text-xs text-gray-500">Điểm lên: Bến D</div>
                    <div class="text-xs text-gray-500">Điểm xuống: Bến F</div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- Check-in Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkin-A04" class="check-status" data-seat="A04"/>
                        <span>Check-in</span>
                    </label>

                    <!-- Check-out Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" id="checkout-A04" class="check-status" data-seat="A04"/>
                        <span>Check-out</span>
                    </label>
                </div>
                <div class="text-sm text-gray-500 mt-2" id="status-A04">Trạng thái: Chưa check-in</div>
            </div>
        </div>

        <!-- Nút hành động cố định ở dưới -->
        <div class="p-4 bg-white border-t">
            <div class="flex justify-end gap-4">
                <button onclick="window.history.back()" class="px-6 py-2 border rounded-lg text-gray-700 hover:bg-gray-100">
                    Hủy
                </button>
                <button id="saveBtn" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                    Lưu điểm danh
                </button>
            </div>
        </div>
    </div>

    <script>
        // Hàm cập nhật trạng thái check-in / check-out
        document.querySelectorAll('.check-status').forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const seat = checkbox.dataset.seat;
                const checkinCheckbox = document.getElementById('checkin-' + seat);
                const checkoutCheckbox = document.getElementById('checkout-' + seat);
                const statusText = document.getElementById('status-' + seat);
                
                // Nếu cả hai đều được chọn, không hợp lệ
                if (checkinCheckbox.checked && checkoutCheckbox.checked) {
                    statusText.textContent = 'Trạng thái: Lỗi! Không thể check-in và check-out cùng lúc';
                } else if (checkinCheckbox.checked) {
                    statusText.textContent = 'Trạng thái: Đã check-in';
                } else if (checkoutCheckbox.checked) {
                    statusText.textContent = 'Trạng thái: Đã check-out';
                } else {
                    statusText.textContent = 'Trạng thái: Chưa check-in';
                }

                console.log(`Cập nhật trạng thái cho ghế ${seat}: ${statusText.textContent}`);
            });
        });

        // Lưu điểm danh
        document.getElementById('saveBtn').addEventListener('click', () => {
            const statuses = {};
            const checkboxes = document.querySelectorAll('.check-status');

            checkboxes.forEach(checkbox => {
                const seat = checkbox.dataset.seat;
                const status = checkbox.checked ? (checkbox.id.includes('checkin') ? 'Đã check-in' : 'Đã check-out') : 'Chưa check-in';
                statuses[seat] = status;
            });

            // Gửi danh sách trạng thái lên server
            console.log('Trạng thái điểm danh:', statuses);

            alert('Đã lưu điểm danh.');
        });
    </script>


    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
