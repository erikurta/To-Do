<template>
  <div>
    <h1>To-Do List</h1>

    <ul>
      <li v-for="task in tasks" :key="task.id">
        <input type="checkbox" v-model="task.completed" @change="toggleTask(task)">
        {{ task.title }}
        <button @click="deleteTask(task.id)">Удалить</button>
      </li>
    </ul>

    <input v-model="newTaskTitle" placeholder="Название задачи">
    <button @click="addTask">Добавить задачу</button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      tasks: [],
      newTaskTitle: '',
    };
  },
  created() {
    this.fetchTasks();
  },
  methods: {
    fetchTasks() {
      axios.get('/api/tasks')
          .then(response => {
            this.tasks = response.data;
          })
          .catch(error => {
            console.error("Ошибка загрузки задач:", error);
          });
    },
    addTask() {
      if (!this.newTaskTitle.trim()) return;
      axios.post('/api/tasks', { title: this.newTaskTitle, completed: false })
          .then(response => {
            this.tasks.push(response.data);
            this.newTaskTitle = '';
          })
          .catch(error => {
            console.error("Ошибка при добавлении задачи:", error);
          });
    },
    toggleTask(task) {
      axios.put(`/api/tasks/${task.id}`, { completed: task.completed })
          .then(() => {
            console.log(`Задача ${task.id} обновлена`);
          })
          .catch(error => {
            console.error("Ошибка обновления задачи:", error);
          });
    },
    deleteTask(id) {
      axios.delete(`/api/tasks/${id}`)
          .then(() => {
            this.tasks = this.tasks.filter(task => task.id !== id);
          })
          .catch(error => {
            console.error("Ошибка удаления задачи:", error);
          });
    }
  }
};
</script>