<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customs Officer Dashboard | GlobalTrade</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap" rel="stylesheet">

    <style>
        :root{
            --navy: #0B1D33;
            --navy-2: #142C48;
            --amber: #F2A93B;
            --paper: #FFFFFF;
            --bg-soft: #F5F7FA;
            --ink: #1C2733;
            --muted: #7A8496;
            --line: #E4E8EF;
        }

        body {
            background-color: var(--bg-soft);
            font-family: 'Inter', sans-serif;
            color: var(--ink);
        }

        /* ===== Sidebar ===== */
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, var(--navy) 0%, var(--navy-2) 100%);
            color: #fff;
            position: relative;
        }

        .sidebar .brand {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 22px 15px 18px;
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 700;
            font-size: 18px;
        }
        .sidebar .brand .brand-badge {
            width: 34px; height: 34px;
            border-radius: 8px;
            background: var(--amber);
            color: var(--navy);
            display: flex; align-items: center; justify-content: center;
            font-size: 15px;
            flex-shrink: 0;
        }

        .sidebar .nav-eyebrow {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 10.5px;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35);
            padding: 0 15px;
            margin: 6px 0 10px;
        }

        .sidebar a {
            color: #b9c2d0;
            text-decoration: none;
            padding: 10px 15px;
            display: flex;
            align-items: center;
            border-radius: 6px;
            margin-bottom: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background .15s ease, color .15s ease;
        }
        .sidebar a i { width: 20px; }
        .sidebar a:hover {
            background-color: rgba(255,255,255,0.06);
            color: #fff;
        }
        .sidebar a.active {
            background-color: rgba(242,169,59,0.14);
            color: var(--amber);
            box-shadow: inset 3px 0 0 var(--amber);
        }
        .sidebar a.active i { color: var(--amber); }
        .sidebar a.text-danger { color: #f28b82 !important; }
        .sidebar a.text-danger:hover { background-color: rgba(242,139,130,0.1); }

        .sidebar hr { border-color: rgba(255,255,255,0.08); margin: 4px 0 14px; }

        /* ===== Topbar ===== */
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--line);
        }
        .topbar .crumbs {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 11.5px;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: var(--muted);
        }
        .topbar .crumbs span { color: var(--navy); }

        .topbar .user-chip {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: var(--muted);
        }
        .topbar .user-chip .avatar {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: var(--navy);
            color: var(--amber);
            display: flex; align-items: center; justify-content: center;
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar Navigation -->
        <div class="col-md-3 col-lg-2 sidebar p-3 d-none d-md-block">
            <div class="brand">
                <span class="brand-badge"><i class="fa-solid fa-shield-halved"></i></span>
                GlobalTrade
            </div>
            <hr>
            <div class="nav-eyebrow">Customs Control</div>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="#" class="nav-link active"><i class="fa-solid fa-chart-pie me-2"></i> Dashboard</a></li>
                <a href="${pageContext.request.contextPath}/j_security_check?logout=true" class="nav-link text-danger mt-5">
                    <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                </a>            </ul>
        </div>

        <!-- Main Content Area -->
        <div class="col-md-9 col-lg-10 ms-auto px-4 py-3">
            <div class="topbar">
                <div class="crumbs">GlobalTrade / <span>Customs Officer</span></div>
                <div class="user-chip">
                    <span class="avatar"><i class="fa-solid fa-user-shield"></i></span>
                    Customs Compliance Center
                </div>
            </div>

            <div id="main-content">
                <!-- Top Welcome Banner -->
                <div class="p-3 px-4 mb-3 rounded-3 text-white shadow-sm" style="background: linear-gradient(135deg, #0B1D33 0%, #142C48 100%);">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h4 class="fw-bold mb-1"><i class="fa-solid fa-shield-halved me-2 text-warning"></i> Customs Clearance & Compliance</h4>
                            <p class="text-white-50 mb-0 small">Review incoming international shipments, verify documentation, and grant customs approvals.</p>
                        </div>
                        <div class="col-md-4 text-md-end mt-2 mt-md-0">
                            <span class="badge bg-success bg-opacity-75 fs-6 px-3 py-1.5"><i class="fa-solid fa-circle-check me-1"></i> System Online</span>
                        </div>
                    </div>
                </div>

                <!-- Shipments Table Card -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-dark text-white py-3 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fa-solid fa-file-invoice me-2 text-warning"></i> Incoming Shipments for Review</h5>
                        <button class="btn btn-sm btn-outline-light" onclick="loadCustomsShipments()"><i class="fa-solid fa-rotate-right me-1"></i> Refresh</button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Tracking No</th>
                                    <th>Origin</th>
                                    <th>Destination</th>
                                    <th>Current Status</th>
                                    <th>Documents</th>
                                    <th class="text-end pe-4">Customs Action</th>
                                </tr>
                                </thead>
                                <tbody id="customsTableBody">
                                <tr><td colspan="6" class="text-center text-muted py-4">Loading shipment data...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- NEW: Official Customs Declarations Table -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-file-signature me-2 text-success"></i> Official Customs Declarations</h6>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadDeclarations()"><i class="fa-solid fa-rotate-right"></i></button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Declaration No</th>
                                    <th>Tracking No</th>
                                    <th>Clearance Status</th>
                                    <th>Submission Date</th>
                                    <th class="pe-4">Clearance Date</th>
                                </tr>
                                </thead>
                                <tbody id="declarationsTableBody">
                                <tr><td colspan="5" class="text-center text-muted py-4">Loading declarations...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Audit Trails / History Section -->
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 border-bottom">
                        <h6 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Customs Compliance Audit Trail</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-sm table-striped align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Timestamp</th>
                                    <th>Officer / Role</th>
                                    <th>Action Taken</th>
                                    <th class="pe-4">Details</th>
                                </tr>
                                </thead>
                                <tbody id="auditTrailTableBody">
                                <tr><td colspan="4" class="text-center text-muted py-3">No recent audit logs.</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

<!-- Document Verification Modal -->
<div class="modal fade" id="docModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title"><i class="fa-solid fa-file-shield me-2"></i> Document Verification</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="docModalBody">
                <!-- Dynamic Content -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function loadCustomsShipments() {
        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/customs/shipments')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('customsTableBody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-4">No shipments found for customs review.</td></tr>';
                    return;
                }

                const transitList = data.filter(s => s.status && s.status.toUpperCase() === 'IN_TRANSIT');

                if (transitList.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-4">No shipments currently in transit for customs clearance.</td></tr>';
                    return;
                }

                transitList.forEach(s => {
                    tbody.innerHTML += `
                        <tr>
                            <td class="ps-4 fw-bold">\${s.trackingNumber || ''}</td>
                            <td>\${s.origin || ''}</td>
                            <td>\${s.destination || ''}</td>
                            <td><span class="badge bg-primary">\${s.status}</span></td>
                            <td>
                                <button class="btn btn-sm btn-outline-dark" onclick="viewDocuments('\${s.trackingNumber}', '\${s.origin}', '\${s.destination}')">
                                    <i class="fa-solid fa-folder-open me-1"></i> View Docs
                                </button>
                            </td>
                            <td class="text-end pe-4">
                                <button class="btn btn-sm btn-success me-1 fw-bold" onclick="updateCustoms('\${s.trackingNumber}', 'CUSTOMS_APPROVED')">
                                    <i class="fa-solid fa-check me-1"></i> Approve
                                </button>
                                <button class="btn btn-sm btn-danger fw-bold" onclick="updateCustoms('\${s.trackingNumber}', 'CUSTOMS_HELD')">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Hold
                                </button>
                            </td>
                        </tr>
                    `;
                });
            })
            .catch(err => {
                console.error('Error loading customs data:', err);
                document.getElementById('customsTableBody').innerHTML = '<tr><td colspan="6" class="text-center text-danger py-4">Failed to load data from server.</td></tr>';
            });
    }

    function updateCustoms(trackingNumber, actionStatus) {
        if (confirm("Are you sure you want to update customs status for " + trackingNumber + " to " + actionStatus + "?")) {
            const contextPath = '${pageContext.request.contextPath}';

            fetch(contextPath + '/api/customs/shipment/clearance/' + trackingNumber + '?status=' + actionStatus, {
                method: 'PUT'
            })
                .then(res => {
                    if (res.ok) {
                        alert("Customs status updated successfully!");
                        loadCustomsShipments();
                        loadDeclarations();
                        loadAuditTrails();
                    } else {
                        alert("Failed to update customs status.");
                    }
                })
                .catch(err => console.error('Error:', err));
        }
    }

    function loadDeclarations() {
        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/customs/declarations')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('declarationsTableBody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">No official customs declarations found.</td></tr>';
                    return;
                }

                data.forEach(dec => {
                    let badgeClass = 'bg-secondary';
                    if (dec.clearanceStatus === 'CUSTOMS_APPROVED') badgeClass = 'bg-success';
                    else if (dec.clearanceStatus === 'CUSTOMS_HELD') badgeClass = 'bg-danger';

                    let trackNo = (dec.shipment && dec.shipment.trackingNumber) ? dec.shipment.trackingNumber : 'N/A';

                    let subDate = dec.submissionDate ? dec.submissionDate.replace('T', ' ').substring(0, 19) : 'N/A';
                    let clrDate = dec.clearanceDate ? dec.clearanceDate.replace('T', ' ').substring(0, 19) : '<span class="text-muted fst-italic">Pending</span>';

                    tbody.innerHTML += `
                        <tr>
                            <td class="ps-4 fw-bold text-primary">\${dec.declarationNumber}</td>
                            <td class="fw-bold">\${trackNo}</td>
                            <td><span class="badge \${badgeClass}">\${dec.clearanceStatus}</span></td>
                            <td>\${subDate}</td>
                            <td class="pe-4">\${clrDate}</td>
                        </tr>
                    `;
                });
            })
            .catch(err => {
                console.error('Error loading declarations:', err);
                document.getElementById('declarationsTableBody').innerHTML = '<tr><td colspan="5" class="text-center text-danger py-4">Failed to load declarations.</td></tr>';
            });
    }

    function viewDocuments(trackingNo, origin, destination) {
        const modalBody = document.getElementById('docModalBody');
        modalBody.innerHTML = `
            <p><strong>Tracking Number:</strong> \${trackingNo}</p>
            <p><strong>Route:</strong> \${origin} ➔ \${destination}</p>
            <hr>
            <ul class="list-group">
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    Commercial Invoice <span class="badge bg-success">Verified</span>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    Certificate of Origin <span class="badge bg-success">Valid</span>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    Import/Export Permit <span class="badge bg-primary">Cleared</span>
                </li>
            </ul>
        `;
        var myModal = new bootstrap.Modal(document.getElementById('docModal'));
        myModal.show();
    }

    function loadAuditTrails() {
        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/customs/audit-logs')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('auditTrailTableBody');
                tbody.innerHTML = '';

                if (!Array.isArray(data) || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">No audit logs found.</td></tr>';
                    return;
                }

                data.forEach(log => {
                    let actionBadge = 'bg-secondary';
                    if (log.action === 'CUSTOMS_APPROVED') actionBadge = 'bg-success';
                    else if (log.action === 'CUSTOMS_HELD') actionBadge = 'bg-danger';

                    tbody.innerHTML += `
                    <tr>
                        <td class="ps-4 text-muted small">\${log.formattedTimestamp || 'N/A'}</td>
                        <td><span class="badge bg-dark">\${log.username || 'N/A'}</span></td>
                        <td><span class="badge \${actionBadge}">\${log.action}</span></td>
                        <td class="pe-4 small">\${log.details}</td>
                    </tr>
                `;
                });
            })
            .catch(err => {
                console.error('Error loading audit logs:', err);
                document.getElementById('auditTrailTableBody').innerHTML = '<tr><td colspan="4" class="text-center text-danger">Failed to load audit logs.</td></tr>';
            });
    }


    loadCustomsShipments();
    loadDeclarations();
    loadAuditTrails();
</script>
</body>
</html>