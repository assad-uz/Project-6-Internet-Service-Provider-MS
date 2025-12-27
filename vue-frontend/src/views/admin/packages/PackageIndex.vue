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
                <div v-if="loading" class="text-center my-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Fetching Packages...</p>
                </div>

                <table v-else class="table table-bordered table-striped align-middle">
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
                                <router-link :to="{ name: 'packages.edit', params: { id: packageItem.id } }" class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

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
        
        <div class="d-flex justify-content-center mt-3"></div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js'; // Axios ইমপোর্ট

// --- স্টেটস ---
const packages = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const errorMessage = ref(null);

// --- মেথড এবং লজিক ---

// API থেকে সব প্যাকেজ নিয়ে আসা
const fetchPackages = async () => {
    loading.value = true;
    try {
        const response = await axios.get('packages');
        // লারাভেল paginate() ব্যবহার করলে ডাটা থাকে response.data.data-তে
        packages.value = response.data.data; 
    } catch (error) {
        console.error("Error fetching packages:", error);
        errorMessage.value = "Failed to load packages. Please check backend.";
    } finally {
        loading.value = false;
    }
};

// প্রাইস ফরম্যাটিং
const formatPrice = (price) => {
    if (!price) return '0.00';
    return parseFloat(price).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
};

// প্যাকেজ ডিলিট করার ফাংশন
const deletePackage = async (packageId) => {
    if (confirm('Are you sure you want to delete this package?')) {
        try {
            await axios.delete(`packages/${packageId}`);
            
            // রিয়েল-টাইমে লিস্ট আপডেট করা
            packages.value = packages.value.filter(p => p.id !== packageId);
            
            successMessage.value = 'Package deleted successfully!';
            setTimeout(() => { successMessage.value = null; }, 3000);
        } catch (error) {
            console.error("Error deleting package:", error);
            errorMessage.value = "Delete failed. This package might be in use.";
            setTimeout(() => { errorMessage.value = null; }, 3000);
        }
    }
};

// কম্পোনেন্ট লোড হওয়ার সময় কল হবে
onMounted(() => {
    fetchPackages();
});
</script>

<style scoped>
.text-end {
    text-align: right;
}
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
}
</style>