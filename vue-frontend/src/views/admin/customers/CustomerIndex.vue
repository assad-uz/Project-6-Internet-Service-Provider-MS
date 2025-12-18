<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Customer Management</h3>
            <router-link :to="{ name: 'customers.create' }" class="btn btn-primary">
                + Add New Customer
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Name & Phone</th>
                            <th style="width: 25%">Address</th>
                            <th style="width: 15%">Type / Area</th>
                            <th style="width: 10%">Status</th>
                            <th style="width: 10%">Created</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(customer, index) in customers" :key="customer.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>
                                <strong>{{ customer.name }}</strong><br>
                                <small class="text-muted">{{ customer.phone }}</small>
                            </td>
                            <td>{{ truncateText(customer.address, 50) }}</td>
                            <td>
                                <span class="badge bg-info">{{ customer.customer_type?.name || 'N/A' }}</span><br>
                                <small class="text-muted">{{ customer.area?.name || 'N/A' }}</small>
                            </td>
                            <td class="text-center">
                                <span :class="['badge', getStatusClass(customer.status)]">
                                    {{ capitalize(customer.status) }}
                                </span>
                            </td>
                            <td>{{ formatDate(customer.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'customers.edit', params: { id: customer.id } }" 
                                             class="btn btn-warning btn-icon btn-sm"><i class="bx bx-edit text-white"></i></router-link>
                                <button @click="deleteCustomer(customer.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="customers.length === 0">
                            <td colspan="7" class="text-center text-muted">No customers found.</td>
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

const successMessage = ref(null);

// ডামি কাস্টমার ডাটা
const customers = ref([
    {
        id: 1,
        name: 'Rahim Uddin',
        phone: '01712345678',
        address: 'House 12, Road 5, Dhanmondi, Dhaka',
        status: 'active',
        created_at: '2025-01-10T10:00:00Z',
        customer_type: { name: 'Home User' },
        area: { name: 'Dhanmondi' }
    },
    {
        id: 2,
        name: 'Abul Kashem',
        phone: '01987654321',
        address: 'Sector 7, Uttara, Dhaka - 1230',
        status: 'suspended',
        created_at: '2025-02-05T12:30:00Z',
        customer_type: { name: 'Corporate' },
        area: { name: 'Uttara' }
    }
]);

// হেল্পার ফাংশনসমূহ
const truncateText = (text, limit) => {
    return text.length > limit ? text.substring(0, limit) + '...' : text;
};

const getStatusClass = (status) => {
    const classes = {
        active: 'bg-success',
        inactive: 'bg-secondary',
        suspended: 'bg-danger'
    };
    return classes[status] || 'bg-dark';
};

const capitalize = (s) => s.charAt(0).toUpperCase() + s.slice(1);

const formatDate = (dateString) => {
    const options = { day: '2-digit', month: 'short', year: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-GB', options);
};

const deleteCustomer = (id) => {
    if (confirm('Are you sure you want to delete this customer?')) {
        customers.value = customers.value.filter(c => c.id !== id);
        successMessage.value = 'Customer deleted successfully!';
        setTimeout(() => successMessage.value = null, 3000);
    }
};
</script>