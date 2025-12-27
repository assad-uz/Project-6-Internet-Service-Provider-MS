<template>
    <div class="container mt-5">
        <div class="card shadow-lg border-0">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit User: {{ form.name || 'Loading...' }}</h4>
            </div>
            <div class="card-body">

                <div v-if="Object.keys(validationErrors).length" class="alert alert-danger">
                    <ul class="mb-0">
                        <template v-for="(errors, field) in validationErrors" :key="field">
                            <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
                        </template>
                    </ul>
                </div>
                
                <div v-if="loading" class="text-center py-5">
                    <div class="spinner-border text-warning" role="status"></div>
                    <p class="mt-2 text-muted">Loading user data...</p>
                </div>

                <form v-else @submit.prevent="updateUser" enctype="multipart/form-data">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label fw-bold">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" v-model="form.email" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label fw-bold">Password</label>
                        <input type="password" class="form-control" id="password" v-model="form.password" placeholder="Leave blank to keep current password">
                        <small class="form-text text-muted">Only fill this if you want to change the password.</small>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label fw-bold">Phone</label>
                        <input type="text" class="form-control" id="phone" v-model="form.phone">
                    </div>

                    <div class="mb-3">
                        <label for="role" class="form-label fw-bold">Role <span class="text-danger">*</span></label>
                        <select class="form-control" id="role" v-model="form.role" required>
                            <option value="technician">Technician</option>
                            <option value="manager">Manager</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label d-block fw-bold">Current Avatar</label>
                        <div class="mb-2">
                            <img v-if="form.current_avatar_url" :src="form.current_avatar_url" alt="Current Avatar" class="img-thumbnail shadow-sm" style="width: 100px; height: 100px; object-fit: cover;">
                            <img v-else src="https://via.placeholder.com/100?text=No+Image" class="img-thumbnail shadow-sm" style="width: 100px;">
                        </div>
                        
                        <label for="avatar" class="form-label fw-bold">Upload New Avatar</label>
                        <input type="file" class="form-control" id="avatar" @change="handleFileChange" accept="image/*">
                        <small class="form-text text-muted">Select a new image if you want to update it.</small>
                    </div>
                    
                    <hr>

                    <div class="d-flex justify-content-between">
                        <router-link :to="{ name: 'users.index' }" class="btn btn-secondary px-4">Back to List</router-link>
                        <button type="submit" class="btn btn-warning px-5 fw-bold" :disabled="submitting">
                            <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
                            Update User
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
import axios from '@/axios.js';

const route = useRoute();
const router = useRouter(); 

const loading = ref(true);
const submitting = ref(false);
const userId = ref(null);
const validationErrors = ref({});

const form = ref({
    name: '',
    email: '',
    password: '',
    phone: '',
    role: '',
    avatar: null,
    current_avatar_url: null,
});

// ফাইল হ্যান্ডলিং
const handleFileChange = (event) => {
    form.value.avatar = event.target.files[0];
};

// ডাটাবেস থেকে ইউজার ডাটা নিয়ে আসা
const fetchUser = async (id) => {
    loading.value = true;
    try {
        const response = await axios.get(`users/${id}`);
        if (response.data.success) {
            const user = response.data.data;
            form.value.name = user.name;
            form.value.email = user.email;
            form.value.phone = user.phone;
            form.value.role = user.role;
            // স্টোরেজ লিঙ্ক অনুযায়ী অ্যাভাটার URL সেট করা
            form.value.current_avatar_url = user.avatar ? `http://localhost:8000/storage/${user.avatar}` : null;
        }
    } catch (error) {
        console.error("Fetch error:", error);
        alert('User not found!');
        router.push({ name: 'users.index' });
    } finally {
        loading.value = false;
    }
};

// আপডেট লজিক
const updateUser = async () => {
    submitting.value = true;
    validationErrors.value = {};

    const formData = new FormData();
    // লারাভেলে PUT রিকোয়েস্ট উইথ ফাইল হ্যান্ডেল করার ট্রিক
    formData.append('_method', 'PUT'); 
    
    formData.append('name', form.value.name);
    formData.append('email', form.value.email);
    formData.append('phone', form.value.phone || '');
    formData.append('role', form.value.role);
    
    // পাসওয়ার্ড দেওয়া থাকলে শুধু তখনই পাঠানো
    if (form.value.password) {
        formData.append('password', form.value.password);
    }
    
    // নতুন ফাইল সিলেক্ট করা হলে পাঠানো
    if (form.value.avatar) {
        formData.append('avatar', form.value.avatar);
    }

    try {
        // লারাভেলের জন্য এখানে .post ব্যবহার করা নিরাপদ যখন FormData+PUT থাকে
        const response = await axios.post(`users/${userId.value}`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });

        if (response.data.success) {
            router.push({ name: 'users.index' });
        }
    } catch (error) {
        if (error.response && error.response.status === 422) {
            validationErrors.value = error.response.data.errors;
        } else {
            alert("Update failed!");
        }
    } finally {
        submitting.value = false;
    }
};

onMounted(() => {
    userId.value = route.params.id;
    if (userId.value) {
        fetchUser(userId.value);
    }
});
</script>

<style scoped>
.card { border-radius: 12px; }
.card-header { border-radius: 12px 12px 0 0 !important; }
</style>