<template>
    <div class="container mt-4">
        
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>
        <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Package Management</h3>
            
            <router-link :to="{ name: 'packages.create' }" class="btn btn-primary">
                + Create New Package
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Code</th>
                            <th style="width: 30%">Package Name</th>
                            <th style="width: 15%">Speed (Mbps)</th>
                            <th style="width: 15%">Price (BDT)</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(packageItem, index) in packages" :key="packageItem.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>{{ packageItem.package_code ?? 'N/A' }}</td>
                            <td>{{ packageItem.package_name }}</td>
                            <td class="text-center">{{ packageItem.speed }}</td>
                            
                            <td class="text-end">৳ {{ formatPrice(packageItem.price) }}</td> 

                            <td class="text-center">
                                <router-link :to="{ name: 'packages.edit', params: { id: packageItem.id } }" class="btn btn-warning btn-icon btn-sm"><i class="bx bx-edit text-white"></i></router-link>

                                <button @click="deletePackage(packageItem.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="packages.length === 0">
                            <td colspan="6" class="text-center text-muted">No packages found.</td>
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

// --- ডামি ডেটা ---
const packages = ref([
    { id: 1, package_code: 'P-10M', package_name: 'Residential Economy', speed: 10, price: 800.00 },
    { id: 2, package_code: 'P-20M', package_name: 'Home Standard', speed: 20, price: 1250.50 },
    { id: 3, package_code: 'P-50M', package_name: 'Corporate Fast', speed: 50, price: 3500.00 },
    { id: 4, package_code: null, package_name: 'Basic Plan', speed: 5, price: 500 },
]);

const successMessage = ref(null);
const errorMessage = ref(null);

// --- মেথড এবং লজিক ---

// টাকা ফরম্যাটিং (number_format এর পরিবর্তে)
const formatPrice = (price) => {
    // মূল্যকে দুই দশমিক স্থান পর্যন্ত ফরম্যাট করা
    return parseFloat(price).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
};


// Delete লজিক (পরে API কল করবে)
const deletePackage = (packageId) => {
    if (confirm('Are you sure you want to delete this package?')) {
        // 🎯 পরে: এখানে Axios.delete কল করা হবে
        console.log(`Deleting package ID: ${packageId}`);
        
        // ডামি রিমুভাল
        packages.value = packages.value.filter(p => p.id !== packageId);
        successMessage.value = 'Package deleted successfully!';
        setTimeout(() => { successMessage.value = null; }, 3000);
    }
};
</script>

<style scoped>
/* টেমপ্লেটের জন্য নির্দিষ্ট স্টাইল */
.text-end {
    text-align: right;
}
</style>