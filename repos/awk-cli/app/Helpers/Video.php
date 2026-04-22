<?php

namespace App\Helpers;

use Symfony\Component\Process\Process;

class Video
{
    public static function isVideo(string $path): bool
    {
        if (! is_file($path)) {
            return false;
        }

        $process = new Process([
            'ffprobe',
            '-v', 'error',
            '-select_streams', 'v',
            '-show_entries', 'stream=index',
            '-of', 'csv=p=0',
            $path,
        ]);

        $process->run();

        if (! $process->isSuccessful()) {
            return false;
        }

        return trim($process->getOutput()) !== '';
    }
}
