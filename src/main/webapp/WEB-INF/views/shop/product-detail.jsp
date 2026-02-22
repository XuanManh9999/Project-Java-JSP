<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${product.name}"/>
<%@ include file="/WEB-INF/views/layout/header.jspf" %>

<div class="product-detail-wrapper">
    <div class="row">
        <div class="col-lg-6 mb-4">
            <div class="product-detail-image">
                <c:choose>
                    <c:when test="${not empty product.imageUrl}">
                        <img src="${product.imageUrl.startsWith('http') ? product.imageUrl : pageContext.request.contextPath.concat('/').concat(product.imageUrl)}" 
                             alt="<c:out value="${product.name}"/>"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="img-placeholder" style="display:none;">&#127921;</div>
                    </c:when>
                    <c:otherwise>
                        <div class="img-placeholder">&#127921;</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="product-detail-info">
                <h1 class="product-detail-title"><c:out value="${product.name}"/></h1>
                
                <div class="product-detail-price">
                    <span class="price-value" data-price="${product.price != null ? product.price : 0}">${product.price != null ? product.price : 0}</span>
                    <small>&#8363;</small>
                </div>
                
                <div class="product-detail-description">
                    <c:out value="${product.description}"/>
                </div>
                
                <div class="product-detail-meta">
                    <div class="product-detail-meta-item">
                        <i class="fas fa-box"></i>
                        <div>
                            <strong>Kho:</strong> ${product.stock} sản phẩm
                        </div>
                    </div>
                    <c:if test="${product.category != null}">
                        <div class="product-detail-meta-item">
                            <i class="fas fa-tag"></i>
                            <div>
                                <strong>Danh mục:</strong> <a href="${pageContext.request.contextPath}/products?category=${product.category.id}" class="text-decoration-none"><c:out value="${product.category.name}"/></a>
                            </div>
                        </div>
                    </c:if>
                </div>
                
                <div class="product-detail-actions">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="w-100">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">
                                <div class="d-flex gap-3 align-items-center flex-wrap mb-3">
                                    <div class="product-detail-quantity">
                                        <label class="mb-0"><strong>Số lượng:</strong></label>
                                        <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="form-control" required>
                                    </div>
                                    <span class="stock-badge in-stock">
                                        <i class="fas fa-check-circle"></i>Còn hàng
                                    </span>
                                </div>
                                <button type="submit" class="btn btn-souvenir w-100">
                                    <i class="fas fa-shopping-cart me-2"></i>Thêm vào giỏ hàng
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center w-100">
                                <span class="stock-badge out-of-stock">
                                    <i class="fas fa-times-circle"></i>Hết hàng
                                </span>
                                <p class="text-muted mt-3">Sản phẩm này hiện không còn hàng. Vui lòng quay lại sau.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${not empty relatedProducts}">
    <div class="related-products-section">
        <h4 class="section-title">Sản phẩm liên quan</h4>
        <div class="row g-4">
            <c:forEach var="p" items="${relatedProducts}">
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="card product-card h-100">
                        <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="text-decoration-none text-dark">
                            <div class="card-img-wrapper">
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${p.imageUrl.startsWith('http') ? p.imageUrl : pageContext.request.contextPath.concat('/').concat(p.imageUrl)}" 
                                             class="card-img-top" alt="<c:out value="${p.name}"/>"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="img-placeholder" style="display:none;">&#127921;</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="img-placeholder">&#127921;</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title"><c:out value="${p.name}"/></h6>
                                <p class="price mb-1">
                                    <span class="price-value" data-price="${p.price != null ? p.price : 0}">${p.price != null ? p.price : 0}</span>
                                    <small>&#8363;</small>
                                </p>
                                <c:if test="${p.stock <= 0}">
                                    <span class="badge bg-secondary">Hết hàng</span>
                                </c:if>
                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/views/layout/footer.jspf" %>
