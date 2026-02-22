<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${product.id > 0 ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}"/>
<%@ include file="/WEB-INF/views/admin/layout/admin-header.jspf" %>

<div class="admin-card">
    <div class="admin-card-header">
        <h2 class="admin-card-title">
            <i class="fas fa-${product.id > 0 ? 'edit' : 'plus'} me-2"></i>${product.id > 0 ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}
        </h2>
        <a href="${pageContext.request.contextPath}/admin/products" class="admin-btn admin-btn-outline">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>
</div>

<form method="post" action="${pageContext.request.contextPath}/admin/products" enctype="multipart/form-data">
    <c:if test="${product.id > 0}">
        <input type="hidden" name="id" value="${product.id}">
    </c:if>
    
    <div class="row g-4">
        <div class="col-md-8">
            <div class="admin-card">
                <div class="admin-card-header">
                    <h5 class="admin-card-title mb-0">Thông tin sản phẩm</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="admin-filter-label">Tên sản phẩm *</label>
                        <input type="text" name="name" class="form-control" 
                               value="<c:out value="${product.name}"/>" required>
                    </div>
                    <div class="mb-3">
                        <label class="admin-filter-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="4"><c:out value="${product.description}"/></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="admin-filter-label">Giá *</label>
                            <input type="number" name="price" class="form-control" 
                                   value="${product.price}" min="0" step="1000" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="admin-filter-label">Số lượng tồn *</label>
                            <input type="number" name="stock" class="form-control" 
                                   value="${product.stock}" min="0" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="admin-filter-label">Danh mục</label>
                        <select name="categoryId" class="form-select">
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.id}" ${product.category != null and product.category.id eq c.id ? 'selected' : ''}>
                                    <c:out value="${c.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="admin-filter-label">Ảnh sản phẩm</label>
                        <input type="file" name="image" class="form-control" accept="image/*">
                        <c:if test="${not empty product.imageUrl}">
                            <small class="text-muted mt-2 d-block">
                                Ảnh hiện tại: <c:out value="${product.imageUrl}"/>
                            </small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="admin-card">
                <div class="admin-card-header">
                    <h5 class="admin-card-title mb-0">Thao tác</h5>
                </div>
                <div class="card-body">
                    <button type="submit" class="admin-btn admin-btn-primary w-100 mb-2">
                        <i class="fas fa-save me-2"></i>Lưu
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products" class="admin-btn admin-btn-outline w-100">
                        <i class="fas fa-times me-2"></i>Hủy
                    </a>
                </div>
            </div>
        </div>
    </div>
</form>

<%@ include file="/WEB-INF/views/admin/layout/admin-footer.jspf" %>
