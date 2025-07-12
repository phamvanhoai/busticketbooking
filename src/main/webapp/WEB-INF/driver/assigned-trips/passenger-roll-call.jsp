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

        <!-- Form để gửi dữ liệu đi -->
        <form action="${pageContext.request.contextPath}/driver/assigned-trips" method="post">
    <div class="space-y-4 mb-8">
        <c:forEach var="passenger" items="${passengers}">
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100">
                <div class="w-10 text-center font-medium">${passenger.seat}</div>
                <div class="flex-1 text-sm text-gray-700">
                    ${passenger.name}
                    <div class="text-xs text-gray-500">SĐT: ${passenger.phone}</div>
                    <div class="text-xs text-gray-500">Điểm lên: ${passenger.pickupLocation}</div>
                    <div class="text-xs text-gray-500">Điểm xuống: ${passenger.dropoffLocation}</div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- Check-in Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" name="checkInStatus-${passenger.id}" class="check-status" 
                               data-seat="${passenger.seat}" data-passenger-id="${passenger.id}" 
                               <c:if test="${not empty passenger.checkInTime}">
                                   checked
                               </c:if>
                        />
                        <span>Check-in</span>
                    </label>

                    <!-- Check-out Checkbox -->
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" name="checkOutStatus-${passenger.id}" class="check-status" 
                               data-seat="${passenger.seat}" data-passenger-id="${passenger.id}" 
                               <c:if test="${not empty passenger.checkOutTime}">
                                   checked
                               </c:if>
                        />
                        <span>Check-out</span>
                    </label>
                </div>
                <div class="text-sm text-gray-500 mt-2" id="status-${passenger.seat}">
                    Trạng thái: ${passenger.checkInTime != null ? 'Đã check-in' : 'Chưa check-in'}
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Nút hành động -->
    <div class="p-4 bg-white border-t">
        <div class="flex justify-end gap-4">
            <button type="button" onclick="window.history.back()" class="px-6 py-2 border rounded-lg text-gray-700 hover:bg-gray-100">
                Hủy
            </button>
            <button type="submit" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                Lưu điểm danh
            </button>
        </div>
    </div>
</form>


    </div>

    <script>
        // Cập nhật trạng thái check-in / check-out
        document.querySelectorAll('.check-status').forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const seat = checkbox.dataset.seat;
                const checkinCheckbox = document.getElementById('checkin-' + seat);
                const checkoutCheckbox = document.getElementById('checkout-' + seat);
                const statusText = document.getElementById('status-' + seat);
                const passengerId = checkbox.dataset.passengerId;

                // Kiểm tra nếu check-out được chọn mà chưa check-in
                if (checkoutCheckbox.checked && !checkinCheckbox.checked) {
                    statusText.textContent = 'Trạng thái: Lỗi! Không thể check-out khi chưa check-in';
                } else if (checkinCheckbox.checked && checkoutCheckbox.checked) {
                    // Nếu cả check-in và check-out đều được chọn
                    statusText.textContent = 'Trạng thái: Đã check-out';
                } else {
                    // Nếu chỉ check-in được chọn
                    if (checkinCheckbox.checked) {
                        statusText.textContent = 'Trạng thái: Đã check-in';
                    }
                    // Nếu chỉ check-out được chọn
                    else if (checkoutCheckbox.checked) {
                        statusText.textContent = 'Trạng thái: Đã check-out';
                    }
                    // Nếu cả 2 đều không chọn
                    else {
                        statusText.textContent = 'Trạng thái: Chưa check-in';
                    }
                }
            });
        });
    </script>

    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/driver/driver-footer.jsp" %>
