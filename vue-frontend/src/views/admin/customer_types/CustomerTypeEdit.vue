<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Customer Type: {{ form.name || 'Loading...' }}</h4>
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
                    <p class="mt-2">Loading type data from server...</p>
                </div>

                <form v-else @submit.prevent="updateCustomerType">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Type Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required :disabled="saving">
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'customer_types.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-warning" :disabled="saving">
                            <span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>
                            {{ saving ? 'Updating...' : 'Update Type' }}
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

const loading = ref(true); // পেজ লোডের সময় ডাটা ফেচিং স্টেট
const saving = ref(false);  // ফর্ম সাবমিট করার সময় সেভিং স্টেট
const typeId = ref(null); 
const validationErrors = ref([]);

const form = ref({
    name: '',
});

// ১. API থেকে নির্দিষ্ট টাইপের ডেটা নিয়ে আসা
const fetchCustomerType = async (id) => {
    loading.value = true;
    try {
        const response = await axios.get(`customer_types/${id}`);
        form.value.name = response.data.name; 
    } catch (error) {
        console.error("Error fetching customer type:", error);
        alert('Customer type not found!');
        router.push({ name: 'customer_types.index' });
    } finally {
        loading.value = false;
    }
};

// ২. ডেটা আপডেট করার ফাংশন (PUT Request)
const updateCustomerType = async () => {
    saving.value = true;
    validationErrors.value = []; 

    try {
        const response = await axios.put(`customer_types/${typeId.value}`, form.value);
        
        alert(response.data.message || 'Customer Type updated successfully!'); 
        router.push({ name: 'customer_types.index' });

    } catch (error) {
        // লারাভেল ভ্যালিডেশন এরর হ্যান্ডেল করা
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            validationErrors.value = Object.values(errors).flat();
        } else {
            console.error("Update failed:", error);
            alert('Failed to update. Please try again.');
        }
    } finally {
        saving.value = false;
    }
};

// কম্পোনেন্ট মাউন্ট হলে আইডি নিয়ে ডেটা লোড করা
onMounted(() => {
    typeId.value = route.params.id;
    if (typeId.value) {
        fetchCustomerType(typeId.value);
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