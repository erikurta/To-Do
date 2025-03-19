<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>To-Do App</title>
    <script src="{{ asset('js/app.js') }}" defer></script>
</head>
<body>
<div id="app">
    <h1>Список задач</h1>

    <input type="text" v-model="newTaskTitle" placeholder="Название задачи">
    <input type="text" v-model="newTaskDescription" placeholder="Описание задачи">
    <button @click="createTask">Добавить задачу</button>

    <ul>
        <li v-for="task in tasks" :key="task.id">
            <input type="checkbox" :checked="task.completed" @change="toggleTaskStatus(task)">
            @{{ task.title }} - @{{ task.description || 'Без описания' }}
            <button @click="deleteTask(task.id)">Удалить</button>
        </li>
    </ul>
</div>
</body>
</html>