<template>
    <div class="container mt-5">
        <div class="card shadow-lg border-0">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New User</h4>
            </div>
            <div class="card-body">

                <div v-if="Object.keys(validationErrors).length" class="alert alert-danger">
                    <ul class="mb-0">
                        <template v-for="(errors, field) in validationErrors" :key="field">
                            <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
                        </template>
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

                    <div v-if="previewUrl" class="mb-3">
                        <img :src="previewUrl" class="img-thumbnail" style="max-height: 100px;">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'users.index' }" class="btn btn-secondary px-4">Back to list</router-link>
                        <button type="submit" class="btn btn-success px-5" :disabled="loading">
                            <span v-if="loading" class="spinner-border spinner-border-sm me-1"></span>
                            Save User
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
import axios from '@/axios.js'; // আপনার axios কনফিগ ফাইল

const router = useRouter();
const loading = ref(false);
const validationErrors = ref({});
const previewUrl = ref(null);

const form = ref({
    name: '',
    email: '',
    password: '',
    phone: '',
    role: 'technician',
    avatar: null,
});

// ফাইল হ্যান্ডলিং এবং প্রিভিউ
const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.value.avatar = file;
        previewUrl.value = URL.createObjectURL(file); // ইমেজের একটি প্রিভিউ তৈরি করবে
    }
};

// এপিআই কল করার লজিক
const createUser = async () => {
    loading.value = true;
    validationErrors.value = {};

    // FormData অবজেক্ট তৈরি করা (ইমেজ পাঠানোর জন্য এটি প্রয়োজন)
    const formData = new FormData();
    formData.append('name', form.value.name);
    formData.append('email', form.value.email);
    formData.append('password', form.value.password);
    formData.append('phone', form.value.phone || '');
    formData.append('role', form.value.role);
    
    if (form.value.avatar) {
        formData.append('avatar', form.value.avatar);
    }

    try {
        const response = await axios.post('users', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });

        if (response.data.success) {
            // সাকসেস হলে লিস্ট পেজে পাঠিয়ে দেওয়া
            router.push({ name: 'users.index' });
        }
    } catch (error) {
        if (error.response && error.response.status === 422) {
            // লারাভেল ভ্যালিডেশন এরর গুলো এখানে ধরবে
            validationErrors.value = error.response.data.errors;
        } else {
            console.error("Submission error:", error);
            alert("Something went wrong. Please try again.");
        }
    } finally {
        loading.value = false;
    }
};
</script>

<style scoped>
.card { border-radius: 12px; }
.card-header { border-radius: 12px 12px 0 0 !important; }
</style>