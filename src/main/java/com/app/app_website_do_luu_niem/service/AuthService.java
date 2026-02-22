package com.app.app_website_do_luu_niem.service;

import com.app.app_website_do_luu_niem.dao.UserDao;
import com.app.app_website_do_luu_niem.dao.impl.UserDaoImpl;
import com.app.app_website_do_luu_niem.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.Optional;

public class AuthService {

    private final UserDao userDao = new UserDaoImpl();

    public Optional<User> login(String email, String password) {
        return userDao.findByEmail(email)
                .filter(User::isActive)
                .filter(u -> BCrypt.checkpw(password, u.getPasswordHash()));
    }

    public boolean register(String fullName, String email, String rawPassword) {
        if (userDao.findByEmail(email).isPresent()) {
            return false;
        }
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(BCrypt.hashpw(rawPassword, BCrypt.gensalt()));
        user.setRole("CUSTOMER");
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        userDao.save(user);
        return true;
    }

    public boolean resetPassword(String email, String newPassword) {
        Optional<User> opt = userDao.findByEmail(email);
        if (opt.isEmpty()) {
            return false;
        }
        User user = opt.get();
        user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        userDao.update(user);
        return true;
    }
}


