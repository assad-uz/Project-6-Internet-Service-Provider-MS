<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit user: {{ form.name || 'Loading...' }}</h4>
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
                    <p class="mt-2">Loading user data...</p>
                </div>

                <form v-else @submit.prevent="updateUser" enctype="multipart/form-data">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" v-model="form.email" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" v-model="form.password" placeholder="Leave blank to keep current password">
                        <small class="form-text text-muted">Leave blank to keep current password.</small>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text" class="form-control" id="phone" v-model="form.phone">
                    </div>

                    <div class="mb-3">
                        <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                        <select class="form-control" id="role" v-model="form.role" required>
                            <option value="technician">Technician</option>
                            <option value="manager">Manager</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label d-block">Current Avatar</label>
                        <template v-if="form.current_avatar_url">
                            <img :src="form.current_avatar_url" alt="Current Avatar" class="img-thumbnail mb-2" style="width: 100px; height: 100px; object-fit: cover;">
                        </template>
                        <template v-else>
                            <p class="text-muted">No avatar uploaded.</p>
                        </template>
                        
                        <label for="avatar" class="form-label">Upload New Avatar</label>
                        <input type="file" class="form-control" id="avatar" @change="handleFileChange" accept="image/*">
                        <small class="form-text text-muted">Upload a new image to replace the current one.</small>
                    </div>
                    
                    <hr>

                    <div class="d-flex justify-content-between">
                        <router-link :to="{ name: 'users.index' }" class="btn btn-secondary">Back to List</router-link>
                        <button type="submit" class="btn btn-warning">Update</button>
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
const userId = ref(null); // ইউজার আইডি
const validationErrors = ref([]);

// 💡 ডামি ফর্ম ডেটা এবং বর্তমান অ্যাভাটার URL
const form = ref({
    name: '',
    email: '',
    password: '', // এডিট করার সময় পাসওয়ার্ড খালি থাকবে
    phone: '',
    role: '',
    avatar: null, // নতুন ফাইল ডেটা
    current_avatar_url: null, // বর্তমান ছবির URL
});

// ডামি ইউজার ডেটা
const dummyUsers = [
    { id: 1, name: 'Admin User', email: 'admin@example.com', phone: '01711223344', role: 'admin', avatar_url: 'https://i.pravatar.cc/100?img=1' },
    { id: 2, name: 'Manager Doe', email: 'manager@example.com', phone: '01811223344', role: 'manager', avatar_url: null },
    // আরও ইউজার ডেটা...
];

// ফাইল ইনপুট হ্যান্ডলিং
const handleFileChange = (event) => {
    form.value.avatar = event.target.files[0];
};

// ইউজার ডেটা লোড করার ডামি ফাংশন
const fetchUser = async (id) => {
    loading.value = true;
    
    // 🎯 পরে: এখানে Axios.get('/api/users/' + id) কল করা হবে।
    
    // ডামি লজিক: আইডি দ্বারা ডামি ইউজার ডেটা খুঁজে বের করা
    const userData = dummyUsers.find(u => u.id === parseInt(id));
    
    if (userData) {
        // ফর্ম ডেটা পূরণ করা
        form.value.name = userData.name;
        form.value.email = userData.email;
        form.value.phone = userData.phone;
        form.value.role = userData.role;
        form.value.current_avatar_url = userData.avatar_url; 
        form.value.password = ''; // পাসওয়ার্ড সর্বদা খালি থাকবে
    } else {
        alert('User not found (Static Mode)');
        router.push({ name: 'users.index' });
    }
    
    loading.value = false;
};

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const updateUser = () => {
    validationErrors.value = [];
    
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    if (!form.value.name || !form.value.email || !form.value.role) {
        validationErrors.value = ['Name, Email, and Role are required.'];
        return;
    }

    // 2. 🎯 পরে: এখানে Axios.patch/put('/api/users/' + userId.value) কল করা হবে।
    console.log(`User ID ${userId.value} update data submitted:`, form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert(`User ${form.value.name} updated successfully! (Static Mode)`); 
    router.push({ name: 'users.index' });
};

// কম্পোনেন্ট লোড হওয়ার সময় আইডি নিয়ে ডেটা লোড করা
onMounted(() => {
    userId.value = route.params.id;
    if (userId.value) {
        fetchUser(userId.value);
    }
});
</script>

<style scoped>
/* স্টাইল এখানে যোগ করুন */
</style>