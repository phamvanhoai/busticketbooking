<%-- 
    Document   : assign-driver-to-trip
    Created on : Jun 14, 2025, 11:48:32 AM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/staff/staff-header.jsp" %>


<body class="bg-[#f9fafb]">

    <div class="px-4 mt-10">
        <h2 class="text-3xl font-bold text-orange-600 mb-6">Assign Driver to Trip</h2>

        <!-- Filters -->
        <div class="flex flex-col lg:grid lg:grid-cols-5 gap-4 items-center mb-6">
            <input
                type="text"
                placeholder="Search by Trip ID or Route"
                class="w-full border rounded-lg px-4 py-2 col-span-2"
                />

            <input
                type="date"
                value="2025-06-10"
                class="w-full border rounded-lg px-4 py-2"
                />

            <select class="w-full border rounded-lg px-4 py-2">
                <option value="All">All Routes</option>
                <option value="HCM → Can Tho">HCM → Can Tho</option>
                <option value="Can Tho → Chau Doc">Can Tho → Chau Doc</option>
            </select>

            <select class="w-full border rounded-lg px-4 py-2">
                <option value="All">All Status</option>
                <option value="Assigned">Assigned</option>
                <option value="Not Assigned">Not Assigned</option>
            </select>
        </div>

        <!-- Table -->
        <div class="bg-white shadow-lg rounded-xl overflow-x-auto">
            <table class="min-w-full text-left">
                <thead class="bg-orange-100 text-orange-700">
                    <tr>
                        <th class="py-2 px-4">Trip ID</th>
                        <th class="py-2 px-4">Route</th>
                        <th class="py-2 px-4">Date</th>
                        <th class="py-2 px-4">Status</th>
                        <th class="py-2 px-4">Assigned Driver</th>
                        <th class="py-2 px-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Trip Row 1 -->
                    <tr class="border-t hover:bg-gray-50">
                        <td class="py-2 px-4">TRIP1000</td>
                        <td class="py-2 px-4">HCM → Can Tho</td>
                        <td class="py-2 px-4">10/06/2025 08:00</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full bg-yellow-100 text-yellow-700">Scheduled</span>
                        </td>
                        <td class="py-2 px-4">—</td>
                        <td class="py-2 px-4">
                            <button class="text-blue-600 hover:underline flex items-center gap-1" onclick="openAssignModal('TRIP1000')">
                                <span>👤</span> Assign
                            </button>
                        </td>
                    </tr>

                    <!-- Trip Row 2 -->
                    <tr class="border-t hover:bg-gray-50">
                        <td class="py-2 px-4">TRIP1001</td>
                        <td class="py-2 px-4">Can Tho → Chau Doc</td>
                        <td class="py-2 px-4">11/06/2025 09:00</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full bg-blue-100 text-blue-700">Departed</span>
                        </td>
                        <td class="py-2 px-4">Driver 2</td>
                        <td class="py-2 px-4">
                            <button class="text-blue-600 hover:underline flex items-center gap-1" onclick="openAssignModal('TRIP1001')">
                                <span>👤</span> Assign
                            </button>
                        </td>
                    </tr>

                    <!-- Trip Row 3 -->
                    <tr class="border-t hover:bg-gray-50">
                        <td class="py-2 px-4">TRIP1002</td>
                        <td class="py-2 px-4">HCM → Vung Tau</td>
                        <td class="py-2 px-4">12/06/2025 10:00</td>
                        <td class="py-2 px-4">
                            <span class="px-3 py-1 text-sm rounded-full bg-green-100 text-green-700">Arrived</span>
                        </td>
                        <td class="py-2 px-4">Driver 3</td>
                        <td class="py-2 px-4">
                            <button class="text-blue-600 hover:underline flex items-center gap-1" onclick="openAssignModal('TRIP1002')">
                                <span>👤</span> Assign
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center gap-2 mt-6">
            <button class="px-3 py-1 rounded-md border bg-orange-500 text-white">1</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">2</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">3</button>
            <button class="px-3 py-1 rounded-md border bg-white text-orange-500 border-orange-300 hover:bg-orange-100">4</button>
        </div>

        <!-- Modal for Assign Driver -->
        <div id="assign-modal" class="fixed inset-0 bg-black bg-opacity-40 flex justify-center items-center z-50" style="display: none;">
            <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-md relative">
                <h3 class="text-lg font-bold mb-4" id="modal-title">Assign Driver to Trip</h3>
                <label class="block mb-2 text-sm font-medium">Available Drivers</label>
                <select id="driver-select" class="w-full border px-4 py-2 rounded-lg mb-4">
                    <option value="">-- Select Driver --</option>
                    <option value="Driver 1">Driver 1</option>
                    <option value="Driver 2">Driver 2</option>
                    <option value="Driver 3">Driver 3</option>
                </select>
                <div class="flex justify-end gap-2">
                    <button onclick="closeModal()" class="px-4 py-2 rounded-lg border border-gray-300">
                        Cancel
                    </button>
                    <button onclick="confirmAssignment()" class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">
                        Confirm
                    </button>
                </div>
            </div>
        </div>

    </div>

    <script>
        // Function to open the modal and load the trip info
        function openAssignModal(tripId) {
            document.getElementById('assign-modal').style.display = 'flex';
            document.getElementById('modal-title').innerText = `Assign Driver to ${tripId}`;
        }

        // Function to close the modal
        function closeModal() {
            document.getElementById('assign-modal').style.display = 'none';
        }

        // Function to confirm the driver assignment
        function confirmAssignment() {
            const driver = document.getElementById('driver-select').value;
            if (driver) {
                alert(`Driver ${driver} has been assigned!`);
            } else {
                alert('Please select a driver.');
            }
            closeModal();
        }
    </script>
    <%-- CONTENT HERE--%>

    <%@include file="/WEB-INF/include/staff/staff-footer.jsp" %>