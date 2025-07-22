/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminLocationsDAO;
import busticket.model.AdminLocations;
import static busticket.util.InputValidator.checkNull;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminLocationsServlet extends HttpServlet {

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

        // Check if the user is an admin; redirect to home if not
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        AdminLocationsDAO adminLocationsDAO = new AdminLocationsDAO();

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }

        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/locations/add-location.jsp")
                    .forward(request, response);
            return;
        }

        // View details
        String detail = request.getParameter("detail");
        if (detail != null) {
            try {
                int locId = Integer.parseInt(detail);
                AdminLocations loc = adminLocationsDAO.getLocationById(locId);
                request.setAttribute("location", loc);
            } catch (Exception e) {
                throw new ServletException("Invalid location ID for detail", e);
            }
            request.getRequestDispatcher("/WEB-INF/admin/locations/view-location-details.jsp")
                    .forward(request, response);
            return;
        }

        String editId = request.getParameter("editId");
        if (editId != null) {
            try {
                int id = Integer.parseInt(editId);
                AdminLocations loc = adminLocationsDAO.getLocationById(id);
                request.setAttribute("location", loc);
                request.getRequestDispatcher("/WEB-INF/admin/locations/edit-location.jsp")
                        .forward(request, response);
                return;
            } catch (NumberFormatException | SQLException e) {
                throw new ServletException("Invalid location ID for edit", e);
            }
        }

        //Delete
        String delete = request.getParameter("delete");
        if (delete != null) {
            try {
                int id = Integer.parseInt(delete);
                AdminLocations loc = adminLocationsDAO.getLocationById(id);
                request.setAttribute("location", loc);
                request.getRequestDispatcher("/WEB-INF/admin/locations/delete-location.jsp")
                        .forward(request, response);
            } catch (Exception e) {
                throw new ServletException("Invalid location ID for delete", e);
            }
            return;

        }
        // 2. Phân trang + search
        String search = request.getParameter("search");  // từ ô input
        int currentPage = 1, rowsPerPage = 10;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                /* giữ currentPage = 1 */ }
        }
        int offset = (currentPage - 1) * rowsPerPage;

        try {
            List<AdminLocations> list = adminLocationsDAO.getLocations(search, offset, rowsPerPage);
            int total = adminLocationsDAO.getTotalLocationsCount(search);
            int totalPages = (int) Math.ceil((double) total / rowsPerPage);

            request.setAttribute("locations", list);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalLocations", total);
            request.setAttribute("search", search);
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("/WEB-INF/admin/locations/locations.jsp")
                .forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        AdminLocationsDAO dao = new AdminLocationsDAO();
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                String locationIdStr = request.getParameter("locationId");
                if (checkNull(locationIdStr)) {
                    session.setAttribute("error", "Location ID is required.");
                    response.sendRedirect(request.getContextPath() + "/admin/locations");
                    return;
                }
                int id = Integer.parseInt(locationIdStr);
                dao.deleteLocation(id);
                session.setAttribute("success", "Location deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/locations");
                return;
            }
            // Kiểm tra các tham số bắt buộc
            String locationName = request.getParameter("locationName");
            String address = request.getParameter("address");
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            String locationType = request.getParameter("locationType");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            if (checkNull(locationName) || checkNull(address) || checkNull(latitudeStr)
                    || checkNull(longitudeStr) || checkNull(locationType) || checkNull(status)) {
                session.setAttribute("error", "Please fill in all required fields.");

                // Kiểm tra action và forward về trang chính xác
                if ("edit".equals(action)) {
                    String locationId = request.getParameter("locationId");
                    request.setAttribute("id", locationId); // Giữ lại ID khi sửa
                    request.setAttribute("locationName", locationName);
                    request.setAttribute("address", address);
                    request.setAttribute("latitude", latitudeStr);
                    request.setAttribute("longitude", longitudeStr);
                    request.setAttribute("locationType", locationType);
                    request.setAttribute("description", description);
                    request.setAttribute("status", status);

                    // Forward lại trang edit
                    request.getRequestDispatcher("/WEB-INF/admin/locations/edit-location.jsp").forward(request, response);
                } else {
                    // Forward về trang thêm nếu là action add
                    request.getRequestDispatcher("/WEB-INF/admin/locations/add-location.jsp").forward(request, response);
                }
                return;
            }

            if ("add".equals(action)) {
                AdminLocations loc = new AdminLocations();
                loc.setLocationName(locationName);
                loc.setAddress(address);
                loc.setLatitude(Double.parseDouble(latitudeStr));
                loc.setLongitude(Double.parseDouble(longitudeStr));
                loc.setLocationType(locationType);
                loc.setLocationDescription(description);
                loc.setLocationStatus(status);

                dao.insertLocation(loc);
                session.setAttribute("success", "Location added successfully!");

            } else if ("edit".equals(action)) {
                // Kiểm tra id, nếu có lỗi thì return
                String locationIdStr = request.getParameter("locationId");
                if (checkNull(locationIdStr)) {
                    session.setAttribute("error", "Location ID is required.");
                    request.getRequestDispatcher("/WEB-INF/admin/locations/edit-location.jsp").forward(request, response);
                    return;
                }
                int locationId = Integer.parseInt(locationIdStr);

                AdminLocations loc = new AdminLocations();
                loc.setLocationId(locationId);
                loc.setLocationName(locationName);
                loc.setAddress(address);
                loc.setLatitude(Double.parseDouble(latitudeStr));
                loc.setLongitude(Double.parseDouble(longitudeStr));
                loc.setLocationType(locationType);
                loc.setLocationDescription(description);
                loc.setLocationStatus(status);
                dao.updateLocation(loc);
                session.setAttribute("success", "Location updated successfully!");

            }

        } catch (Exception ex) {
            session.setAttribute("error", "Error processing location: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/locations");
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
