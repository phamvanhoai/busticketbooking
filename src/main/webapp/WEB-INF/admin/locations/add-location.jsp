<%-- 
    Document   : add-location
    Created on : Jun 20, 2025, 2:52:30 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body class="bg-[#f3f3f5] min-h-screen p-6">
    <div class="bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-[#EF5222] mb-6">Add New Location</h1>

        <form action="${pageContext.request.contextPath}/admin/locations" method="post" class="space-y-6">
            <!-- Cho servlet biết đây là thêm mới -->
            <input type="hidden" name="action" value="add"/>

            <!-- Location Name -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Location Name</label>
                <input type="text" name="locationName" required
                       placeholder="e.g. Downtown Station"
                       class="w-full border rounded-lg px-4 py-2 focus:ring-orange-400"/>
            </div>

            <!-- Address -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Address</label>
                <input type="text" name="address" required
                       placeholder="123 Main St, District 1, HCMC"
                       class="w-full border rounded-lg px-4 py-2 focus:ring-orange-400"/>
            </div>

            <!-- Latitude & Longitude -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="latitude" class="block text-sm font-medium text-gray-700 mb-1">Latitude</label>
                    <input
                        type="number"
                        step="any"
                        id="latitude"
                        name="latitude"
                        required
                        placeholder="10.8231"
                        class="w-full border rounded-lg px-4 py-2 focus:ring-orange-400"/>
                </div>
                <div>
                    <label for="longitude" class="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                    <input
                        type="number"
                        step="any"
                        id="longitude"
                        name="longitude"
                        required
                        placeholder="106.6297"
                        class="w-full border rounded-lg px-4 py-2 focus:ring-orange-400"/>
                </div>
            </div>

            <!-- Map container -->
            <div id="map" style="height: 300px; margin:1rem 0;"></div>

            <!-- Description -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea name="description" rows="3"
                          placeholder="Notes about this location..."
                          class="w-full border rounded-lg px-4 py-2 focus:ring-orange-400 resize-none"></textarea>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Location Type  -->
                <div>
                    <label for="locationType" class="block text-sm font-medium text-gray-700 mb-1">Location Type</label>
                    <select name="locationType" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400" required>
                        <option value="City">City</option>
                        <option value="Bus Terminal">Bus Terminal</option>
                        <option value="Rest Stop">Rest Stop</option>
                        <option value="Province">Province</option>
                    </select>

                </div>

                <!-- Status -->
                <div>
                    <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select name="status" id="status" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400">
                        <option value="Active" ${loc.locationStatus=='Active'? 'selected':''}>Active</option>
                        <option value="Inactive" ${loc.locationStatus=='Inactive'? 'selected':''}>Inactive</option>
                    </select>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-end gap-4 pt-4">
                <a href="${pageContext.request.contextPath}/admin/locations">
                    <button type="button"
                            class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-6 py-2 rounded-lg">
                        Cancel
                    </button>
                </a>
                <button type="submit"
                        class="bg-orange-500 hover:bg-orange-600 text-white px-6 py-2 rounded-lg">
                    Save Location
                </button>
            </div>
        </form>
    </div>

    <!-- Leaflet CSS/JS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <script>
        // Khởi tạo bản đồ tại vị trí mặc định
        var defaultLat = 10.8231, defaultLng = 106.6297;
        var map = L.map('map').setView([defaultLat, defaultLng], 13);
        L.tileLayer('http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            maxZoom: 20,
            attribution: '© Google'
        }).addTo(map);

        // Marker draggable
        var marker = L.marker([defaultLat, defaultLng], {draggable: true}).addTo(map);

        // Cập nhật input khi marker di chuyển hoặc click lên bản đồ
        function updateInputs(lat, lng) {
            document.getElementById('latitude').value = lat.toFixed(6);
            document.getElementById('longitude').value = lng.toFixed(6);
        }
        marker.on('moveend', function (e) {
            updateInputs(e.target.getLatLng().lat, e.target.getLatLng().lng);
        });
        map.on('click', function (e) {
            marker.setLatLng(e.latlng);
            updateInputs(e.latlng.lat, e.latlng.lng);
        });

        // Di chuyển marker khi thay đổi input thủ công
        function moveMarkerFromInputs() {
            var lat = parseFloat(document.getElementById('latitude').value),
                    lng = parseFloat(document.getElementById('longitude').value);
            if (!isNaN(lat) && !isNaN(lng)) {
                var ll = L.latLng(lat, lng);
                marker.setLatLng(ll);
                map.panTo(ll);
            }
        }
        document.getElementById('latitude').addEventListener('change', moveMarkerFromInputs);
        document.getElementById('longitude').addEventListener('change', moveMarkerFromInputs);

        // Khởi tạo giá trị input ban đầu
        updateInputs(defaultLat, defaultLng);
    </script>
    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>