/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminBusesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminBuses;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusesServlet extends HttpServlet {

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

        AdminBusesDAO adminBusesDAO = new AdminBusesDAO();

        // Lấy tham số hành động (action)
        // Xử lý thêm xe buýt
        if (request.getParameter("add") != null) {
            // Lấy tất cả loại xe buýt
            List<AdminBusTypes> busTypes = adminBusesDAO.getAllBusTypes();
            request.setAttribute("busTypes", busTypes); // Gửi dữ liệu busTypes vào JSP
            request.getRequestDispatcher("/WEB-INF/admin/buses/add-bus.jsp").forward(request, response);
            return;
        }

        // Xử lý xóa xe buýt
        if (request.getParameter("delete") != null) {  // Nếu action là "delete"
            try {
                // Lấy busId từ tham số `delete` trong URL
                String busIdStr = request.getParameter("delete");
                if (busIdStr != null && !busIdStr.trim().isEmpty()) {
                    int busId = Integer.parseInt(busIdStr);  // Chuyển busId sang int nếu hợp lệ

                    // Lấy thông tin xe buýt từ DAO
                    AdminBuses bus = adminBusesDAO.getBusById(busId);  // Lấy thông tin xe buýt theo busId

                    if (bus != null) {
                        // Gửi thông tin xe buýt vào request để hiển thị trong trang delete
                        request.setAttribute("bus", bus);

                        // Chuyển tiếp yêu cầu tới trang delete-bus.jsp để người dùng xác nhận xóa
                        request.getRequestDispatcher("/WEB-INF/admin/buses/delete-bus.jsp").forward(request, response);
                        return;
                    } else {
                        // Nếu không tìm thấy xe buýt, chuyển hướng về trang danh sách xe buýt
                        response.sendRedirect(request.getContextPath() + "/admin/buses");
                    }
                } else {
                    // Nếu không có busId trong URL, chuyển hướng về trang danh sách xe buýt
                    response.sendRedirect(request.getContextPath() + "/admin/buses");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                // Nếu có lỗi khi lấy busId, chuyển hướng về trang danh sách xe buýt
                response.sendRedirect(request.getContextPath() + "/admin/buses");
            }
        }

        // Xử lý chỉnh sửa xe buýt
        if (request.getParameter("editId") != null) {
            // Forward đến trang chỉnh sửa xe buýt
            String editId = request.getParameter("editId");  // Lấy tham số editId từ URL

            if (editId != null) {
                try {
                    int busId = Integer.parseInt(editId);  // Chuyển editId sang int

                    AdminBuses bus = adminBusesDAO.getBusById(busId);  // Lấy thông tin xe buýt theo busId

                    if (bus != null) {
                        // Gửi thông tin xe buýt vào request để hiển thị trên form
                        request.setAttribute("bus", bus);

                        // Lấy danh sách các loại xe buýt để hiển thị trong dropdown
                        List<AdminBusTypes> busTypes = adminBusesDAO.getAllBusTypes();
                        request.setAttribute("busTypes", busTypes);  // Chuyển danh sách busTypes vào request

                        // Chuyển tiếp tới trang chỉnh sửa xe buýt
                        request.getRequestDispatcher("/WEB-INF/admin/buses/edit-bus.jsp").forward(request, response);
                        return;
                    } else {
                        // Nếu không tìm thấy xe buýt, chuyển hướng về trang danh sách xe buýt
                        response.sendRedirect(request.getContextPath() + "/admin/buses");
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    // Nếu editId không hợp lệ (không phải số), gửi lỗi và chuyển hướng về trang danh sách xe buýt
                    response.sendRedirect(request.getContextPath() + "/admin/buses");
                }
            } else {
                // Nếu không có editId trong URL, chuyển hướng về trang danh sách xe buýt
                response.sendRedirect(request.getContextPath() + "/admin/buses");
            }
        }

        // Xử lý phân trang
        int requestsPerPage = 10;
        int currentPage = 1;

        // Kiểm tra tham số page trong URL
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;  // Nếu không phải số, mặc định trang là 1
            }
        }

        // Tính toán offset cho truy vấn SQL
        int offset = (currentPage - 1) * requestsPerPage;

        // Lấy danh sách xe buýt theo phân trang
        List<AdminBuses> busesList = adminBusesDAO.getAllBuses(offset, requestsPerPage);
        int totalBuses = adminBusesDAO.countAllBuses();  // Tổng số xe buýt
        int totalPages = (int) Math.ceil((double) totalBuses / requestsPerPage);  // Tổng số trang

        // Set dữ liệu vào request để truyền cho JSP
        request.setAttribute("busesList", busesList);
        request.setAttribute("totalBuses", totalBuses);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Chuyển tiếp yêu cầu đến JSP mà không thay đổi URL
        request.getRequestDispatcher("/WEB-INF/admin/buses/buses.jsp").forward(request, response);
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
        AdminBusesDAO adminBusesDAO = new AdminBusesDAO();
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                String busCode = request.getParameter("busCode");
                String plateNumber = request.getParameter("plateNumber");
                int busTypeId = Integer.parseInt(request.getParameter("busTypeId"));
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String busStatus = request.getParameter("busStatus");

                // Kiểm tra xem busCode hoặc plateNumber đã tồn tại chưa
                boolean isBusExist = adminBusesDAO.isBusExist(busCode, plateNumber);

                if (isBusExist) {
                    // Lưu thông báo lỗi vào session và chuyển hướng về trang add-bus.jsp
                    String error = "Bus Code or Plate Number already exists!";
                    request.getSession().setAttribute("error", error);
                    response.sendRedirect(request.getContextPath() + "/admin/buses?add");
                    return;
                }

                // Nếu không có lỗi, tiến hành thêm xe buýt vào cơ sở dữ liệu
                AdminBuses bus = new AdminBuses(busCode, plateNumber, busTypeId, capacity, busStatus);
                try {
                    adminBusesDAO.addBus(bus);
                    // Sau khi thêm xe buýt thành công, lưu thông báo thành công vào session
                    request.getSession().setAttribute("success", "Bus added successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/buses"); // Chuyển hướng về trang add-bus.jsp
                } catch (Exception e) {
                    e.printStackTrace();
                    // Lưu thông báo lỗi vào session nếu có lỗi
                    request.getSession().setAttribute("error", "Failed to add bus. Please try again.");
                    response.sendRedirect(request.getContextPath() + "/admin/buses?add");
                }
            } else if ("edit".equals(action)) {
                // --- UPDATE bus ---
                try {
                    // Lấy dữ liệu từ form và kiểm tra null
                    int busId = 0;
                    String busIdStr = request.getParameter("busId");
                    if (busIdStr != null && !busIdStr.trim().isEmpty()) {
                        busId = Integer.parseInt(busIdStr);  // Chuyển busId sang int nếu hợp lệ
                    } else {
                        throw new NumberFormatException("Bus ID is invalid.");
                    }

                    String busCode = request.getParameter("busCode");

                    String plateNumber = request.getParameter("plate"); // Plate Number
                    int busTypeId = 0;
                    String busTypeIdStr = request.getParameter("type");
                    if (busTypeIdStr != null && !busTypeIdStr.trim().isEmpty()) {
                        busTypeId = Integer.parseInt(busTypeIdStr); // Bus Type ID
                    } else {
                        throw new NumberFormatException("Bus Type ID is invalid.");
                    }

                    int capacity = 0;
                    String capacityStr = request.getParameter("capacity"); // Capacity
                    if (capacityStr != null && !capacityStr.trim().isEmpty()) {
                        capacity = Integer.parseInt(capacityStr);  // Chuyển capacity sang int nếu hợp lệ
                    } else {
                        throw new NumberFormatException("Capacity is invalid.");
                    }

                    String busStatus = request.getParameter("status"); // Bus Status

                    // Tạo đối tượng AdminBuses để lưu trữ thông tin cần chỉnh sửa
                    AdminBuses bus = new AdminBuses();
                    bus.setBusId(busId);
                    bus.setBusCode(busCode);
                    bus.setPlateNumber(plateNumber);
                    bus.setBusTypeId(busTypeId);
                    bus.setCapacity(capacity);
                    bus.setBusStatus(busStatus);

                    // Gọi phương thức updateBus trong DAO để cập nhật dữ liệu
                    adminBusesDAO.updateBus(bus); // Cập nhật xe buýt

                    // Lưu thông báo thành công vào session
                    request.getSession().setAttribute("success", "Bus updated successfully!");

                    // Sau khi cập nhật thành công, chuyển hướng về trang danh sách xe buýt
                    response.sendRedirect(request.getContextPath() + "/admin/buses");

                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    // Lưu thông báo lỗi vào session nếu có lỗi xảy ra
                    request.getSession().setAttribute("error", "Invalid input. Please make sure all fields are correctly filled.");

                    // Truyền `editId` vào để giữ lại URL và form
                    String editId = request.getParameter("busId"); // Sử dụng busId thay vì id để giữ chính xác giá trị
                    request.setAttribute("editId", editId);

                    // Nếu có lỗi, forward lại về trang chỉnh sửa mà không thay đổi URL
                    request.getRequestDispatcher("/WEB-INF/admin/buses/edit-bus.jsp").forward(request, response);
                }

                // Loại bỏ success và error khỏi session sau khi forward hoặc redirect
                request.getSession().removeAttribute("success");
                request.getSession().removeAttribute("error");
            } else if ("delete".equals(action)) {  // Nếu action là "delete"
                try {
                    // Lấy busId từ tham số `delete` trong request
                    String busIdStr = request.getParameter("busId"); // Lấy busId từ form
                    if (busIdStr != null && !busIdStr.trim().isEmpty()) {
                        int busId = Integer.parseInt(busIdStr);  // Chuyển busId sang int

                        // Gọi phương thức deleteBus trong DAO để xóa xe buýt
                        adminBusesDAO.deleteBus(busId);  // Thực hiện xóa xe buýt

                        // Lưu thông báo thành công vào session
                        request.getSession().setAttribute("success", "Bus deleted successfully!");

                        // Sau khi xóa thành công, chuyển hướng về trang danh sách xe buýt
                        response.sendRedirect(request.getContextPath() + "/admin/buses");

                    } else {
                        // Nếu không có busId trong request, thông báo lỗi
                        request.getSession().setAttribute("error", "Invalid bus ID for deletion.");
                        response.sendRedirect(request.getContextPath() + "/admin/buses");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    // Nếu có lỗi, thông báo lỗi và quay lại trang danh sách xe buýt
                    request.getSession().setAttribute("error", "Error occurred while deleting bus.");
                    response.sendRedirect(request.getContextPath() + "/admin/buses");
                }
            }

        } catch (Exception ex) {
            // Nếu có lỗi, đưa thông báo vào request và forward về trang error hoặc list
            response.sendRedirect(request.getContextPath() + "/admin/buses");
            return;
        }
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
