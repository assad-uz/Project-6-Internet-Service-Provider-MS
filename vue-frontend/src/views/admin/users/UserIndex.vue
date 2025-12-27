<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success alert-dismissible fade show">
            {{ successMessage }}
            <button type="button" class="btn-close" @click="successMessage = null"></button>
        </div>

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
                        <tr v-if="loading">
                            <td colspan="8" class="text-center py-4">Loading users...</td>
                        </tr>

                        <tr v-for="(user, index) in users" :key="user.id" v-else>
                            <td class="text-center">{{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}</td> 

                            <td class="text-center">
                                <template v-if="user.avatar">
                                    <img :src="getImageUrl(user.avatar)" :alt="user.name + ' Avatar'" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                                </template>
                                <template v-else>
                                    <span class="text-muted">N/A</span>
                                </template>
                            </td>

                            <td>{{ user.name }}</td>
                            <td>{{ user.email }}</td>
                            <td>{{ user.phone ?? 'N/A' }}</td>
                            
                            <td class="text-center">
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
                                <router-link :to="{ name: 'users.edit', params: { id: user.id } }" class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

                                <button @click="deleteUser(user.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="!loading && users.length === 0">
                            <td colspan="8" class="text-center text-muted py-4">No users found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div v-if="pagination.last_page > 1" class="d-flex justify-content-center mt-3">
            <nav>
                <ul class="pagination">
                    <li class="page-item" :class="{ disabled: pagination.current_page === 1 }">
                        <button class="page-link" @click="fetchUsers(pagination.current_page - 1)">Previous</button>
                    </li>
                    <li class="page-item active">
                        <span class="page-link">{{ pagination.current_page }}</span>
                    </li>
                    <li class="page-item" :class="{ disabled: pagination.current_page === pagination.last_page }">
                        <button class="page-link" @click="fetchUsers(pagination.current_page + 1)">Next</button>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js';

const users = ref([]);
const pagination = ref({
    current_page: 1,
    last_page: 1,
    per_page: 10
});
const loading = ref(true);
const successMessage = ref(null);

// এপিআই থেকে ডেটা আনা
const fetchUsers = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axios.get(`users?page=${page}`);
        if (response.data.success) {
            users.value = response.data.data.data; // লারাভেল প্যাগিনেটেড ডেটা
            pagination.value = {
                current_page: response.data.data.current_page,
                last_page: response.data.data.last_page,
                per_page: response.data.data.per_page
            };
        }
    } catch (error) {
        console.error("Error fetching users:", error);
    } finally {
        loading.value = false;
    }
};

// ইমেজের ফুল পাথ
const getImageUrl = (path) => {
    return `http://localhost:8000/storage/${path}`;
};

const capitalize = (str) => {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1);
};

const getRoleBadgeClass = (role) => {
    switch (role) {
        case 'admin': return 'bg-danger';
        case 'manager': return 'bg-warning text-dark';
        case 'technician': return 'bg-info';
        default: return 'bg-secondary';
    }
};

const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

const timeAgo = (isoDate) => {
    if (!isoDate) return '';
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

const deleteUser = async (userId) => {
    if (confirm('Are you sure you want to delete this user?')) {
        try {
            const response = await axios.delete(`users/${userId}`);
            if (response.data.success) {
                successMessage.value = response.data.message;
                fetchUsers(pagination.value.current_page);
                setTimeout(() => { successMessage.value = null; }, 3000);
            }
        } catch (error) {
            console.error("Error deleting user:", error);
        }
    }
};

onMounted(() => {
    fetchUsers();
});
</script>