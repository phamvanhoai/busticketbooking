<%-- 
    Document   : auth
    Created on : Jun 11, 2025, 10:26:00 PM
    Author     : Pham Van Hoai - CE181744
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/include/header.jsp" %>
<%--<%@include file="/WEB-INF/include/sidebar.jsp" %>--%>

<body class="min-h-screen flex justify-center items-center px-4 bg-white">

  <div class="w-full max-w-md bg-white rounded-2xl shadow-xl px-8 py-10">
    <h2 class="text-2xl font-bold text-center mb-6 text-[#111]">
      Log in account
    </h2>

    <!-- Tabs -->
    <div class="flex justify-center mb-8 border-b border-gray-200">
      <button id="loginTab" class="px-6 py-2 font-semibold text-sm border-b-2 text-[#ef5222] border-[#ef5222]" onclick="switchTab('login')">
        LOG IN
      </button>
      <button id="signupTab" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent" onclick="switchTab('signup')">
        REGISTER
      </button>
      <button id="forgotPasswordTab" class="px-6 py-2 font-semibold text-sm border-b-2 text-gray-400 border-transparent" onclick="switchTab('forgotPassword')">
        FORGOT PASSWORD
      </button>
    </div>

    <!-- LOG IN Form -->
    <div id="loginForm" class="space-y-5">
      <form onsubmit="handleLoginSubmit(event)">
        <div class="relative">
          <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
        </div>
        <div class="relative">
          <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="password" name="password" placeholder="Password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
          <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
        </div>
        <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
          Login
        </button>
        <div class="text-right">
          <button type="button" class="text-[#ef5222] text-sm font-medium hover:underline" onclick="switchTab('forgotPassword')">
            Forgot password
          </button>
        </div>
      </form>
    </div>

    <!-- REGISTER Form -->
    <div id="signupForm" class="space-y-5 hidden">
      <form onsubmit="handleRegisterSubmit(event)">
        <div class="relative">
          <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="text" name="fullName" placeholder="Full name" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
        </div>
        <div class="relative">
          <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
        </div>
        <div class="relative">
          <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="password" name="password" placeholder="Password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
          <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
        </div>
        <div class="relative">
          <i class="fas fa-key absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
          <input type="password" name="confirmPassword" placeholder="Confirm password" class="w-full pl-12 pr-10 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
          <i class="fas fa-eye-slash absolute right-4 top-1/2 -translate-y-1/2 text-[#bdbdbd] cursor-pointer"></i>
        </div>
        <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
          Confirm
        </button>
      </form>
    </div>

    <!-- FORGOT PASSWORD Form -->
    <div id="forgotPasswordForm" class="space-y-5 hidden">
      <p class="text-sm text-gray-600">
        Enter your email address and we will send you a link to reset your password.
      </p>
      <div class="relative">
        <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-[#ef5222]"></i>
        <input type="email" name="email" placeholder="Email" class="w-full pl-12 pr-4 py-3 border border-[#fc7b4c] rounded-xl text-sm placeholder-[#bdbdbd]" required />
      </div>
      <button type="submit" class="w-full bg-[#ef5222] hover:bg-[#fc7b4c] text-white font-bold py-3 rounded-full text-sm">
        Send Reset Link
      </button>
      <div class="text-center">
        <button class="text-[#ef5222] text-sm font-medium hover:underline" onclick="switchTab('login')">
          Back to login
        </button>
      </div>
    </div>
  </div>

  <script>
    // Switch between tabs
    function switchTab(tab) {
      // Hide all forms
      document.getElementById('loginForm').classList.add('hidden');
      document.getElementById('signupForm').classList.add('hidden');
      document.getElementById('forgotPasswordForm').classList.add('hidden');

      // Remove active class from all tabs
      document.getElementById('loginTab').classList.remove('text-[#ef5222]');
      document.getElementById('signupTab').classList.remove('text-[#ef5222]');
      document.getElementById('forgotPasswordTab').classList.remove('text-[#ef5222]');

      // Add active class to clicked tab
      if (tab === 'login') {
        document.getElementById('loginTab').classList.add('text-[#ef5222]');
        document.getElementById('loginForm').classList.remove('hidden');
      } else if (tab === 'signup') {
        document.getElementById('signupTab').classList.add('text-[#ef5222]');
        document.getElementById('signupForm').classList.remove('hidden');
      } else if (tab === 'forgotPassword') {
        document.getElementById('forgotPasswordTab').classList.add('text-[#ef5222]');
        document.getElementById('forgotPasswordForm').classList.remove('hidden');
      }
    }

    // Sample form submission handlers
    function handleLoginSubmit(event) {
      event.preventDefault();
      alert("Login submitted!");
    }

    function handleRegisterSubmit(event) {
      event.preventDefault();
      alert("Registration successful! Please verify your email.");
    }
  </script>

<%-- CONTENT HERE--%>

<%@include file="/WEB-INF/include/footer.jsp" %>