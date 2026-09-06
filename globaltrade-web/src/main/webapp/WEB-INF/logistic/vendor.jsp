<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vendor Management | GlobalTrade</title>
  <!-- Bootstrap 5 CSS -->
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
    .card-stat.stat-rating{ border-left-color: var(--amber) !important; }
    .card-stat.stat-rating h3{ color: #C4821F !important; }
    .card-stat.stat-noncompliant{ border-left-color: #dc3545 !important; }

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

    .panel-card .btn-primary{
      background: var(--amber);
      border-color: var(--amber);
      color: var(--navy);
      font-weight: 600;
    }
    .panel-card .btn-primary:hover{
      background: #e0982a;
      border-color: #e0982a;
      color: var(--navy);
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

    .rating-stars{ color: var(--amber); font-size: 12px; letter-spacing: 1px; }
    .rating-value{ font-family:'IBM Plex Mono', monospace; font-size: 12.5px; color: var(--muted); margin-left: 4px; }

    .badge-compliant{ background: #E5F5EA; color: #1F8A43; font-weight: 600; }
    .badge-noncompliant{ background: #FBE7E9; color: #C22A38; font-weight: 600; }

    .shipment-count{
      font-family:'IBM Plex Mono', monospace;
      font-size: 12px;
      background: #F0F3F8;
      color: var(--ink);
      border-radius: 12px;
      padding: 3px 10px;
    }

    #vendorModal .modal-content{ border: none; border-radius: 10px; overflow: hidden; }
    #vendorModal .modal-header{
      background: var(--navy);
      color: #fff;
      border-bottom: 3px solid var(--amber);
    }
    #vendorModal .modal-header .modal-title{
      font-family: 'Space Grotesk', sans-serif;
      font-weight: 600;
      font-size: 17px;
    }
    #vendorModal .btn-close{ filter: invert(1) grayscale(1) brightness(2); }

    #vendorModal .field-label{
      font-family:'IBM Plex Mono', monospace;
      font-size: 10.5px;
      font-weight: 600;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 6px;
      display: block;
    }
    #vendorModal .form-control, #vendorModal .form-select{
      border: 1px solid var(--line);
      border-radius: 5px;
      padding: 10px 12px;
      font-size: 14px;
    }
    #vendorModal .form-control:focus, #vendorModal .form-select:focus{
      border-color: #2F6FED;
      box-shadow: 0 0 0 3px rgba(47,111,237,0.15);
    }
    #vendorModal .form-check-input:checked{
      background-color: var(--amber);
      border-color: var(--amber);
    }
    #vendorModal .btn-save{
      background: var(--navy);
      color: #fff;
      font-weight: 600;
      border: none;
      padding: 9px 22px;
      border-radius: 5px;
    }
    #vendorModal .btn-save:hover{ background: var(--navy-2); }
  </style>
</head>
<body>

<div class="container-fluid px-0">
  <!-- Top Header -->
  <div class="content-header d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
    <h2>Vendor Management</h2>
    <span class="welcome-chip"><i class="fa-solid fa-handshake me-1"></i> Vendor / Supplier Registry</span>
  </div>

  <!-- Quick Stats Cards -->
  <div class="row text-center mb-4">
    <div class="col-md-4 mb-3">
      <div class="card card-stat stat-total shadow-sm p-3 bg-white">
        <h6 class="text-muted">Total Vendors</h6>
        <h3 id="totalVendors" class="text-primary">0</h3>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card card-stat stat-rating shadow-sm p-3 bg-white">
        <h6 class="text-muted">Avg Performance Rating</h6>
        <h3 id="avgRating">0.0</h3>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card card-stat stat-noncompliant shadow-sm p-3 bg-white">
        <h6 class="text-muted">Non-Compliant</h6>
        <h3 id="nonCompliantCount" class="text-danger">0</h3>
      </div>
    </div>
  </div>

  <!-- Vendor Table -->
  <div class="card panel-card shadow-sm">
    <div class="card-header text-white d-flex justify-content-between align-items-center">
      <h5 class="mb-0"><i class="fa-solid fa-handshake me-2"></i> Registered Vendors</h5>
      <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#vendorModal" onclick="openVendorModal()">
        <i class="fa-solid fa-plus me-1"></i> Add Vendor
      </button>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead class="table-light">
          <tr>
            <th>Vendor Name</th>
            <th>Email</th>
            <th>Contact No</th>
            <th>Performance</th>
            <th>Compliance</th>
            <th>Shipments</th>
            <th>Action</th>
          </tr>
          </thead>
          <tbody id="vendorTableBody">
          <tr>
            <td colspan="7" class="text-center text-muted">Loading vendors...</td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Add / Edit Vendor Modal -->
