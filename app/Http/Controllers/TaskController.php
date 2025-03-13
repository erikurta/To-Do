<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use App\Http\Requests\StoreTaskRequest;
use App\Http\Requests\UpdateTaskRequest;


class TaskController extends Controller

{
    // Получить список всех задач
    public function index()
    {
        return Task::all();
    }

    // создание новой задачи
    public function store(StoreTaskRequest $request)
    {
        // Данные уже валидированы
        $task = Task::create($request->validated());
        return response()->json($task, 201);
    }

    // получить задачу (одну)
    public function show(Task $task)
    {
        return $task;
    }

    // обновить задачу
    public function update(UpdateTaskRequest $request, Task $task)
    {
        $task->update($request->validated());
        return response()->json($task, 200);
    }

    // удаление задачи
    public function destroy(Task $task)
    {
        $task->delete();
        return response()->json(null, 204);
    }
}
