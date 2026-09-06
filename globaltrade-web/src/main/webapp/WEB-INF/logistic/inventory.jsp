<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <h2><i class="fa-solid fa-warehouse me-2"></i> Inventory Management & Dispatch</h2>
        <!-- නව Inventory අයිතමයක් එකතු කිරීමට බොත්තම -->
        <button type="button" class="btn btn-primary btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#addInventoryModal">
            <i class="fa-solid fa-plus me-1"></i> Add New Item
        </button>
    </div>

    <!-- Low Stock Alert -->
    <div id="lowStockAlert" class="alert alert-danger d-none" role="alert">
        <i class="fa-solid fa-triangle-exclamation me-2"></i> <strong>Low Stock Alert:</strong> Some items are below the reorder level!
    </div>

    <!-- Inventory Table -->
    <div class="card panel-card shadow-sm">
        <div class="card-body">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>Item Code</th>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Reorder Level</th>
                    <th>Warehouse</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody id="inventoryTableBody">
                <tr><td colspan="6" class="text-center">Loading inventory...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add New Inventory Item Modal -->
<div class="modal fade" id="addInventoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title">Add New Inventory Item</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="addInventoryForm" onsubmit="saveNewInventory(event)">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Item Code</label>
                        <input type="text" class="form-control" id="newItemCode" required placeholder="ITM-XXXX">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Item Name</label>
                        <input type="text" class="form-control" id="newItemName" required placeholder="e.g. Steel Pipe">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Initial Quantity</label>
                        <input type="number" class="form-control" id="newQuantity" required min="0" placeholder="100">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Reorder Level</label>
                        <input type="number" class="form-control" id="newReorderLevel" required min="0" placeholder="10">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Warehouse Location</label>
                        <input type="text" class="form-control" id="newWarehouseLocation" required value="Main Warehouse Kandy">
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Ship Item Modal -->
<div class="modal fade" id="shipItemModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title">Dispatch / Ship Item</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="shipItemForm" onsubmit="submitShipItem(event)">
                <div class="modal-body">
                    <input type="hidden" id="modalInventoryId">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tracking Number</label>
                        <input type="text" class="form-control" id="shipTrackingNo" required placeholder="TRK-XXXX">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Origin Warehouse</label>
                        <input type="text" class="form-control" id="shipOrigin" required value="Main Warehouse Kandy">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Destination</label>
                        <input type="text" class="form-control" id="shipDestination" required placeholder="Colombo Port">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Location</label>
                        <input type="text" class="form-control" id="shipCurrentLoc" required placeholder="Kandy Hub">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Quantity to Ship</label>
                        <input type="number" class="form-control" id="shipQty" required min="1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Select Vendor</label>
                        <select class="form-select" id="shipVendorSelect" required>
                            <option value="" selected disabled>Loading vendors...</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Estimated Delivery Date & Time</label>
                        <input type="datetime-local" class="form-control" id="shipEstDelivery" required>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Confirm & Ship</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function loadInventory() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/inventory')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('inventoryTableBody');
                const alertDiv = document.getElementById('lowStockAlert');
                tbody.innerHTML = '';
                let hasLowStock = false;

                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">No inventory items found.</td></tr>';
                    return;
                }

                data.forEach(item => {
                    const qty = item.quantity !== undefined ? item.quantity : 0;
                    const reorder = item.reorderLevel !== undefined ? item.reorderLevel : 0;
                    const isLow = qty <= reorder;
                    if (isLow) hasLowStock = true;

                    const tr = document.createElement('tr');
                    if (isLow) tr.classList.add('table-danger');

                    tr.innerHTML =
                        '<td><strong>' + (item.itemCode || '') + '</strong></td>' +
                        '<td>' + (item.itemName || '') + '</td>' +
                        '<td>' + qty + '</td>' +
                        '<td>' + reorder + '</td>' +
                        '<td>' + (item.warehouseLocation || '') + '</td>' +
                        '<td>' +
                        '<button class="btn btn-sm btn-success me-1" onclick="openShipModal(' + item.id + ', ' + qty + ')">Ship</button>' +
                        '<button class="btn btn-sm btn-primary" onclick="updateStock(' + item.id + ')">Edit</button>' +
                        '</td>';

                    tbody.appendChild(tr);
                });

                if (hasLowStock) alertDiv.classList.remove('d-none');
                else alertDiv.classList.add('d-none');
            })
            .catch(err => console.error("Error loading inventory:", err));
    }

    function saveNewInventory(event) {
        event.preventDefault();

        const inventoryData = {
            itemCode: document.getElementById('newItemCode').value,
            itemName: document.getElementById('newItemName').value,
            quantity: parseInt(document.getElementById('newQuantity').value),
            reorderLevel: parseInt(document.getElementById('newReorderLevel').value),
            warehouseLocation: document.getElementById('newWarehouseLocation').value
        };

        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        fetch(contextPath + '/api/logistics/inventory', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(inventoryData)
        })
            .then(res => {
                if (res.ok) {
                    alert('New inventory item added successfully!');
                    bootstrap.Modal.getInstance(document.getElementById('addInventoryModal')).hide();
                    document.getElementById('addInventoryForm').reset();
                    loadInventory();
                } else {
                    alert('Failed to add item. Item code may already exist.');
                }
            })
            .catch(err => console.error('Error adding inventory:', err));
    }

    function openShipModal(inventoryId, maxQty) {
        document.getElementById('modalInventoryId').value = inventoryId;
        document.getElementById('shipQty').max = maxQty;
        document.getElementById('shipQty').value = 1;

        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        const vendorSelect = document.getElementById('shipVendorSelect');
        vendorSelect.innerHTML = '<option value="" selected disabled>Loading vendors...</option>';

        fetch(contextPath + '/api/vendors')
            .then(res => res.json())
            .then(vendors => {
                vendorSelect.innerHTML = '<option value="" selected disabled>Choose vendor...</option>';
                vendors.forEach(v => {
                    const opt = document.createElement('option');
                    opt.value = v.id;
                    opt.textContent = v.vendorName;
                    vendorSelect.appendChild(opt);
                });
            });

        const myModal = new bootstrap.Modal(document.getElementById('shipItemModal'));
        myModal.show();
    }

    function submitShipItem(event) {
        event.preventDefault();
        const inventoryId = document.getElementById('modalInventoryId').value;
        const qty = parseInt(document.getElementById('shipQty').value);
        const vendorId = document.getElementById('shipVendorSelect').value;

        const shipmentData = {
            trackingNumber: document.getElementById('shipTrackingNo').value,
            origin: document.getElementById('shipOrigin').value,
            destination: document.getElementById('shipDestination').value,
            currentLocation: document.getElementById('shipCurrentLoc').value,
            status: 'IN_TRANSIT',
            estimatedDelivery: document.getElementById('shipEstDelivery').value + ':00',
            vendor: { id: parseInt(vendorId) }
        };

        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        fetch(contextPath + '/api/logistics/ship-item?inventoryId=' + inventoryId + '&qty=' + qty, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(shipmentData)
        })
            .then(res => {
                if (res.ok) {
                    alert('Item shipped successfully and inventory updated!');
                    bootstrap.Modal.getInstance(document.getElementById('shipItemModal')).hide();
                    document.getElementById('shipItemForm').reset();
                    loadInventory();
                } else {
                    alert('Failed to ship item. Check stock or tracking number.');
                }
            })
            .catch(err => console.error('Error:', err));
    }

    function updateStock(id) {
        let newQty = prompt("Enter new quantity:");
        if (newQty !== null && newQty.trim() !== "") {
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
            fetch(contextPath + '/api/logistics/inventory/' + id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ quantity: parseInt(newQty) })
            }).then(() => loadInventory());
        }
    }

    loadInventory();
</script>