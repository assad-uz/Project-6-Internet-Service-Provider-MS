<template>

  <div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">

      <TheSidebar />
      <div class="layout-page">
        <TheHeader />
        <div class="content-wrapper">
          <div class="flex-grow-1 container-p-y">

            <div class="card-body">
              <router-view></router-view>
            </div>
          </div>
          <TheFooter />
          <div class="content-backdrop fade"></div>
        </div>
      </div>
    </div>

    <div class="layout-overlay layout-menu-toggle"></div>
  </div>


</template>

<script setup>
import { onMounted } from 'vue';
// Composition API-তে অন্যান্য কম্পোনেন্ট ইম্পোর্ট
import TheSidebar from './layouts/TheSidebar.vue';
import TheHeader from './layouts/TheHeader.vue';
import TheFooter from './layouts/TheFooter.vue';

onMounted(() => {
  // English: Re-initialize Sneat Menu if helpers.js is loaded in index.html
  // এটি নিশ্চিত করে যে Vue কম্পোনেন্ট মাউন্ট হওয়ার পর টেমপ্লেটের JS বাটনগুলোকে চিনতে পারবে
  if (window.Helpers) {
    window.Helpers.init();
    window.Helpers.setAutoUpdate(true);
  }
});
</script>

<style scoped>

</style>