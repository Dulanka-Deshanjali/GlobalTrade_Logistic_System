<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Audit Logs | GlobalTrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --navy: #0B1D33; --bg-soft: #F5F7FA; --ink: #1C2733; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; color: var(--ink); }
        .panel-card { border: 1px solid #E4E8EF; border-radius: 10px; overflow: hidden; }
        .panel-card .card-header { background: var(--navy) !important; color: #fff; padding: 14px 20px; }
        .badge-action { font-family: 'IBM Plex Mono', monospace; font-size: 11px; padding: 5px 10px; border-radius: 12px; background: #e2e8f0; color: #1e293b; }
    </style>
</head>
<body>

<div class="container-fluid px-0">
    <!-- Top Header -->
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <h2><i class="fa-solid fa-shield-halved me-2"></i> System Audit Logs</h2>
        <span class="text-muted fw-bold"><i class="fa-solid fa-clock-rotate-left me-1"></i> Track System Activities</span>
    </div>

    <!-- Audit Logs Table -->
    <div class="card panel-card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Activity History & Security Logs</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Action</th>
                        <th>Details</th>
                        <th>Timestamp</th>
                    </tr>
                    </thead>
                    <tbody id="auditTableBody">
                    <tr><td colspan="5" class="text-center text-muted">Loading audit logs...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>

    function loadAuditLogs() {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

        fetch(contextPath + '/api/logistics/audit-logs')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('auditTableBody');
                tbody.innerHTML = '';

                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">No audit logs found.</td></tr>';
                    return;
                }

                data.forEach(log => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td><strong>#\${log.id}</strong></td>
                        <td>\${log.username || 'System'}</td>
                        <td><span class="badge badge-action">\${log.action}</span></td>
                        <td>\${log.details}</td>
                        <td>\${log.timestamp ? log.timestamp.replace('T', ' ') : 'N/A'}</td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                console.error('Error loading audit logs:', err);
                document.getElementById('auditTableBody').innerHTML = '<tr><td colspan="5" class="text-center text-danger">Failed to load audit logs from server.</td></tr>';
            });
    }


    loadAuditLogs();
</script>
</body>
</html>