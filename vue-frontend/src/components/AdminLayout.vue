<template>
    <div>
        <body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <!-- Menu -->

        <TheSidebar />
        <!-- / Menu -->

        <!-- Layout container -->
        <div class="layout-page">
          <!-- Navbar -->

          <TheHeader />

          <!-- / Navbar -->

          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->
            <div class="flex-grow-1 container-p-y">
                <div className="card-body">
                  <!-- Insert Your content here -->
                  <router-view></router-view>                 
                </div>
              </div>
            <!-- / Content -->

            <!-- Footer -->
            <TheFooter />
            <!-- / Footer -->

            <div class="content-backdrop fade"></div>
          </div>
          <!-- Content wrapper -->
        </div>
        <!-- / Layout page -->
      </div>

      <!-- Overlay -->
      <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <!-- / Layout wrapper -->

    <div class="buy-now">
      <a
        href="https://themeselection.com/item/sneat-dashboard-pro-bootstrap/"
        target="_blank"
        class="btn btn-danger btn-buy-now"
        >Upgrade to Pro</a
      >
    </div>

    <!-- Core JS -->

    <script src="admin-src/assets/vendor/libs/jquery/jquery.js"></script>

    <script src="admin-src/assets/vendor/libs/popper/popper.js"></script>
    <script src="admin-src/assets/vendor/js/bootstrap.js"></script>

    <script src="admin-src/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="admin-src/assets/vendor/js/menu.js"></script>

    <!-- endbuild -->

    <!-- Vendors JS -->
    <script src="admin-src/assets/vendor/libs/apex-charts/apexcharts.js"></script>

    <!-- Main JS -->

    <script src="admin-src/assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="admin-src/assets/js/dashboards-analytics.js"></script>

    <!-- Place this tag before closing body tag for github widget button. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
  </body>
    </div>
</template>

<script setup>
import TheSidebar from './layouts/TheSidebar.vue';
import TheHeader from './layouts/TheHeader.vue';
import TheFooter from './layouts/TheFooter.vue';
</script>

<style scoped>

</style>