/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverIncidentsDAO;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverIncidents;
import busticket.model.Users;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import busticket.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class DriverIncidentsServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "/assets/images/uploads/";

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
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isDriver(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

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

        Users currentUser = (Users) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = currentUser.getUser_id();
        DriverIncidentsDAO driverIncidentsDAO = new DriverIncidentsDAO();
        int driverId = driverIncidentsDAO.getDriverIdFromUser(userId);
        if (driverId == -1) {
            session.setAttribute("error", "No driver found for this account.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String add = request.getParameter("add");
        if (add != null) {
            List<DriverAssignedTrip> assignedTrips = driverIncidentsDAO.getAssignedTripsForDriver(userId);
            request.setAttribute("assignedTrips", assignedTrips);
            request.getRequestDispatcher("/WEB-INF/driver/incidents/add-incident.jsp").forward(request, response);
            return;
        }

        // Pagination setup
        int currentPage = 1;
        int requestsPerPage = 10;
        try {
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        int offset = (currentPage - 1) * requestsPerPage;

        // Retrieve paginated incidents and total count
        List<DriverIncidents> incidents = driverIncidentsDAO.getIncidentsByDriver(driverId, offset, requestsPerPage);
        int totalIncidents = driverIncidentsDAO.countIncidentsByDriver(driverId);
        int totalPages = (int) Math.ceil((double) totalIncidents / requestsPerPage);

        // Set attributes for JSP
        request.setAttribute("incidents", incidents);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalIncidents", totalIncidents);

        request.getRequestDispatcher("/WEB-INF/driver/incidents/driver-incidents.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        int userId = currentUser.getUser_id();
        DriverIncidentsDAO dao = new DriverIncidentsDAO();
        int driverId = dao.getDriverIdFromUser(userId);
        if (driverId == -1) {
            session.setAttribute("error", "No driver found for this account.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("createIncident".equals(action)) {
            Integer tripId = request.getParameter("tripId") != null && !request.getParameter("tripId").isEmpty()
                    ? Integer.parseInt(request.getParameter("tripId")) : null;
            String description = request.getParameter("incidentDescription");
            String location = request.getParameter("incidentLocation");
            String incidentType = request.getParameter("incidentType");

            // Xử lý upload ảnh
            String photoUrl = handleFileUpload(request, dao);

            // Xác thực input
            if (description == null || description.isEmpty() || incidentType == null) {
                session.setAttribute("error", "Incident description and type are required, and the incident type must be valid.");
                response.sendRedirect(request.getContextPath() + "/driver/incidents?add");
                return;
            }

            // Kiểm tra khóa ngoại tripId
            if (tripId != null && !dao.isValidTripId(tripId)) {
                session.setAttribute("error", "Invalid trip.");
                response.sendRedirect(request.getContextPath() + "/driver/incidents?add");
                return;
            }

            // Lưu vào database
            boolean created = dao.createIncident(driverId, tripId, description, location, photoUrl, incidentType);
            if (created) {
                session.setAttribute("success", "Urgent report sent successfully!");
                response.sendRedirect(request.getContextPath() + "/driver/incidents");
            } else {
                session.setAttribute("error", "Error saving report to database.");
                response.sendRedirect(request.getContextPath() + "/driver/incidents?add");
            }
            return;
        }
    }

    private String handleFileUpload(HttpServletRequest request, DriverIncidentsDAO dao) throws IOException, ServletException {
        Part filePart = request.getPart("incidentPhoto");
        String fileName = filePart != null ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;
        String photoUrl = null;

        if (fileName != null && !fileName.isEmpty()) {
            // Kiểm tra định dạng file
            if (!fileName.toLowerCase().endsWith(".jpg") && !fileName.toLowerCase().endsWith(".png")) {
                request.getSession().setAttribute("error", "Only JPG or PNG files are accepted.");
                return null;
            }

            // Tạo tên file duy nhất
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR.replace("/", File.separator);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            try {
                filePart.write(filePath);
                photoUrl = UPLOAD_DIR + uniqueFileName;
            } catch (IOException e) {
                request.getSession().setAttribute("error", "Error uploading photo:" + e.getMessage());
                return null;
            }
        }
        return photoUrl;
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
