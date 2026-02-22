package com.app.app_website_do_luu_niem.controller.shop;

import com.app.app_website_do_luu_niem.dao.ProductDao;
import com.app.app_website_do_luu_niem.dao.impl.ProductDaoImpl;
import com.app.app_website_do_luu_niem.model.CartItem;
import com.app.app_website_do_luu_niem.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "cartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        List<CartItem> cart = getCart(session);
        req.setAttribute("cartItems", cart);
        req.setAttribute("totalAmount", calculateTotal(cart));
        req.getRequestDispatcher("/WEB-INF/views/shop/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "add";
        }
        HttpSession session = req.getSession(true);
        List<CartItem> cart = getCart(session);

        switch (action) {
            case "add" -> handleAdd(req, cart);
            case "update" -> handleUpdate(req, cart);
            case "remove" -> handleRemove(req, cart);
            default -> {
            }
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        Object obj = session.getAttribute("cart");
        if (obj instanceof List) {
            return (List<CartItem>) obj;
        }
        List<CartItem> cart = new ArrayList<>();
        session.setAttribute("cart", cart);
        return cart;
    }

    private void handleAdd(HttpServletRequest req, List<CartItem> cart) {
        String idParam = req.getParameter("productId");
        String qtyParam = req.getParameter("quantity");
        int productId;
        int quantity = 1;
        try {
            productId = Integer.parseInt(idParam);
            if (qtyParam != null) {
                quantity = Integer.parseInt(qtyParam);
            }
        } catch (NumberFormatException e) {
            return;
        }

        Optional<Product> opt = productDao.findById(productId);
        if (opt.isEmpty()) {
            return;
        }
        Product product = opt.get();
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        CartItem item = new CartItem();
        item.setProduct(product);
        item.setQuantity(quantity);
        cart.add(item);
    }

    private void handleUpdate(HttpServletRequest req, List<CartItem> cart) {
        String[] ids = req.getParameterValues("productId");
        String[] quantities = req.getParameterValues("quantity");
        if (ids == null || quantities == null || ids.length != quantities.length) {
            return;
        }
        for (int i = 0; i < ids.length; i++) {
            try {
                int id = Integer.parseInt(ids[i]);
                int qty = Integer.parseInt(quantities[i]);
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == id) {
                        if (qty <= 0) {
                            item.setQuantity(0);
                        } else {
                            item.setQuantity(qty);
                        }
                        break;
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }
        // remove zero-quantity items
        Iterator<CartItem> it = cart.iterator();
        while (it.hasNext()) {
            if (it.next().getQuantity() <= 0) {
                it.remove();
            }
        }
    }

    private void handleRemove(HttpServletRequest req, List<CartItem> cart) {
        String idParam = req.getParameter("productId");
        try {
            int id = Integer.parseInt(idParam);
            cart.removeIf(item -> item.getProduct().getId() == id);
        } catch (NumberFormatException ignored) {
        }
    }

    private BigDecimal calculateTotal(List<CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getTotalPrice());
        }
        return total;
    }
}


