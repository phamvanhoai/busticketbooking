/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminBusTypesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminSeatPosition;
import busticket.util.InputValidator;
import static busticket.util.InputValidator.checkNull;
import busticket.util.SessionUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

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

        // Check if the user is an admin; redirect to home if not
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }
        AdminBusTypesDAO adminBusTypesDAO = new AdminBusTypesDAO();
        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        // flash messages
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

        // Chuyển hướng đến trang thêm loại xe
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
            return;
        }

        // Chuyển hướng đến trang xem chi tiet loại xe
        if (request.getParameter("detail") != null) {
            String sid = request.getParameter("detail");
            try {
                int id = Integer.parseInt(sid);
                // 1. Lấy BusType
                AdminBusTypes busType = adminBusTypesDAO.getBusTypeById(id);
                if (busType == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/bus-types");
                    return;
                }
                // 2. Lấy seat templates
                List<AdminSeatPosition> seatsDown = adminBusTypesDAO.getSeatPositionsForBusType(id, "down");
                List<AdminSeatPosition> seatsUp = adminBusTypesDAO.getSeatPositionsForBusType(id, "up");

                // 3. Đưa vào request
                request.setAttribute("busType", busType);
                request.setAttribute("seatsDown", seatsDown);
                request.setAttribute("seatsUp", seatsUp);

                // Forward đến JSP chi tiết
                request.getRequestDispatcher("/WEB-INF/admin/bus-types/view-bus-type-details.jsp")
                        .forward(request, response);
            } catch (NumberFormatException | SQLException ex) {
                // nếu id sai hoặc lỗi SQL, quay về list
                response.sendRedirect(request.getContextPath() + "/admin/bus-types");
            }
            return;
        }

        // Chuyển hướng đến trang xóa loại xe
        if (request.getParameter("delete") != null) {
            String sid = request.getParameter("delete");
            try {
                int id = Integer.parseInt(sid);
                AdminBusTypes busType = adminBusTypesDAO.getBusTypeById(id);
                if (busType == null) {
                    // Không tìm thấy, quay về list
                    response.sendRedirect(request.getContextPath() + "/admin/bus-types");
                    return;
                }
                request.setAttribute("busType", busType);
                request.getRequestDispatcher("/WEB-INF/admin/bus-types/delete-bus-type.jsp")
                        .forward(request, response);
            } catch (NumberFormatException | SQLException ex) {
                // Nếu lỗi, quay về list
                response.sendRedirect(request.getContextPath() + "/admin/bus-types");
            }
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
                request.setAttribute("seatsUpJson", mapper.writeValueAsString(seatsUp));

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
                String seatType = request.getParameter("seatType");

                // Kiểm tra các tham số đầu vào có null hoặc rỗng hay không
                if (checkNull(name) || checkNull(layoutDown)
                        || checkNull(prefixDown) || checkNull(seatType)) {
                    session.setAttribute("error", "Please fill in all fields.");
                    request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
                    return;
                }

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
                model.setSeatType(seatType);

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

                session.setAttribute("success", "Create a successful vehicle!");

            } else if ("edit".equals(action)) {
                // 1. Đọc form
                int busTypeId = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                int rowsDown = Integer.parseInt(request.getParameter("rowsDown"));
                int colsDown = Integer.parseInt(request.getParameter("colsDown"));
                String prefixDown = request.getParameter("prefixDown");
                int rowsUp = Integer.parseInt(request.getParameter("rowsUp"));
                int colsUp = Integer.parseInt(request.getParameter("colsUp"));
                String prefixUp = request.getParameter("prefixUp");
                String seatType = request.getParameter("seatType");

                // 2. Cập nhật Bus_Types toàn bộ cột
                AdminBusTypes updateModel = new AdminBusTypes();
                updateModel.setBusTypeId(busTypeId);
                updateModel.setBusTypeName(name);
                updateModel.setBusTypeDescription(desc);
                updateModel.setRowsDown(rowsDown);
                updateModel.setColsDown(colsDown);
                updateModel.setPrefixDown(prefixDown);
                updateModel.setRowsUp(rowsUp);
                updateModel.setColsUp(colsUp);
                updateModel.setPrefixUp(prefixUp);
                updateModel.setSeatType(seatType);
                adminBusTypesDAO.updateBusType(updateModel);

                // 3. Xóa hết seat cũ để insert lại
                adminBusTypesDAO.deleteSeatsForBusType(busTypeId);

                // 4. Parse JSON layout và insert lại seats
                TypeReference<List<Map<String, Object>>> ref
                        = new TypeReference<List<Map<String, Object>>>() {
                };
                List<Map<String, Object>> downSeats = mapper.readValue(
                        request.getParameter("layoutDown"), ref);
                int order = 1;
                for (Map<String, Object> s : downSeats) {
                    int r = (int) s.get("r");
                    int c = (int) s.get("c");
                    String code = s.get("code").toString();
                    adminBusTypesDAO.insertSeatPosition(busTypeId, "down", r, c, order++, code);
                }
                List<Map<String, Object>> upSeats = mapper.readValue(
                        request.getParameter("layoutUp"), ref);
                order = 1;
                for (Map<String, Object> s : upSeats) {
                    int r = (int) s.get("r");
                    int c = (int) s.get("c");
                    String code = s.get("code").toString();
                    adminBusTypesDAO.insertSeatPosition(busTypeId, "up", r, c, order++, code);
                }

                session.setAttribute("success", "Vehicle type updated successfully!");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                adminBusTypesDAO.deleteBusType(id);
                session.setAttribute("success", "Vehicle type deleted successfully!");
            }
            // TODO: edit/delete nếu cần
        } catch (Exception ex) {
            session.setAttribute("error", "Error: " + ex.getMessage());
            return;

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
