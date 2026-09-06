<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logistics Coordinator Dashboard | GlobalTrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{
            --navy: #0B1D33;
            --navy-2: #142C48;
            --amber: #F2A93B;
            --ink: #1C2733;
            --muted: #7A8496;
            --line: #E4E8EF;
        }

        .content-header h2{
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 700;
            font-size: 22px;
            color: var(--ink);
            margin: 0;
        }
        .content-header .welcome-chip{
            font-family: 'IBM Plex Mono', monospace;
            font-size: 12px;
            letter-spacing: .5px;
            color: var(--navy);
            background: #EAF1FF;
            padding: 7px 14px;
            border-radius: 20px;
        }
        .content-header .welcome-chip i{ color: #2F6FED; }

        .card-stat{
            border: 1px solid var(--line);
            border-left: 4px solid var(--amber) !important;
            border-radius: 8px;
        }
        .card-stat h6{
            font-family: 'IBM Plex Mono', monospace;
            font-size: 10.5px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .card-stat h3{
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 700;
            margin: 0;
        }
        .card-stat.stat-total{ border-left-color: #2F6FED !important; }
        .card-stat.stat-total h3{ color: #2F6FED !important; }
        .card-stat.stat-transit{ border-left-color: var(--amber) !important; }
        .card-stat.stat-transit h3{ color: #C4821F !important; }
        .card-stat.stat-alerts{ border-left-color: #dc3545 !important; }

        .panel-card{
            border: 1px solid var(--line);
            border-radius: 10px;
            overflow: hidden;
        }
        .panel-card .card-header{
            background: var(--navy) !important;
            border-bottom: none;
            padding: 14px 20px;
        }
        .panel-card .card-header h5{
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 600;
            font-size: 15px;
        }
        .panel-card.panel-alerts .card-header{
            background: #EAF1FF !important;
            color: var(--navy) !important;
        }

        .panel-card table thead th{
            font-family: 'IBM Plex Mono', monospace;
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: var(--muted);
            border-bottom-width: 1px;
        }
        .panel-card table td{ font-size: 13.5px; vertical-align: middle; }

        .badge-pending { background: #FFF3CD; color: #856404; font-family: 'IBM Plex Mono', monospace; }
        .badge-transit { background: var(--amber); color: var(--navy); font-family: 'IBM Plex Mono', monospace; }
        .badge-delivered { background: #D4EDDA; color: #155724; font-family: 'IBM Plex Mono', monospace; }
        .badge-delayed { background: #F8D7DA; color: #721C24; font-family: 'IBM Plex Mono', monospace; }
        .badge-held { background: #dc3545; color: #fff; font-family: 'IBM Plex Mono', monospace; box-shadow: 0 0 5px rgba(220,53,69,0.5); }
        .badge-approved { background: #198754; color: #fff; font-family: 'IBM Plex Mono', monospace; }

        .table-danger td { background-color: #fdf2f2 !important; border-bottom: 1px solid #f5c2c7; }
    </style>
</head>
<body class="bg-light p-4">

<div class="container-fluid px-0">
    <!-- Top Header -->
    <div class="content-header d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <h2>Logistics Coordinator Dashboard</h2>
        <span class="welcome-chip"><i class="fa-solid fa-user-tie me-1"></i> Welcome, Coordinator</span>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row text-center mb-4">
        <div class="col-md-4 mb-3">
            <div class="card card-stat stat-total shadow-sm p-3 bg-white">
                <h6 class="text-muted">Total Shipments</h6>
                <h3 id="totalShipments">0</h3>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-stat stat-transit shadow-sm p-3 bg-white">
                <h6 class="text-muted">In Transit</h6>
                <h3 id="inTransit">0</h3>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card card-stat stat-alerts shadow-sm p-3 bg-white">
                <h6 class="text-muted text-danger fw-bold"><i class="fa-solid fa-circle-exclamation me-1"></i> Delayed / Customs Held</h6>
                <h3 id="delayedAlerts" class="text-danger">0</h3>
            </div>
        </div>
    </div>

    <!-- Shipment Management Table -->
    <div class="card panel-card shadow-sm mb-4">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0 text-white"><i class="fa-solid fa-box me-2"></i> Shipment Management</h5>
            <button class="btn btn-sm btn-outline-light" onclick="loadDashboardData()"><i class="fa-solid fa-rotate-right me-1"></i> Refresh</button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Tracking No & Date</th>
                        <th>Item Name</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="shipmentTableBody">
                    <tr><td colspan="6" class="text-center text-muted">Loading shipments...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Low Stock Inventory Alerts -->
    <div class="card panel-card panel-alerts shadow-sm">
        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0 text-dark"><i class="fa-solid fa-triangle-exclamation me-2"></i> Low Stock Inventory Alerts</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Item Code</th>
                        <th>Item Name</th>
                        <th>Current Quantity</th>
                        <th>Reorder Level</th>
                    </tr>
                    </thead>
                    <tbody id="lowStockTableBody">
                    <tr><td colspan="4" class="text-center text-muted">Checking low stock items...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Reschedule / Delay Modal -->
<div class="modal fade" id="rescheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark border-0">
                <h6 class="modal-title fw-bold"><i class="fa-solid fa-calendar-day me-2"></i> Set New Date</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="small text-muted mb-2">Select new delivery date for: <strong id="rescheduleTrackingNo" class="text-dark"></strong></p>
                <div class="mb-3">
                    <label class="form-label fw-bold small">New Estimated Delivery</label>
                    <input type="datetime-local" class="form-control" id="newDeliveryDate" required>
                </div>
            </div>
            <div class="modal-footer border-0 p-2">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-sm btn-primary fw-bold" onclick="submitReschedule()">Save Date & Update</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let pendingStatusChange = null;

    function loadDashboardData() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/shipments')
            .then(res => res.json())
            .then(shipments => {
                const tbody = document.getElementById('shipmentTableBody');
                tbody.innerHTML = '';

                let total = shipments.length;
                let transitCount = 0;
                let delayedCount = 0;

                if (!shipments || total === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">No shipments found.</td></tr>';
                } else {
                    shipments.forEach(s => {
                        if (s.status === 'IN_TRANSIT') transitCount++;
                        if (s.status === 'DELAYED' || s.status === 'CUSTOMS_HELD') delayedCount++;

                        let badgeClass = 'badge-pending';
                        if (s.status === 'IN_TRANSIT') badgeClass = 'badge-transit';
                        else if (s.status === 'DELIVERED') badgeClass = 'badge-delivered';
                        else if (s.status === 'DELAYED') badgeClass = 'badge-delayed';
                        else if (s.status === 'CUSTOMS_HELD') badgeClass = 'badge-held px-2 py-1';
                        else if (s.status === 'CUSTOMS_APPROVED') badgeClass = 'badge-approved px-2 py-1';

                        let rowClass = s.status === 'CUSTOMS_HELD' ? 'table-danger' : '';
                        let itemName = (s.inventory && s.inventory.itemName) ? s.inventory.itemName : 'N/A';
                        let estDate = s.estimatedDelivery ? s.estimatedDelivery.replace('T', ' ') : 'No Date Set';


                        let dropdownOptions = '';

                        if (s.status === 'CUSTOMS_HELD') {
                            dropdownOptions = `
                                <option value="CUSTOMS_HELD" selected disabled>CUSTOMS_HELD</option>
                                <option value="IN_TRANSIT">IN_TRANSIT (Resume)</option>
                            `;
                        }
                        else if (s.status === 'CUSTOMS_APPROVED') {
                            dropdownOptions = `
                                <option value="CUSTOMS_APPROVED" selected disabled>CUSTOMS_APPROVED</option>
                                <option value="DELIVERED">DELIVERED</option>
                            `;
                        }
                        else if (s.status === 'DELAYED' || s.status === 'IN_TRANSIT') {
                            dropdownOptions = `
                                <option value="\${s.status}" selected disabled>\${s.status}</option>
                                <option value="PENDING">PENDING (Reset)</option>
                            `;
                        }
                        else if (s.status === 'PENDING') {
                            dropdownOptions = `
                                <option value="PENDING" selected disabled>PENDING</option>
                                <option value="READY_FOR_DISPATCH">READY_FOR_DISPATCH</option>
                            `;
                        }
                        else if (s.status === 'READY_FOR_DISPATCH') {
                            dropdownOptions = `
                                <option value="READY_FOR_DISPATCH" selected disabled>READY_FOR_DISPATCH</option>
                                <option value="IN_TRANSIT">IN_TRANSIT</option>
                            `;
                        }
                        else {
                            dropdownOptions = `<option value="\${s.status}" selected disabled>\${s.status}</option>`;
                        }

                        let calendarBtn = '';
                        if (s.status === 'DELAYED') {
                            calendarBtn = `
                                <button class="btn btn-sm btn-outline-danger fw-bold ms-1" onclick="openRescheduleModal('\${s.trackingNumber}', null)" title="Change Date (Reschedule)">
                                    <i class="fa-solid fa-calendar-plus"></i>
                                </button>
                            `;
                        }

                        const tr = document.createElement('tr');
                        tr.className = rowClass;
                        tr.innerHTML = `
                            <td>
                                <strong>\${s.trackingNumber}</strong><br>
                                <small class="text-muted"><i class="fa-regular fa-clock me-1"></i>\${estDate}</small>
                            </td>
                            <td>\${itemName}</td>
                            <td>\${s.origin}</td>
                            <td>\${s.destination}</td>
                            <td><span class="badge \${badgeClass}">\${s.status}</span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <select class="form-select form-select-sm w-auto me-1" id="status-\${s.trackingNumber}">
                                        \${dropdownOptions}
                                    </select>
                                    <button class="btn btn-sm btn-outline-primary fw-bold" onclick="updateStatus('\${s.trackingNumber}')" title="Update Status">
                                        Update
                                    </button>
                                    \${calendarBtn}
                                </div>
                            </td>
                        `;
                        tbody.appendChild(tr);
                    });
                }

                document.getElementById('totalShipments').textContent = total;
                document.getElementById('inTransit').textContent = transitCount;
                document.getElementById('delayedAlerts').textContent = delayedCount;
            })
            .catch(err => console.error('Error loading shipments:', err));

        fetch(contextPath + '/api/logistics/inventory')
            .then(res => res.json())
            .then(inventory => {
                const lowStockTbody = document.getElementById('lowStockTableBody');
                lowStockTbody.innerHTML = '';
                if (!inventory || inventory.length === 0) return;

                const lowStockItems = inventory.filter(item => item.quantity <= item.reorderLevel);
                if (lowStockItems.length === 0) return;

                lowStockItems.forEach(item => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td><strong>\${item.itemCode}</strong></td>
                        <td>\${item.itemName}</td>
                        <td class="text-danger fw-bold">\${item.quantity}</td>
                        <td>\${item.reorderLevel}</td>
                    `;
                    lowStockTbody.appendChild(tr);
                });
            })
            .catch(err => console.error('Error loading inventory:', err));
    }

    function updateStatus(trackingNumber) {
        const newStatus = document.getElementById('status-' + trackingNumber).value;
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        if (newStatus === 'PENDING') {
            alert("You must set a new Estimated Delivery Date before marking the shipment as PENDING.");
            openRescheduleModal(trackingNumber, 'PENDING');
            return;
        }

        if(confirm(`Are you sure you want to change the status of \${trackingNumber} to \${newStatus}?`)) {
            fetch(contextPath + '/api/logistics/shipment/status/' + trackingNumber + '?status=' + newStatus, {
                method: 'PUT'
            })
                .then(res => {
                    if (res.ok) {
                        alert('Shipment status updated to ' + newStatus);
                        loadDashboardData();
                    } else {
                        alert('Failed to update shipment status.');
                    }
                })
                .catch(err => console.error('Error:', err));
        }
    }

    function openRescheduleModal(trackingNumber, targetStatus) {
        document.getElementById('rescheduleTrackingNo').textContent = trackingNumber;
        document.getElementById('newDeliveryDate').value = '';
        pendingStatusChange = targetStatus; // targetStatus පාලනය කිරීම (PENDING හෝ null)
        const modal = new bootstrap.Modal(document.getElementById('rescheduleModal'));
        modal.show();
    }

    function submitReschedule() {
        const trackingNumber = document.getElementById('rescheduleTrackingNo').textContent;
        let newDate = document.getElementById('newDeliveryDate').value;

        if (!newDate) {
            alert("Please select a new date and time.");
            return;
        }

        if (newDate.length === 16) {
            newDate += ':00';
        }

        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/shipment/reschedule/' + trackingNumber + '?newDate=' + newDate, {
            method: 'PUT'
        })
            .then(res => {
                if (res.ok) {
                    if (pendingStatusChange) {
                        return fetch(contextPath + '/api/logistics/shipment/status/' + trackingNumber + '?status=' + pendingStatusChange, {
                            method: 'PUT'
                        });
                    }
                    return Promise.resolve({ok: true});
                } else {
                    throw new Error('Failed to update date.');
                }
            })
            .then(res => {
                if (res.ok) {
                    alert('Shipment date rescheduled successfully!');
                    const modalEl = document.getElementById('rescheduleModal');
                    bootstrap.Modal.getInstance(modalEl).hide();
                    pendingStatusChange = null;
                    loadDashboardData();
                } else {
                    alert('Date saved, but failed to update status.');
                }
            })
            .catch(err => console.error('Error:', err));
    }

    loadDashboardData();
</script>
</body>
</html>