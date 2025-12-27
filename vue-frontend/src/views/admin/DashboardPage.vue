<template>
    <div class="container-fluid py-4 bg-light min-vh-100">
        <div class="row mb-4">
            <div class="col-12">
                <h4 class="fw-bold text-dark">Business Overview</h4>
                <p class="text-muted">Welcome back! Here's what's happening today.</p>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0 bg-primary bg-opacity-10 p-3 rounded-3">
                                <i class="bx bx-group fs-2 text-primary"></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="text-muted mb-1 small">Total Customers</h6>
                                <h3 class="fw-bold mb-0">{{ stats.totalCustomers }}</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0 bg-success bg-opacity-10 p-3 rounded-3">
                                <i class="bx bx-user-check fs-2 text-success"></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="text-muted mb-1 small">Active Users</h6>
                                <h3 class="fw-bold text-success mb-0">{{ stats.activeCustomers }}</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0 bg-warning bg-opacity-10 p-3 rounded-3">
                                <i class="bx bx-support fs-2 text-warning"></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="text-muted mb-1 small">Open Tickets</h6>
                                <h3 class="fw-bold text-warning mb-0">{{ stats.pendingTickets }}</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
    <div class="card border-0 shadow-sm rounded-4 text-white" style="background: linear-gradient(45deg, #4e73df, #224abe);">
        <div class="card-body p-4">
            <div class="d-flex align-items-center">
                <div class="flex-shrink-0 bg-white bg-opacity-20 p-3 rounded-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                    <i class="bx bx-wallet fs-2 text-white"></i>
                </div>
                <div class="flex-grow-1 ms-3">
                    <h6 class="text-white text-opacity-75 mb-1 small">Collection ({{ stats.currentMonthName || 'Monthly' }})</h6>
                    <h3 class="fw-bold mb-0">৳ {{ totalSalesAmountFormatted }}</h3>
                </div>
            </div>
        </div>
    </div>
</div>
        </div>

        <div class="row g-3">
            <div class="col-12 col-lg-8">
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="fw-bold mb-0">Package Distribution</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4 border-0">Package Name</th>
                                        <th class="text-center border-0">Users</th>
                                        <th class="border-0">Progress</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="packageStat in stats.packageCounts" :key="packageStat.package_id">
                                        <td class="ps-4 fw-medium">{{ packageStat.package?.package_name || 'N/A' }}</td>
                                        <td class="text-center"><span class="badge bg-info bg-opacity-10 text-info px-3">{{ packageStat.total }}</span></td>
                                        <td style="width: 40%">
                                            <div class="progress" style="height: 6px;">
                                                <div class="progress-bar bg-info" :style="{ width: (packageStat.total / stats.totalCustomers * 100) + '%' }"></div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-body p-4 d-flex flex-column justify-content-center text-center">
                        <div class="bg-danger bg-opacity-10 p-4 rounded-circle d-inline-block mx-auto mb-3">
                            <i class="bx bx-error-circle fs-1 text-danger"></i>
                        </div>
                        <h6 class="text-muted mb-1">Total Due Billings</h6>
                        <h2 class="fw-bold text-danger mb-3">{{ stats.totalDueBillingsCount }}</h2>
                        <button class="btn btn-outline-danger rounded-pill px-4 btn-sm">View Reports</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from '@/axios.js';

const loading = ref(true);
const stats = ref({
    totalCustomers: 0,
    activeCustomers: 0,
    inactiveCustomers: 0,
    pendingTickets: 0,
    totalDueBillingsCount: 0,
    totalSalesAmount: 0,
    packageCounts: [],
    currentMonthName: ''
});

const fetchDashboardStats = async () => {
    loading.value = true;
    try {
        const response = await axios.get('dashboard');
        if (response.data.success) {
            stats.value = response.data.data;
        }
    } catch (error) {
        console.error("Error fetching dashboard data:", error);
    } finally {
        loading.value = false;
    }
};

const totalSalesAmountFormatted = computed(() => {
    return (stats.value.totalSalesAmount || 0).toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
});

onMounted(() => {
    fetchDashboardStats();
});
</script>

<style scoped>
.rounded-4 { border-radius: 1rem !important; }
.bg-opacity-10 { --bs-bg-opacity: 0.1; }
.progress { background-color: #f0f0f0; border-radius: 10px; }
.table thead th { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; color: #888; }
/* Boxicons ব্যবহার করতে হলে আপনার index.html এ লিঙ্কটি থাকতে হবে */
</style>