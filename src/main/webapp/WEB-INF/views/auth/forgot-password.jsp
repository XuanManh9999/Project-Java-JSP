<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quên mật khẩu"/>
<%@ include file="/WEB-INF/views/layout/header.jspf" %>

<div class="auth-page">
    <div class="auth-wrapper">
        <div class="auth-banner">
            <div class="icon-wrap"><i class="fas fa-key"></i></div>
            <h2>Đặt lại mật khẩu</h2>
            <p>Nhập email và mật khẩu mới để khôi phục tài khoản. Đảm bảo mật khẩu mới đủ mạnh để bảo vệ tài khoản của bạn.</p>
        </div>
        <div class="auth-form-section">
            <h3>Quên mật khẩu</h3>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><c:out value="${error}"/></div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success"><c:out value="${message}"/></div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Nhập email đăng ký" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu mới</label>
                    <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nhập lại mật khẩu mới</label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu mới" required>
                </div>
                <button type="submit" class="btn btn-souvenir mb-3">Cập nhật mật khẩu</button>
            </form>
            <div class="auth-divider">Nhớ mật khẩu rồi?</div>
            <a href="${pageContext.request.contextPath}/login" class="auth-link">Quay lại đăng nhập</a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jspf" %>
