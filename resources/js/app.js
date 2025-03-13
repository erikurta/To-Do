import { createApp, ref, onMounted } from 'vue';
import axios from 'axios';

const app = createApp({
    setup() {
        const tasks = ref([]);
        const newTaskTitle = ref('');
        const newTaskDescription = ref('');

        const getTasks = async () => {
            try {
                const response = await axios.get('/api/tasks');
                tasks.value = response.data;
            } catch (error) {
                console.error('Ошибка при загрузке задач:', error);
            }
        };

        const createTask = async () => {
            if (!newTaskTitle.value.trim()) return;

            try {
                const response = await axios.post('/api/tasks', {
                    title: newTaskTitle.value,
                    description: newTaskDescription.value,
                    completed: false
                });

                tasks.value.push(response.data);
                newTaskTitle.value = '';
                newTaskDescription.value = '';
            } catch (error) {
                console.error('Ошибка при добавлении задачи:', error);
            }
        };

        const deleteTask = async (taskId) => {
            try {
                await axios.delete(`/api/tasks/${taskId}`);
                tasks.value = tasks.value.filter(task => task.id !== taskId);
            } catch (error) {
                console.error('Ошибка при удалении задачи:', error);
            }
        };

        const toggleTaskStatus = async (task) => {
            try {
                await axios.put(`/api/tasks/${task.id}`, {
                    completed: !task.completed
                });

                task.completed = !task.completed;
            } catch (error) {
                console.error('Ошибка при изменении статуса задачи:', error);
            }
        };

        onMounted(getTasks);

        return {
            tasks,
            newTaskTitle,
            newTaskDescription,
            createTask,
            deleteTask,
            toggleTaskStatus
        };
    }
});

app.mount('#app');