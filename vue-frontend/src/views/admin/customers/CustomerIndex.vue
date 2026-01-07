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
                            <td class="text-center">{{ index + 1 }}</td>
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
                                <router-link :to="{ name: 'connections.edit', params: { id: connection.id } }"
                                    class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

                                <button @click="deleteConnection(connection.id)"
                                    class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="connections.length === 0">
                            <td colspan="8" class="text-center py-4 text-muted">No connections found.</td>
                        </tr>
                    </tbody>
                </table>
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

const fetchConnections = async () => {
    loading.value = true;
    try {
        const response = await axios.get('connections');
        connections.value = response.data.data.data; 
    } catch (error) {
        console.error("Error fetching connections:", error);
    } finally {
        loading.value = false;
    }
};

const deleteConnection = async (id) => {
    if (confirm('Are you sure you want to delete this connection?')) {
        try {
            const response = await axios.delete(`connections/${id}`);
            if (response.data.success) {
                connections.value = connections.value.filter(c => c.id !== id);
                successMessage.value = 'Connection deleted successfully!';
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            console.error(error);
            alert("Could not delete connection.");
        }
    }
};

const getStatusClass = (status) => {
    const classes = {
        active: 'bg-success',
        suspended: 'bg-danger', // কাস্টমার মডিউল অনুযায়ী কালার
        inactive: 'bg-secondary',
        terminated: 'bg-dark'
    };
    return classes[status] || 'bg-dark';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

onMounted(() => {
    fetchConnections();
});
</script>

<style scoped>
/* কাস্টমার টেবিলের সেইম সিএসএস */
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
}
</style>