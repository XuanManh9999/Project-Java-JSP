package com.app.app_website_do_luu_niem.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.stream.Collectors;

/**
 * Tự động khởi tạo bảng và dữ liệu mẫu khi ứng dụng khởi động nếu chưa tồn tại.
 */
@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            if (!tableExists("products")) {
                runSchemaInit();
            }
        } catch (Exception e) {
            sce.getServletContext().log("Không thể khởi tạo database: " + e.getMessage(), e);
        }
    }

    private boolean tableExists(String tableName) {
        try (Connection conn = DBConnection.getConnection();
             ResultSet rs = conn.getMetaData().getTables(null, null, tableName, null)) {
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }

    private void runSchemaInit() throws Exception {
        String sql = new BufferedReader(
                new InputStreamReader(
                        getClass().getClassLoader().getResourceAsStream("schema-init.sql"),
                        StandardCharsets.UTF_8
                )
        ).lines().collect(Collectors.joining("\n"));

        String[] statements = sql.split(";");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            for (String s : statements) {
                String trimmed = s.trim();
                if (!trimmed.isEmpty() && !trimmed.startsWith("--")) {
                    try {
                        stmt.execute(trimmed);
                    } catch (Exception e) {
                        // Bỏ qua lỗi INSERT khi đã có dữ liệu (chạy lại)
                        if (!e.getMessage().contains("Duplicate") && !e.getMessage().contains("already exists")) {
                            throw e;
                        }
                    }
                }
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}

