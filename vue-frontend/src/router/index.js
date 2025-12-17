import { createRouter, createWebHistory } from 'vue-router'

// Layout এবং Page কম্পোনেন্ট ইম্পোর্ট করুন
import AdminLayout from '../components/AdminLayout.vue'
import DashboardPage from '../views/admin/DashboardPage.vue'

// users
import UserIndex from '../views/admin/users/UserIndex.vue'
import UserCreate from '../views/admin/users/UserCreate.vue'
import UserEdit from '../views/admin/users/UserEdit.vue'

// customer_types
import CustomerTypeIndex from '../views/admin/customer_types/CustomerTypeIndex.vue'
import CustomerTypeCreate from '../views/admin/customer_types/CustomerTypeCreate.vue'
import CustomerTypeEdit from '../views/admin/customer_types/CustomerTypeEdit.vue'

// packages
import PackageIndex from '../views/admin/packages/PackageIndex.vue'
import PackageCreate from '../views/admin/packages/PackageCreate.vue'
import PackageEdit from '../views/admin/packages/PackageEdit.vue'

// areas
import AreaIndex from '../views/admin/areas/AreaIndex.vue'
import AreaCreate from '../views/admin/areas/AreaCreate.vue'
import AreaEdit from '../views/admin/areas/AreaEdit.vue'

// distribution_boxes
import BoxIndex from '../views/admin/distribution_boxes/BoxIndex.vue'
import BoxCreate from '../views/admin/distribution_boxes/BoxCreate.vue'
import BoxEdit from '../views/admin/distribution_boxes/BoxEdit.vue'

// customers
import CustomerIndex from '../views/admin/customers/CustomerIndex.vue'
import CustomerCreate from '../views/admin/customers/CustomerCreate.vue'
import CustomerEdit from '../views/admin/customers/CustomerEdit.vue'


// 💡 রানটাইম এরর এড়াতে DummyPage কে একটি ফাংশনাল কম্পোনেন্ট হিসেবে তৈরি করা হলো (template ছাড়া)
// const DummyPage = {
//     render() {
//         return h('div', { class: 'p-4' }, [
//             h('h1', 'Content coming soon for this page!')
//         ])
//     }
// }
// দ্রষ্টব্য: উপরের render ফাংশন ঝামেলা মনে হলে নিচের রুটগুলোতে সরাসরি component: DashboardPage দিয়ে রাখতে পারেন সাময়িকভাবে।

const routes = [
    {
        path: '/',
        component: AdminLayout,
        children: [
            // Dashboard
            { path: '', name: 'Dashboard', component: DashboardPage },
            { path: 'dashboard', name: 'dashboard', component: DashboardPage },

            // Users
            { path: 'users', name: 'users.index', component: UserIndex },
            { path: 'users/create', name: 'users.create', component: UserCreate },
            { path: 'users/:id/edit', name: 'users.edit', component: UserEdit },

            // Customer Types
            { path: 'customer_types', name: 'customer_types.index', component: CustomerTypeIndex },
            { path: 'customer_types/create', name: 'customer_types.create', component: CustomerTypeCreate },
            { path: 'customer_types/:id/edit', name: 'customer_types.edit', component: CustomerTypeEdit },

            // Packages
            { path: 'packages', name: 'packages.index', component: PackageIndex },
            { path: 'packages/create', name: 'packages.create', component: PackageCreate },
            { path: 'packages/:id/edit', name: 'packages.edit', component: PackageEdit },

            // Areas
            { path: 'areas', name: 'areas.index', component: AreaIndex },
            { path: 'areas/create', name: 'areas.create', component: AreaCreate },
            { path: 'areas/:id/edit', name: 'areas.edit', component: AreaEdit },

            // Distribution Boxes
            { path: 'distribution_boxes', name: 'distribution_boxes.index', component: BoxIndex }, 
{ path: 'distribution_boxes/create', name: 'distribution_boxes.create', component: BoxCreate }, 
{ path: 'distribution_boxes/:id/edit', name: 'distribution_boxes.edit', component: BoxEdit },

            // Customers
            { path: 'customers', name: 'customers.index', component: CustomerIndex },
            { path: 'customers/create', name: 'customers.create', component: CustomerCreate },
            { path: 'customers/:id/edit', name: 'customers.edit', component: CustomerEdit },

            // বাকি রুটগুলো (যেগুলো এখনও তৈরি হয়নি, সেগুলোতে DashboardPage দিয়ে রাখছি এরর এড়াতে)
            { path: 'connections', name: 'connections.index', component: DashboardPage },
            { path: 'billings', name: 'billings.index', component: DashboardPage },
            { path: 'payments', name: 'payments.index', component: DashboardPage },
            { path: 'admin/newsletters', name: 'admin.newsletters.index', component: DashboardPage },
            { path: 'reports', name: 'reports', component: DashboardPage },
        ],
    },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: routes,
})

export default router