/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminRoutesDAO;
import busticket.model.AdminRoutes;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminRoutesServlet extends HttpServlet {

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

        AdminRoutesDAO dao = new AdminRoutesDAO();

        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/routes/add-route.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("editId") != null) {
    int id = Integer.parseInt(request.getParameter("editId"));
    AdminRoutes route = dao.getRouteById(id);  // Gọi phương thức để lấy tuyến đường
    request.setAttribute("route", route);  // Đặt đối tượng route vào request
    request.getRequestDispatcher("/WEB-INF/admin/routes/edit-route.jsp").forward(request, response);
    return;
}

    // Chức năng Delete
    if (request.getParameter("delete") != null) {
        int routeId = Integer.parseInt(request.getParameter("delete"));
        AdminRoutes route = dao.getRouteById(routeId);  // Lấy thông tin tuyến đường cần xóa
        if (route != null) {
            request.setAttribute("route", route);  // Set dữ liệu vào request để hiển thị trên form
            request.getRequestDispatcher("/WEB-INF/admin/routes/delete-route.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Route not found.");
        }
        return;
    }

// Fetch all routes
        // Pagination setup
    int requestsPerPage = 10;  // Số dòng mỗi trang
    int currentPage = 1;  // Mặc định trang 1
    if (request.getParameter("page") != null) {
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * requestsPerPage;

    // Fetch routes with pagination
    List<AdminRoutes> routesList = dao.getAllRoutes(offset, requestsPerPage);
    int totalRoutes = dao.countRoutes();
    int totalPages = (int) Math.ceil((double) totalRoutes / requestsPerPage);

    // Set attributes for JSP
    request.setAttribute("routes", routesList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/admin/routes/routes.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminRoutesDAO dao = new AdminRoutesDAO();

        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            AdminRoutes r = new AdminRoutes();
            r.setStartLocation(request.getParameter("origin"));
            r.setEndLocation(request.getParameter("destination"));

            // Kiểm tra và xử lý estimatedTime (Chuyển từ HH:mm:ss sang phút)
            try {
                String estimatedTimeStr = request.getParameter("estimatedTime");

                int estimatedTimeInMinutes = convertTimeToMinutes(estimatedTimeStr);  // Hàm chuyển từ HH:mm:ss sang phút
                r.setEstimatedTime(String.format("%d minutes", estimatedTimeInMinutes));  // Lưu kết quả ở dạng phút
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid estimated time format. Please use HH:mm:ss format.");
                return;
            }

            // Kiểm tra và xử lý distance
            String distanceStr = request.getParameter("distance");
            if (distanceStr != null && !distanceStr.isEmpty()) {
                // Loại bỏ "km" nếu có
                distanceStr = distanceStr.replace("km", "").trim(); // Loại bỏ "km" và khoảng trắng
                try {
                    double distance = Double.parseDouble(distanceStr);  // Chuyển đổi phần số thành Double
                    r.setDistanceKm(distance);  // Lưu giá trị distance
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid distance format. Please provide a valid number.");
                    return;
                }
            }

            try {
                dao.createRoute(r);
                response.sendRedirect("routes");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating route.");
            }
            return;
        }

        if ("update".equalsIgnoreCase(action)) {
        // Xử lý cập nhật tuyến đường
        int routeId = Integer.parseInt(request.getParameter("route_id"));
        AdminRoutes r = new AdminRoutes();
        r.setRouteId(routeId);
        r.setStartLocation(request.getParameter("origin"));
        r.setEndLocation(request.getParameter("destination"));
        r.setDistanceKm(Double.parseDouble(request.getParameter("distance")));
        r.setEstimatedTime(request.getParameter("estimatedTime"));

        try {
            dao.updateRoute(r);  // Gọi phương thức cập nhật tuyến đường trong DAO
            response.sendRedirect("routes");  // Redirect về danh sách tuyến đường
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating route.");
        }
        return;
    }

    if ("delete".equalsIgnoreCase(action)) {
        // Xử lý xóa tuyến đường
        int routeId = Integer.parseInt(request.getParameter("route_id"));
        try {
            dao.deleteRoute(routeId);  // Gọi phương thức xóa tuyến đường trong DAO
            response.sendRedirect("routes");  // Redirect về danh sách tuyến đường
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting route.");
        }
        return;
    }
}

// Hàm chuyển đổi từ HH:mm:ss sang số phút
    private int convertTimeToMinutes(String timeStr) throws Exception {
        // Kiểm tra xem timeStr có đúng định dạng không
        if (timeStr == null || !timeStr.matches("^\\d{2}:\\d{2}:\\d{2}$")) {
            throw new Exception("Invalid time format. Expected HH:mm:ss.");
        }

        String[] timeParts = timeStr.split(":");
        int hours = Integer.parseInt(timeParts[0]);
        int minutes = Integer.parseInt(timeParts[1]);

        // Tính tổng số phút
        return hours * 60 + minutes;
    }
}
