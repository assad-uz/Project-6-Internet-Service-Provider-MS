<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Customer Type</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createCustomerType">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Type Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required :disabled="loading">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'customer_types.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-success" :disabled="loading">
                            <span v-if="loading" class="spinner-border spinner-border-sm me-1"></span>
                            {{ loading ? 'Saving...' : 'Save Type' }}
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
import axios from '@/axios.js'; // Axios instance ইমপোর্ট করা হলো

const router = useRouter();

// ফর্ম ডাটা রিঅ্যাক্টিভ অবজেক্ট
const form = ref({
    name: '',
});

const validationErrors = ref([]);
const loading = ref(false); // সাবমিট করার সময় স্টেট ট্র্যাক করার জন্য

// কাস্টমার টাইপ তৈরির মেইন ফাংশন
const createCustomerType = async () => {
    loading.value = true;
    validationErrors.value = []; // পুরানো এরর পরিষ্কার করা

    try {
        // লারাভেল এপিআই-তে POST রিকোয়েস্ট পাঠানো হচ্ছে
        const response = await axios.post('customer_types', form.value);
        
        // সাকসেস হলে ইউজারকে মেসেজ দেখানো এবং ইনডেক্স পেজে পাঠানো
        alert(response.data.message || 'Customer Type created successfully!'); 
        router.push({ name: 'customer_types.index' }); 

    } catch (error) {
        // যদি লারাভেল থেকে ভ্যালিডেশন এরর (৪২২) আসে
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            // এরর অবজেক্টকে একটি সিম্পল অ্যারেতে রূপান্তর করা
            validationErrors.value = Object.values(errors).flat();
        } else {
            console.error('Error creating customer type:', error);
            alert('Something went wrong. Please try again.');
        }
    } finally {
        loading.value = false;
    }
};
</script>

<style scoped>
/* কার্ডের জন্য কাস্টম ডিজাইন */
.card {
    border: none;
    border-radius: 10px;
}
.card-header {
    border-radius: 10px 10px 0 0 !important;
}
</style>