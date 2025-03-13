import axios from 'axios';

const apiClient = axios.create({
    baseURL: '/api',
    headers: {
        'Content-Type': 'application/json',
    },
});

export function getTasks() {
    return apiClient.get('/tasks');
}

export function createTask(task) {
    return apiClient.post('/tasks', task);
}

export function toggleTaskStatus(task) {
    return apiClient.put(`/tasks/${task.id}`, {
        completed: !task.completed
    });
}

export function deleteTask(id) {
    return apiClient.delete(`/tasks/${id}`);
}