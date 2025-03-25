<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class DeployInit extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:deploy-init';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        \Artisan::call('migrate', ['--force' => true]);
        \Artisan::call('config:cache');
        $this->info('Deployment setup complete');
    }
}
