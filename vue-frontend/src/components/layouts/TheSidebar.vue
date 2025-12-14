<template>
    <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
        <div class="app-brand demo">
            
            <router-link to="/" class="app-brand-link"> 
                <span class="app-brand-logo demo">
                    <img 
                        src="/admin-src/assets/img/logo/my_logo.png" 
                        alt="My Company Logo" 
                        class="w-auto h-auto" 
                        style="height: 25px;"
                    />
                </span>
                <span class="app-brand-text demo menu-text fw-bold ms-2">SwiftNet</span>
            </router-link>

            <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto">
                <i class="bx bx-chevron-left d-block d-xl-none align-middle"></i>
            </a>
        </div>

        <div class="menu-divider mt-0"></div>

        <div class="menu-inner-shadow"></div>

        <ul class="menu-inner py-1">
            <li class="menu-item"> 
                <router-link to="/dashboard" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-home-smile"></i>
                    <div class="text-truncate" data-i18n="Dashboards">Dashboards</div>
                </router-link>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'users.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-user"></i>
                    <div class="text-truncate" data-i18n="Layouts">Users</div>
                </router-link>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'customer_types.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-user-pin"></i> 
                    <div class="text-truncate" data-i18n="Customer Types">Customer Types</div>
                </router-link>
            </li>
            
            <li class="menu-item">
                <router-link :to="{ name: 'packages.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-list-ul"></i>
                    <div class="text-truncate" data-i18n="Layouts">Packages</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase"><span class="menu-header-text">Location</span></li>
            <li class="menu-item">
                <router-link :to="{ name: 'areas.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-bullseye"></i> <div class="text-truncate" data-i18n="Areas">Areas</div>
                </router-link>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'distribution_boxes.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-box"></i> <div class="text-truncate" data-i18n="Distribution Box">Distribution Box</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase"><span class="menu-header-text">Connections</span></li>
            <li class="menu-item">
                <router-link :to="{ name: 'customers.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-user-plus"></i> 
                    <div class="text-truncate" data-i18n="Customers">Customers</div>
                </router-link>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'connections.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-globe"></i> 
                    <div class="text-truncate" data-i18n="Connections">Connections</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase"><span class="menu-header-text">Billing &amp; Payments</span></li>
            <li class="menu-item">
                <router-link :to="{ name: 'billings.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-credit-card"></i> 
                    <div class="text-truncate" data-i18n="Billings">Billings</div>
                </router-link>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'payments.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-wallet"></i> 
                    <div class="text-truncate" data-i18n="Payments">Payments</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase"><span class="menu-header-text">Services</span></li>
            <li class="menu-item">
                <a href="javascript:void(0);" class="menu-link"> 
                    <i class="menu-icon tf-icons bx bx-help-circle"></i>
                    <div class="text-truncate" data-i18n="Layouts">Support Tickets</div>
                </a>
            </li>

            <li class="menu-item">
                <a href="javascript:void(0);" class="menu-link"> 
                    <i class="menu-icon tf-icons bx bx-envelope-open"></i>
                    <div class="text-truncate" data-i18n="Layouts">Contact Messages</div>
                </a>
            </li>

            <li class="menu-item">
                <router-link :to="{ name: 'admin.newsletters.index' }" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-notification"></i>
                    <div class="text-truncate" data-i18n="Layouts">Newsletter Subscribers</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase"><span class="menu-header-text">Report</span></li>
            <li class="menu-item">
                <router-link to="/reports" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-edit"></i>
                    <div class="text-truncate" data-i18n="Layouts">Reports</div>
                </router-link>
            </li>

            <li class="menu-header small text-uppercase">
                <span class="menu-header-text">MISC</span>
            </li>

            <li class="menu-item">
                <a href="http://127.0.0.1:8000/" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-globe"></i>
                    <div class="text-truncate" data-i18n="Layouts">Portal</div>
                </a>
            </li>
        </ul>
    </aside>
</template>

<script setup>
// Vue Router-এর Active Class এর জন্য সাধারণত কোনো অতিরিক্ত লজিক লাগে না।
</script>

<style scoped>
/*
    Vue Router স্বয়ংক্রিয়ভাবে সক্রিয় (active) মেনু আইটেমের parent <li>-তে 
    "router-link-active" অথবা "router-link-exact-active" ক্লাস যুক্ত করবে।
    আপনার CSS সেই ক্লাসটি ব্যবহার করে সক্রিয় আইটেমকে হাইলাইট করবে।
*/
</style>