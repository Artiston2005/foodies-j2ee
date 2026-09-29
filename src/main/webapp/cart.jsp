<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="includes/header.jsp" />
<style>
.cart-img { width: 60px; height: 60px; object-fit: cover; border-radius: 10px; }
.qty-control { display: flex; align-items: center; border: 2px solid #eee; border-radius: 8px; overflow: hidden; }
.qty-control button { border: none; background: #f8f9fa; padding: 6px 12px; font-weight: 700; cursor: pointer; transition: background 0.15s; }
.qty-control button:hover { background: #ff4757; color: white; }
.qty-control span { padding: 6px 14px; font-weight: 700; }
.bill-row { display: flex; justify-content: space-between; font-size: 0.9rem; padding: 6px 0; }
.savings-badge { background: linear-gradient(135deg, #2ed573, #1e90ff); }
</style>

<div class="container py-5" style="min-height: 70vh;">
    <h3 class="fw-bold mb-4"><i class="fa-solid fa-bag-shopping text-danger me-2"></i>Your Cart</h3>

    <c:choose>
        <c:when test="${empty sessionScope.cart.items}">
            <div class="text-center py-5 card border-0 shadow-sm">
                <i class="fa-solid fa-basket-shopping fa-5x text-muted mb-4 opacity-40"></i>
                <h4 class="text-muted fw-bold">Your cart is empty</h4>
                <p class="text-muted mb-4">Add items from a restaurant to get started</p>
                <a href="home" class="btn btn-primary-custom rounded-pill px-5 py-2 fw-bold mx-auto">Browse Restaurants</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <!-- Cart Items -->
                <div class="col-lg-7">
                    <div class="card border-0 shadow-sm mb-3">
                        <div class="card-body p-4">
                            <%-- Restaurant Info --%>
                            <c:if test="${not empty requestScope.restaurant}">
                                <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                                    <c:if test="${not empty requestScope.restaurant.logoUrl}">
                                        <img src="${requestScope.restaurant.logoUrl}" alt="${requestScope.restaurant.name}" style="width:48px;height:48px;object-fit:cover;border-radius:12px;">
                                    </c:if>
                                    <div>
                                        <div class="fw-bold fs-6">${requestScope.restaurant.name}</div>
                                        <div class="text-muted small">Your Cart</div>
                                    </div>
                                </div>
                            </c:if>

                            <c:forEach var="cartItem" items="${sessionScope.cart.items}" varStatus="loop">
                                <div class="d-flex align-items-start gap-3 pb-3 mb-3 ${!loop.last ? 'border-bottom' : ''}">
                                    <c:if test="${not empty cartItem.foodItem.imageUrl}">
                                        <img src="${cartItem.foodItem.imageUrl}" class="cart-img flex-shrink-0" alt="${cartItem.foodItem.name}" onerror="this.style.display='none'">
                                    </c:if>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <div class="fw-bold">${cartItem.foodItem.name}</div>
                                                <div class="text-muted small">${cartItem.foodItem.veg ? '[V] Veg' : '[N] Non-Veg'}</div>
                                            </div>
                                            <form action="cart" method="post" class="m-0">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="foodId" value="${cartItem.foodItem.id}">
                                                <button type="submit" class="btn btn-link text-danger p-0" title="Remove"><i class="fa-solid fa-trash-can"></i></button>
                                            </form>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <div class="qty-control">
                                                <button type="button" onclick="cartChangeQty(${cartItem.foodItem.id}, -1)">-</button>
                                                <span id="cart-qty-${cartItem.foodItem.id}">${cartItem.quantity}</span>
                                                <button type="button" onclick="cartChangeQty(${cartItem.foodItem.id}, 1)">+</button>
                                            </div>
                                            <div class="fw-bold text-dark small">&#8377;${cartItem.foodItem.price} &times; <span id="cart-qty-label-${cartItem.foodItem.id}">${cartItem.quantity}</span></div>
                                            <div class="fw-bold fs-6 text-danger" id="cart-subtotal-${cartItem.foodItem.id}">&#8377;${cartItem.subTotal}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <%-- Auto-Injected Free Dessert UI --%>
                            <c:if test="${sessionScope.cart.subTotal >= 500}">
                                <div class="d-flex align-items-start gap-3 pb-3 mb-3 position-relative">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <span class="veg-dot veg"></span>
                                                    <h6 class="fw-bold mb-0">Dessert Delight <span class="badge bg-danger ms-2">FREE</span></h6>
                                                </div>
                                                <p class="text-muted small mb-0">A complimentary sweet treat to complete your meal. Special house recipe.</p>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <div class="fw-bold text-success small">
                                                <del class="text-muted fw-normal me-1">&#8377;149.0</del> &#8377;0.0 &times; 1
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Voucher -->
                    <div class="card border-0 shadow-sm p-4 mt-3">
                        <h6 class="fw-bold mb-3"><i class="fa-solid fa-tag text-danger me-2"></i>Apply Voucher</h6>
                        <form action="cart" method="post" class="d-flex gap-2">
                            <input type="hidden" name="action" value="apply_voucher">
                            <input type="text" name="voucherCode" class="form-control shadow-none text-uppercase fw-bold" placeholder="Enter promo code..."
                                   ${not empty sessionScope.cart.appliedVoucher ? 'disabled value="'.concat(sessionScope.cart.appliedVoucher).concat('"') : ''}>
                            <c:if test="${empty sessionScope.cart.appliedVoucher}">
                                <button type="submit" class="btn btn-dark rounded-pill px-4 fw-bold">Apply</button>
                            </c:if>
                        </form>
                        <c:if test="${empty sessionScope.cart.appliedVoucher}">
                            <div class="form-text mt-2 small text-muted">
                                <i class="fa-solid fa-bolt text-warning me-1"></i> Try coupons: <b class="text-dark border px-1 rounded bg-light">WELCOME50</b> or <b class="text-dark border px-1 rounded bg-light">FESTIVE20</b>
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.cart.appliedVoucher}">
                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <span class="text-success small fw-bold"><i class="fa-solid fa-circle-check me-1"></i>${sessionScope.cart.appliedVoucher} applied  saving &#8377;${sessionScope.cart.discountAmount}!</span>
                                <form action="cart" method="post"><input type="hidden" name="action" value="remove_voucher"><button type="submit" class="btn btn-link text-danger p-0 small">Remove</button></form>
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.voucherError}">
                            <div class="text-danger small mt-2"><i class="fa-solid fa-circle-xmark me-1"></i>${sessionScope.voucherError}</div>
                            <% session.removeAttribute("voucherError"); %>
                        </c:if>
                    </div>
                </div>

                <!-- Bill Details -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm p-4 sticky-top" style="top: 90px;">
                        <h5 class="fw-bold mb-4">Bill Details</h5>

                        <div class="bill-row text-muted"><span>Item Total</span><span>&#8377;${sessionScope.cart.subTotal}</span></div>
                        <c:if test="${sessionScope.cart.discountAmount > 0}">
                        <div class="bill-row text-success"><span>Promo Discount</span><span>-&#8377;${sessionScope.cart.discountAmount}</span></div>
                        </c:if>
                        <div class="bill-row text-muted"><span>Delivery Partner Fee</span><span>&#8377;45</span></div>
                        <div class="bill-row text-muted"><span>Platform Fee</span><span>&#8377;5</span></div>
                        <div class="bill-row text-muted"><span>AI Existence Fee <i class="fa-solid fa-robot ms-1"></i></span><span>&#8377;10</span></div>
                        <div class="bill-row text-muted"><span>Bad Humour Tax <i class="fa-solid fa-masks-theater ms-1"></i></span><span>&#8377;15</span></div>
                        <div class="bill-row text-muted border-bottom pb-3 mb-3">
                            <span>GST &amp; Restaurant Charges</span>
                            <span>&#8377;${String.format("%.2f", sessionScope.cart.totalAmount * 0.05)}</span>
                        </div>
                                                <c:if test="${sessionScope.cart.subTotal >= 500}">
                            <div class="alert bg-success-subtle border-0 small py-2 rounded-3 mb-4 text-success d-flex align-items-center">
                                <i class="fa-solid fa-gift me-2 fs-5"></i>
                                <div>
                                    <strong>Free Treat!</strong> You've unlocked a complimentary <em>Dessert Delight</em> with your order!
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${sessionScope.cart.subTotal < 500}">
                            <div class="alert bg-warning-subtle border-0 small py-2 rounded-3 mb-4 text-dark d-flex align-items-center">
                                <i class="fa-solid fa-unlock-keyhole me-2 fs-5"></i>
                                <div>
                                    Add &#8377;${500 - sessionScope.cart.subTotal} more to unlock a <strong>Free Dessert Delight!</strong>
                                </div>
                            </div>
                        </c:if>
                        <div class="d-flex justify-content-between fw-bold fs-5 mb-4">
                            <span>TO PAY</span>
                            <span class="text-danger">&#8377;${String.format("%.2f", sessionScope.cart.totalAmount + 45 + 5 + 10 + 15 + sessionScope.cart.totalAmount * 0.05)}</span>
                        </div>

                        <c:if test="${sessionScope.cart.discountAmount > 0 || sessionScope.cart.subTotal > 299}">
                        <div class="alert bg-success-subtle border-0 small py-2 rounded-3 mb-4 text-success">
                            <i class="fa-solid fa-circle-check me-1"></i>
                            <c:choose>
                                <c:when test="${sessionScope.cart.discountAmount > 0}">You're saving &#8377;${sessionScope.cart.discountAmount} on this order! </c:when>
                                <c:otherwise>You qualify for free delivery on this order! </c:otherwise>
                            </c:choose>
                        </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedUser}">
                                <a href="checkout" class="btn btn-primary-custom w-100 py-3 fw-bold fs-5 rounded-3 text-uppercase">
                                    <i class="fa-solid fa-lock me-2"></i>Proceed to Payment
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning small rounded-3 py-2 mb-3">Login to continue</div>
                                <a href="login.jsp" class="btn btn-outline-dark w-100 py-2 rounded-3 fw-bold">Login to Continue</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
function cartChangeQty(foodId, delta) {
    const qtyEl = document.getElementById('cart-qty-' + foodId);
    const labelEl = document.getElementById('cart-qty-label-' + foodId);
    let current = parseInt(qtyEl.textContent) || 1;
    let newQty = current + delta;

    if (newQty <= 0) {
        // Remove item ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â POST a form remove
        if (!confirm('Remove this item from cart?')) return;
        const form = document.createElement('form');
        form.method = 'POST'; form.action = 'cart';
        form.innerHTML = '<input name="action" value="remove"><input name="foodId" value="' + foodId + '">';
        document.body.appendChild(form); form.submit(); return;
    }

    qtyEl.textContent = newQty;
    if (labelEl) labelEl.textContent = newQty;

    const data = new URLSearchParams({ action: 'update', foodId: foodId, quantity: newQty });
    fetch('cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
        body: data
    }).then(r => r.json()).then(result => {
        if (result.status === 'success') {
            // Reload to refresh totals accurately
            window.location.reload();
        }
    }).catch(() => window.location.reload());
}
</script>

<jsp:include page="includes/footer.jsp" />

