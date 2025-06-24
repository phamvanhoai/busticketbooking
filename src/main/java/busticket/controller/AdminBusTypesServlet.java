/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminBusTypesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminSeatPosition;
import busticket.model.AdminSeatTemplate;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

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

        HttpSession session = request.getSession();
        AdminBusTypesDAO adminBusTypesDAO = new AdminBusTypesDAO();
        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        // Chuyển hướng đến trang thêm loại xe
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
            return;
        }

        // Chuyển hướng đến trang xóa loại xe
        if (request.getParameter("delete") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/delete-bus-type.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("editId") != null) {
            try {
                String editId = request.getParameter("editId");
                int id = Integer.parseInt(editId);

                // Lấy thông tin loại xe từ DB
                AdminBusTypes busType = adminBusTypesDAO.getBusTypeById(id);
                request.setAttribute("busType", busType);

                // Lấy thông tin ghế đã lưu (tầng dưới và tầng trên)
                // 2. Lấy danh sách ghế
                List<AdminSeatPosition> seatsDown = adminBusTypesDAO.getSeatPositionsForBusType(id, "down");
                List<AdminSeatPosition> seatsUp = adminBusTypesDAO.getSeatPositionsForBusType(id, "up");

// 3. Đưa vào request để JSP dùng JSTL render server-side
                request.setAttribute("busType", busType);
                request.setAttribute("seatsDown", seatsDown);
                request.setAttribute("seatsUp", seatsUp);
                ObjectMapper mapper = new ObjectMapper();
request.setAttribute("seatsDownJson", mapper.writeValueAsString(seatsDown));
request.setAttribute("seatsUpJson",   mapper.writeValueAsString(seatsUp));


// 4. Đưa cả cấu hình rows/cols/prefix để bảng biết kích thước
                request.setAttribute("rowsDown", busType.getRowsDown());
                request.setAttribute("colsDown", busType.getColsDown());
                request.setAttribute("prefixDown", busType.getPrefixDown());
                request.setAttribute("rowsUp", busType.getRowsUp());
                request.setAttribute("colsUp", busType.getColsUp());
                request.setAttribute("prefixUp", busType.getPrefixUp());

                // Tiến hành forward tới JSP
                request.getRequestDispatcher("/WEB-INF/admin/bus-types/edit-bus-type.jsp").forward(request, response);
                return;
            } catch (SQLException ex) {
                Logger.getLogger(AdminBusTypesServlet.class.getName()).log(Level.SEVERE, "SQLException", ex);
                // Nếu có lỗi SQL, bạn có thể trả về một trang lỗi hoặc thông báo lỗi
                request.setAttribute("error", "Error retrieving data: " + ex.getMessage());
                request.getRequestDispatcher("/WEB-INF/admin/error.jsp").forward(request, response);
            } catch (NumberFormatException ex) {
                // Nếu có lỗi trong việc chuyển đổi ID sang Integer
                request.setAttribute("error", "Invalid bus type ID format");
                request.getRequestDispatcher("/WEB-INF/admin/error.jsp").forward(request, response);
            }
        }

        // Phân trang
        int currentPage = 1;
        int rowsPerPage = 10;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;  // Nếu không hợp lệ, giữ lại trang 1
            }
        }
        int offset = (currentPage - 1) * rowsPerPage;

        try {
            List<AdminBusTypes> list = adminBusTypesDAO.getBusTypes(offset, rowsPerPage);
            int total = adminBusTypesDAO.getTotalBusTypesCount();
            int totalPages = (int) Math.ceil((double) total / rowsPerPage);

            request.setAttribute("busTypes", list);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            throw new ServletException("Error while fetching bus types", e);
        }

        // Chuyển hướng tới trang danh sách loại xe
        request.getRequestDispatcher("/WEB-INF/admin/bus-types/bus-types.jsp")
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
        HttpSession session = request.getSession();
        AdminBusTypesDAO adminBusTypesDAO = new AdminBusTypesDAO();

        try {
            if ("add".equals(action)) {
                // 1. Lấy dữ liệu từ form
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                String layoutDown = request.getParameter("layoutDown");
                String layoutUp = request.getParameter("layoutUp");

                // **MỚI**: đọc thêm cấu hình ghế
                int rowsDown = Integer.parseInt(request.getParameter("rowsDown"));
                int colsDown = Integer.parseInt(request.getParameter("colsDown"));
                String prefixDown = request.getParameter("prefixDown");
                int rowsUp = Integer.parseInt(request.getParameter("rowsUp"));
                int colsUp = Integer.parseInt(request.getParameter("colsUp"));
                String prefixUp = request.getParameter("prefixUp");

                // 2. Khởi tạo model với đủ thông số
                AdminBusTypes model = new AdminBusTypes();
                model.setBusTypeName(name);
                model.setBusTypeDescription(desc);
                model.setRowsDown(rowsDown);
                model.setColsDown(colsDown);
                model.setPrefixDown(prefixDown);
                model.setRowsUp(rowsUp);
                model.setColsUp(colsUp);
                model.setPrefixUp(prefixUp);

                // 3. Thêm Bus_Type và lấy ID
                int busTypeId = adminBusTypesDAO.insertBusType(model);

                // 4. Parse JSON layout và thêm chi tiết ghế tầng dưới
                ObjectMapper mapper = new ObjectMapper();
                TypeReference<List<Map<String, Object>>> ref
                        = new TypeReference<List<Map<String, Object>>>() {
                };

                List<Map<String, Object>> downSeats = mapper.readValue(layoutDown, ref);
                int order = 1;
                for (Map<String, Object> seat : downSeats) {
                    int r = Integer.parseInt(seat.get("r").toString());
                    int c = Integer.parseInt(seat.get("c").toString());
                    String code = seat.get("code").toString();
                    adminBusTypesDAO.insertSeatPosition(busTypeId, "down", r, c, order++, code);
                }

                // 5. Tầng trên tương tự
                List<Map<String, Object>> upSeats = mapper.readValue(layoutUp, ref);
                order = 1;
                for (Map<String, Object> seat : upSeats) {
                    int r = Integer.parseInt(seat.get("r").toString());
                    int c = Integer.parseInt(seat.get("c").toString());
                    String code = seat.get("code").toString();
                    adminBusTypesDAO.insertSeatPosition(busTypeId, "up", r, c, order++, code);
                }

                session.setAttribute("success", "Tạo loại xe thành công!");

            } else if ("edit".equals(action)) {
                // 1. Lấy dữ liệu từ form
                int busTypeId = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                String layoutDown = request.getParameter("layoutDown");
                String layoutUp = request.getParameter("layoutUp");

                // 2. Cập nhật Bus_Types
                AdminBusTypes model = new AdminBusTypes(busTypeId, name, desc);
                adminBusTypesDAO.updateBusType(model);

                // 3. Xử lý ghế tầng dưới
                ObjectMapper mapper = new ObjectMapper();
                TypeReference<List<Map<String, Object>>> ref
                        = new TypeReference<List<Map<String, Object>>>() {
                };
                List<Map<String, Object>> downSeats = mapper.readValue(layoutDown, ref);
                for (Map<String, Object> seat : downSeats) {
                    int r = Integer.parseInt(seat.get("r").toString());
                    int c = Integer.parseInt(seat.get("c").toString());
                    String code = seat.get("code").toString();
                    adminBusTypesDAO.updateSeatPosition(busTypeId, "down", r, c, code);
                }

                // 4. Xử lý ghế tầng trên
                List<Map<String, Object>> upSeats = mapper.readValue(layoutUp, ref);
                for (Map<String, Object> seat : upSeats) {
                    int r = Integer.parseInt(seat.get("r").toString());
                    int c = Integer.parseInt(seat.get("c").toString());
                    String code = seat.get("code").toString();
                    adminBusTypesDAO.updateSeatPosition(busTypeId, "up", r, c, code);
                }

                session.setAttribute("success", "Cập nhật loại xe thành công!");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                adminBusTypesDAO.deleteBusType(id);
                session.setAttribute("success", "Xóa loại xe thành công!");
            }
            // TODO: edit/delete nếu cần
        } catch (Exception ex) {
            session.setAttribute("error", "Lỗi: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bus-types");
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
