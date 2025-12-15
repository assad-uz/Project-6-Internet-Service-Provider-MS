<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Customer Type</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createCustomerType">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Type Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'customer_types.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-success">Save Type</button>
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

// 💡 ডামি ফর্ম ডেটা সেট করা হলো
const form = ref({
    name: '',
});

const validationErrors = ref([]);

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const createCustomerType = () => {
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    if (!form.value.name) {
        validationErrors.value = ['Type Name is required.'];
        return;
    }
    
    validationErrors.value = []; // এরর থাকলে ক্লিয়ার
    
    // 2. 🎯 পরে: এখানে Axios দিয়ে API কল করে ডেটা Laravel ব্যাকএন্ডে পাঠানো হবে।
    console.log('Customer Type submitted:', form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert('Customer Type created successfully! (Static Mode)'); 
    router.push({ name: 'customer_types.index' }); 
};
</script>

<style scoped>
/* স্টাইল এখানে যোগ করুন */
</style>