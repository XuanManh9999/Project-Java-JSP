package com.app.app_website_do_luu_niem.controller.admin;

import com.app.app_website_do_luu_niem.dao.CategoryDao;
import com.app.app_website_do_luu_niem.dao.ProductDao;
import com.app.app_website_do_luu_niem.dao.impl.CategoryDaoImpl;
import com.app.app_website_do_luu_niem.dao.impl.ProductDaoImpl;
import com.app.app_website_do_luu_niem.model.Category;
import com.app.app_website_do_luu_niem.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "adminProductServlet", urlPatterns = "/admin/products")
@MultipartConfig
public class AdminProductServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDaoImpl();
    private final CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "create" -> showForm(req, resp, new Product());
            case "edit" -> showEditForm(req, resp);
            case "delete" -> handleDelete(req, resp);
            default -> showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        Product product;
        if (idParam == null || idParam.isBlank()) {
            product = new Product();
            product.setCreatedAt(LocalDateTime.now());
        } else {
            int id = Integer.parseInt(idParam);
            Optional<Product> opt = productDao.findById(id);
            product = opt.orElseGet(Product::new);
        }

        product.setName(req.getParameter("name"));
        product.setDescription(req.getParameter("description"));
        try {
            product.setPrice(new BigDecimal(req.getParameter("price")));
        } catch (Exception e) {
            product.setPrice(BigDecimal.ZERO);
        }
        try {
            product.setStock(Integer.parseInt(req.getParameter("stock")));
        } catch (Exception e) {
            product.setStock(0);
        }

        String categoryIdParam = req.getParameter("categoryId");
        if (categoryIdParam != null && !categoryIdParam.isBlank()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                Category c = new Category();
                c.setId(categoryId);
                product.setCategory(c);
            } catch (NumberFormatException ignored) {
            }
        }

        Part imagePart = req.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadsDir = getServletContext().getRealPath("/uploads");
            File dir = new File(uploadsDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
            File file = new File(dir, fileName);
            imagePart.write(file.getAbsolutePath());
            product.setImageUrl("uploads/" + fileName);
        }

        if (product.getId() == 0) {
            productDao.save(product);
        } else {
            productDao.update(product);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Parse parameters
        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int pageSize = parseIntOrDefault(req.getParameter("pageSize"), 10);
        String search = req.getParameter("search");
        String categoryIdParam = req.getParameter("categoryId");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        
        if (search != null && search.isBlank()) {
            search = null;
        }
        
        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException ignored) {
            }
        }
        
        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "id";
        }
        if (sortOrder == null || sortOrder.isBlank()) {
            sortOrder = "DESC";
        }
        
        // Get products with pagination
        List<Product> products = productDao.findAll(page, pageSize, search, categoryId, sortBy + " " + sortOrder);
        int totalProducts = productDao.countAll(search, categoryId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        
        // Get categories for filter
        List<Category> categories = categoryDao.findAll();
        
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("search", search != null ? search : "");
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }
    
    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, Product product)
            throws ServletException, IOException {
        req.setAttribute("product", product);
        req.setAttribute("categories", categoryDao.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            Optional<Product> opt = productDao.findById(id);
            if (opt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
            showForm(req, resp, opt.get());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                productDao.delete(id);
            } catch (NumberFormatException ignored) {
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }
}


