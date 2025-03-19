import Vue from 'vue';

new Vue({
    el: '#app',
    data() {
        return {
            newTaskTitle: '',
            newTaskDescription: '',
            tasks: [],
        };
    },
    methods: {
        async fetchTasks() {
            const response = await fetch('/api/tasks');
            this.tasks = await response.json();
        },
        async createTask() {
            if (!this.newTaskTitle) return;

            const response = await fetch('/api/tasks', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    title: this.newTaskTitle,
                    description: this.newTaskDescription,
                }),
            });

            if (response.ok) {
                this.newTaskTitle = '';
                this.newTaskDescription = '';
                this.fetchTasks();
            }
        },
        async deleteTask(id) {
            await fetch(`/api/tasks/${id}`, { method: 'DELETE' });
            this.fetchTasks();
        }
    },
    mounted() {
        this.fetchTasks();
    }
});