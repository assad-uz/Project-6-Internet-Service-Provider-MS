<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Package: {{ form.package_name || 'Loading...' }}</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>
                
                <div v-if="loading" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading package data from server...</p>
                </div>

                <form v-else @submit.prevent="updatePackage">
                    
                    <div class="mb-3">
                        <label for="package_code" class="form-label">Package Code (Optional)</label>
                        <input type="text" class="form-control" id="package_code" v-model="form.package_code" :disabled="saving">
                    </div>
                    
                    <div class="mb-3">
                        <label for="package_name" class="form-label">Package Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="package_name" v-model="form.package_name" required :disabled="saving">
                    </div>

                    <div class="mb-3">
                        <label for="speed" class="form-label">Speed (in Mbps) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="speed" v-model="form.speed" required :disabled="saving">
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Price (BDT) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" class="form-control" id="price" v-model="form.price" required :disabled="saving">
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'packages.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-warning" :disabled="saving">
                            <span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>
                            {{ saving ? 'Updating...' : 'Update Package' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from '@/axios.js'; // আপনার Axios কনফিগারেশন

const route = useRoute(); 
const router = useRouter(); 

const loading = ref(true); // ডেটা ফেচিং লোডার
const saving = ref(false);  // আপডেট সাবমিশন লোডার
const packageId = ref(null); 
const validationErrors = ref([]);

const form = ref({
    package_code: '',
    package_name: '',
    speed: null,
    price: null,
});

// ১. এপিআই থেকে প্যাকেজের ডেটা নিয়ে আসা
const fetchPackage = async (id) => {
    loading.value = true;
    try {
        const response = await axios.get(`packages/${id}`);
        const data = response.data;
        
        // ফর্ম ফিল্ডগুলো পূর্ণ করা
        form.value.package_code = data.package_code;
        form.value.package_name = data.package_name;
        form.value.speed = data.speed;
        form.value.price = data.price;
    } catch (error) {
        console.error("Error fetching package:", error);
        alert('Package not found or server error!');
        router.push({ name: 'packages.index' });
    } finally {
        loading.value = false;
    }
};

// ২. এপিআই-তে আপডেট রিকোয়েস্ট পাঠানো
const updatePackage = async () => {
    saving.value = true;
    validationErrors.value = []; 

    try {
        const response = await axios.put(`packages/${packageId.value}`, form.value);
        
        alert(response.data.message || 'Package updated successfully!'); 
        router.push({ name: 'packages.index' });

    } catch (error) {
        // লারাভেল ৪২২ (ভ্যালিডেশন এরর) হ্যান্ডেল করা
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            validationErrors.value = Object.values(errors).flat();
        } else {
            console.error("Update error:", error);
            alert('Something went wrong during update.');
        }
    } finally {
        saving.value = false;
    }
};

// পেজ লোড হওয়ার সাথে সাথে আইডি ধরে ডেটা আনা
onMounted(() => {
    packageId.value = route.params.id;
    if (packageId.value) {
        fetchPackage(packageId.value);
    }
});
</script>

<style scoped>
.card {
    border: none;
    border-radius: 12px;
}
.card-header {
    border-radius: 12px 12px 0 0 !important;
}
</style>