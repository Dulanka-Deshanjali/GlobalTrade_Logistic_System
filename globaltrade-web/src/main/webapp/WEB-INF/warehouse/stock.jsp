<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Low Stock & Inventory Management | GlobalTrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --navy: #0B1D33; --amber: #F2A93B; --bg-soft: #F5F7FA; --ink: #1C2733; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; color: var(--ink); }
        .panel-card { border: 1px solid #E4E8EF; border-radius: 10px; overflow: hidden; }
        .panel-card .card-header { background: var(--navy) !important; color: #fff; padding: 14px 20px; }
    </style>
</head>
<body>

<div class="container-fluid px-0">
    <!-- Top Header -->
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <h2><i class="fa-solid fa-boxes-stacked me-2 text-warning"></i> Low Stock & Inventory Management</h2>
    </div>

    <!-- Low Stock Alert Banner -->
    <div id="warehouseLowStockAlert" class="alert alert-danger d-none" role="alert">
        <i class="fa-solid fa-triangle-exclamation me-2"></i> <strong>Critical Notice:</strong> The items listed below have fallen below their safe reorder level and require immediate stock updates!
    </div>

    <!-- Low Stock / Inventory Table -->
    <div class="card panel-card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Low Inventory Items Requiring Restock</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Item Code</th>
                        <th>Item Name</th>
                        <th>Current Quantity</th>
                        <th>Reorder Level</th>
                        <th>Warehouse Location</th>
                        <th>Action (Update Stock)</th>
                    </tr>
                    </thead>
                    <tbody id="warehouseStockTableBody">
                    <tr><td colspan="6" class="text-center text-muted">Checking low stock items...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function loadLowStockItems() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/inventory')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('warehouseStockTableBody');
                const alertDiv = document.getElementById('warehouseLowStockAlert');
                tbody.innerHTML = '';

                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-3">No inventory records found.</td></tr>';
                    return;
                }

                const lowStockItems = data.filter(item => {
                    const qty = item.quantity !== undefined ? item.quantity : 0;
                    const reorder = item.reorderLevel !== undefined ? item.reorderLevel : 0;
                    return qty <= reorder;
                });

                if (lowStockItems.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-success py-3"><i class="fa-solid fa-circle-check me-1"></i> All inventory levels are optimal. No low stock items!</td></tr>';
                    alertDiv.classList.add('d-none');
                    return;
                }


                alertDiv.classList.remove('d-none');

                lowStockItems.forEach(item => {
                    const qty = item.quantity !== undefined ? item.quantity : 0;
                    const reorder = item.reorderLevel !== undefined ? item.reorderLevel : 0;

                    const tr = document.createElement('tr');
                    tr.classList.add('table-danger');
                    tr.innerHTML = `
                        <td><strong>\${item.itemCode || ''}</strong></td>
                        <td>\${item.itemName || ''}</td>
                        <td><span class="badge bg-danger">\${qty} Units</span></td>
                        <td>\${reorder} Units</td>
                        <td>\${item.warehouseLocation || ''}</td>
                        <td>
                            <div class="input-group input-group-sm" style="width: 220px;">
                                <input type="number" class="form-control" id="new-qty-\${item.id}" placeholder="New total qty" min="0">
                                <button class="btn btn-dark" onclick="updateWarehouseStock(\${item.id}, '\${item.itemName}')">Update</button>
                            </div>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                console.error('Error loading inventory stock:', err);
                document.getElementById('warehouseStockTableBody').innerHTML = '<tr><td colspan="6" class="text-center text-danger">Failed to load low stock items from server.</td></tr>';
            });
    }


    function updateWarehouseStock(id, itemName) {
        const inputField = document.getElementById('new-qty-' + id);
        const qtyToAdd = inputField.value;

        if (qtyToAdd === '' || parseInt(qtyToAdd) <= 0) {
            alert("Please enter a valid quantity to add!");
            return;
        }

        if (confirm("Are you sure you want to add " + qtyToAdd + " units to the stock of '" + itemName + "'?")) {
            const contextPath = '${pageContext.request.contextPath}';

            fetch(contextPath + '/api/logistics/inventory/' + id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ quantity: parseInt(qtyToAdd) })
            })
                .then(res => {
                    if (res.ok) {
                        alert("Stock successfully updated!");
                        loadLowStockItems();
                    } else {
                        alert("Failed to update stock.");
                    }
                })
                .catch(err => console.error('Error:', err));
        }
    }


    loadLowStockItems();
</script>
</body>
</html>