<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8" />
    <title>ToDo App</title>
</head>
<body>
<h1>Список задач</h1>

<!-- Форма для создания новой задачи -->
<div style="margin-bottom: 1rem;">
    <input type="text" id="title" placeholder="Название задачи" />
    <input type="text" id="description" placeholder="Описание задачи" />
    <button id="createTaskBtn">Добавить задачу</button>
</div>

<!-- Список задач -->
<ul id="taskList"></ul>

<script>
    // Функция для получения списка задач с сервера и отрисовки их на странице
    async function fetchTasks() {
        try {
            const response = await fetch('/api/tasks');
            const tasks = await response.json();

            const taskList = document.getElementById('taskList');
            taskList.innerHTML = ''; // Очищаем список перед перерисовкой

            tasks.forEach(task => {
                const li = document.createElement('li');

                // Создаем чекбокс для изменения статуса задачи
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.checked = task.completed;
                // При изменении состояния чекбокса отправляем запрос на обновление задачи
                checkbox.addEventListener('change', () => {
                    updateTaskStatus(task.id, checkbox.checked);
                });

                li.appendChild(checkbox);

                // Текстовое описание задачи
                const text = document.createTextNode(` ${task.title} — ${task.description ? task.description : 'Без описания'}`);
                li.appendChild(text);

                taskList.appendChild(li);
            });
        } catch (error) {
            console.error('Ошибка при получении списка задач:', error);
        }
    }

    // Функция для создания новой задачи через POST-запрос
    async function createTask() {
        const title = document.getElementById('title').value.trim();
        const description = document.getElementById('description').value.trim();

        if (!title) {
            alert('Название задачи не может быть пустым');
            return;
        }

        try {
            const response = await fetch('/api/tasks', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    title,
                    description,
                    completed: false
                })
            });

            if (!response.ok) {
                throw new Error(`Ошибка при создании задачи: ${response.status} ${response.statusText}`);
            }

            // Очищаем поля ввода
            document.getElementById('title').value = '';
            document.getElementById('description').value = '';

            // Обновляем список задач
            await fetchTasks();
        } catch (error) {
            console.error('Ошибка при создании задачи:', error);
        }
    }

    // Функция для обновления статуса задачи через PATCH-запрос
    async function updateTaskStatus(taskId, completed) {
        try {
            const response = await fetch('/api/tasks/' + taskId, {
                method: 'PATCH', // можно также использовать PUT
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ completed })
            });
            if (!response.ok) {
                throw new Error(`Ошибка при обновлении задачи: ${response.status} ${response.statusText}`);
            }
        } catch (error) {
            console.error('Ошибка при обновлении статуса задачи:', error);
        }
    }

    // Назначаем обработчик клика на кнопку создания задачи
    document.getElementById('createTaskBtn').addEventListener('click', createTask);

    // Загружаем список задач при загрузке страницы
    fetchTasks();
</script>
</body>
</html>
