<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Package</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createPackage">
                    
                    <div class="mb-3">
                        <label for="package_code" class="form-label">Package Code (Optional)</label>
                        <input type="text" class="form-control" id="package_code" v-model="form.package_code" :disabled="loading">
                    </div>
                    
                    <div class="mb-3">
                        <label for="package_name" class="form-label">Package Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="package_name" v-model="form.package_name" required :disabled="loading">
                    </div>

                    <div class="mb-3">
                        <label for="speed" class="form-label">Speed (in Mbps) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="speed" v-model="form.speed" required :disabled="loading">
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Price (BDT) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" class="form-control" id="price" v-model="form.price" required :disabled="loading">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'packages.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-success" :disabled="loading">
                            <span v-if="loading" class="spinner-border spinner-border-sm me-1"></span>
                            {{ loading ? 'Saving...' : 'Save Package' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router'; 
import axios from '@/axios.js'; // Axios ইমপোর্ট

const router = useRouter();
const loading = ref(false);
const validationErrors = ref([]);

// ফর্ম ডাটা অবজেক্ট
const form = ref({
    package_code: '',
    package_name: '',
    speed: null,
    price: null,
});

// এপিআই-তে ডাটা সেভ করার ফাংশন
const createPackage = async () => {
    loading.value = true;
    validationErrors.value = []; 

    try {
        // লারাভেল এপিআই-তে পোস্ট রিকোয়েস্ট পাঠানো হচ্ছে
        const response = await axios.post('packages', form.value);
        
        // সাকসেস মেসেজ এবং রিডাইরেকশন
        alert(response.data.message || 'Package created successfully!'); 
        router.push({ name: 'packages.index' }); 

    } catch (error) {
        // লারাভেল থেকে ৪২২ (Validation Error) আসলে
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            validationErrors.value = Object.values(errors).flat();
        } else {
            console.error('Submission error:', error);
            alert('Something went wrong. Please check your connection.');
        }
    } finally {
        loading.value = false;
    }
};
</script>

<style scoped>
/* কার্ডের সৌন্দর্য বৃদ্ধির জন্য সামান্য স্টাইল */
.card {
    border: none;
    border-radius: 10px;
}
.card-header {
    border-radius: 10px 10px 0 0 !important;
}
</style>