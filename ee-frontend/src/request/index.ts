import axios, { type AxiosInstance } from 'axios';
import { ElMessage } from 'element-plus';

const instance: AxiosInstance = axios.create({
    baseURL: '/',
    timeout: 3000,
    headers: {
        'Content-Type': 'application/json',
    },
});

instance.interceptors.request.use(request => {
    request.headers.Authorization = 'Bearer ' + '';
    return request;
});

instance.interceptors.response.use(response => response.data, error => {
    if (error.response) {
        let response = error.response;
        if (response.status === 401) {
            ElMessage.error('Unauthorized');
        } else {
            ElMessage.error(`Error: ${response.status}, ${response.data.message}`);
        
        }
        const { data, status } = error.response;
        ElMessage.error(`Error: ${status}, ${data.message}`);
    }
    return Promise.reject(error);
});

export default instance;