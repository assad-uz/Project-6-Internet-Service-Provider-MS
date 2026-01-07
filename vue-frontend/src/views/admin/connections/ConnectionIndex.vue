<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
            {{ successMessage }}
            <button type="button" class="btn-close" @click="successMessage = null"></button>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Connection Management</h3>
            <router-link :to="{ name: 'connections.create' }" class="btn btn-primary shadow-sm">
                <i class="bx bx-plus"></i> Add New Connection
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div v-if="loading" class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Fetching connections...</p>
            </div>

            <div v-else class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark text-center">
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Customer & Phone</th>
                            <th style="width: 15%">Username</th>
                            <th style="width: 15%">Package</th>
                            <th style="width: 15%">Box / Port</th>
                            <th style="width: 12%">Type / Date</th>
                            <th style="width: 8%">Status</th>
                            <th style="width: 10%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(connection, index) in connections" :key="connection.id">
                            <td class="text-center">
                                {{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}
                            </td>
                            <td>
                                <strong>{{ connection.customer?.name || 'N/A' }}</strong><br>
                                <small class="text-muted"><i class="bx bx-phone"></i> {{ connection.customer?.phone || '' }}</small>
                            </td>
                            <td class="text-center">
                                <strong>{{ connection.username }}</strong>
                            </td>
                            <td>
                                {{ connection.package?.package_name || 'N/A' }}<br>
                                <small class="text-success fw-bold">{{ connection.package?.price || 0 }} TK</small>
                            </td>
                            <td>
                                <i class="bx bx-box text-muted"></i> {{ connection.distribution_box?.box_code || 'N/A' }}<br>
                                <small class="text-muted">Port: {{ connection.box_port_number || 'N/A' }}</small>
                            </td>
                            <td class="text-center">
                                <span class="badge bg-info text-dark">{{ connection.connection_type }}</span><br>
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
                                        class="btn btn-warning btn-icon btn-sm">
                                        <i class="bx bx-edit text-white"></i>
                                    </router-link>

                                    <button @click="confirmDelete(connection.id)"
                                        class="btn btn-danger btn-icon btn-sm ms-1">
                                        <i class="bx bx-trash text-white"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr v-if="connections.length === 0">
                            <td colspan="8" class="text-center py-4 text-muted">No connections found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mt-3" v-if="pagination.last_page > 1">
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
const pagination = ref({
    current_page: 1,
    per_page: 10,
    last_page: 1
});

const fetchConnections = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axios.get(`connections?page=${page}`);
        if (response.data.success) {
            connections.value = response.data.data.data;
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
        suspended: 'bg-danger',
        inactive: 'bg-secondary',
        terminated: 'bg-dark'
    };
    return classes[status] || 'bg-dark';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const formatDate = (dateStr) => {
    if (!dateStr) return 'N/A';
    return new Date(dateStr).toLocaleDateString('en-GB', { 
        day: '2-digit', 
        month: 'short', 
        year: 'numeric' 
    });
};

const confirmDelete = async (id) => {
    if (confirm('Are you sure you want to delete this connection?')) {
        try {
            const response = await axios.delete(`connections/${id}`);
            if (response.data.success) {
                successMessage.value = 'Connection deleted successfully!';
                fetchConnections(pagination.value.current_page);
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            console.error("Error deleting:", error);
            alert('Error deleting connection!');
        }
    }
};

onMounted(() => {
    fetchConnections();
});
</script>

<style scoped>
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
    width: 32px;
    height: 32px;
}
.table-dark {
    background-color: #343a40;
    border-color: #454d55;
}
.badge {
    font-weight: 500;
    padding: 0.5em 0.8em;
}
</style>