<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Giỏ hàng"/>
<%@ include file="/WEB-INF/views/layout/header.jspf" %>

<h4 class="section-title mb-4">Giỏ hàng</h4>

<c:choose>
    <c:when test="${empty cartItems}">
        <div class="alert alert-info">Giỏ hàng trống. <a href="${pageContext.request.contextPath}/products">Mua sắm ngay</a></div>
    </c:when>
    <c:otherwise>
        <form method="post" action="${pageContext.request.contextPath}/cart">
            <input type="hidden" name="action" value="update">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${cartItems}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/product?id=${item.product.id}" class="text-decoration-none text-dark">
                                        <c:out value="${item.product.name}"/>
                                    </a>
                                </td>
                                <td>
                                    <span class="price-value" data-price="${item.product.price}">${item.product.price}</span> &#8363;
                                </td>
                                <td>
                                    <input type="hidden" name="productId" value="${item.product.id}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stock}" class="form-control form-control-sm" style="width: 70px;">
                                </td>
                                <td>
                                    <span class="item-total" data-price="${item.totalPrice}">${item.totalPrice}</span> &#8363;
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-sm btn-outline-danger" onclick="event.preventDefault(); document.getElementById('remove${item.product.id}').submit();">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-4">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-souvenir">Tiếp tục mua</a>
                <div>
                    <strong>Tổng: <span class="price-value" data-price="${totalAmount}">${totalAmount}</span> &#8363;</strong>
                    <button type="submit" class="btn btn-souvenir ms-3">Cập nhật</button>
                </div>
            </div>
        </form>

        <form id="removeForm" method="post" action="${pageContext.request.contextPath}/cart" style="display:none;">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="productId" id="removeProductId">
        </form>
        <c:forEach var="item" items="${cartItems}">
            <form id="remove${item.product.id}" method="post" action="${pageContext.request.contextPath}/cart" style="display:none;">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="productId" value="${item.product.id}">
            </form>
        </c:forEach>

        <div class="text-end mt-3">
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-souvenir btn-lg">Thanh toán</a>
        </div>
    </c:otherwise>
</c:choose>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tính tổng tiền tự động khi thay đổi số lượng
    const quantityInputs = document.querySelectorAll('input[name="quantity"]');
    quantityInputs.forEach(input => {
        input.addEventListener('change', function() {
            const row = this.closest('tr');
            const price = parseFloat(row.querySelector('.price-value').getAttribute('data-price')) || 0;
            const qty = parseInt(this.value) || 0;
            const total = price * qty;
            const totalCell = row.querySelector('.item-total');
            totalCell.textContent = new Intl.NumberFormat('vi-VN').format(total);
            totalCell.setAttribute('data-price', total);
            
            // Cập nhật tổng
            updateCartTotal();
        });
    });
    
    function updateCartTotal() {
        let total = 0;
        document.querySelectorAll('.item-total').forEach(el => {
            const price = parseFloat(el.getAttribute('data-price')) || 0;
            total += price;
        });
        const totalEl = document.querySelector('strong .price-value');
        if (totalEl) {
            totalEl.textContent = new Intl.NumberFormat('vi-VN').format(total);
            totalEl.setAttribute('data-price', total);
        }
    }
});
</script>

<%@ include file="/WEB-INF/views/layout/footer.jspf" %>

