<%-- 
    Document   : view-trips
    Created on : Jun 15, 2025, 10:53:46 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<%@include file="/WEB-INF/include/banner.jsp" %>
<style>
    /* Sidebar “Your Trip” panels */
    .your-trip > div {
        display: none;
    }
    #trip1:checked ~ .layout .sidebar .your-trip .trip1,
    #trip2:checked ~ .layout .sidebar .your-trip .trip2,
    #trip3:checked ~ .layout .sidebar .your-trip .trip3 {
        display: block;
    }
    /* highlight toàn bộ card khi chọn */
    #trip1:checked ~ .layout .content .card:nth-of-type(1),
    #trip2:checked ~ .layout .content .card:nth-of-type(2),
    #trip3:checked ~ .layout .content .card:nth-of-type(3) {
        border-color: #fb923c;
        box-shadow: 0 0 0 2px rgba(251,146,60,0.3);
    }
</style>


<body class="bg-gray-100 text-gray-800">

  <!-- Hidden radios for CSS-only trip selection -->
  <input type="radio" name="selected" id="trip1" hidden>
  <input type="radio" name="selected" id="trip2" hidden>
  <input type="radio" name="selected" id="trip3" hidden>

  <div class="layout flex max-w-6xl mx-auto py-8 px-4 gap-6">

    <!-- Sidebar -->
    <div class="sidebar w-1/3 space-y-6">

      <!-- Your Trip panels -->
      <div class="your-trip space-y-4">
        <!-- trip1 -->
        <div class="trip1 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
          <h3 class="font-semibold">YOUR TRIP</h3>
          <p class="text-sm text-gray-600">Tuesday, 17/06/2025</p>
          <div class="flex justify-between items-center mt-2">
            <div>
              <p class="text-lg font-bold">07:01</p>
              <p class="text-xs text-gray-500">Bến Xe Đồng Tâm (Cà Mau)</p>
            </div>
            <div class="text-center text-sm text-gray-500">7 hours</div>
            <div>
              <p class="text-lg font-bold">14:01</p>
              <p class="text-xs text-gray-500">Bến Xe Miền Tây</p>
            </div>
          </div>
        </div>
        <!-- trip2 -->
        <div class="trip2 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
          <h3 class="font-semibold">YOUR TRIP</h3>
          <p class="text-sm text-gray-600">Tuesday, 17/06/2025</p>
          <div class="flex justify-between items-center mt-2">
            <div>
              <p class="text-lg font-bold">08:00</p>
              <p class="text-xs text-gray-500">Bến Xe Cà Mau</p>
            </div>
            <div class="text-center text-sm text-gray-500">8 hours</div>
            <div>
              <p class="text-lg font-bold">16:00</p>
              <p class="text-xs text-gray-500">BX Miền Đông Mới</p>
            </div>
          </div>
        </div>
        <!-- trip3 -->
        <div class="trip3 bg-white rounded-xl shadow p-4 border-l-4 border-orange-500">
          <h3 class="font-semibold">YOUR TRIP</h3>
          <p class="text-sm text-gray-600">Tuesday, 17/06/2025</p>
          <div class="flex justify-between items-center mt-2">
            <div>
              <p class="text-lg font-bold">08:01</p>
              <p class="text-xs text-gray-500">Bến Xe Đồng Tâm (Cà Mau)</p>
            </div>
            <div class="text-center text-sm text-gray-500">7 hours</div>
            <div>
              <p class="text-lg font-bold">15:01</p>
              <p class="text-xs text-gray-500">Bến Xe Miền Tây</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Search Filters -->
      <div class="bg-white rounded-xl shadow p-4 space-y-6">
        <div class="flex justify-between items-center">
          <h3 class="font-semibold uppercase">Search Filters</h3>
          <button class="text-red-500 text-sm">Clear filter 🗑️</button>
        </div>
        <!-- ... (giữ nguyên phần filter như bạn đang có) ... -->
        <div>
          <p class="font-medium mb-2">Departure time</p>
          <div class="space-y-2 text-sm">
            <label class="flex items-center gap-2">
              <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Midnight 00:00 – 06:00 (0)
            </label>
            <label class="flex items-center gap-2">
              <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Morning 06:00 – 12:00 (9)
            </label>
            <label class="flex items-center gap-2">
              <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Afternoon 12:00 – 18:00 (3)
            </label>
            <label class="flex items-center gap-2">
              <input type="checkbox" class="form-checkbox h-4 w-4 rounded"/> Evening 18:00 – 24:00 (10)
            </label>
          </div>
        </div>
        <div>
          <p class="font-medium mb-2">Vehicle kind</p>
          <div class="flex gap-2">
            <button class="px-3 py-1 border rounded-full text-sm">Seat</button>
            <button class="px-3 py-1 border rounded-full text-sm">Bunk</button>
            <button class="px-3 py-1 border rounded-full text-sm">Limousine</button>
          </div>
        </div>
        <div>
          <p class="font-medium mb-2">Row of seats</p>
          <div class="flex gap-2">
            <button class="px-3 py-1 border rounded-full text-sm">Top row</button>
            <button class="px-3 py-1 border rounded-full text-sm">Middle row</button>
            <button class="px-3 py-1 border rounded-full text-sm">Bottom row</button>
          </div>
        </div>
        <div>
          <p class="font-medium mb-2">Floor</p>
          <div class="flex gap-2">
            <button class="px-3 py-1 border rounded-full text-sm">Up floor</button>
            <button class="px-3 py-1 border rounded-full text-sm">Downstairs</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Content (trip cards) -->
    <div class="content flex-1 space-y-6">

      <!-- Trip 1 -->
      <div class="card bg-white rounded-xl border border-gray-200 shadow overflow-hidden">
        <label for="trip1" class="block p-4 cursor-pointer hover:shadow-lg transition">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-lg font-bold">07:01</p>
              <p class="text-sm text-gray-600">Bến Xe Đồng Tâm (Cà Mau)</p>
            </div>
            <div class="text-center text-sm text-gray-500">7 hours</div>
            <div>
              <p class="text-lg font-bold">14:01</p>
              <p class="text-sm text-gray-600">Bến Xe Miền Tây</p>
            </div>
          </div>
          <div class="flex justify-between items-center mt-4 text-gray-600 text-sm">
            <span>Limousine • 34 blank seat</span>
            <span class="text-orange-500 font-semibold">260.000₫</span>
          </div>
        </label>
        <div class="p-4 bg-gray-50 flex gap-4 text-sm text-gray-500">
          <button data-tab="seat"     class="px-3 py-1 hover:text-orange-500">Choose seat</button>
          <button data-tab="schedule" class="px-3 py-1 hover:text-orange-500">Schedule</button>
          <button data-tab="trans"    class="px-3 py-1 hover:text-orange-500">Transshipment</button>
          <button data-tab="policy"   class="px-3 py-1 hover:text-orange-500">Policy</button>
          <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">
            Select trip
          </button>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="seat">
          <!-- seat map -->
          <div class="flex items-center gap-4 mb-2 text-xs">
            <div class="flex items-center gap-1"><div class="w-3 h-3 bg-gray-400 rounded"></div>Sold</div>
            <div class="flex items-center gap-1"><div class="w-3 h-3 bg-blue-200 rounded"></div>Blank</div>
            <div class="flex items-center gap-1"><div class="w-3 h-3 bg-red-100 rounded"></div>Pending</div>
          </div>
          <div class="grid grid-cols-5 gap-2 text-center text-xs">
            <div class="col-span-5 font-medium">Downstairs</div>
            <div class="p-2 bg-blue-200 rounded">C01</div>
            <div class="p-2 bg-blue-200 rounded">C02</div>
            <div class="p-2 bg-gray-400 rounded">C03</div>
            <div class="p-2 bg-blue-200 rounded">C04</div>
            <div class="p-2 bg-blue-200 rounded">C05</div>
          </div>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="schedule">
          <ul class="space-y-2 text-xs text-gray-700">
            <li><span class="font-medium">07:01</span> – Bến Xe Đồng Tâm …</li>
            <li><span class="font-medium">08:30</span> – Chặng tiếp theo …</li>
            <li class="pt-2 border-t text-gray-500 italic text-[10px]">Note: Các giờ có thể thay đổi …</li>
          </ul>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="trans">
          <ul class="list-disc list-inside text-xs text-gray-700 space-y-1">
            <li>Door-to-door service …</li>
            <li>Chuẩn bị 30 phút trước giờ khởi hành …</li>
          </ul>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="policy">
          <ul class="list-disc list-inside text-xs text-gray-700 space-y-1">
            <li>Hủy vé: Phạt 10–30% tùy thời gian …</li>
            <li>Liên hệ tổng đài ít nhất 24h trước …</li>
          </ul>
        </div>
      </div>

      <!-- Trip 2 -->
      <div class="card bg-white rounded-xl border border-gray-200 shadow overflow-hidden">
        <label for="trip2" class="block p-4 cursor-pointer hover:shadow-lg transition">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-lg font-bold">08:00</p>
              <p class="text-sm text-gray-600">Bến Xe Cà Mau</p>
            </div>
            <div class="text-center text-sm text-gray-500">8 hours</div>
            <div>
              <p class="text-lg font-bold">16:00</p>
              <p class="text-sm text-gray-600">BX Miền Đông Mới</p>
            </div>
          </div>
          <div class="flex justify-between items-center mt-4 text-gray-600 text-sm">
            <span>Limousine • 32 blank seat</span>
            <span class="text-orange-500 font-semibold">260.000₫</span>
          </div>
        </label>
        <div class="p-4 bg-gray-50 flex gap-4 text-sm text-gray-500">
          <button data-tab="seat"     class="px-3 py-1 hover:text-orange-500">Choose seat</button>
          <button data-tab="schedule" class="px-3 py-1 hover:text-orange-500">Schedule</button>
          <button data-tab="trans"    class="px-3 py-1 hover:text-orange-500">Transshipment</button>
          <button data-tab="policy"   class="px-3 py-1 hover:text-orange-500">Policy</button>
          <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">
            Select trip
          </button>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="seat">
          <!-- seat map 2 -->
          <p class="text-xs text-gray-600">[Seat map cho trip2]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="schedule">
          <p class="text-xs text-gray-600">[Schedule cho trip2]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="trans">
          <p class="text-xs text-gray-600">[Transshipment cho trip2]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="policy">
          <p class="text-xs text-gray-600">[Policy cho trip2]</p>
        </div>
      </div>

      <!-- Trip 3 -->
      <div class="card bg-white rounded-xl border border-gray-200 shadow overflow-hidden">
        <label for="trip3" class="block p-4 cursor-pointer hover:shadow-lg transition">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-lg font-bold">08:01</p>
              <p class="text-sm text-gray-600">Bến Xe Đồng Tâm (Cà Mau)</p>
            </div>
            <div class="text-center text-sm text-gray-500">7 hours</div>
            <div>
              <p class="text-lg font-bold">15:01</p>
              <p class="text-sm text-gray-600">Bến Xe Miền Tây</p>
            </div>
          </div>
          <div class="flex justify-between items-center mt-4 text-gray-600 text-sm">
            <span>Limousine • 34 blank seat</span>
            <span class="text-orange-500 font-semibold">260.000₫</span>
          </div>
        </label>
        <div class="p-4 bg-gray-50 flex gap-4 text-sm text-gray-500">
          <button data-tab="seat"     class="px-3 py-1 hover:text-orange-500">Choose seat</button>
          <button data-tab="schedule" class="px-3 py-1 hover:text-orange-500">Schedule</button>
          <button data-tab="trans"    class="px-3 py-1 hover:text-orange-500">Transshipment</button>
          <button data-tab="policy"   class="px-3 py-1 hover:text-orange-500">Policy</button>
          <button class="ml-auto px-4 py-1 bg-orange-100 text-orange-600 rounded-full text-sm">
            Select trip
          </button>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="seat">
          <!-- seat map 3 -->
          <p class="text-xs text-gray-600">[Seat map cho trip3]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="schedule">
          <p class="text-xs text-gray-600">[Schedule cho trip3]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="trans">
          <p class="text-xs text-gray-600">[Transshipment cho trip3]</p>
        </div>
        <div class="tab-content px-4 py-3 hidden" data-content="policy">
          <p class="text-xs text-gray-600">[Policy cho trip3]</p>
        </div>
      </div>

    </div>
  </div>

  <!-- JS to toggle tabs -->
  <script>
    document.querySelectorAll('.card').forEach(card => {
      card.querySelectorAll('[data-tab]').forEach(tab => {
        tab.addEventListener('click', e => {
          e.stopPropagation();            // tránh bắn event lên label
          const name    = tab.dataset.tab;
          const content = card.querySelector(`.tab-content[data-content="${name}"]`);
          const wasHidden = content.classList.contains('hidden');
          // Đóng tất cả trong cùng card
          card.querySelectorAll('.tab-content').forEach(c => c.classList.add('hidden'));
          card.querySelectorAll('[data-tab]').forEach(t => 
            t.classList.remove('text-orange-500','border-b-2','border-orange-500')
          );
          // Toggle mở nếu trước đó đang ẩn
          if (wasHidden) {
            content.classList.remove('hidden');
            tab.classList.add('text-orange-500','border-b-2','border-orange-500');
          }
        });
      });
    });
  </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/footer.jsp" %>