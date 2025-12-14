<template>
    <div class="container py-4">
        <div class="row g-3">
            
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Total Customers</h6>
                        <h3 class="fw-bold">{{ totalCustomers }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Active Customers</h6>
                        <h3 class="fw-bold text-success">{{ activeCustomers }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Inactive Customers</h6>
                        <h3 class="fw-bold text-danger">{{ inactiveCustomers }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Pending Support Ticket</h6>
                        <h3 class="fw-bold text-warning">{{ pendingTickets }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-md-3" v-for="packageStat in packageCounts" :key="packageStat.id">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Total Users | {{ packageStat.package_name ?? 'N/A' }}</h6>
                        <h3 class="fw-bold">{{ packageStat.total }}</h3>
                    </div>
                </div>
            </div>
            
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Total Due Bills</h6>
                        <h3 class="fw-bold text-danger">{{ totalDueBillingsCount }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
                <div class="card shadow-sm border-0">
                    <div class="card-body text-center">
                        <h6 class="text-muted">Collection ({{ currentMonthYear }})</h6>
                        <h3 class="fw-bold text-primary">৳ {{ totalSalesAmountFormatted }}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// 💡 দ্রষ্টব্য: কম্পোনেন্টটি ডেটা রেন্ডার করার জন্য প্রস্তুত। 
// আপনাকে এখন এই ডেটাগুলি লোড করার জন্য API কল করতে হবে।

// ডামি ডেটা (API কল করার আগে টেস্টিং এর জন্য)
const totalCustomers = ref(1500);
const activeCustomers = ref(1450);
const inactiveCustomers = ref(50);
const pendingTickets = ref(8);
const totalDueBillingsCount = ref(120);
const totalSalesAmount = ref(150000.75);

// Blade লুপের জন্য ডামি প্যাকেজ ডেটা
const packageCounts = ref([
    { id: 1, package_name: 'Silver 10Mbps', total: 600 },
    { id: 2, package_name: 'Gold 20Mbps', total: 400 },
    { id: 3, package_name: 'Platinum 50Mbps', total: 300 },
]);


// ফাংশন এবং কম্পিউটেড প্রপার্টি (Blade লজিক প্রতিস্থাপনের জন্য)

// সংখ্যাকে কমা দিয়ে ফরম্যাট করার জন্য ফাংশন
// const formatNumber = (value) => {
//   return value.toLocaleString('en-IN', { maximumFractionDigits: 0 });
// };

// টাকার পরিমাণকে ২ দশমিক স্থান এবং কমা দিয়ে ফরম্যাট করা
const totalSalesAmountFormatted = computed(() => {
    return totalSalesAmount.value.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
});

// কার্বন ফাংশন প্রতিস্থাপন: বর্তমান মাস ও বছর
const currentMonthYear = computed(() => {
    const now = new Date();
    return now.toLocaleString('en-IN', { month: 'short', year: 'numeric' });
});

</script>

<style scoped>
/* আপনার টেমপ্লেটের অন্যান্য CSS (যদি প্রয়োজন হয়) */
</style>