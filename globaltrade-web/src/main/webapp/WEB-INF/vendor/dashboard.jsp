<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Portal | GlobalTrade</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #F5F7FA; font-family: 'Inter', sans-serif; color: #1C2733; }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #0B1D33 0%, #142C48 100%); color: #fff; }
        .sidebar a { color: #b9c2d0; text-decoration: none; padding: 10px 15px; display: flex; align-items: center; border-radius: 6px; margin-bottom: 4px; transition: all 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(242,169,59,0.14); color: #F2A93B; }
        .topbar { display: flex; align-items: center; justify-content: space-between; padding-bottom: 16px; margin-bottom: 20px; border-bottom: 1px solid #E4E8EF; background: #fff; padding: 15px 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 sidebar p-3 d-none d-md-block">
            <h4 class="fw-bold text-warning mb-4"><i class="fa-solid fa-boxes-stacked me-2"></i> Vendor Portal</h4>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="#" class="nav-link active"><i class="fa-solid fa-chart-pie me-2"></i> Dashboard</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger mt-5"><i class="fa-solid fa-right-from-bracket me-2"></i> Logout</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 ms-auto px-4 py-3">
            <!-- Topbar -->
            <div class="topbar">
                <div class="text-muted small">GlobalTrade / <span class="fw-bold text-dark">Vendor Representative</span></div>
                <div class="fw-bold text-dark"><i class="fa-solid fa-user-tie me-1 text-warning"></i> Supplier Dashboard</div>
            </div>

            <!-- Banner -->
            <div class="p-4 mb-4 rounded-3 text-white shadow-sm" style="background: linear-gradient(135deg, #0B1D33 0%, #142C48 100%);">
                <h4 class="fw-bold mb-1"><i class="fa-solid fa-clipboard-list me-2 text-warning"></i> Assigned Shipments Management</h4>
                <p class="text-white-50 mb-0 small">Review incoming orders, prepare supplies, and mark shipments as ready for warehouse dispatch.</p>
            </div>

            <!-- Table Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa-solid fa-box-open me-2 text-warning"></i> Pending & Preparing Shipments</h5>
                    <button class="btn btn-sm btn-outline-light" onclick="loadVendorShipments()"><i class="fa-solid fa-rotate-right me-1"></i> Refresh</button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4">Tracking No</th>
                                <th>Origin</th>
                                <th>Destination</th>
                                <th>Status</th>
                                <th class="text-end pe-4">Action</th>
                            </tr>
                            </thead>
                            <tbody id="vendorTableBody">
                            <tr><td colspan="5" class="text-center text-muted py-4">Loading shipments...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function loadVendorShipments() {
        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/logistics/vendor-shipments', {
            method: 'GET',
            headers: { 'Cache-Control': 'no-cache' }
        })
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('vendorTableBody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">No shipments assigned to vendor.</td></tr>';
                    return;
                }

                data.forEach(s => {
                    let badgeClass = s.status === 'PENDING' ? 'bg-secondary' : 'bg-info text-dark';
                    tbody.innerHTML += `
                        <tr>
                            <td class="ps-4 fw-bold">\${s.trackingNumber}</td>
                            <td>\${s.origin}</td>
                            <td>\${s.destination}</td>
                            <td><span class="badge \${badgeClass}">\${s.status}</span></td>
                            <td class="text-end pe-4">
                                <button class="btn btn-sm btn-warning fw-bold text-dark" onclick="updateStatus('\${s.trackingNumber}', 'READY_FOR_DISPATCH')">
                                    <i class="fa-solid fa-check-to-slot me-1"></i> Ready for Dispatch
                                </button>
                            </td>
                        </tr>
                    `;
                });
            })
            .catch(err => {
                console.error('Error:', err);
                document.getElementById('vendorTableBody').innerHTML = '<tr><td colspan="5" class="text-center text-danger py-4">Failed to load shipments.</td></tr>';
            });
    }

    function updateStatus(trackingNo, status) {
        if (confirm("Are you sure you want to mark shipment " + trackingNo + " as Ready for Dispatch?")) {
            const contextPath = '${pageContext.request.contextPath}';

            fetch(contextPath + '/api/logistics/shipment/status/' + trackingNo + '?status=' + status, { method: 'PUT' })
                .then(res => {
                    if (res.ok) {
                        alert("Shipment status updated successfully!");
                        loadVendorShipments();
                    } else {
                        alert("Failed to update shipment status.");
                    }
                })
                .catch(err => console.error('Error:', err));
        }
    }


    loadVendorShipments();
</script>
</body>
</html>