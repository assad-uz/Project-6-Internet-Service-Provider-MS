<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success alert-dismissible fade show">
            {{ successMessage }}
            <button type="button" class="btn-close" @click="successMessage = null"></button>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Connection Management</h3>
            <router-link :to="{ name: 'connections.create' }" class="btn btn-primary shadow-sm">
                <i class="bx bx-plus"></i> Add New Connection
            </router-link>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 5%">#</th>
                                <th style="width: 20%">Customer (Phone)</th>
                                <th style="width: 15%">Username</th>
                                <th style="width: 15%">Package</th>
                                <th style="width: 15%">Box/Port</th>
                                <th style="width: 12%">Type/Date</th>
                                <th class="text-center" style="width: 8%">Status</th>
                                <th class="text-center" style="width: 10%">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="loading">
                                <td colspan="8" class="text-center py-5">
                                    <div class="spinner-border text-primary" role="status"></div>
                                    <p class="mt-2 text-muted">Loading connections...</p>
                                </td>
                            </tr>

                            <tr v-for="(connection, index) in connections" :key="connection.id" v-else>
                                <td class="text-center">{{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}</td>
                                <td>
                                    <div class="fw-bold text-dark">{{ connection.customer?.name || 'N/A' }}</div>
                                    <small class="text-muted"><i class="bx bx-phone"></i> {{ connection.customer?.phone || '' }}</small>
                                </td>
                                <td><code class="text-primary fw-bold">{{ connection.username }}</code></td>
                                <td>
                                    <span class="text-dark">{{ connection.package?.package_name || 'N/A' }}</span>
                                </td>
                                <td>
                                    <div class="badge bg-light text-dark border">
                                        {{ connection.distribution_box?.box_code || 'N/A' }}
                                    </div>
                                    <div class="small text-muted mt-1">Port: {{ connection.box_port_number || 'N/A' }}</div>
                                </td>
                                <td>
                                    <span class="badge bg-info text-white small">{{ connection.connection_type }}</span><br>
                                    <small class="text-muted">{{ formatDate(connection.connection_date) }}</small>
                                </td>
                                <td class="text-center">
                                    <span :class="['badge', getStatusClass(connection.status)]">
                                        {{ capitalize(connection.status) }}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <router-link :to="{ name: 'connections.edit', params: { id: connection.id } }"
                                            class="btn btn-outline-warning btn-sm">
                                            <i class="bx bx-edit-alt"></i>
                                        </router-link>
                                        <button @click="confirmDelete(connection.id)"
                                            class="btn btn-outline-danger btn-sm">
                                            <i class="bx bx-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <tr v-if="!loading && connections.length === 0">
                                <td colspan="8" class="text-center py-5 text-muted">No connections found.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="card-footer bg-white border-top py-3" v-if="pagination.last_page > 1">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item" :class="{ disabled: !pagination.prev_page_url }">
                            <button class="page-link" @click="fetchConnections(pagination.current_page - 1)">Previous</button>
                        </li>
                        <li v-for="page in pagination.last_page" :key="page" class="page-item" :class="{ active: page === pagination.current_page }">
                            <button class="page-link" @click="fetchConnections(page)">{{ page }}</button>
                        </li>
                        <li class="page-item" :class="{ disabled: !pagination.next_page_url }">
                            <button class="page-link" @click="fetchConnections(pagination.current_page + 1)">Next</button>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js';

const connections = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const pagination = ref({});

// এপিআই থেকে ডাটা আনা
const fetchConnections = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axios.get(`connections?page=${page}`);
        if (response.data.success) {
            connections.value = response.data.data.data; // Paginated data
            pagination.value = {
                current_page: response.data.data.current_page,
                last_page: response.data.data.last_page,
                prev_page_url: response.data.data.prev_page_url,
                next_page_url: response.data.data.next_page_url,
                per_page: response.data.data.per_page,
            };
        }
    } catch (error) {
        console.error("Error fetching connections:", error);
    } finally {
        loading.value = false;
    }
};

const getStatusClass = (status) => {
    const classes = {
        active: 'bg-success',
        suspended: 'bg-warning text-dark',
        terminated: 'bg-danger'
    };
    return classes[status] || 'bg-secondary';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const formatDate = (dateStr) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-GB'); // DD/MM/YYYY
};

const confirmDelete = async (id) => {
    if (confirm('Are you sure you want to delete this connection? This action cannot be undone.')) {
        try {
            const response = await axios.delete(`connections/${id}`);
            if (response.data.success) {
                successMessage.value = 'Connection deleted successfully!';
                fetchConnections(pagination.value.current_page);
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            alert('Error deleting connection!');
        }
    }
};

onMounted(() => {
    fetchConnections();
});
</script>

<style scoped>
.btn-icon { width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; }
.table th { font-size: 0.85rem; letter-spacing: 0.5px; text-transform: uppercase; }
.badge { font-weight: 500; padding: 0.5em 0.8em; }
</style>