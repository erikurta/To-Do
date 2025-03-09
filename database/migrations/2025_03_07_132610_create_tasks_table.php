<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tasks', function (Blueprint $table) {
                $table->id();
                $table->string('title', 32);                // название задачи
                $table->text('description')->nullable(); // описание задачи
                $table->boolean('completed')->default(false); // статус
                $table->timestamps();                   // создание и обновление
            });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
