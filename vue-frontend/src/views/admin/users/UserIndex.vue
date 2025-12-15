<template>
    <div class="container mt-4">

        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">User Management</h3>
            
            <router-link :to="{ name: 'users.create' }" class="btn btn-primary">
                + Create New User
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 8%">Avatar</th>
                            <th style="width: 15%">Name</th>
                            <th style="width: 20%">Email</th>
                            <th style="width: 10%">Phone</th>
                            <th style="width: 10%">Role</th>
                            <th style="width: 14%">Last Login</th>
                            <th style="width: 10%">Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr v-for="(user, index) in users" :key="user.id">
                            <td class="text-center">{{ index + 1 }}</td> 

                            <td class="text-center">
                                <template v-if="user.avatar_url">
                                    <img :src="user.avatar_url" :alt="user.name + ' Avatar'" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                                </template>
                                <template v-else>
                                    <span class="text-muted">N/A</span>
                                </template>
                            </td>

                            <td>{{ user.name }}</td>
                            <td>{{ user.email }}</td>
                            
                            <td>{{ user.phone ?? 'N/A' }}</td>
                            
                            <td>
                                <span :class="getRoleBadgeClass(user.role)" class="badge">{{ capitalize(user.role) }}</span>
                            </td>

                            <td>
                                <template v-if="user.last_login_at">
                                    {{ timeAgo(user.last_login_at) }}
                                    <small class="text-muted d-block">{{ formatDate(user.last_login_at) }}</small>
                                </template>
                                <template v-else>
                                    <span class="text-muted">Never</span>
                                </template>
                            </td>
                            
                            <td class="text-center">
                                <router-link :to="{ name: 'users.edit', params: { id: user.id } }" class="btn btn-warning btn-icon btn-sm"><i class="bx bx-edit text-white"></i></router-link>

                                <button @click="deleteUser(user.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="users.length === 0">
                            <td colspan="8" class="text-center text-muted">No users found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="d-flex justify-content-center mt-3">
            </div>

    </div>
</template>

<script setup>
import { ref } from 'vue';

// --- ডামি ডেটা ---
const users = ref([
    { id: 1, name: 'Admin User', email: 'admin@example.com', phone: '01711223344', role: 'admin', avatar_url: 'https://i.pravatar.cc/150?img=1', last_login_at: '2025-12-14T10:00:00Z' },
    { id: 2, name: 'Manager Doe', email: 'manager@example.com', phone: '01811223344', role: 'manager', avatar_url: null, last_login_at: '2025-12-10T08:30:00Z' },
    { id: 3, name: 'Staff Smith', email: 'staff@example.com', phone: '01911223344', role: 'staff', avatar_url: 'https://i.pravatar.cc/150?img=3', last_login_at: '2025-11-20T15:45:00Z' },
    { id: 4, name: 'Viewer Jones', email: 'viewer@example.com', phone: null, role: 'viewer', avatar_url: 'https://i.pravatar.cc/150?img=4', last_login_at: null },
]);

const successMessage = ref(null); // 'User deleted successfully!' অথবা null হবে

// --- মেথড এবং লজিক ---

// Blade-এর ucfirst() ফাংশন প্রতিস্থাপন
const capitalize = (str) => {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1);
};

// Role অনুসারে বুটস্ট্র্যাপ ব্যাজ ক্লাস নির্ধারণ
const getRoleBadgeClass = (role) => {
    switch (role) {
        case 'admin':
            return 'bg-danger';
        case 'manager':
            return 'bg-warning text-dark';
        case 'staff':
            return 'bg-info';
        default:
            return 'bg-secondary';
    }
};

// Date Formatting (Moment.js এর বদলে JS Date অবজেক্ট ব্যবহার)
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    // Simple date formatting (d M Y)
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// diffForHumans() ফাংশন প্রতিস্থাপন
const timeAgo = (isoDate) => {
    if (!isoDate) return '';
    // এটি একটি সরলীকৃত বাস্তবায়ন
    const seconds = Math.floor((new Date() - new Date(isoDate)) / 1000);
    let interval = seconds / 31536000;
    if (interval > 1) return Math.floor(interval) + " years ago";
    interval = seconds / 2592000;
    if (interval > 1) return Math.floor(interval) + " months ago";
    interval = seconds / 86400;
    if (interval > 1) return Math.floor(interval) + " days ago";
    interval = seconds / 3600;
    if (interval > 1) return Math.floor(interval) + " hours ago";
    interval = seconds / 60;
    if (interval > 1) return Math.floor(interval) + " minutes ago";
    return Math.floor(seconds) + " seconds ago";
};

// Delete লজিক (এটি পরে API কল করবে)
const deleteUser = (userId) => {
    if (confirm('Are you sure you want to delete this user?')) {
        // 🎯 পরে: এখানে Axios.delete কল করা হবে
        console.log(`Deleting user with ID: ${userId}`);
        
        // ডামি রিমুভাল
        users.value = users.value.filter(u => u.id !== userId);
        successMessage.value = 'User deleted successfully!';
        setTimeout(() => { successMessage.value = null; }, 3000);
    }
};

// যখন কম্পোনেন্ট মাউন্ট হবে, তখন ডেটা আনার জন্য লজিক (পরে API কল হবে)
// import { onMounted } from 'vue';
// onMounted(() => {
//     fetchUsers(); // API কল ফাংশন
// });
</script>

<style scoped>
/*
যদি আপনার টেমপ্লেটের জন্য কোনো নির্দিষ্ট CSS থাকে,
তাহলে এখানে বা গ্লোবাল CSS ফাইলে যোগ করুন।
*/
</style>