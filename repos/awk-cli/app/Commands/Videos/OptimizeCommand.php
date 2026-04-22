<?php

namespace App\Commands\Videos;

use LaravelZero\Framework\Commands\Command;

class OptimizeCommand extends Command
{
    protected $signature = 'videos:optimize
    {--i|input_dir=~/Desktop/input : input_dir}
    {--o|output_dir=~/Desktop/output : output_dir}
    ';

    protected $description = 'Optimize videos';

    public function handle(): void
    {
        echo 234234;
    }
}
