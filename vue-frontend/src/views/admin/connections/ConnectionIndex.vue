<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Connection Management</h3>
            <router-link :to="{ name: 'connections.create' }" class="btn btn-primary">
                + Add New Connection
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Customer (Phone)</th>
                            <th style="width: 15%">Username</th>
                            <th style="width: 15%">Package</th>
                            <th style="width: 15%">Box/Port</th>
                            <th style="width: 10%">Type/Date</th>
                            <th style="width: 8%">Status</th>
                            <th style="width: 12%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(connection, index) in connections" :key="connection.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>
                                <strong>{{ connection.customer?.name || 'N/A' }}</strong><br>
                                <small class="text-muted">{{ connection.customer?.phone || '' }}</small>
                            </td>
                            <td>{{ connection.username }}</td>
                            <td>{{ connection.package?.package_name || 'N/A' }}</td>
                            <td>
                                {{ connection.distribution_box?.box_code || 'N/A' }} /
                                {{ connection.box_port_number || 'N/A' }}
                            </td>
                            <td>
                                <span class="badge bg-secondary">{{ connection.connection_type }}</span><br>
                                <small>{{ connection.connection_date }}</small>
                            </td>
                            <td class="text-center">
                                <span :class="['badge', getStatusClass(connection.status)]">
                                    {{ capitalize(connection.status) }}
                                </span>
                            </td>
                            <td class="text-center">
                                <router-link :to="{ name: 'connections.edit', params: { id: connection.id } }"
                                    class="btn btn-warning btn-icon btn-sm"><i
                                        class="bx bx-edit text-white"></i></router-link>
                                <button @click="deleteConnection(connection.id)"
                                    class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="connections.length === 0">
                            <td colspan="8" class="text-center text-muted">No connections found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const successMessage = ref(null);

// ডামি কানেকশন ডাটা
const connections = ref([
    {
        id: 1,
        username: 'rahim_dhaka',
        connection_type: 'PPPoE',
        connection_date: '2025-01-15',
        box_port_number: 'Port-03',
        status: 'active',
        customer: { name: 'Rahim Uddin', phone: '01712345678' },
        package: { package_name: '10 Mbps Standard' },
        distribution_box: { box_code: 'DB-DH-001' }
    },
    {
        id: 2,
        username: 'kashem_ut',
        connection_type: 'Static IP',
        connection_date: '2025-02-10',
        box_port_number: 'Port-08',
        status: 'suspended',
        customer: { name: 'Abul Kashem', phone: '01987654321' },
        package: { package_name: '20 Mbps Premium' },
        distribution_box: { box_code: 'DB-UT-010' }
    }
]);

const getStatusClass = (status) => {
    const classes = {
        active: 'bg-success',
        suspended: 'bg-warning',
        terminated: 'bg-danger'
    };
    return classes[status] || 'bg-dark';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const deleteConnection = (id) => {
    if (confirm('Are you sure you want to delete this connection?')) {
        connections.value = connections.value.filter(c => c.id !== id);
        successMessage.value = 'Connection removed successfully!';
        setTimeout(() => successMessage.value = null, 3000);
    }
};
</script>