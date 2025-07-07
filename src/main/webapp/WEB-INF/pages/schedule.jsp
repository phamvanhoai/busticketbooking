<%-- 
    Document   : schedule
    Created on : Jul 7, 2025, 1:02:16 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<body class="min-h-screen bg-white py-14 px-6">
  <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">

    <!-- SEARCH -->
    <div class="shedule-input-form flex justify-center gap-4">
      <span class="relative flex items-center border rounded-full px-12 py-2 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500">
        <img src="${pageContext.request.contextPath}/assets/images/icons/search.svg" class="w-5 h-5 text-gray-400" alt="">
        <input type="text" placeholder="Enter origin" class="ml-2 outline-none w-60" />
      </span>
      <button>
        <img src="${pageContext.request.contextPath}/assets/images/icons/switch_location.svg" class="w-25 h-25" alt="">
      </button>
      <span class="relative flex items-center border rounded-full px-12 py-2 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500">
        <img src="${pageContext.request.contextPath}/assets/images/icons/search.svg" class="w-5 h-5 text-gray-400" alt="">
        <input type="text" placeholder="Enter destination" class="ml-2 outline-none w-60" />
      </span>
    </div>

    <!-- TABLE HEADER -->
    <div
      class="mt-6 bg-white border border-gray-200 rounded-full px-4 py-2 text-sm font-medium grid justify-items-center items-center"
      style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
    >
      <div>Route</div>
      <div>Car</div>
      <div>Distance</div>
      <div>Time</div>
      <div>Price</div>
      <div></div>
    </div>

    <!-- 1) Nhóm đơn 1 row -->
    <div class="mt-4 bg-white border border-gray-200 rounded-2xl overflow-hidden">
      <div
        class="grid justify-items-center items-center px-4 py-4"
        style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
      >
        <div class="flex items-center gap-2 text-orange font-medium">
          An Hữu (Tiền Giang)
          <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
          <span>TP.Hồ Chí Minh</span>
        </div>
        <div>Limousine</div>
        <div>123km</div>
        <div>2 hours</div>
        <div>---</div>
        <div class="flex justify-end">
          <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
        </div>
      </div>
    </div>

    <!-- 2) Nhóm 2 row con -->
    <div class="mt-4 bg-white border border-gray-200 rounded-2xl overflow-hidden">
      <div class="flex flex-col">
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            An Khê (Gia Lai)
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>TP.Hồ Chí Minh</span>
          </div>
          <div>Limousine</div>
          <div>640km</div>
          <div>13 hours</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <div
          class="grid justify-items-center items-center px-4 py-4 last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            An Khê (Gia Lai)
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>TP.Hồ Chí Minh</span>
          </div>
          <div>Limousine</div>
          <div>690km</div>
          <div>14 hours</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 3) Nhóm Bạc Liêu 2 row con -->
    <div class="mt-4 bg-white border border-gray-200 rounded-2xl overflow-hidden">
      <div class="flex flex-col">
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            Bạc Liêu
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>TP.Hồ Chí Minh</span>
          </div>
          <div>Bunk</div>
          <div>271km</div>
          <div>6 hours</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <div
          class="grid justify-items-center items-center px-4 py-4 last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            Bạc Liêu
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>TP.Hồ Chí Minh</span>
          </div>
          <div>Limousine</div>
          <div>243km</div>
          <div>5 hours</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 4) Nhóm Bảo Lộc 6 row con có scroll -->
    <div class="mt-4 bg-white border border-gray-200 rounded-2xl overflow-hidden">
      <div class="max-h-48 overflow-y-scroll">
        <!-- Row 1 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>Bình Sơn</span>
          </div>
          <div>Limousine</div>
          <div>650km</div>
          <div>15h30</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <!-- Row 2 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>Đà Nẵng</span>
          </div>
          <div>Bunk</div>
          <div>756km</div>
          <div>16h38</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <!-- Row 3 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>Huế</span>
          </div>
          <div>Bunk</div>
          <div>827km</div>
          <div>19h00</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <!-- Row 4 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange	font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>Huế</span>
          </div>
          <div>Limousine</div>
          <div>900km</div>
          <div>18h30</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <!-- Row 5 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 border-b last border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange	font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>Quảng Ngãi</span>
          </div>
          <div>---</div>
          <div>---</div>
          <div>---</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
        <!-- Row 6 -->
        <div
          class="grid justify-items-center items-center px-4 py-4 last:border-b-0"
          style="grid-template-columns:6fr 2fr 3fr 4fr 2fr auto;"
        >
          <div class="flex items-center gap-2 text-orange	font-medium">
            Bảo Lộc
            <img src="${pageContext.request.contextPath}/assets/images/icons/ic_double_arrow.svg" class="w-4 h-4" alt="">
            <span>TP.Hồ Chí Minh</span>
          </div>
          <div>Limousine</div>
          <div>165km</div>
          <div>5h21</div>
          <div>---</div>
          <div class="flex justify-end">
            <button class="bg-red-200 text-red-600 py-2 px-4 rounded-full">Search trip</button>
          </div>
        </div>
      </div>
    </div>

  </div>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>