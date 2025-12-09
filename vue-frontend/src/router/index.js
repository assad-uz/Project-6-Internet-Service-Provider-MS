
import { createRouter, createWebHistory } from 'vue-router'

// Layout এবং Page কম্পোনেন্ট ইম্পোর্ট করুন
// ধরে নিচ্ছি আপনি @ alias সেট করেননি, তাই সঠিক রিলেটিভ পাথ ব্যবহার করছি
// যদি আপনার @ alias ঠিকমতো কাজ করে, তবে আপনি আপনার কোডটিই ব্যবহার করতে পারেন।

import AdminLayout from '../components/AdminLayout.vue' 
import DashboardPage from '../views/admin/DashboardPage.vue' 

const routes = [
    {
        path: '/', 
        component: AdminLayout, // <-- ১. রুট পাথে AdminLayout কে লোড করুন 
        children: [ // <-- ২. কন্টেন্টগুলিকে AdminLayout এর children হিসেবে সেট করুন
            {
                path: '', //  এটি '/' পাথকেই নির্দেশ করে
                name: 'Dashboard',
                component: DashboardPage // <-- DashboardPage এখন AdminLayout এর router-view তে লোড হবে
            },
        ]
    },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: routes, // <-- সংশোধিত routes অ্যারেটি ব্যবহার করা হলো
})

export default router;