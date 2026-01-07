<template>
    <div class="container mt-4">
        <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
            {{ successMessage }}
            <button type="button" class="btn-close" @click="successMessage = null"></button>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Payment Management</h3>
            <router-link :to="{ name: 'payments.create' }" class="btn btn-primary shadow-sm">
                <i class="bx bx-plus"></i> Record New Payment
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div v-if="loading" class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Fetching payment records...</p>
            </div>

            <div v-else class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark text-center">
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 15%">Date</th>
                            <th style="width: 25%" class="text-start">Customer & Bill Month</th>
                            <th style="width: 15%">Amount</th>
                            <th style="width: 15%">Method / Txn ID</th>
                            <th style="width: 15%">Collected By</th>
                            <th style="width: 10%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(payment, index) in payments" :key="payment.id">
                            <td class="text-center">
                                {{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}
                            </td>
                            <td class="text-center">
                                <strong>{{ formatDate(payment.payment_date) }}</strong>
                            </td>
                            <td>
                                <strong>{{ payment.customer?.name || 'N/A' }}</strong><br>
                                <small class="text-primary fw-bold">
                                    Bill: {{ formatMonth(payment.billing?.billing_month) }}
                                </small>
                            </td>
                            <td class="text-center">
                                <span class="text-success fw-bold">৳ {{ formatNumber(payment.amount) }}</span>
                            </td>
                            <td class="text-center">
                                <span :class="['badge', getMethodClass(payment.payment_method)]">
                                    {{ payment.payment_method.toUpperCase() }}
                                </span><br>
                                <small class="text-muted font-monospace">{{ payment.transaction_id || 'N/A' }}</small>
                            </td>
                            <td class="text-center">
                                <small><i class="bx bx-user-circle"></i> {{ payment.collector?.name || 'N/A' }}</small>
                            </td>
                            <td class="text-center">
                                <div class="btn-group">
                                    <router-link :to="{ name: 'payments.edit', params: { id: payment.id } }"
                                        class="btn btn-warning btn-icon btn-sm me-1">
                                        <i class="bx bx-edit text-white"></i>
                                    </router-link>

                                    <button @click="confirmDelete(payment.id)" class="btn btn-danger btn-icon btn-sm">
                                        <i class="bx bx-trash text-white"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr v-if="payments.length === 0">
                            <td colspan="7" class="text-center py-4 text-muted">No payment records found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mt-3" v-if="pagination.last_page > 1">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item" :class="{ disabled: !pagination.prev_page_url }">
                            <button class="page-link"
                                @click="fetchPayments(pagination.current_page - 1)">Previous</button>
                        </li>
                        <li v-for="page in pagination.last_page" :key="page" class="page-item"
                            :class="{ active: page === pagination.current_page }">
                            <button class="page-link" @click="fetchPayments(page)">{{ page }}</button>
                        </li>
                        <li class="page-item" :class="{ disabled: !pagination.next_page_url }">
                            <button class="page-link" @click="fetchPayments(pagination.current_page + 1)">Next</button>
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

const payments = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const pagination = ref({
    current_page: 1,
    per_page: 10,
    last_page: 1
});

const fetchPayments = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axios.get(`payments?page=${page}`);
        if (response.data.success) {
            payments.value = response.data.data.data;
            pagination.value = {
                current_page: response.data.data.current_page,
                last_page: response.data.data.last_page,
                prev_page_url: response.data.data.prev_page_url,
                next_page_url: response.data.data.next_page_url,
                per_page: response.data.data.per_page,
            };
        }
    } catch (error) {
        console.error("Error fetching payments:", error);
    } finally {
        loading.value = false;
    }
};

const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleDateString('en-GB'); // DD/MM/YYYY
};

const formatMonth = (dateString) => {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
};

const formatNumber = (num) => {
    return parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2 });
};

const getMethodClass = (method) => {
    const mapping = {
        cash: 'bg-success',
        bkash: 'bg-danger',
        card: 'bg-primary',
        bank: 'bg-info text-dark'
    };
    return mapping[method.toLowerCase()] || 'bg-secondary';
};

const confirmDelete = async (id) => {
    if (confirm('Are you sure you want to delete this payment record?')) {
        try {
            const response = await axios.delete(`payments/${id}`);
            if (response.data.success) {
                successMessage.value = 'Payment deleted successfully!';
                fetchPayments(pagination.value.current_page);
                setTimeout(() => successMessage.value = null, 3000);
            }
        } catch (error) {
            console.error(error);
            alert("Could not delete payment.");
        }
    }
};

onMounted(() => {
    fetchPayments();
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
</style>