<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
            {{ successMessage }}
            <button type="button" class="btn-close" @click="successMessage = null"></button>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Customer Management</h3>
            <router-link :to="{ name: 'customers.create' }" class="btn btn-primary shadow-sm">
                <i class="bx bx-plus"></i> Add New Customer
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div v-if="loading" class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Fetching customers...</p>
            </div>

            <div v-else class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark text-center">
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 20%" class="text-start">Name & Phone</th>
                            <th style="width: 25%" class="text-start">Address</th>
                            <th style="width: 15%">Type / Area</th>
                            <th style="width: 10%">Status</th>
                            <th style="width: 10%">Created</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(customer, index) in customers" :key="customer.id">
                            <td class="text-center">
                                {{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}
                            </td>
                            <td class="text-start">
                                <strong>{{ customer.name }}</strong><br>
                                <small class="text-muted"><i class="bx bx-phone"></i> {{ customer.phone }}</small>
                            </td>
                            <td class="text-start">
                                <div class="text-truncate" style="max-width: 200px;">
                                    {{ customer.address }}
                                </div>
                            </td>
                            <td class="text-center">
                                <span class="badge bg-info text-dark mb-1">{{ customer.customer_type?.name || 'N/A' }}</span><br>
                                <small class="text-muted">{{ customer.area?.name || 'N/A' }}</small>
                            </td>
                            <td class="text-center">
                                <span :class="['badge', getStatusClass(customer.status)]">
                                    {{ capitalize(customer.status) }}
                                </span>
                            </td>
                            <td class="text-center small text-muted">
                                {{ formatDate(customer.created_at) }}
                            </td>
                            <td class="text-center">
                                <div class="btn-group">
                                    <router-link :to="{ name: 'customers.edit', params: { id: customer.id } }"
                                        class="btn btn-warning btn-icon btn-sm">
                                        <i class="bx bx-edit text-white"></i>
                                    </router-link>

                                    <button @click="deleteCustomer(customer.id)"
                                        class="btn btn-danger btn-icon btn-sm ms-1">
                                        <i class="bx bx-trash text-white"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr v-if="customers.length === 0">
                            <td colspan="7" class="text-center py-4 text-muted">No customers found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mt-3" v-if="pagination.last_page > 1">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item" :class="{ disabled: pagination.current_page === 1 }">
                            <button class="page-link" @click="fetchCustomers(pagination.current_page - 1)">Previous</button>
                        </li>
                        <li v-for="page in pagination.last_page" :key="page" class="page-item" :class="{ active: pagination.current_page === page }">
                            <button class="page-link" @click="fetchCustomers(page)">{{ page }}</button>
                        </li>
                        <li class="page-item" :class="{ disabled: pagination.current_page === pagination.last_page }">
                            <button class="page-link" @click="fetchCustomers(pagination.current_page + 1)">Next</button>
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

const customers = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const pagination = ref({
    current_page: 1,
    per_page: 10,
    last_page: 1
});

const fetchCustomers = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axios.get(`customers?page=${page}`);
        if (response.data.success) {
            customers.value = response.data.data.data;
            pagination.value = response.data.data;
        }
    } catch (error) {
        console.error("Error fetching customers:", error);
    } finally {
        loading.value = false;
    }
};

const getStatusClass = (status) => {
    const mapping = {
        active: 'bg-success',
        inactive: 'bg-secondary',
        suspended: 'bg-danger'
    };
    return mapping[status.toLowerCase()] || 'bg-dark';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const deleteCustomer = async (id) => {
    if (confirm('Are you sure you want to delete this customer?')) {
        try {
            const response = await axios.delete(`customers/${id}`);
            if (response.data.success) {
                successMessage.value = "Customer deleted successfully.";
                fetchCustomers(pagination.value.current_page);
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            console.error(error);
            alert("Failed to delete customer.");
        }
    }
};

const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

onMounted(() => {
    fetchCustomers();
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
}
.badge {
    font-weight: 500;
    padding: 0.5em 0.8em;
}
.table th {
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
</style>