<?php

namespace App\Commands;

use LaravelZero\Framework\Commands\Command;
use Symfony\Component\Console\Command\Command as CommandAlias;
use Symfony\Component\Process\Process;

class FfmpegCommand extends Command
{
    protected $signature = 'ffmpeg {args* : Arguments to pass to ffmpeg}';

    protected $description = 'Run ffmpeg with predefined arguments';

    public function handle(): int
    {

        $config = config('ffmpeg');

        $videoCodec = $config['codec'];
        $crf = $config['quality'];

        $defaultArgs = [];

        if ($videoCodec === 'h264_nvenc') {
            $defaultArgs = [
                '-c:v', $videoCodec,
                '-rc', 'vbr',
                '-cq', $crf,
            ];
        }

        $userArgs = $this->argument('args');
        $args = array_merge($defaultArgs, $userArgs);

        $process = new Process(array_merge(['ffmpeg'], $args));

        $this->info($process->getCommandLine());

        $process->setTimeout(null);
        $process->run(function ($type, $buffer) {
            $this->output->write($buffer);
        });

        return $process->isSuccessful() ? CommandAlias::SUCCESS : CommandAlias::FAILURE;
    }
}
