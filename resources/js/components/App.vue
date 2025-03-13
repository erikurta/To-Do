<script>
import { fetchTasks, addTask, updateTask, deleteTask } from '../api.js';

export default {
  data() {
    return {
      tasks: [],
      newTaskTitle: '',
      newTaskDescription: ''
    };
  },
  mounted() {
    fetchTasks().then(data => this.tasks = data);
  },
  methods: {
    addNewTask() {
      if (!this.newTaskTitle.trim()) return alert("Название не может быть пустым!");
      addTask({ title: this.newTaskTitle, description: this.newTaskDescription, completed: false })
          .then(newTask => {
            this.tasks.push(newTask);
            this.newTaskTitle = '';
            this.newTaskDescription = '';
          });
    },
    toggleTaskCompletion(task) {
      updateTask(task).catch(error => console.error("Ошибка обновления", error));
    },
    removeTask(taskId) {
      deleteTask(taskId).then(() => {
        this.tasks = this.tasks.filter(task => task.id !== taskId);
      });
    }
  }
};
</script>