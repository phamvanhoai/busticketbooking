<%-- 
    Document   : edit-location
    Created on : Jun 20, 2025, 2:52:53 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/admin/admin-header.jsp" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="loc" value="${location}" />

<body class="bg-[#f3f3f5] min-h-screen p-6">

    <div class="bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-[#EF5222] mb-6">Edit Location</h1>

        <!-- Flash messages -->
        <c:if test="${not empty success}">
            <div class="flex items-center gap-2 p-3 mb-4 bg-green-50 border-l-4 border-green-400 text-green-700 rounded">
                <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.707a1 1 0 00-1.414-1.414L9 
                      10.586 7.707 9.293a1 1 0 10-1.414 
                      1.414L9 13.414l4.707-4.707z"
                      clip-rule="evenodd"/>
                </svg>
                <span class="text-sm font-medium">${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="flex items-center gap-2 p-3 mb-4 bg-red-50 border-l-4 border-red-400 text-red-700 rounded">
                <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd"
                      d="M8.257 3.099c.765-1.36 2.72-1.36 
                      3.485 0l5.516 9.814A1.75 1.75 
                      0 0116.516 15H3.484a1.75 1.75 
                      0 01-1.742-2.087L8.257 3.1zM11 
                      13a1 1 0 10-2 0 1 1 0 002 
                      0zm-.25-2.75a.75.75 0 
                      00-1.5 0v1.5a.75.75 0 
                      001.5 0v-1.5z"
                      clip-rule="evenodd"/>
                </svg>
                <span class="text-sm font-medium">${error}</span>
            </div>
        </c:if>


        <form action="${pageContext.request.contextPath}/admin/locations" method="post" class="space-y-6">
            <!-- Indicate action edit -->
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="locationId" value="${loc.locationId}" />

            <!-- Location Name -->
            <div>
                <label for="loc-name" class="block text-sm font-medium text-gray-700 mb-1">Location Name</label>
                <input
                    type="text"
                    id="loc-name"
                    name="locationName"
                    value="${loc.locationName}"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    required
                    />
            </div>

            <!-- Address -->
            <div>
                <label for="loc-address" class="block text-sm font-medium text-gray-700 mb-1">Address</label>
                <input
                    type="text"
                    id="loc-address"
                    name="address"
                    value="${loc.address}"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                    required
                    />
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
                        value="${loc.latitude}"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required
                        />
                </div>
                <div>
                    <label for="longitude" class="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                    <input
                        type="number"
                        step="any"
                        id="longitude"
                        name="longitude"
                        value="${loc.longitude}"
                        class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                        required
                        />
                </div>
            </div>

            <!-- Map Preview -->
            <div id="map" style="height: 300px; margin:1rem 0;"></div>

            <!-- Description -->
            <div>
                <label for="loc-desc" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea
                    id="loc-desc"
                    name="description"
                    rows="3"
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400 resize-none"
                    >${loc.locationDescription}</textarea>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Location Type  -->
                <div>
                    <label for="locationType" class="block text-sm font-medium text-gray-700 mb-1">Location Type</label>
                    <select id="locationType" name="locationType"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-400"
                            required>
                        <option value="City" ${loc.locationType=='City'?'selected':''}>City</option>
                        <option value="Bus Terminal" ${loc.locationType=='Bus Terminal'?'selected':''}>Bus Terminal</option>
                        <option value="Rest Stop" ${loc.locationType=='Rest Stop'?'selected':''}>Rest Stop</option>
                        <option value="Province" ${loc.locationType=='Province'?'selected':''}>Province</option>
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
                    <button type="button" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-6 py-2 rounded-lg transition">
                        Cancel
                    </button>
                </a>
                <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white font-medium px-6 py-2 rounded-lg transition">
                    Update Location
                </button>
            </div>
        </form>
    </div>

    <%-- Leaflet JS for map --%>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
        // Initialize map
        var map = L.map('map').setView([${loc.latitude}, ${loc.longitude}], 13);
        L.tileLayer('http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'], maxZoom: 20, attribution: '© Google'
        }).addTo(map);
        var marker = L.marker([${loc.latitude}, ${loc.longitude}], {draggable: true}).addTo(map);
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
        document.getElementById('latitude').addEventListener('change', function () {
            var lat = parseFloat(this.value), lng = parseFloat(document.getElementById('longitude').value);
            if (!isNaN(lat) && !isNaN(lng)) {
                marker.setLatLng([lat, lng]);
                map.panTo([lat, lng]);
            }
        });
        document.getElementById('longitude').addEventListener('change', function () {
            var lat = parseFloat(document.getElementById('latitude').value), lng = parseFloat(this.value);
            if (!isNaN(lat) && !isNaN(lng)) {
                marker.setLatLng([lat, lng]);
                map.panTo([lat, lng]);
            }
        });
    </script>

    <%-- CONTENT HERE--%>
    <%@include file="/WEB-INF/include/admin/admin-footer.jsp" %>