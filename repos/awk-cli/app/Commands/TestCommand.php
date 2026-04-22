<?php

namespace App\Commands;

use App\Helpers\Video;
use Illuminate\Support\Collection;
use Symfony\Component\Console\Command\Command as CommandAlias;
use Symfony\Component\Finder\Finder;
use Symfony\Component\Finder\SplFileInfo;
use Symfony\Component\Process\Process;

class TestCommand extends Base
{
    protected array $config = [];

    protected Collection $files;

    protected $signature = 'test:test
        {--i|input=./ : Путь к входной директории с видео}
        {--o|output=~/Desktop/output : Путь к выходной директории}
        {--qo|quality : (меньше = лучше качество, 18-28 рекомендуется)}
        {--e|output_extension : Формат выходного файла}
        {--v:c|codec : Формат выходного файла}
        {--y|yes : Пропустить подтверждение}
        {--f|force : Перезаписать существующие файлы}';

    protected $description = 'test';

    public function handle(): int
    {

        $this->task('Загрузка конфигурации', function () {
            $this->config = config('ffmpeg.video');
            foreach ($this->config as $key => $value) {
                $this->options[$key] = $this->options[$key] ?: $this->config[$key];
            }

            $this->options['input'] = realpath($this->options['input']);
            $this->options['output'] = realpath($this->options['output']);
        });

        $this->task('Загрузка файлов', function () {
            $finder = Finder::create();
            $finder->files()->in($this->options['input']);
            $finder->name('/\.(mov|mp4)$/i');
            if (! $finder->hasResults()) {
                $this->error('no input files');

                return CommandAlias::FAILURE;
            }
            $bar = $this->output->createProgressBar($finder->count());
            $bar->start();
            $this->files = collect();
            foreach ($finder as $file) {
                $this->files->add($file);
            }

            return CommandAlias::SUCCESS;
        });

        $this->task('Проверка видео потоков', function () {
            /* @var SplFileInfo $file */
            foreach ($this->files as $file) {
                if (! Video::isVideo($file)) {
                    dump($file);

                    return CommandAlias::FAILURE;
                }
            }

            return CommandAlias::SUCCESS;
        });

        // step confirm
        $this->stepConfirm();

        $this->task('Процесс', function () {
            $bar = $this->output->createProgressBar($this->files->count());
            $bar->start();

            /* @var SplFileInfo $file */
            foreach ($this->files as $file) {
                $extension = $file->getExtension();
                $newExtension = $this->options['output_extension'];
                $name = $file->getBasename(".$extension");
                $newFile = $this->options['output'].DIRECTORY_SEPARATOR."$name.$newExtension";
                $this->command = [
                    'ffmpeg',
                    // '-loglevel', 'error',
                    '-i', $this->options['input'].DIRECTORY_SEPARATOR."$name.$extension",
                    '-c:v', $this->options['codec'],
                    ...match ($this->options['codec']) {
                        'h264_nvenc' => [
                            '-rc', 'vbr',
                            '-cq', $this->options['quality'],
                        ],
                        'libx264', 'libx265' => [
                            '-crf', $this->options['quality'],
                        ],
                        default => throw new \RuntimeException("Unsupported codec: {$this->options['codec']}"),
                    },
                    '-hide_banner',
                    $newFile,
                ];
                if ($this->options['yes']) {
                    $this->command[] = '-y';
                }
                $this->command[] = $newFile;
                $process = new Process($this->command);
                $process->run(function ($type, $buffer) {
                    if ($type === Process::ERR) {
                        echo $buffer;
                    }
                });
                $bar->advance();
            }
            $bar->finish();

            return CommandAlias::SUCCESS;
        });

        return CommandAlias::SUCCESS;
    }
}
