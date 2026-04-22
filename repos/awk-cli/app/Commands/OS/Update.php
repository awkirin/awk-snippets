<?php

namespace App\Commands\OS;

use App\Commands\Base;
use Illuminate\Support\Facades\Process;

class Update extends Base
{
    protected $signature = 'os:update';

    protected $description = '';

    public function handle(): void
    {

        $this->task('choco', function () {
            $process = Process::command([
                'choco', 'upgrade', 'all', '-y',
            ]);
            $process->run(null, function ($type, $buffer) {
                $this->output->write($buffer);
            });
        });

        $this->task('lol', function () {
            //            $process = Process::command([
            //                'choco', 'upgrade', 'all', '-y'
            //            ]);
            //            $process->run(null, function ($type, $buffer) {
            //                $this->output->write($buffer);
            //            });
        });

    }
}