<div class="modal fade" id="vendorModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="vendorModalTitle"><i class="fa-solid fa-handshake me-2"></i>Add Vendor</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="vendorForm" onsubmit="saveVendor(event)">
        <div class="modal-body">
          <input type="hidden" id="vendorId">

          <div class="mb-3">
            <label class="field-label" for="vendorName">Vendor Name</label>
            <input type="text" class="form-control" id="vendorName" required placeholder="e.g. Ceylon Freight Partners">
          </div>

          <div class="mb-3">
            <label class="field-label" for="vendorEmail">Email</label>
            <select class="form-select" id="vendorEmail" required>
              <option value="" selected disabled>Loading emails...</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="field-label" for="vendorContactNumber">Contact Number</label>
            <input type="tel" class="form-control" id="vendorContactNumber" placeholder="+94 7X XXX XXXX">
          </div>

          <div class="row">
            <div class="col-7 mb-3">
              <label class="field-label" for="vendorPerformanceRating">Performance Rating</label>
              <input type="number" class="form-control" id="vendorPerformanceRating" min="0" max="5" step="0.1" value="0" required>
            </div>
            <div class="col-5 mb-3 d-flex align-items-end">
              <div class="form-check form-switch mb-1">
                <input class="form-check-input" type="checkbox" role="switch" id="vendorComplianceStatus" checked>
                <label class="form-check-label field-label mb-0" for="vendorComplianceStatus" style="text-transform:none; font-weight:500; font-size:13px;">Compliant</label>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-save"><i class="fa-solid fa-check me-1"></i> Save Vendor</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  function loadVendorsToTable() {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

    fetch(contextPath + '/api/vendors', {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    })
            .then(response => response.json())
            .then(vendors => {
              const tbody = document.getElementById('vendorTableBody');
              tbody.innerHTML = '';

              if (!vendors || vendors.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No vendors found.</td></tr>';
                document.getElementById('totalVendors').innerText = 0;
                document.getElementById('avgRating').innerText = '0.0';
                document.getElementById('nonCompliantCount').innerText = 0;
                return;
              }

              let totalVendors = vendors.length;
              let totalRating = 0;
              let nonCompliantCount = 0;

              vendors.forEach(vendor => {
                totalRating += vendor.performanceRating;
                if (!vendor.complianceStatus) {
                  nonCompliantCount++;
                }

                let starsHtml = '';
                let rating = vendor.performanceRating;
                for (let i = 1; i <= 5; i++) {
                  if (i <= Math.floor(rating)) {
                    starsHtml += '<i class="fa-solid fa-star"></i>';
                  } else {
                    starsHtml += '<i class="fa-regular fa-star"></i>';
                  }
                }

                let badgeClass = vendor.complianceStatus ? 'badge-compliant' : 'badge-noncompliant';
                let badgeText = vendor.complianceStatus ? 'COMPLIANT' : 'NON-COMPLIANT';

                const tr = document.createElement('tr');
                tr.setAttribute('data-vendor-id', vendor.id);
                tr.innerHTML = `
                    <td>\${vendor.vendorName}</td>
                    <td>\${vendor.email}</td>
                    <td>\${vendor.contactNumber || 'N/A'}</td>
                    <td>
                        <span class="rating-stars">\${starsHtml}</span>
                        <span class="rating-value">\${vendor.performanceRating}</span>
                    </td>
                    <td><span class="badge \${badgeClass}">\${badgeText}</span></td>
                    <td><span class="shipment-count">-- shipments</span></td>
                    <td>
                        <button class="btn btn-sm btn-outline-primary" onclick="editVendor(\${vendor.id}, '\${vendor.vendorName}', '\${vendor.email}', '\${vendor.contactNumber}', \${vendor.performanceRating}, \${vendor.complianceStatus})"><i class="fa-solid fa-pen"></i></button>
                        <button class="btn btn-sm btn-outline-danger" onclick="deleteVendor(\${vendor.id})"><i class="fa-solid fa-trash"></i></button>
                    </td>
                `;
                tbody.appendChild(tr);
              });

              document.getElementById('totalVendors').innerText = totalVendors;
              document.getElementById('avgRating').innerText = (totalRating / totalVendors).toFixed(1);
              document.getElementById('nonCompliantCount').innerText = nonCompliantCount;
            })
            .catch(error => {
              console.error('Error loading vendors:', error);
              document.getElementById('vendorTableBody').innerHTML = '<tr><td colspan="7" class="text-center text-danger">Failed to load vendors.</td></tr>';
            });
  }

  function loadVendorEmails(selectedEmail) {
    const emailSelect = document.getElementById('vendorEmail');
    emailSelect.innerHTML = '<option value="" selected disabled>Loading emails...</option>';

    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

    fetch(contextPath + '/api/vendors/users?role=VENDOR')
            .then(response => response.json())
            .then(users => {
              emailSelect.innerHTML = '<option value="" selected disabled>Choose email...</option>';
              users.forEach(user => {
                const opt = document.createElement('option');
                opt.value = user.email;
                opt.textContent = user.email;
                if (selectedEmail && user.email === selectedEmail) {
                  opt.selected = true;
                }
                emailSelect.appendChild(opt);
              });
            })
            .catch(error => {
              console.error('Error loading emails:', error);
              emailSelect.innerHTML = '<option value="" selected disabled>Failed to load emails</option>';
            });
  }

  function openVendorModal() {
    document.getElementById('vendorForm').reset();
    document.getElementById('vendorId').value = '';
    document.getElementById('vendorComplianceStatus').checked = true;
    document.getElementById('vendorModalTitle').innerHTML = '<i class="fa-solid fa-handshake me-2"></i>Add Vendor';
    loadVendorEmails();
  }

  function editVendor(id, name, email, contact, rating, compliant) {
    document.getElementById('vendorId').value = id;
    document.getElementById('vendorName').value = name;
    document.getElementById('vendorContactNumber').value = contact === 'null' ? '' : contact;
    document.getElementById('vendorPerformanceRating').value = rating;
    document.getElementById('vendorComplianceStatus').checked = compliant;
    document.getElementById('vendorModalTitle').innerHTML = '<i class="fa-solid fa-pen me-2"></i>Edit Vendor';

    loadVendorEmails(email);
    new bootstrap.Modal(document.getElementById('vendorModal')).show();
  }

  function saveVendor(event) {
    event.preventDefault();

    const vendorData = {
      id: document.getElementById('vendorId').value || null,
      vendorName: document.getElementById('vendorName').value,
      email: document.getElementById('vendorEmail').value,
      contactNumber: document.getElementById('vendorContactNumber').value,
      performanceRating: parseFloat(document.getElementById('vendorPerformanceRating').value),
      complianceStatus: document.getElementById('vendorComplianceStatus').checked
    };

    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
    const isEdit = !!vendorData.id;

    fetch(contextPath + '/api/vendors' + (isEdit ? ('/' + vendorData.id) : ''), {
      method: isEdit ? 'PUT' : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(vendorData)
    })
            .then(response => {
              if (response.ok) {
                alert(isEdit ? 'Vendor updated successfully!' : 'Vendor added successfully!');

                const modalEl = document.getElementById('vendorModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                modal.hide();

                loadVendorsToTable();
              } else {
                alert('Save failed! Email may already exist.');
              }
            })
            .catch(error => console.error('Error:', error));
  }

  function deleteVendor(id) {
    if (!confirm('Remove this vendor?')) return;

    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));

    fetch(contextPath + '/api/vendors/' + id, { method: 'DELETE' })
            .then(response => {
              if (response.ok) {
                loadVendorsToTable();
              } else {
                alert('Delete failed.');
              }
            })
            .catch(error => console.error('Error:', error));
  }

  loadVendorsToTable();
</script>
</body>
</html>