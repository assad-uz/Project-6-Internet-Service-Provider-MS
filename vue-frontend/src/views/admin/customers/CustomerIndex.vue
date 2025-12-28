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
                                <small class="text-muted"><i class="bx bx-phone"></i> {{ customer.phone }}</small>
                            </td>
                            <td>{{ truncateText(customer.address, 50) }}</td>
                            <td>
                                <span class="badge bg-info text-dark">{{ customer.customer_type?.name || 'N/A'
                                    }}</span><br>
                                <small class="text-muted"><i class="bx bx-map"></i> {{ customer.area?.name || 'N/A'
                                    }}</small>
                            </td>
                            <td class="text-center">
                                <span :class="['badge', getStatusClass(customer.status)]">
                                    {{ capitalize(customer.status) }}
                                </span>
                            </td>
                            <td class="text-center">{{ formatDate(customer.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'customers.edit', params: { id: customer.id } }"
                                    class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

                                <button @click="deleteCustomer(customer.id)"
                                    class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="customers.length === 0">
                            <td colspan="7" class="text-center py-4 text-muted">No customers found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js'; // আপনার তৈরি করা axios কনফিগ

const customers = ref([]);
const loading = ref(true);
const successMessage = ref(null);

// এপিআই থেকে কাস্টমার লিস্ট নিয়ে আসা
const fetchCustomers = async () => {
    loading.value = true;
    try {
        const response = await axios.get('customers');
        // লারাভেল কন্ট্রোলার থেকে পাঠানো ডেটা
        customers.value = response.data.data.data; // paginate() ব্যবহার করলে .data.data.data হয়
    } catch (error) {
        console.error("Error fetching customers:", error);
    } finally {
        loading.value = false;
    }
};

// কাস্টমার ডিলিট করা
const deleteCustomer = async (id) => {
    if (confirm('Are you sure you want to delete this customer?')) {
        try {
            const response = await axios.delete(`customers/${id}`);
            if (response.data.success) {
                // লিস্ট থেকে ফিল্টার করে রিমুভ করা (পেজ রিফ্রেশ ছাড়া)
                customers.value = customers.value.filter(c => c.id !== id);
                successMessage.value = 'Customer deleted successfully!';
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            console.error("Delete error:", error);
            alert("Could not delete customer.");
        }
    }
};

// হেল্পার ফাংশনসমূহ
const truncateText = (text, limit) => {
    return text && text.length > limit ? text.substring(0, limit) + '...' : text;
};

const getStatusClass = (status) => {
    const classes = {
        active: 'bg-success',
        inactive: 'bg-secondary',
        suspended: 'bg-danger'
    };
    return classes[status] || 'bg-dark';
};

const capitalize = (s) => s ? s.charAt(0).toUpperCase() + s.slice(1) : '';

const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    const options = { day: '2-digit', month: 'short', year: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-GB', options);
};

// কম্পোনেন্ট মাউন্ট হলে ডেটা লোড হবে
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
}
</style>