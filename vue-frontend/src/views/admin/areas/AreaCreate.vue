<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Area</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createArea">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Area Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required :disabled="loading">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'areas.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-success" :disabled="loading">
                            <span v-if="loading" class="spinner-border spinner-border-sm me-1"></span>
                            {{ loading ? 'Saving...' : 'Save Area' }}
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
import axios from '@/axios.js'; // আপনার Axios কনফিগারেশন ইমপোর্ট করা হলো

const router = useRouter();

// ফর্ম ডাটা অবজেক্ট
const form = ref({
    name: '',
});

const validationErrors = ref([]);
const loading = ref(false); // সেভ করার সময় লোডিং স্টেট

// এরিয়া তৈরির ফাংশন (Async ব্যবহার করা হয়েছে API কলের জন্য)
const createArea = async () => {
    loading.value = true;
    validationErrors.value = []; // আগে কোনো এরর থাকলে তা পরিষ্কার করা

    try {
        // লারাভেল এপিআই-তে ডাটা পাঠানো হচ্ছে
        const response = await axios.post('areas', form.value);
        
        // সাকসেস হলে ইনডেক্স পেজে পাঠিয়ে দেওয়া হবে
        // লারাভেল কন্ট্রোলারে আমরা 'message' পাঠিয়েছি, চাইলে সেটি এলার্টে দেখানো যায়
        alert(response.data.message || 'Area created successfully!'); 
        router.push({ name: 'areas.index' }); 

    } catch (error) {
        // যদি লারাভেল থেকে ৪২২ (Validation Error) আসে
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            // সব এরর মেসেজগুলোকে একটি অ্যারেতে সাজানো হচ্ছে
            validationErrors.value = Object.values(errors).flat();
        } else {
            // অন্য কোনো টেকনিক্যাল এরর হলে
            console.error("Error creating area:", error);
            validationErrors.value = ['Something went wrong. Please try again later.'];
        }
    } finally {
        loading.value = false;
    }
};
</script>

<style scoped>
/* কার্ডের জন্য সামান্য শ্যাডো ইফেক্ট */
.card {
    border: none;
    border-radius: 10px;
}
.card-header {
    border-radius: 10px 10px 0 0 !important;
}
</style>