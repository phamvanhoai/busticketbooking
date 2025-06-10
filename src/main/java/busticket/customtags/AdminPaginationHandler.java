/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.customtags;

import jakarta.servlet.jsp.JspException;
import static jakarta.servlet.jsp.tagext.Tag.SKIP_BODY;
import jakarta.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminPaginationHandler extends TagSupport {

    private String url;
    private int currentPage;
    private int totalPages;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = (url == null) ? "" : url; // Prevent NullPointerException
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    @Override
public int doStartTag() throws JspException {
    StringBuilder pagination = new StringBuilder();

    try {
        pagination.append("<ul class='pagination pagination-sm m-0 float-end'>");

        // ✅ Lấy dữ liệu và kiểm tra null
        Integer currentPageObj = (Integer) pageContext.getRequest().getAttribute("currentPage");
        Integer totalPagesObj = (Integer) pageContext.getRequest().getAttribute("totalPages");

        int currentPage = (currentPageObj != null) ? currentPageObj : 1;
        int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;

        String searchQuery = (String) pageContext.getRequest().getAttribute("searchQuery");
        String selectedGenre = (String) pageContext.getRequest().getAttribute("selectedGenre");

        searchQuery = (searchQuery != null) ? searchQuery : "";
        selectedGenre = (selectedGenre != null) ? selectedGenre : "";

        // ✅ Kiểm tra URL
        String safeUrl = (url != null) ? url : "";
        StringBuilder queryParams = new StringBuilder(safeUrl.contains("?") ? safeUrl + "&" : safeUrl + "?");

        if (!searchQuery.isEmpty()) {
            queryParams.append("search=").append(searchQuery).append("&");
        }
        if (!selectedGenre.isEmpty()) {
            queryParams.append("genre=").append(selectedGenre).append("&");
        }
        String baseUrl = queryParams.toString();

        // Previous Button
        if (currentPage > 1) {
            pagination.append(String.format("<li class='page-item'><a class='page-link' href='%spage=1'>&laquo;</a></li>", baseUrl));
            pagination.append(String.format("<li class='page-item'><a class='page-link' href='%spage=%d'>&lt;</a></li>", baseUrl, currentPage - 1));
        } else {
            pagination.append("<li class='page-item disabled'><a class='page-link'>Previous</a></li>");
        }

        // ✅ Xử lý hiển thị số trang
        int range = 3;
        int startPage = Math.max(1, currentPage - range);
        int endPage = Math.min(totalPages, currentPage + range);

        for (int i = startPage; i <= endPage; i++) {
            if (i == currentPage) {
                pagination.append(String.format("<li class='page-item active'><a class='page-link' href='%spage=%d'>%d</a></li>", baseUrl, i, i));
            } else {
                pagination.append(String.format("<li class='page-item'><a class='page-link' href='%spage=%d'>%d</a></li>", baseUrl, i, i));
            }
        }

        // Next Button
        if (currentPage < totalPages) {
            pagination.append(String.format("<li class='page-item'><a class='page-link' href='%spage=%d'>&gt;</a></li>", baseUrl, currentPage + 1));
            pagination.append(String.format("<li class='page-item'><a class='page-link' href='%spage=%d'>&raquo;</a></li>", baseUrl, totalPages));
        } else {
            pagination.append("<li class='page-item disabled'><a class='page-link'>Next</a></li>");
        }

        pagination.append("</ul>");
        pageContext.getOut().write(pagination.toString());
    } catch (IOException e) {
        throw new JspException("Error in PaginationHandler", e);
    }

    return SKIP_BODY;
}


}
