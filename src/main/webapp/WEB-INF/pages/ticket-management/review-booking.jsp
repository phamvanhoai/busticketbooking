<%-- 
    Document   : review-booking
    Created on : Jun 28, 2025, 11:00:22 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body class="bg-gray-50 min-h-screen">
  <div class="max-w-6xl mx-auto mt-12 p-8 bg-white rounded-3xl shadow-2xl border border-orange-300">
    <!-- Header -->
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-6">
      <div>
        <h1 class="text-3xl font-bold text-gray-800">Review Your Booking</h1>
        <p class="text-gray-500">We value your feedback. Please rate and review your recent trip.</p>
      </div>
    </div>

    <!-- Review Form -->
    <form action="#" method="post" class="space-y-6">
      <!-- Repeat this block for each booking -->
      <div class="p-6 bg-gray-50 rounded-2xl border border-gray-100">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-700">Route Name</h2>
            <p class="text-gray-500 mt-1">Departure: <span class="font-medium text-gray-600">2025-07-01 08:00 AM</span></p>
          </div>
        </div>

        <!-- Rating -->
        <div class="mt-4">
          <label class="block text-sm font-medium text-gray-700 mb-2">Your Rating</label>
          <div class="flex items-center space-x-1">
            <!-- 5-star rating -->
            <label class="cursor-pointer">
              <input type="radio" name="rating1" value="1" class="hidden peer" />
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 peer-checked:text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
              </svg>
            </label>
            <label class="cursor-pointer">
              <input type="radio" name="rating1" value="2" class="hidden peer" />
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 peer-checked:text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
              </svg>
            </label>
            <label class="cursor-pointer">
              <input type="radio" name="rating1" value="3" class="hidden peer" />
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 peer-checked:text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
              </svg>
            </label>
            <label class="cursor-pointer">
              <input type="radio" name="rating1" value="4" class="hidden peer" />
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 peer-checked:text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
              </svg>
            </label>
            <label class="cursor-pointer">
              <input type="radio" name="rating1" value="5" class="hidden peer" />
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300 peer-checked:text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.96a1 1 0 00.95.69h4.163c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.96c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.785.57-1.84-.197-1.54-1.118l1.286-3.96a1 1 0 00-.364-1.118L2.07 9.387c-.783-.57-.38-1.81.588-1.81h4.163a1 1 0 00.95-.69l1.286-3.96z" />
              </svg>
            </label>
          </div>
        </div>

        <!-- Review Text -->
        <div class="mt-4">
          <label for="reviewText1" class="block text-sm font-medium text-gray-700 mb-1">Your Review</label>
          <textarea id="reviewText1" name="reviewText1" rows="4" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200" placeholder="Share your experience..."></textarea>
        </div>
      </div>
      <!-- End booking block -->

      <!-- Submit Button -->
      <div class="text-right">
        <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white font-semibold px-6 py-3 rounded-full shadow">Submit Review</button>
      </div>
    </form>
  </div>

  <%@ include file="/WEB-INF/include/footer.jsp" %>