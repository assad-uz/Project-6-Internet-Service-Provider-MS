<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New User</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createUser" enctype="multipart/form-data">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" v-model="form.email" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="password" v-model="form.password" required>
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
                        <label for="avatar" class="form-label">Avatar (Profile Picture)</label>
                        <input type="file" class="form-control" id="avatar" @change="handleFileChange" accept="image/*">
                        <small class="form-text text-muted">Max 2MB. Allowed formats: jpeg, png, jpg, gif.</small>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'users.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-success">Save user</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router'; // রাউটিং এর জন্য

const router = useRouter();

// 💡 ডামি ফর্ম ডেটা সেট করা হলো
const form = ref({
    name: '',
    email: '',
    password: '',
    phone: '',
    role: 'technician', // ডিফল্ট ভ্যালু
    avatar: null, // ফাইল ডেটা
});

const validationErrors = ref([]);

// ফাইল ইনপুট হ্যান্ডলিং
const handleFileChange = (event) => {
    // শুধুমাত্র প্রথম ফাইলটি ফর্ম ডেটাতে সংরক্ষণ করা
    form.value.avatar = event.target.files[0];
};

// ফর্ম সাবমিশন লজিক (পরে এটি API কল করবে)
const createUser = () => {
    // 1. ভ্যালিডেশন চেক (আপাতত ডামি)
    if (!form.value.name || !form.value.email || !form.value.password) {
        validationErrors.value = ['Name, Email, and Password are required.'];
        return;
    }
    
    validationErrors.value = []; // এরর থাকলে ক্লিয়ার
    
    // 2. 🎯 পরে: এখানে Axios দিয়ে API কল করে ডেটা Laravel ব্যাকএন্ডে পাঠানো হবে।
    console.log('User form submitted:', form.value);

    // 3. ডামি সাকসেস লজিক: index পেজে রিডাইরেক্ট করে মেসেজ দেখানো
    alert('User created successfully! (Static Mode)'); 
    router.push({ name: 'users.index' }); 
};
</script>

<style scoped>
/* কার্ডের জন্য কাস্টম স্টাইল (যদি প্রয়োজন হয়) */
</style>