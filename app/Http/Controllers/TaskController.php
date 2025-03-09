<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    // Получить список всех задач
    public function index()
    {
        return Task::all();
    }

    // создание новой задачи
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title'       => 'required|string|max:255',
            'description' => 'nullable|string',
            'completed'   => 'boolean'
        ]);

        $task = Task::create($validated);
        return response()->json($task, 201);
    }

    // получить задачу (одну)
    public function show(Task $task)
    {
        return $task;
    }

    // обновить задачу
    public function update(Request $request, Task $task)
    {
        $validated = $request->validate([
            'title'       => 'sometimes|required|string|max:255',
            'description' => 'sometimes|nullable|string',
            'completed'   => 'sometimes|boolean'
        ]);

        $task->update($validated);
        return response()->json($task, 200);
    }

    // удаление задачи
    public function destroy(Task $task)
    {
        $task->delete();
        return response()->json(null, 204);
    }
}
