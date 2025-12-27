import axios from 'axios';

const axiosInstance = axios.create({
    // এখানে আপনার লারাভেল এপিআই-এর মেইন ইউআরএল থাকবে
    baseURL: 'http://localhost:8000/api/',
    timeout: 10000, // ১০ সেকেন্ড পর রিকোয়েস্ট টাইমআউট হবে
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
});

export default axiosInstance;