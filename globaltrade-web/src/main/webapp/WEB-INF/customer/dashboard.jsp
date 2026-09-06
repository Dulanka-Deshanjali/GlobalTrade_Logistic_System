<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard | GlobalTrade Logistics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --navy: #0B1D33; --amber: #F2A93B; }
        body { background-color: #F5F7FA; font-family: 'Inter', sans-serif; }
        .navbar { background-color: var(--navy) !important; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.06); }

        /* AliExpress Style Step Progress Bar */
        .tracking-steps { display: flex; justify-content: space-between; position: relative; margin-bottom: 30px; margin-top: 20px; }
        .tracking-steps::before { content: ''; position: absolute; top: 15px; left: 10%; right: 10%; height: 4px; background: #e0e0e0; z-index: 1; }
        .step { position: relative; z-index: 2; text-align: center; flex: 1; }
        .step-icon { width: 36px; height: 36px; border-radius: 50%; background: #e0e0e0; color: #fff; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-size: 14px; transition: all 0.3s; }
        .step.completed .step-icon { background: #28a745; }
        .step.active .step-icon { background: var(--amber); color: var(--navy); font-weight: bold; box-shadow: 0 0 0 4px rgba(242, 169, 59, 0.2); }
        .step.delayed .step-icon { background: #dc3545; }
        .step-text { font-size: 12px; font-weight: 600; color: #6c757d; }
        .step.active .step-text { color: var(--navy); }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark px-4 py-3">
    <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-earth-americas me-2 text-warning"></i>GlobalTrade - Customer Portal</a>
    <button class="btn btn-outline-light btn-sm px-3" onclick="logout()">Sign Out</button>
</nav>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card card-custom p-4 bg-white">
                <h4 class="fw-bold mb-2"><i class="fa-solid fa-truck-fast text-warning me-2"></i>Track Your Shipment</h4>
                <p class="text-muted small mb-4">Enter your shipment tracking ID to monitor real-time customs, processing, and transit statuses.</p>

                <div class="input-group mb-4">
                    <input type="text" id="trackingNumber" class="form-control form-control-lg fs-6" placeholder="Enter Tracking ID (e.g., TRK-12345)">
                    <button class="btn btn-dark px-4 fw-bold" onclick="trackShipment()">Track</button>
                </div>

                <div id="resultCard" class="d-none">

                    <div id="alertBox" class="alert d-none mb-4 py-2 small fw-bold" role="alert"></div>

                    <div class="card bg-light border-0 p-3 mb-4">
                        <div class="row">
                            <div class="col-md-4 mb-2 mb-md-0">
                                <span class="text-muted small d-block">Current Status</span>
                                <span id="shipmentStatusBadge" class="badge bg-secondary fs-6 mt-1">Processing</span>
                            </div>
                            <div class="col-md-4 mb-2 mb-md-0">
                                <span class="text-muted small d-block">Current Location</span>
                                <strong id="shipmentLocation" class="text-dark">-</strong>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted small d-block">Estimated Delivery</span>
                                <strong id="shipmentDelivery" class="text-dark">-</strong>
                            </div>
                        </div>
                    </div>

                    <!-- AliExpress Style Step Progress Visualizer -->
                    <h6 class="fw-bold text-muted small mb-3 text-uppercase">Logistics Progress Timeline</h6>
                    <div class="tracking-steps">
                        <div class="step" id="step-processing">
                            <div class="step-icon"><i class="fa-solid fa-box"></i></div>
                            <div class="step-text">Processing</div>
                        </div>
                        <div class="step" id="step-dispatch">
                            <div class="step-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                            <div class="step-text">Ready for Dispatch</div>
                        </div>
                        <div class="step" id="step-transit">
                            <div class="step-icon"><i class="fa-solid fa-plane-departure"></i></div>
                            <div class="step-text">In Transit</div>
                        </div>
                        <div class="step" id="step-customs">
                            <div class="step-icon"><i class="fa-solid fa-building-shield"></i></div>
                            <div class="step-text">Customs Check</div>
                        </div>
                        <div class="step" id="step-delivered">
                            <div class="step-icon"><i class="fa-solid fa-house-chimney"></i></div>
                            <div class="step-text">Delivered</div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function trackShipment() {
        const trackingNo = document.getElementById('trackingNumber').value.trim();
        const contextPath = '${pageContext.request.contextPath}';

        if(!trackingNo) {
            alert('Please enter a tracking number.');
            return;
        }

        fetch(contextPath + '/api/customer/track/' + trackingNo, {
            method: 'GET',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok) {
                    document.getElementById('resultCard').classList.remove('d-none');

                    document.getElementById('shipmentLocation').innerText = data.currentLocation || 'Warehouse Hub';
                    document.getElementById('shipmentDelivery').innerText = data.estimatedDelivery || 'Pending';

                    const status = data.status ? data.status.toUpperCase() : 'PROCESSING';
                    const badge = document.getElementById('shipmentStatusBadge');
                    const alertBox = document.getElementById('alertBox');

                    badge.innerText = data.status;

                    ['step-processing', 'step-dispatch', 'step-transit', 'step-customs', 'step-delivered'].forEach(id => {
                        const el = document.getElementById(id);
                        el.className = 'step';
                    });
                    alertBox.className = 'alert d-none mb-4 py-2 small fw-bold';

                    if(status.includes('HOLD') || status.includes('CUSTOMS_HELD')) {
                        alertBox.className = 'alert alert-danger mb-4 py-2 small fw-bold d-block';
                        alertBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i> Customs Alert: Shipment is currently on hold pending regulatory document clearance.';
                    } else if(status.includes('DELAY')) {
                        alertBox.className = 'alert alert-warning mb-4 py-2 small fw-bold d-block';
                        alertBox.innerHTML = '<i class="fa-solid fa-clock-rotate-left me-1"></i> Notice: Shipment is experiencing minor transit delays.';
                    }

                    if(status === 'PENDING') {
                        document.getElementById('step-processing').classList.add('active');
                        badge.className = 'badge bg-warning text-dark fs-6 mt-1';
                    }
                    else if(status === 'READY_FOR_DISPATCH' || status === 'DISPATCHED') {
                        document.getElementById('step-processing').classList.add('completed');
                        document.getElementById('step-dispatch').classList.add('active');
                        badge.className = 'badge bg-info text-dark fs-6 mt-1';
                    }
                    else if(status === 'IN_TRANSIT') {
                        document.getElementById('step-processing').classList.add('completed');
                        document.getElementById('step-dispatch').classList.add('completed');
                        document.getElementById('step-transit').classList.add('active');
                        badge.className = 'badge bg-primary fs-6 mt-1';
                    }
                    else if(status === 'CUSTOMS_APPROVED' || status === 'CUSTOMS_HELD') {
                        document.getElementById('step-processing').classList.add('completed');
                        document.getElementById('step-dispatch').classList.add('completed');
                        document.getElementById('step-transit').classList.add('completed');
                        document.getElementById('step-customs').classList.add(status.includes('HOLD') ? 'delayed' : 'active');
                        badge.className = 'badge bg-danger fs-6 mt-1';
                    }
                    else if(status === 'DELIVERED') {
                        ['step-processing', 'step-dispatch', 'step-transit', 'step-customs', 'step-delivered'].forEach(id => {
                            document.getElementById(id).classList.add('completed');
                        });
                        badge.className = 'badge bg-success fs-6 mt-1';
                    }

                } else {
                    alert(data.error || 'Shipment not found.');
                    document.getElementById('resultCard').classList.add('d-none');
                }
            })
            .catch(err => {
                console.error('Error:', err);
                alert('Failed to connect to tracking service.');
            });
    }

    function logout() {
        localStorage.removeItem('customerToken');
        window.location.href = '${pageContext.request.contextPath}/login.jsp';
    }
</script>
</body>
</html>