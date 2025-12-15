<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Customer Type: {{ form.name || 'Loading...' }}</h4>
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
                    <p class="mt-2">Loading type data...</p>
                </div>

                <form v-else @submit.prevent="updateCustomerType">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Type Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'customer_types.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-warning">Update Type</button>
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
const typeId = ref(null); // টাইপ আইডি
const validationErrors = ref([]);

// 💡 ডামি ফর্ম ডেটা সেট করা হলো
const form = ref({
    name: '',
});

// ডামি কাস্টমার টাইপ ডেটা
const dummyCustomerTypes = [
    { id: 1, name: 'Residential', created_at: '2025-01-15T10:00:00Z' },
    { id: 2, name: 'SME/Office', created_at: '2025-05-20T11:30:00Z' },
    { id: 3, name: 'Corporate', created_at: '2025-10-01T15:45:00Z' },
];

// কাস্টমার টাইপ ডেটা লোড করার ডামি ফাংশন
const fetchCustomerType = async (id) => {
    loading.value = true;
    
    // 🎯 পরে: এখানে Axios.get('/api/customer-types/' + id) কল করা হবে।
    
    // ডামি লজিক: আইডি দ্বারা ডামি ডেটা খুঁজে বের করা
    const typeData = dummyCustomerTypes.find(t => t.id === parseInt(id));
    
    if (typeData) {
        // ফর্ম ডেটা পূরণ করা
        form.value.name = typeData.name;
    } else {
        alert('Customer type not found (Static Mode)');
        router.push({ name: 'customer_types.index' });
    }
    
    loading.value = false;
};

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const updateCustomerType = () => {
    validationErrors.value = [];
    
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    if (!form.value.name) {
        validationErrors.value = ['Type Name is required.'];
        return;
    }

    // 2. 🎯 পরে: এখানে Axios.put('/api/customer-types/' + typeId.value) কল করা হবে।
    console.log(`Customer Type ID ${typeId.value} update data submitted:`, form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert(`Customer Type "${form.value.name}" updated successfully! (Static Mode)`); 
    router.push({ name: 'customer_types.index' });
};

// কম্পোনেন্ট লোড হওয়ার সময় আইডি নিয়ে ডেটা লোড করা
onMounted(() => {
    typeId.value = route.params.id;
    if (typeId.value) {
        fetchCustomerType(typeId.value);
    }
});
</script>

<style scoped>
/* স্টাইল এখানে যোগ করুন */
</style>