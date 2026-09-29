<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="includes/header.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<style>
.stat-card { border-radius: 20px; padding: 24px; color: white; position: relative; overflow: hidden; }
.stat-card::after { content: ''; position: absolute; right: -20px; bottom: -20px; width: 120px; height: 120px; border-radius: 50%; background: rgba(255,255,255,0.12); }
.stat-card .icon { width: 50px; height: 50px; border-radius: 14px; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; margin-bottom: 12px; }
</style>

<div class="container-fluid py-4 px-4 px-lg-5" style="min-height: 80vh;">
    <c:choose>
        <c:when test="${sessionScope.loggedUser.role != 'ADMIN'}">
            <div class="text-center py-5">
                <i class="fa-solid fa-shield-xmark fa-4x text-danger mb-3"></i>
                <h3>Access Denied</h3>
            </div>
        </c:when>
        <c:otherwise>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h2 class="fw-bold mb-0">Admin Dashboard</h2>
                <p class="text-muted mb-0">Welcome back, ${sessionScope.loggedUser.username}</p>
            </div>
            <a href="admin/orders" class="btn btn-danger fw-bold px-4 rounded-pill">
                <i class="fa-solid fa-bell me-2"></i>Live Orders
                <c:if test="${todayOrders > 0}"><span class="badge bg-light text-danger ms-1">${todayOrders}</span></c:if>
            </a>
        </div>

        <!-- Stats Row -->
        <div class="row g-4 mt-2">
            <div class="col-6 col-lg-3">
                <div class="stat-card bg-primary shadow">
                    <div class="icon"><i class="fa-solid fa-users"></i></div>
                    <h3 class="fw-bold mb-1">${totalUsers}</h3>
                    <p class="mb-0 opacity-75">Total Users</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card bg-success shadow">
                    <div class="icon"><i class="fa-solid fa-wallet"></i></div>
                    <h3 class="fw-bold mb-1">&#8377;<fmt:formatNumber value="${totalRevenue * 0.10}" maxFractionDigits="2"/></h3>
                    <p class="mb-0 opacity-75">Comm (10%)</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card bg-info shadow">
                    <div class="icon"><i class="fa-solid fa-store"></i></div>
                    <h3 class="fw-bold mb-1">${totalRestaurants}</h3>
                    <p class="mb-0 opacity-75">Restaurants</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card bg-danger shadow">
                    <div class="icon"><i class="fa-solid fa-bag-shopping"></i></div>
                    <h3 class="fw-bold mb-1">${totalOrders}</h3>
                    <p class="mb-0 opacity-75">Total Orders</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card shadow" style="background: linear-gradient(135deg, #f39c12, #d35400);">
                    <div class="icon"><i class="fa-solid fa-utensils"></i></div>
                    <h3 class="fw-bold mb-1">${totalItems}</h3>
                    <p class="mb-0 opacity-75">Menu Items</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card shadow" style="background: linear-gradient(135deg, #8e44ad, #9b59b6);">
                    <div class="icon"><i class="fa-solid fa-chart-line"></i></div>
                    <h3 class="fw-bold mb-1">${todayOrders}</h3>
                    <p class="mb-0 opacity-75">Orders Today</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card shadow" style="background: linear-gradient(135deg, #27ae60, #2ecc71);">
                    <div class="icon"><i class="fa-solid fa-coins"></i></div>
                    <h3 class="fw-bold mb-1">&#8377;${todayRevenue}</h3>
                    <p class="mb-0 opacity-75">Revenue Today</p>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card shadow" style="background: linear-gradient(135deg, #34495e, #2c3e50);">
                    <div class="icon"><i class="fa-solid fa-money-bill-wave"></i></div>
                    <h3 class="fw-bold mb-1">&#8377;${totalRevenue}</h3>
                    <p class="mb-0 opacity-75">Gross Total Vol</p>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Add/Edit Item Form -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm p-4 h-100" id="itemFormCard">
                    <h5 class="fw-bold mb-4" id="formTitle"><i class="fa-solid fa-pen-to-square text-danger me-2"></i>Add / Edit Menu Item</h5>
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success small">Item saved successfully!</div>
                    </c:if>
                    <form action="admin" method="POST" id="itemForm">
                        <input type="hidden" name="action" value="addItem">
                        <input type="hidden" name="itemId" id="formItemId" value="">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-bold">Item Name</label>
                                <input type="text" class="form-control" name="name" id="formName" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Price (&#8377;)</label>
                                <input type="number" step="0.01" class="form-control" name="price" id="formPrice" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Prep Time (mins)</label>
                                <input type="number" class="form-control" name="prepTime" id="formPrepTime" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Category</label>
                                <select class="form-select" name="categoryId" id="formCategoryId" required>
                                    <c:forEach var="cat" items="${allCategories}">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Restaurant</label>
                                <select class="form-select" name="restaurantId" id="formRestaurantId" required>
                                    <c:forEach var="rest" items="${allRestaurants}">
                                        <option value="${rest.id}">${rest.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Diet Type</label>
                                <select class="form-select" name="isVeg" id="formIsVeg" required>
                                    <option value="true">Veg</option>
                                    <option value="false">Non-Veg</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small fw-bold">Image URL</label>
                                <input type="url" class="form-control" name="imageUrl" id="formImageUrl" placeholder="https://...">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold">Description</label>
                                <textarea class="form-control" name="description" id="formDescription" rows="2" required></textarea>
                            </div>
                            <div class="col-12 d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-dark rounded-pill px-5 fw-bold" id="formSubmitBtn">Save Item</button>
                                <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="clearForm()">Clear / New</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Order Status Chart -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold mb-4"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Order Status</h5>
                    <canvas id="statusChart" height="230"></canvas>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0">Recent Orders</h5>
                <a href="admin/orders" class="btn btn-outline-dark btn-sm rounded-pill">View All</a>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Order ID</th>
                            <th>User</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Time</th>
                            <th class="pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td class="ps-4 fw-bold">#${order.id}</td>
                            <td>User #${order.userId}</td>
                            <td class="fw-bold">&#8377;${order.totalAmount}</td>
                            <td><span class="badge bg-light text-dark border">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</span></td>
                            <td>
                                <span class="badge ${order.status == 'DELIVERED' ? 'bg-success' : (order.status == 'REJECTED' || order.status == 'Cancelled' ? 'bg-danger' : (order.status == 'OUT_FOR_DELIVERY' ? 'bg-info' : 'bg-warning text-dark'))}">
                                    ${order.status}
                                </span>
                            </td>
                            <td class="text-muted small"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM, hh:mm a" /></td>
                            <td class="pe-4">
                                <c:if test="${order.status == 'Pending'}">
                                    <form action="admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateOrderStatus">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <input type="hidden" name="status" value="Preparing">
                                        <button type="submit" class="btn btn-sm btn-success rounded-pill" title="Accept Order"><i class="fa-solid fa-check"></i></button>
                                    </form>
                                    <form action="admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateOrderStatus">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <input type="hidden" name="status" value="Cancelled">
                                        <button type="submit" class="btn btn-sm btn-danger rounded-pill" title="Reject Order"><i class="fa-solid fa-xmark"></i></button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Existing Menu Items -->
        <h4 class="fw-bold mt-5 mb-4">Existing Menu Items</h4>
        <c:forEach var="entry" items="${groupedFoodItems}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                    <h5 class="fw-bold text-danger mb-0"><i class="fa-solid fa-store me-2"></i>${entry.key}</h5>
                </div>
                <div class="card-body p-0 mt-3">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Image</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Type</th>
                                    <th>Rating</th>
                                    <th>Bestseller</th>
                                    <th class="text-end pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${entry.value}">
                                    <tr>
                                        <td class="ps-4">
                                            <c:if test="${not empty item.imageUrl}">
                                                <img src="${item.imageUrl}" alt="${item.name}" style="width: 40px; height: 40px; object-fit: cover; border-radius: 8px;">
                                            </c:if>
                                        </td>
                                        <td class="fw-bold">${item.name}</td>
                                        <td>&#8377;${item.price}</td>
                                        <td>
                                            <span class="badge ${item.veg ? 'bg-success' : 'bg-danger'}">${item.veg ? 'Veg' : 'Non-Veg'}</span>
                                        </td>
                                        <td><i class="fa-solid fa-star text-warning me-1"></i>${item.rating}</td>
                                        <td>
                                            <c:if test="${item.bestseller}">
                                                <span class="badge bg-warning text-dark"><i class="fa-solid fa-crown me-1"></i>Yes</span>
                                            </c:if>
                                        </td>
                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-outline-dark rounded-pill" onclick="editItem(${item.id}, '${item.name.replace("'", "\\'")}', ${item.price}, ${item.prepTime}, ${item.categoryId}, ${item.restaurantId}, ${item.veg}, '${item.imageUrl}', '${item.description.replace("'", "\\'")}')">Edit</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:forEach>

        </c:otherwise>
    </c:choose>
</div>

<script>
// Status donut chart
const ctx = document.getElementById('statusChart');
if (ctx) {
    const data = [
        ${chartPending != null ? chartPending : 0},
        ${chartPreparing != null ? chartPreparing : 0},
        ${chartOut != null ? chartOut : 0},
        ${chartDelivered != null ? chartDelivered : 0},
        ${chartRejected != null ? chartRejected : 0}
    ];
    
    if (data.reduce((a, b) => a + b, 0) === 0) {
        ctx.style.display = 'none';
        ctx.insertAdjacentHTML('afterend', '<div class="text-center text-muted mt-4"><i class="fa-solid fa-chart-pie fa-3x mb-3 opacity-50"></i><p>No orders yet</p></div>');
    } else {
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Rejected'],
                datasets: [{
                    data: data,
                    backgroundColor: ['#6c757d', '#ffc107', '#17a2b8', '#28a745', '#dc3545'],
                    borderWidth: 0,
                    hoverOffset: 8
                }]
            },
            options: {
                cutout: '70%',
                plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 16 } } }
            }
        });
    }
}
</script>
<script>
function editItem(id, name, price, prepTime, categoryId, restaurantId, isVeg, imageUrl, description) {
    document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen-to-square text-danger me-2"></i>Edit Menu Item';
    document.getElementById('formItemId').value = id;
    document.getElementById('formName').value = name;
    document.getElementById('formPrice').value = price;
    document.getElementById('formPrepTime').value = prepTime;
    document.getElementById('formCategoryId').value = categoryId;
    document.getElementById('formRestaurantId').value = restaurantId;
    document.getElementById('formIsVeg').value = isVeg;
    document.getElementById('formImageUrl').value = imageUrl;
    document.getElementById('formDescription').value = description;
    document.getElementById('formSubmitBtn').innerText = 'Update Item';
    
    // Scroll smoothly to form
    document.getElementById('itemFormCard').scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function clearForm() {
    document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-plus-circle text-danger me-2"></i>Add / Edit Menu Item';
    document.getElementById('formItemId').value = '';
    document.getElementById('itemForm').reset();
    document.getElementById('formSubmitBtn').innerText = 'Save Item';
}
</script>
<jsp:include page="includes/footer.jsp" />
