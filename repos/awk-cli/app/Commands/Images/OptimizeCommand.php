<?php

namespace App\Commands\Images;

use LaravelZero\Framework\Commands\Command;

class OptimizeCommand extends Command
{
    protected $signature = 'images:optimize
    {--i|input_dir=~/Desktop/input : input_dir}
    {--o|output_dir=~/Desktop/output : output_dir}
    ';

    protected $description = 'Optimize images';

    public function handle(): void
    {
        echo 234234;
    }
}
