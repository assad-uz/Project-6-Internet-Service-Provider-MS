<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Package</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createPackage">
                    
                    <div class="mb-3">
                        <label for="package_code" class="form-label">Package Code (Optional)</label>
                        <input type="text" class="form-control" id="package_code" v-model="form.package_code">
                    </div>
                    
                    <div class="mb-3">
                        <label for="package_name" class="form-label">Package Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="package_name" v-model="form.package_name" required>
                    </div>

                    <div class="mb-3">
                        <label for="speed" class="form-label">Speed (in Mbps) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="speed" v-model="form.speed" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Price (BDT) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" class="form-control" id="price" v-model="form.price" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'packages.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-success">Save Package</button>
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
    package_code: '',
    package_name: '',
    speed: null, // সংখ্যা হিসাবে শুরু
    price: null, // সংখ্যা হিসাবে শুরু
});

const validationErrors = ref([]);

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const createPackage = () => {
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    // নিশ্চিত করতে হবে যেন required ফিল্ডগুলো খালি না থাকে এবং সংখ্যাগুলো শূন্যের বেশি হয়
    if (!form.value.package_name || !form.value.speed || !form.value.price || form.value.speed <= 0 || form.value.price <= 0) {
        validationErrors.value = ['Package Name, Speed, and Price are required and must be greater than zero.'];
        return;
    }
    
    validationErrors.value = []; // এরর থাকলে ক্লিয়ার
    
    // 2. 🎯 পরে: এখানে Axios দিয়ে API কল করে ডেটা Laravel ব্যাকএন্ডে পাঠানো হবে।
    console.log('Package form submitted:', form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert('Package created successfully! (Static Mode)'); 
    router.push({ name: 'packages.index' }); 
};
</script>

<style scoped>
/* স্টাইল এখানে যোগ করুন */
</style>