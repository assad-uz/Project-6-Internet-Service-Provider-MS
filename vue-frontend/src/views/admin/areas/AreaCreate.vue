<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Area</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createArea">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Area Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'areas.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-success">Save Area</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router'; 

const router = useRouter();

// ফর্ম ডাটা অবজেক্ট
const form = ref({
    name: '',
});

const validationErrors = ref([]);

// এরিয়া তৈরির ফাংশন
const createArea = () => {
    // বেসিক ভ্যালিডেশন
    if (!form.value.name) {
        validationErrors.value = ['Area Name is required.'];
        return;
    }
    
    validationErrors.value = []; 
    
    // 🎯 API ইন্টিগ্রেশনের সময় এখানে Axios কল হবে
    console.log('Area created:', form.value);

    // সাকসেস অ্যালার্ট এবং রিডাইরেকশন
    alert('Area created successfully! (Static Mode)'); 
    router.push({ name: 'areas.index' }); 
};
</script>

<style scoped>
/* প্রয়োজন হলে কাস্টম স্টাইল এখানে দিন */
</style>