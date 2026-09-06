<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container-fluid px-0 pt-0">
    <!-- Welcome Banner -->
    <div class="p-3 px-4 mb-3 rounded-3 text-white shadow-sm" style="background: linear-gradient(135deg, #0B1D33 0%, #142C48 100%);">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h4 class="fw-bold mb-1"><i class="fa-solid fa-warehouse me-2 text-warning"></i> Warehouse Control Center</h4>
                <p class="text-white-50 mb-0 small">Monitor low inventory levels, restock items, and dispatch pending shipments efficiently.</p>
            </div>
            <div class="col-md-4 text-md-end mt-2 mt-md-0">
                <span class="badge bg-success bg-opacity-75 fs-6 px-3 py-1.5"><i class="fa-solid fa-circle-check me-1"></i> System Online</span>
            </div>
        </div>
    </div>

    <!-- Quick Stats Cards (Dynamic Values) -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card p-3 shadow-sm border-0 border-start border-danger border-4 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase small mb-1">Low Stock Alerts</h6>
                        <h3 class="fw-bold text-danger mb-0" id="statLowStockCount">--</h3>
                    </div>
                    <div class="fs-1 text-danger opacity-25"><i class="fa-solid fa-triangle-exclamation"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 shadow-sm border-0 border-start border-primary border-4 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase small mb-1">Pending Shipments</h6>
                        <h3 class="fw-bold text-primary mb-0" id="statPendingCount">--</h3>
                    </div>
                    <div class="fs-1 text-primary opacity-25"><i class="fa-solid fa-truck-ramp-loading"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 shadow-sm border-0 border-start border-success border-4 h-100">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase small mb-1">Total Active Stock</h6>
                        <h3 class="fw-bold text-success mb-0" id="statTotalStock">--</h3>
                    </div>
                    <div class="fs-1 text-success opacity-25"><i class="fa-solid fa-boxes-stacked"></i></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Navigation Panels -->
    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-dark text-white py-2.5">
                    <h6 class="mb-0"><i class="fa-solid fa-truck-fast me-2"></i> Pending Shipments Management</h6>
                </div>
                <div class="card-body d-flex flex-column justify-content-between">
                    <p class="text-muted small">Review incoming shipments currently in <strong>PENDING</strong> status and quickly dispatch them.</p>
                    <button class="btn btn-warning btn-sm fw-bold align-self-start" onclick="loadContent('pending_shipments')">
                        <i class="fa-solid fa-arrow-right me-1"></i> Go to Pending Shipments
                    </button>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-dark text-white py-2.5">
                    <h6 class="mb-0"><i class="fa-solid fa-boxes-stacked me-2"></i> Low Stock & Inventory Management</h6>
                </div>
                <div class="card-body d-flex flex-column justify-content-between">
                    <p class="text-muted small">Monitor inventory levels, identify low stock items, and securely update stock quantities.</p>
                    <button class="btn btn-primary btn-sm fw-bold align-self-start" onclick="loadContent('stock')">
                        <i class="fa-solid fa-arrow-right me-1"></i> Go to Low Stock & Inventory
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Additional Section: Critical Low Stock Preview Table -->
    <div class="row g-4">
        <div class="col-md-12">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-bold text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> Critical Low Stock Items Preview</h6>
                    <button class="btn btn-sm btn-outline-dark" onclick="loadContent('stock')">View All</button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Item Code</th>
                                <th>Item Name</th>
                                <th>Current Quantity</th>
                                <th>Reorder Level</th>
                                <th>Location</th>
                            </tr>
                            </thead>
                            <tbody id="dashboardLowStockTable">
                            <tr><td colspan="5" class="text-center text-muted py-3">Loading critical items...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function loadDashboardData() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/shipments')
            .then(res => res.json())
            .then(data => {
                if (Array.isArray(data)) {
                    const pending = data.filter(s => s.status && s.status.toUpperCase() === 'PENDING');
                    document.getElementById('statPendingCount').textContent = pending.length;
                }
            })
            .catch(err => console.error('Error fetching shipments:', err));

        fetch(contextPath + '/api/logistics/inventory')
            .then(res => res.json())
            .then(data => {
                if (Array.isArray(data)) {
                    let totalUnits = 0;
                    let lowStockCount = 0;
                    const lowStockList = [];

                    data.forEach(item => {
                        const qty = item.quantity !== undefined ? item.quantity : 0;
                        const reorder = item.reorderLevel !== undefined ? item.reorderLevel : 0;

                        totalUnits += qty;
                        if (qty <= reorder) {
                            lowStockCount++;
                            lowStockList.push(item);
                        }
                    });

                    document.getElementById('statLowStockCount').textContent = lowStockCount;
                    document.getElementById('statTotalStock').textContent = totalUnits.toLocaleString() + ' Units';

                    const tbody = document.getElementById('dashboardLowStockTable');
                    tbody.innerHTML = '';

                    if (lowStockList.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="5" class="text-center text-success py-3"><i class="fa-solid fa-circle-check me-1"></i> No critical low stock items right now!</td></tr>';
                    } else {
                        lowStockList.slice(0, 5).forEach(item => {
                            tbody.innerHTML += `
                                <tr class="table-danger">
                                    <td><strong>\${item.itemCode || ''}</strong></td>
                                    <td>\${item.itemName || ''}</td>
                                    <td><span class="badge bg-danger">\${item.quantity} Units</span></td>
                                    <td>\${item.reorderLevel} Units</td>
                                    <td>\${item.warehouseLocation || ''}</td>
                                </tr>
                            `;
                        });
                    }
                }
            })
            .catch(err => console.error('Error fetching inventory:', err));
    }

    loadDashboardData();
</script>