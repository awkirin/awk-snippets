<?php

namespace App\Commands;

use Illuminate\Support\Arr;
use LaravelZero\Framework\Commands\Command;
use Symfony\Component\Console\Command\Command as CommandAlias;
use Symfony\Component\Console\Input\InputDefinition;
use Symfony\Component\Console\Input\InputOption;

abstract class Base extends Command
{
    protected function initialize(...$args): void
    {
        parent::initialize(...$args);
        $this->clear();
        $this->name();
    }

    function name(): void
    {
        $this->title("$this->name");
    }

    function clear(): void
    {
        $this->output->write("\033\143");
    }

    function addOptionInputDir(): void
    {
        $this->addOption(
            'input-dir',
            'i',
            InputOption::VALUE_REQUIRED,
            'Input directory path',
            null
        );
    }
    function addOptionOutputDir(): void
    {
        $this->addOption(
            'output-dir',
            'o',
            InputOption::VALUE_REQUIRED,
            'Input directory path',
            null
        );
    }
}
