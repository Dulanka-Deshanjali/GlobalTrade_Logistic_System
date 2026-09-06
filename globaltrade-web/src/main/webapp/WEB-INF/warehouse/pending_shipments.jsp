<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Warehouse Dispatch | GlobalTrade</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root { --navy: #0B1D33; --amber: #F2A93B; --bg-soft: #F5F7FA; --ink: #1C2733; }
    body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; color: var(--ink); }
    .panel-card { border: 1px solid #E4E8EF; border-radius: 10px; overflow: hidden; }
    .panel-card .card-header { background: var(--navy) !important; color: #fff; padding: 14px 20px; }
    .badge-status { font-family: 'IBM Plex Mono', monospace; font-size: 11px; padding: 5px 10px; border-radius: 12px; }
    .status-ready { background: #D1E7DD; color: #0F5132; }
  </style>
</head>
<body>

<div class="container-fluid px-4 py-3">
  <!-- Top Header -->
  <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
    <h2><i class="fa-solid fa-warehouse"></i> Warehouse Dispatch Management</h2>
    <button class="btn btn-sm btn-outline-dark" onclick="loadReadyShipments()"><i class="fa-solid fa-rotate-right me-1"></i> Refresh</button>
  </div>

  <!-- Ready to Dispatch Shipment Table -->
  <div class="card panel-card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h5 class="mb-0">Shipments Ready For Warehouse Dispatch</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th class="ps-4">Tracking No</th>
            <th>Item Name</th>
            <th>Origin</th>
            <th>Destination</th>
            <th>Status</th>
            <th class="text-end pe-4">Action</th>
          </tr>
          </thead>
          <tbody id="readyShipmentTableBody">
          <tr><td colspan="6" class="text-center text-muted py-4">Loading shipments...</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
  function loadReadyShipments() {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

    fetch(contextPath + '/api/logistics/shipments')
            .then(res => res.json())
            .then(data => {
              const tbody = document.getElementById('readyShipmentTableBody');
              tbody.innerHTML = '';

              const readyData = data.filter(s => s.status && s.status.toUpperCase() === 'READY_FOR_DISPATCH');

              if (!readyData || readyData.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-4">No shipments ready for dispatch from vendors.</td></tr>';
                return;
              }

              readyData.forEach(s => {
                let itemName = (s.inventory && s.inventory.itemName) ? s.inventory.itemName : 'N/A';

                tbody.innerHTML += `
                        <tr>
                            <td class="ps-4 fw-bold">\${s.trackingNumber}</td>
                            <td>\${itemName}</td>
                            <td>\${s.origin}</td>
                            <td>\${s.destination}</td>
                            <td><span class="badge badge-status status-ready">\${s.status}</span></td>
                            <td class="text-end pe-4">
                                <button class="btn btn-success btn-sm fw-bold" onclick="dispatchShipment('\${s.trackingNumber}')">
                                    <i class="fa-solid fa-truck-fast me-1"></i> Ship Now (In-Transit)
                                </button>
                            </td>
                        </tr>
                    `;
              });
            })
            .catch(err => {
              console.error('Error:', err);
              document.getElementById('readyShipmentTableBody').innerHTML = '<tr><td colspan="6" class="text-center text-danger py-4">Failed to load shipments.</td></tr>';
            });
  }

  function dispatchShipment(trackingNumber) {
    if (confirm("Are you sure you want to dispatch shipment " + trackingNumber + "? This will update status to IN_TRANSIT and deduct inventory stock.")) {
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

      fetch(contextPath + '/api/logistics/shipment/status/' + trackingNumber + '?status=IN_TRANSIT', {
        method: 'PUT'
      })
              .then(async response => {
                const result = await response.json().catch(() => ({}));
                if (response.ok) {
                  alert("Shipment successfully dispatched!");
                  loadReadyShipments();
                } else {
                  alert("Failed to update: " + (result.error || "Unknown error occurred."));
                }
              })
              .catch(err => {
                console.error('Error:', err);
                alert('Failed to connect to server.');
              });
    }
  }
  loadReadyShipments();
</script>
</body>
</html>