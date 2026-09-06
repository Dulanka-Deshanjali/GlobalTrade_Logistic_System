<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Manager Dashboard | GlobalTrade</title>
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

        #main-content {
            padding-top: 4px;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar Navigation -->
        <div class="col-md-3 col-lg-2 sidebar p-3 d-none d-md-block">
            <div class="brand">
                <span class="brand-badge"><i class="fa-solid fa-warehouse"></i></span>
                GlobalTrade
            </div>
            <hr>
            <div class="nav-eyebrow">Warehouse Control</div>
            <ul class="nav flex-column">
                <li class="nav-item"><a onclick="loadContent('dashboard_content')" class="nav-link active"><i class="fa-solid fa-chart-pie me-2"></i> Dashboard</a></li>
                <li class="nav-item"><a onclick="loadContent('stock')" class="nav-link"><i class="fa-solid fa-boxes-stacked me-2"></i> Low Stock & Inventory</a></li>
                <li class="nav-item"><a onclick="loadContent('pending_shipments')" class="nav-link"><i class="fa-solid fa-truck-ramp-loading me-2"></i> Pending Shipments</a></li>
                <li class="nav-item mt-5"><a href="logout" class="nav-link text-danger"><i class="fa-solid fa-right-from-bracket me-2"></i> Logout</a></li>
            </ul>
        </div>

        <!-- Main Content Area -->
        <div class="col-md-9 col-lg-10 ms-auto px-4 py-3">
            <div class="topbar">
                <div class="crumbs">GlobalTrade / <span>Warehouse Manager</span></div>
                <div class="user-chip">
                    <span class="avatar"><i class="fa-solid fa-user-gear"></i></span>
                    Warehouse Control Center
                </div>
            </div>
            <div id="main-content">
                <!-- Dynamic Content Loads Here -->
            </div>
        </div>

    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script>
    function loadContent(pageName) {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1));
        $('#main-content').load(contextPath + '/warehouse/page/' + pageName);
    }

    $(document).ready(function() {

        loadContent('dashboard_content');

        $('.sidebar .nav-link').on('click', function() {
            if(!$(this).hasClass('text-danger')) {
                $('.sidebar .nav-link').removeClass('active');
                $(this).addClass('active');
            }
        });
    });
</script>

</body>
</html>