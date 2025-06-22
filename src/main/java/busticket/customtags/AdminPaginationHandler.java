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
            // Retrieve pagination parameters
            Integer currentPageObj = (Integer) pageContext.getRequest().getAttribute("currentPage");
            Integer totalPagesObj = (Integer) pageContext.getRequest().getAttribute("totalPages");
            int currentPage = (currentPageObj != null) ? currentPageObj : 1;
            int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;

            // Optional filters
            String searchQuery = (String) pageContext.getRequest().getAttribute("searchQuery");
            String selectedGenre = (String) pageContext.getRequest().getAttribute("selectedGenre");
            searchQuery = (searchQuery != null) ? searchQuery : "";
            selectedGenre = (selectedGenre != null) ? selectedGenre : "";

            // Build base URL with existing params
            StringBuilder base = new StringBuilder((url != null ? url : ""));
            base.append((url != null && url.contains("?")) ? "&" : "?");
            if (!searchQuery.isEmpty()) base.append("search=").append(searchQuery).append("&");
            if (!selectedGenre.isEmpty()) base.append("genre=").append(selectedGenre).append("&");
            String baseUrl = base.toString();

            // Tailwind-styled pagination container
            pagination.append("<div class=\"flex justify-center space-x-2 mt-6\">");

            // First and Previous buttons
            if (currentPage > 1) {
                pagination.append(String.format(
                    "<a href=\"%spage=1\" class=\"px-3 py-2 border border-orange-500 text-orange-500 rounded-lg hover:bg-orange-100\">&laquo;</a>", baseUrl
                ));
                pagination.append(String.format(
                    "<a href=\"%spage=%d\" class=\"px-3 py-2 border border-orange-500 text-orange-500 rounded-lg hover:bg-orange-100\">&lt;</a>", baseUrl, currentPage - 1
                ));
            } else {
                pagination.append("<button disabled class=\"px-3 py-2 border border-gray-300 text-gray-400 rounded-lg cursor-not-allowed\">&laquo;</button>");
                pagination.append("<button disabled class=\"px-3 py-2 border border-gray-300 text-gray-400 rounded-lg cursor-not-allowed\">&lt;</button>");
            }

            // Numeric page links
            int range = 3;
            int startPage = Math.max(1, currentPage - range);
            int endPage = Math.min(totalPages, currentPage + range);
            for (int i = startPage; i <= endPage; i++) {
                if (i == currentPage) {
                    pagination.append(String.format(
                        "<button class=\"px-4 py-2 bg-[#EF5222] text-white rounded-lg\">%d</button>", i
                    ));
                } else {
                    pagination.append(String.format(
                        "<a href=\"%spage=%d\" class=\"px-4 py-2 border border-orange-500 text-orange-500 rounded-lg hover:bg-orange-100\">%d</a>", baseUrl, i, i
                    ));
                }
            }

            // Next and Last buttons
            if (currentPage < totalPages) {
                pagination.append(String.format(
                    "<a href=\"%spage=%d\" class=\"px-3 py-2 border border-orange-500 text-orange-500 rounded-lg hover:bg-orange-100\">&gt;</a>", baseUrl, currentPage + 1
                ));
                pagination.append(String.format(
                    "<a href=\"%spage=%d\" class=\"px-3 py-2 border border-orange-500 text-orange-500 rounded-lg hover:bg-orange-100\">&raquo;</a>", baseUrl, totalPages
                ));
            } else {
                pagination.append("<button disabled class=\"px-3 py-2 border border-gray-300 text-gray-400 rounded-lg cursor-not-allowed\">&gt;</button>");
                pagination.append("<button disabled class=\"px-3 py-2 border border-gray-300 text-gray-400 rounded-lg cursor-not-allowed\">&raquo;</button>");
            }

            pagination.append("</div>");
            pageContext.getOut().write(pagination.toString());
        } catch (IOException e) {
            throw new JspException("Error in AdminPaginationTag", e);
        }
        return SKIP_BODY;
    }
}
