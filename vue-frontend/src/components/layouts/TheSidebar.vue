<template>
  <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme shadow-sm custom-sidebar">
    
    <div class="app-brand demo">
      <router-link to="/dashboard" class="app-brand-link">
        <span class="app-brand-logo demo">
          <img src="/admin-src/assets/img/logo/my_logo.png" alt="Logo" style="height: 25px;" />
        </span>
        <span class="app-brand-text demo menu-text fw-bold ms-2">SwiftNet</span>
      </router-link>

      <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none">
        <i class="bx bx-chevron-left bx-sm align-middle"></i>
      </a>
    </div>

    <div class="menu-divider mt-0"></div>
    <div class="menu-inner-shadow"></div>

    <ul class="menu-inner py-1 custom-scroll-area">
      
      <li class="menu-item" :class="{ active: $route.name?.includes('dashboard') }">
        <router-link to="/dashboard" class="menu-link">
          <i class="menu-icon tf-icons bx bx-home-smile"></i>
          <div class="text-truncate">Dashboards</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('users') }">
        <router-link :to="{ name: 'users.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-user"></i>
          <div>User Management</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('customer_types') }">
        <router-link :to="{ name: 'customer_types.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-group"></i>
          <div>Customer Types</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('packages') }">
        <router-link :to="{ name: 'packages.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-list-ul"></i>
          <div>Packages</div>
        </router-link>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">Location</span></li>
      
      <li class="menu-item" :class="{ active: $route.name?.includes('areas') }">
        <router-link :to="{ name: 'areas.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-map"></i>
          <div>Areas</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('distribution_boxes') }">
        <router-link :to="{ name: 'distribution_boxes.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-box"></i>
          <div>Distribution Box</div>
        </router-link>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">Connections</span></li>
      
      <li class="menu-item" :class="{ active: $route.name?.includes('customers') }">
        <router-link :to="{ name: 'customers.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-group"></i>
          <div>Customers</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('connections') }">
        <router-link :to="{ name: 'connections.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-link-alt"></i>
          <div>Connections</div>
        </router-link>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">Billing &amp; Payments</span></li>
      
      <li class="menu-item" :class="{ active: $route.name?.includes('billings') }">
        <router-link :to="{ name: 'billings.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-receipt"></i>
          <div>Billing / Invoices</div>
        </router-link>
      </li>

      <li class="menu-item" :class="{ active: $route.name?.includes('payments') }">
        <router-link :to="{ name: 'payments.index' }" class="menu-link">
          <i class="menu-icon tf-icons bx bx-credit-card-front"></i>
          <div>Payments History</div>
        </router-link>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">Services</span></li>
      
      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link">
          <i class="menu-icon tf-icons bx bx-help-circle"></i>
          <div>Support Tickets</div>
        </a>
      </li>

      <li class="menu-item">
        <a href="javascript:void(0);" class="menu-link">
          <i class="menu-icon tf-icons bx bx-envelope-open"></i>
          <div>Contact Messages</div>
        </a>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">Report</span></li>
      <li class="menu-item" :class="{ active: $route.name?.includes('reports') }">
        <router-link to="/reports" class="menu-link">
          <i class="menu-icon tf-icons bx bx-edit"></i>
          <div>Reports</div>
        </router-link>
      </li>

      <li class="menu-header small text-uppercase"><span class="menu-header-text">MISC</span></li>
      <li class="menu-item">
        <a href="http://127.0.0.1:8000/" target="_blank" class="menu-link">
          <i class="menu-icon tf-icons bx bx-globe"></i>
          <div>Portal</div>
        </a>
      </li>
    </ul>
  </aside>
</template>

<script setup>

</script>

<style scoped>
/* সাইডবারকে পুরো স্ক্রিন জুড়ে রাখার জন্য */
.custom-sidebar {
  height: 100vh !important;
  display: flex;
  flex-direction: column;
}

/* মেনু এরিয়াতে স্ক্রল সচল করার জন্য ফিক্স */
.custom-scroll-area {
  flex: 1;
  overflow-y: auto !important; /* স্ক্রলবার নিয়ে আসবে */
  overflow-x: hidden;
}

/* স্ক্রলবারটি চিকন এবং থিমের সাথে মানানসই করার জন্য */
.custom-scroll-area::-webkit-scrollbar {
  width: 4px;
}
.custom-scroll-area::-webkit-scrollbar-thumb {
  background: #dbade9; 
  border-radius: 10px;
}
/* ১. নিশ্চিত করা যে একটিভ মেনু আইটেমটি তার ইন্ডিকেটরকে নিজের ভেতরে রাখে */
#layout-menu .menu-item.active {
    position: relative !important;
}

#layout-menu .menu-item.active > .menu-link::after {
    content: "";
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    height: 1.9rem; /* আপনার প্রয়োজনমতো ছোট-বড় করতে পারেন */
    width: 0.25rem;
    background-color: #696cff;
    border-radius: 5px 0 0 5px;
}
.menu-vertical .menu-item.active:not(.open) > .menu-link::before {
    display: none !important;
}
</style>