// Layout এবং Page কম্পোনেন্ট ইম্পোর্ট করুন
// ধরে নিচ্ছি আপনি @ alias সেট করেননি, তাই সঠিক রিলেটিভ পাথ ব্যবহার করছি
// যদি আপনার @ alias ঠিকমতো কাজ করে, তবে আপনি আপনার কোডটিই ব্যবহার করতে পারেন।

import { createRouter, createWebHistory } from 'vue-router'

// Layout এবং Page কম্পোনেন্ট ইম্পোর্ট করুন
import AdminLayout from '../components/AdminLayout.vue' 
import DashboardPage from '../views/admin/DashboardPage.vue' 

// 🎯 ডামি পেজ তৈরি করা হলো, যেন রুট নেমগুলো কাজ করে
const DummyPage = { template: '<div class="p-4"><h1>{{ $route.name }} - Content coming soon!</h1></div>' }


const routes = [
    {
        path: '/', 
        component: AdminLayout,
        children: [ 
            // ড্যাশবোর্ড (প্যারেন্ট রুট)
            {
                path: '', 
                name: 'Dashboard',
                component: DashboardPage 
            },
            {
                path: 'dashboard', 
                name: 'dashboard', // 'Dashboard' নামের বদলে 'dashboard' ব্যবহার করা ভালো
                component: DashboardPage 
            },

            // TheSidebar.vue এ ব্যবহৃত অন্যান্য রুটগুলি এখানে যুক্ত করা হলো
            // Users
            { path: 'users', name: 'users.index', component: DummyPage },

            // Customer Types
            { path: 'customer_types', name: 'customer_types.index', component: DummyPage },

            // Packages
            { path: 'packages', name: 'packages.index', component: DummyPage },

            // Location
            { path: 'areas', name: 'areas.index', component: DummyPage },
            { path: 'distribution_boxes', name: 'distribution_boxes.index', component: DummyPage },

            // Connections
            { path: 'customers', name: 'customers.index', component: DummyPage },
            { path: 'connections', name: 'connections.index', component: DummyPage },

            // Billing & Payments
            { path: 'billings', name: 'billings.index', component: DummyPage },
            { path: 'payments', name: 'payments.index', component: DummyPage },

            // Services
            { path: 'admin/newsletters', name: 'admin.newsletters.index', component: DummyPage },

            // Report
            { path: 'reports', name: 'reports', component: DummyPage },
            // আপনি যদি ভবিষ্যতে অন্য কোনো রুট নেম ব্যবহার করেন, সেগুলিও এখানে যোগ করতে হবে।
        ]
    },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: routes,
})

export default router;