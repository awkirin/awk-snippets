<?php

use Symfony\Component\Filesystem\Path;

function path(string $path, ?string $base = null): string
{
    if ($path === '~' || str_starts_with($path, '~/')) {
        $home = getenv('HOME')
            ?: getenv('USERPROFILE')
                ?: throw new RuntimeException('Cannot resolve home directory');

        $path = $home.substr($path, 1);
    }

    $base ??= getcwd();

    if (! Path::isAbsolute($path)) {
        $path = Path::makeAbsolute($path, $base);
    }

    return Path::canonicalize($path);
}
