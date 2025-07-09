<%-- 
    Document   : review-booking
    Created on : Jun 28, 2025, 11:00:22 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="hasReview" value="${not empty invoice.reviewRating}" />
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* Đảm bảo các sao có màu vàng khi được chọn */
    .text-yellow-400 {
        color: #fbbf24; /* Màu vàng */
    }

</style>

<body class="bg-gray-50 min-h-screen">
    <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
        <!-- Header -->
        <div class="w-full py-2">
            <h1 class="text-2xl font-bold text-[#ef5222] text-center">
                <c:choose>
                    <c:when test="${hasReview}">
                        Edit Your Review
                    </c:when>
                    <c:otherwise>
                        Review Trip
                    </c:otherwise>
                </c:choose>
            </h1>
        </div>

        <div class="p-6 bg-white rounded-xl shadow-md mt-4">
            <h2 class="text-lg font-bold text-gray-800">Order ID: #${invoice.invoiceCode}</h2>
            <div class="mt-4 text-gray-600">
                <p><span class="font-semibold">Customer:</span> ${invoice.customerName}</p>
                <p><span class="font-semibold">Date:</span> 
                <fmt:formatDate value="${invoice.paidAt}" pattern="yyyy-MM-dd HH:mm" />
                </p>
                <p><span class="font-semibold">Total Amount:</span> ${invoice.invoiceTotalAmount} ₫</p>
                <p><span class="font-semibold">Payment Status:</span> ${invoice.invoiceStatus}</p>
                <p><span class="font-semibold">Route:</span> ${invoice.route}</p>
                <p><span class="font-semibold">Departure Time:</span> 
                <fmt:formatDate value="${invoice.departureTime}" pattern="yyyy-MM-dd HH:mm" />
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/ticket-management" method="post" class="mt-6 space-y-4">
                <input type="hidden" name="action" value="review" />
                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />

                <!-- Rating -->
                <div>
                    <label class="block text-gray-800 font-medium mb-2">Your Rating</label>
                    <div class="flex items-center space-x-1">
                        <c:forEach var="i" begin="1" end="5">
                            <label class="cursor-pointer">
                                <input type="radio" 
                                       name="rating" 
                                       value="${i}" 
                                       class="hidden peer" 
                                       required
                                       <c:if test="${invoice.reviewRating == i}">checked</c:if> />
                                <svg id="star-${i}" xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
                                </svg>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <!-- Review Text -->
                <div>
                    <label for="reviewText" class="block text-gray-800 font-medium mb-2">Your Review</label>
                    <textarea id="reviewText"
                              name="reviewText"
                              rows="4"
                              class="w-full border rounded-lg p-4 text-gray-800"
                              placeholder="Share your experience...">${fn:escapeXml(fn:trim(invoice.reviewText))}</textarea>                </div>

                <div class="flex justify-end space-x-4 mt-4">
                    <button type="button" onclick="window.history.back();" class="px-6 py-2 bg-gray-300 text-gray-800 rounded-lg hover:bg-gray-400 transition">
                        Cancel
                    </button>
                    <button type="submit" class="px-6 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
                        <c:choose>
                            <c:when test="${hasReview}">
                                Edit Review
                            </c:when>
                            <c:otherwise>
                                Submit Review
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
    <script>
        // Lắng nghe sự kiện thay đổi khi người dùng chọn sao
        document.addEventListener("DOMContentLoaded", function () {
            const stars = document.querySelectorAll('input[name="rating"]');

            stars.forEach(star => {
                star.addEventListener('change', function () {
                    updateStars(this.value);
                });
            });

            // Hàm cập nhật màu sắc sao
            function updateStars(rating) {
                // Duyệt qua tất cả các sao
                for (let i = 1; i <= 5; i++) {
                    const star = document.getElementById('star-' + i);
                    if (i <= rating) {
                        star.classList.add('text-yellow-400'); // Áp dụng màu vàng cho sao được chọn và trước đó
                    } else {
                        star.classList.remove('text-yellow-400'); // Xóa màu vàng cho các sao chưa chọn
                    }
                }
            }

            // Cập nhật màu sắc sao khi trang được tải nếu đã có sao được chọn
            const checkedRating = document.querySelector('input[name="rating"]:checked');
            if (checkedRating) {
                updateStars(checkedRating.value);
            }
        });
    </script>

    <%@ include file="/WEB-INF/include/footer.jsp" %>