<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Register New User — Cargo Ops Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap" rel="stylesheet">
  <style>
    :root{
      --primary: #2F6FED;
      --primary-dark: #1E4FBB;
      --amber: #F2A93B;
      --paper: #FFFFFF;
      --bg-soft: #F5F7FA;
      --ink: #1C2733;
      --muted: #7A8496;
      --line: #E4E8EF;
    }
    *{box-sizing:border-box;}

    /* This block simulates the dashboard's own content pane.
       Remove this wrapper in production — .dash-content-demo is only here so the
       component previews the way it will sit inside your real dashboard shell. */
    .dash-content-demo{
      background: var(--bg-soft);
      min-height:100vh;
      padding: 28px 32px;
      font-family:'Inter', sans-serif;
    }
    .dash-crumbs{
      font-family:'IBM Plex Mono', monospace;
      font-size:11.5px;
      letter-spacing:1px;
      color:#9AA3B2;
      text-transform:uppercase;
      margin-bottom:16px;
    }
    .dash-crumbs span{ color: var(--primary); }

    /* ===== actual component starts here ===== */

    .register-panel{
      width:100%;
      background: var(--paper);
      border-radius: 8px;
      box-shadow: 0 1px 2px rgba(16,24,40,0.05), 0 0 0 1px var(--line);
      overflow:hidden;
      display:grid;
      grid-template-columns: 320px 1fr;
    }

    @media (max-width: 820px){
      .register-panel{ grid-template-columns: 1fr; }
    }

    /* left info rail — light, not dark */
    .reg-aside{
      background: linear-gradient(160deg, #EAF1FF 0%, #F6F9FF 100%);
      color: var(--ink);
      padding: 32px 30px;
      border-right: 1px solid var(--line);
    }
    .reg-aside .eyebrow{
      font-family:'IBM Plex Mono', monospace;
      font-size: 11px;
      letter-spacing: 2.5px;
      text-transform: uppercase;
      color: var(--primary-dark);
      display:flex;
      align-items:center;
      gap:8px;
      margin-bottom: 14px;
    }
    .reg-aside .eyebrow::before{ content:""; width:16px; height:1px; background: var(--primary); display:inline-block; }
    .reg-aside h3{
      font-family:'Space Grotesk', sans-serif;
      font-weight:700;
      font-size: 22px;
      margin: 0 0 10px;
      display:flex;
      align-items:center;
      gap:12px;
      color: var(--ink);
    }
    .reg-aside h3 .icon-badge{
      width:36px; height:36px;
      border-radius:50%;
      background: var(--primary);
      color: #fff;
      display:flex; align-items:center; justify-content:center;
      font-size:15px; flex-shrink:0;
    }
    .reg-aside p.lead{
      margin:0 0 26px;
      font-size: 13px;
      color: var(--muted);
      line-height:1.5;
    }

    .role-legend{ display:flex; flex-direction:column; gap:14px; }
    .role-legend .role-item{
      display:flex; align-items:flex-start; gap:11px;
      padding-bottom:14px;
      border-bottom: 1px solid rgba(28,39,51,0.08);
    }
    .role-legend .role-item:last-child{ border-bottom:none; padding-bottom:0; }
    .role-legend i{
      width:28px; height:28px; flex-shrink:0;
      border-radius:6px;
      background: #fff;
      box-shadow: 0 0 0 1px var(--line);
      color: var(--primary);
      display:flex; align-items:center; justify-content:center;
      font-size:12px;
    }
    .role-legend strong{ display:block; font-size:12.5px; font-weight:600; color: var(--ink); }
    .role-legend span{ display:block; font-size:11.5px; color: var(--muted); margin-top:2px; line-height:1.4; }

    /* right side — the actual form */
    .reg-form-side{ padding: 32px 36px; background: var(--paper); }

    form{ margin:0; }

    .form-grid{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px 20px;
    }
    .field.full{ grid-column: 1 / -1; }

    @media (max-width: 560px){
      .form-grid{ grid-template-columns: 1fr; }
    }

    .field label{
      display:block;
      font-family:'IBM Plex Mono', monospace;
      font-size: 10.5px;
      font-weight:600;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 7px;
    }

    .input-wrap{ position:relative; }
    .input-wrap i{
      position:absolute; left:13px; top:50%;
      transform:translateY(-50%);
      color: var(--muted); font-size: 13px;
    }

    .field input, .field select{
      width:100%;
      padding: 11px 14px 11px 38px;
      font-family:'Inter', sans-serif;
      font-size: 14px;
      color: var(--ink);
      background: #FBFCFE;
      border: 1px solid var(--line);
      border-radius: 5px;
      outline: none;
      transition: border-color .15s ease, box-shadow .15s ease, background .15s ease;
      appearance:none; -webkit-appearance:none;
    }
    .field select{ padding-left: 38px; }
    .field .chevron{
      position:absolute; right:14px; top:50%;
      transform:translateY(-50%);
      color: var(--muted); font-size: 11px; pointer-events:none;
    }
    .field input:focus, .field select:focus{
      border-color: var(--primary);
      background: #fff;
      box-shadow: 0 0 0 3px rgba(47,111,237,0.15);
    }
    .field input::placeholder{ color: #B3BAC7; }

    .form-actions{
      grid-column: 1 / -1;
      display:flex;
      align-items:center;
      gap: 14px;
      margin-top: 6px;
      padding-top: 22px;
      border-top: 1px solid var(--line);
    }

    button.btn-register{
      padding: 12px 26px;
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 5px;
      font-family:'Space Grotesk', sans-serif;
      font-weight:600;
      font-size: 14px;
      cursor:pointer;
      display:flex; align-items:center; gap:9px;
      transition: background .15s ease, transform .1s ease;
    }
    button.btn-register:hover{ background: var(--primary-dark); }
    button.btn-register:active{ transform: translateY(1px); }

    .btn-cancel{
      padding: 12px 22px;
      background: transparent;
      border: 1px solid var(--line);
      border-radius: 5px;
      font-family:'Inter', sans-serif;
      font-size: 14px;
      color: var(--muted);
      cursor:pointer;
    }
    .btn-cancel:hover{ color: var(--ink); border-color: #C7CEDA; }

    .form-note{
      margin-left:auto;
      font-family:'IBM Plex Mono', monospace;
      font-size: 11px;
      color: var(--muted);
    }
  </style>
</head>
<body>

<div class="dash-content-demo">
  <div class="dash-crumbs">Admin Dashboard / <span>Register User</span></div>

  <div class="register-panel">

    <aside class="reg-aside">
      <div class="eyebrow">Access Provisioning</div>
      <h3>
        <span class="icon-badge"><i class="fa-solid fa-user-plus"></i></span>
        New User
      </h3>
      <p class="lead">Create an account and assign the correct operating role. Each role controls what the user can see and act on across the platform.</p>

      <div class="role-legend">
        <div class="role-item">
          <i class="fa-solid fa-handshake"></i>
          <div><strong>Vendor / Supplier</strong><span>Submits orders and fulfillment updates</span></div>
        </div>
        <div class="role-item">
          <i class="fa-solid fa-stamp"></i>
          <div><strong>Customs Official</strong><span>Reviews and clears cross-border cargo</span></div>
        </div>
        <div class="role-item">
          <i class="fa-solid fa-warehouse"></i>
          <div><strong>Warehouse Manager</strong><span>Manages inventory and storage locations</span></div>
        </div>
      </div>
    </aside>

    <div class="reg-form-side">
      <!-- Registration Form — onsubmit calls your existing registerNewUser(event), untouched -->
      <form id="registerForm" onsubmit="registerNewUser(event)">
        <div class="form-grid">

          <div class="field full">
            <label for="regFullName">Full Name</label>
            <div class="input-wrap">
              <i class="fa-regular fa-id-card"></i>
              <input type="text" id="regFullName" required placeholder="Enter full name">
            </div>
          </div>

          <div class="field">
            <label for="regUsername">Username</label>
            <div class="input-wrap">
              <i class="fa-solid fa-at"></i>
              <input type="text" id="regUsername" required placeholder="Choose a username">
            </div>
          </div>

          <div class="field">
            <label for="regEmail">Email Address</label>
            <div class="input-wrap">
              <i class="fa-regular fa-envelope"></i>
              <input type="email" id="regEmail" required placeholder="name@example.com">
            </div>
          </div>

          <div class="field">
            <label for="regPassword">Password</label>
            <div class="input-wrap">
              <i class="fa-solid fa-lock"></i>
              <input type="password" id="regPassword" required placeholder="Create a password">
            </div>
          </div>

          <div class="field">
            <label for="regRole">Select User Role</label>
            <div class="input-wrap">
              <i class="fa-solid fa-truck-field"></i>
              <select id="regRole" required>
                <option value="" selected disabled>Choose role...</option>
                <option value="VENDOR">Vendor / Supplier</option>
                <option value="CUSTOMS_OFFICIAL">Customs Official</option>
                <option value="WAREHOUSE_MANAGER">Warehouse Manager</option>
              </select>
              <i class="fa-solid fa-chevron-down chevron"></i>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn-register">
              Register User <i class="fa-solid fa-arrow-right"></i>
            </button>
            <button type="button" class="btn-cancel">Cancel</button>
            <span class="form-note">MANIFEST-ADMIN · SECURE PROVISIONING</span>
          </div>

        </div>
      </form>
    </div>

  </div>
</div>

</body>
</html>