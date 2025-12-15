<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Package: {{ form.package_name || 'Loading...' }}</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>
                
                <div v-if="loading" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading package data...</p>
                </div>

                <form v-else @submit.prevent="updatePackage">
                    
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
                        <button type="submit" class="btn btn-warning">Update Package</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute(); // রুট প্যারামিটার নেওয়ার জন্য
const router = useRouter(); 

const loading = ref(true); // লোডিং স্টেট
const packageId = ref(null); // প্যাকেজ আইডি
const validationErrors = ref([]);

// 💡 ডামি ফর্ম ডেটা সেট করা হলো
const form = ref({
    package_code: '',
    package_name: '',
    speed: null,
    price: null,
});

// ডামি প্যাকেজ ডেটা
const dummyPackages = [
    { id: 1, package_code: 'P-10M', package_name: 'Residential Economy', speed: 10, price: 800.00 },
    { id: 2, package_code: 'P-20M', package_name: 'Home Standard', speed: 20, price: 1250.50 },
    { id: 3, package_code: 'P-50M', package_name: 'Corporate Fast', speed: 50, price: 3500.00 },
];

// প্যাকেজ ডেটা লোড করার ডামি ফাংশন
const fetchPackage = async (id) => {
    loading.value = true;
    
    // 🎯 পরে: এখানে Axios.get('/api/packages/' + id) কল করা হবে।
    
    // ডামি লজিক: আইডি দ্বারা ডামি ডেটা খুঁজে বের করা
    const packageData = dummyPackages.find(p => p.id === parseInt(id));
    
    if (packageData) {
        // ফর্ম ডেটা পূরণ করা
        form.value.package_code = packageData.package_code;
        form.value.package_name = packageData.package_name;
        // ensure speed and price are numbers
        form.value.speed = packageData.speed; 
        form.value.price = packageData.price; 
    } else {
        alert('Package not found (Static Mode)');
        router.push({ name: 'packages.index' });
    }
    
    loading.value = false;
};

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const updatePackage = () => {
    validationErrors.value = [];
    
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    if (!form.value.package_name || !form.value.speed || !form.value.price || form.value.speed <= 0 || form.value.price <= 0) {
        validationErrors.value = ['Package Name, Speed, and Price are required and must be greater than zero.'];
        return;
    }

    // 2. 🎯 পরে: এখানে Axios.put('/api/packages/' + packageId.value) কল করা হবে।
    console.log(`Package ID ${packageId.value} update data submitted:`, form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert(`Package "${form.value.package_name}" updated successfully! (Static Mode)`); 
    router.push({ name: 'packages.index' });
};

// কম্পোনেন্ট লোড হওয়ার সময় আইডি নিয়ে ডেটা লোড করা
onMounted(() => {
    packageId.value = route.params.id;
    if (packageId.value) {
        fetchPackage(packageId.value);
    }
});
</script>

<style scoped>
/* স্টাইল এখানে যোগ করুন */
</style>