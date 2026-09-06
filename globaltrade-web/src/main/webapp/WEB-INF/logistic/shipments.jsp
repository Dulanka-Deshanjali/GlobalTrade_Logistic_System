<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipment Management | GlobalTrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --navy: #0B1D33; --amber: #F2A93B; --bg-soft: #F5F7FA; --ink: #1C2733; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; color: var(--ink); }
        .panel-card { border: 1px solid #E4E8EF; border-radius: 10px; overflow: hidden; }
        .panel-card .card-header { background: var(--navy) !important; color: #fff; padding: 14px 20px; }
        .badge-status { font-family: 'IBM Plex Mono', monospace; font-size: 11px; padding: 5px 10px; border-radius: 12px; }
        .status-pending { background: #FFF3CD; color: #856404; }
        .status-transit { background: #CCE5FF; color: #004085; }
        .status-delivered { background: #D4EDDA; color: #155724; }
        .status-delayed { background: #F8D7DA; color: #721C24; }
    </style>
</head>
<body>

<div class="container-fluid px-0">
    <!-- Top Header -->
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <h2><i class="fa-solid fa-boxes-packing me-2"></i> Shipment Management</h2>
        <button type="button" class="btn btn-warning btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#shipmentModal" onclick="openShipmentModal()">
            <i class="fa-solid fa-plus me-1"></i> Add New Shipment
        </button>
    </div>

    <!-- Shipment Table -->
    <div class="card panel-card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Active Shipments & Tracking</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Tracking No</th>
                        <th>Item Name</th>
                        <th>Quantity</th> <!-- අලුතින් එකතු කළ Quantity කණුව -->
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Vendor</th>
                        <th>Status</th>
                        <th>Est. Delivery</th>
                    </tr>
                    </thead>
                    <tbody id="shipmentTableBody">
                    <tr><td colspan="8" class="text-center text-muted">Loading shipments...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Shipment Modal -->
<div class="modal fade" id="shipmentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title">Add New Shipment</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="shipmentForm" onsubmit="saveShipment(event)">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tracking Number</label>
                        <input type="text" class="form-control" id="trackingNumber" required placeholder="TRK-XXXX">
                    </div>
                    <!-- Inventory Item Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Select Inventory Item</label>
                        <select class="form-select" id="shipmentInventory" required>
                            <option value="" selected disabled>Loading inventory items...</option>
                        </select>
                    </div>
                    <!-- අලුතින් එකතු කළ Quantity Input Field එක -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Dispatch Quantity</label>
                        <input type="number" class="form-control" id="shipmentQuantity" required min="1" placeholder="Enter quantity">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Origin</label>
                        <input type="text" class="form-control" id="origin" required placeholder="Warehouse Kandy">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Destination</label>
                        <input type="text" class="form-control" id="destination" required placeholder="Port Colombo">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Location</label>
                        <input type="text" class="form-control" id="currentLocation" required placeholder="e.g. Kandy Warehouse">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Assign Vendor</label>
                        <select class="form-select" id="shipmentVendor" required>
                            <option value="" selected disabled>Loading vendors...</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Estimated Delivery Date & Time</label>
                        <input type="datetime-local" class="form-control" id="estimatedDelivery" required>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Shipment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 1. Shipments ලෝඩ් කර වගුවේ පෙන්වීම
    function loadShipments() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/shipments')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('shipmentTableBody');
                tbody.innerHTML = '';

                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">No shipments found in database.</td></tr>';
                    return;
                }

                data.forEach(s => {
                    let statusClass = 'status-pending';
                    if (s.status === 'IN_TRANSIT') statusClass = 'status-transit';
                    else if (s.status === 'DELIVERED') statusClass = 'status-delivered';
                    else if (s.status === 'DELAYED') statusClass = 'status-delayed';

                    let vendorName = (s.vendor && s.vendor.vendorName) ? s.vendor.vendorName : 'N/A';
                    let itemName = (s.inventory && s.inventory.itemName) ? s.inventory.itemName : 'N/A';
                    let qty = s.qty !== undefined ? s.qty : 'N/A'; // ෂිප්මන්ට් ප්‍රමාණය පෙන්වීම

                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td><strong>\${s.trackingNumber}</strong></td>
                        <td>\${itemName}</td>
                        <td><span class="fw-bold text-primary">\${qty}</span></td>
                        <td>\${s.origin}</td>
                        <td>\${s.destination}</td>
                        <td>\${vendorName}</td>
                        <td><span class="badge badge-status \${statusClass}">\${s.status}</span></td>
                        <td>\${s.estimatedDelivery ? s.estimatedDelivery.replace('T', ' ') : 'N/A'}</td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                console.error('Error loading shipments:', err);
                document.getElementById('shipmentTableBody').innerHTML = '<tr><td colspan="8" class="text-center text-danger">Failed to load shipments from server.</td></tr>';
            });
    }

    function openShipmentModal() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        const vendorSelect = document.getElementById('shipmentVendor');
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

        const inventorySelect = document.getElementById('shipmentInventory');
        inventorySelect.innerHTML = '<option value="" selected disabled>Loading inventory...</option>';
        fetch(contextPath + '/api/logistics/inventory')
            .then(res => res.json())
            .then(items => {
                inventorySelect.innerHTML = '<option value="" selected disabled>Choose inventory item...</option>';
                items.forEach(i => {
                    const opt = document.createElement('option');
                    opt.value = i.id;
                    opt.textContent = i.itemName + ' (Stock: ' + i.quantity + ')';
                    inventorySelect.appendChild(opt);
                });
            });
    }

    function saveShipment(event) {
        event.preventDefault();

        const vendorId = document.getElementById('shipmentVendor').value;
        const inventoryId = document.getElementById('shipmentInventory').value;
        const qty = document.getElementById('shipmentQuantity').value;

        const shipmentData = {
            trackingNumber: document.getElementById('trackingNumber.value') || document.getElementById('trackingNumber').value,
            origin: document.getElementById('origin').value,
            destination: document.getElementById('destination').value,
            currentLocation: document.getElementById('currentLocation').value,
            status: 'PENDING',
            qty: parseInt(qty),
            estimatedDelivery: document.getElementById('estimatedDelivery').value + ':00',
            vendor: { id: parseInt(vendorId) },
            inventory: { id: parseInt(inventoryId) }
        };

        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        fetch(contextPath + '/api/logistics/shipment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(shipmentData)
        })
            .then(res => {
                if (res.ok) {
                    alert('Shipment added successfully with quantity!');
                    const modalEl = document.getElementById('shipmentModal');
                    bootstrap.Modal.getInstance(modalEl).hide();
                    document.getElementById('shipmentForm').reset();
                    loadShipments();
                } else {
                    alert('Failed to save shipment. Tracking number may already exist.');
                }
            })
            .catch(err => console.error('Error:', err));
    }

    loadShipments();
</script>
</body>
</html>