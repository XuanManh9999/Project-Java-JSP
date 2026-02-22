package com.app.app_website_do_luu_niem.controller.auth;

import com.app.app_website_do_luu_niem.dao.UserDao;
import com.app.app_website_do_luu_niem.dao.impl.UserDaoImpl;
import com.app.app_website_do_luu_niem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "changePasswordServlet", urlPatterns = "/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + 
                java.net.URLEncoder.encode(req.getRequestURI(), java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + 
                java.net.URLEncoder.encode(req.getRequestURI(), java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isBlank() ||
            newPassword == null || newPassword.isBlank() ||
            confirmPassword == null || confirmPassword.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra mật khẩu hiện tại
        Optional<User> opt = userDao.findById(currentUser.getId());
        if (opt.isEmpty()) {
            req.setAttribute("error", "Không tìm thấy tài khoản.");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        User user = opt.get();
        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            req.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra mật khẩu mới và xác nhận
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu mới và xác nhận không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        // Cập nhật mật khẩu
        user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        userDao.update(user);

        req.setAttribute("success", "Đổi mật khẩu thành công!");
        req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
    }
}

