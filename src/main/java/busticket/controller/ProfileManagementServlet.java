/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.ProfileManangementDAO;
import busticket.model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ProfileManagementServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy đường dẫn từ URL (xóa phần base path như "/ticket-management")
        String path = request.getPathInfo();
        ProfileManangementDAO profileManangementDAO = new ProfileManangementDAO();

        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/profile/view");
            return;
        }

        // Dựa trên path để chuyển hướng tới các JSP khác nhau
        switch (path) {
            case "/view":
                // Lấy đối tượng User đã lưu trong session khi login
                HttpSession session = request.getSession(false);
                if (session == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                Users currentUser = (Users) session.getAttribute("currentUser");
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                int userId = currentUser.getUser_id();
                // Lấy lại thông tin user mới nhất từ DB
                Users profile = profileManangementDAO.getUserById(userId);
                // Đẩy xuống JSP
                request.setAttribute("userProfile", profile != null ? profile : currentUser);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/view-profile.jsp")
                       .forward(request, response);
                break;
            case "/update":
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                break;
            // Thêm các trường hợp khác nếu cần
            case "/change-password":
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                break;
            default:
                // Nếu không khớp với bất kỳ URL nào, có thể redirect về trang mặc định
                response.sendRedirect(request.getContextPath() + "/profile/view");
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
