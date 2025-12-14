<template>
  <footer class="content-footer footer bg-footer-theme">
    <div class="container-xxl">
      <div class="footer-container d-flex align-items-center justify-content-between py-4 flex-md-row flex-column">
        <div class="mb-2 mb-md-0">
          &#169; {{ currentYear }}, developed by
          <a href="https://linkedin.com/in/assad-uz/" target="_blank" class="footer-link">ASSADUZZAMAN SHAON</a>
        </div>
        <div class="d-none d-lg-inline-block">
          <a href="https://demos.themeselection.com/sneat-bootstrap-html-admin-template/documentation/" target="_blank"
            class="footer-link me-4">Documentation</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue';

// বর্তমান বছর স্বয়ংক্রিয়ভাবে দেখানোর জন্য computed property
const currentYear = computed(() => {
  return new Date().getFullYear();
});
</script>

<style scoped>
/* এই কম্পোনেন্টের জন্য নির্দিষ্ট কোনো CSS থাকলে এখানে লিখুন */
</style>