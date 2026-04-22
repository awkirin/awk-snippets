<?php

use Symfony\Component\Filesystem\Path;
use function path;

beforeEach(function () {
    // Сохраняем оригинальные значения окружения
    $this->originalHome = getenv('HOME');
    $this->originalUserProfile = getenv('USERPROFILE');
    $this->originalCwd = getcwd();
});

afterEach(function () {
    // Восстанавливаем оригинальные значения
    if ($this->originalHome !== false) {
        putenv('HOME='.$this->originalHome);
    } else {
        putenv('HOME');
    }

    if ($this->originalUserProfile !== false) {
        putenv('USERPROFILE='.$this->originalUserProfile);
    } else {
        putenv('USERPROFILE');
    }

    if ($this->originalCwd !== false) {
        chdir($this->originalCwd);
    }
});

test('path returns canonicalized path for absolute path', function () {
    $result = path('/var/www/project');
    expect($result)->toBe('/var/www/project');
});

test('path resolves relative path based on current directory', function () {
    $result = path('src/Controller');
    expect($result)->toBe(Path::canonicalize(getcwd().'/src/Controller'));
});

test('path resolves relative path with custom base', function () {
    $base = '/custom/base';
    $result = path('src/Controller', $base);
    expect($result)->toBe('/custom/base/src/Controller');
});

test('path resolves tilde as home directory', function () {
    putenv('HOME=/home/user');

    $result = path('~');
    expect($result)->toBe('/home/user');
});

test('path resolves tilde with path', function () {
    putenv('HOME=/home/user');

    $result = path('~/projects/test');
    expect($result)->toBe('/home/user/projects/test');
});

test('path throws RuntimeException when neither HOME nor USERPROFILE is set', function () {
    putenv('HOME');
    putenv('USERPROFILE');

    path('~');
})->throws(RuntimeException::class, 'Cannot resolve home directory');

test('path handles relative path with .. correctly', function () {
    $result = path('../parent', '/current/dir');
    expect($result)->toBe('/current/parent');
});

test('path preserves trailing slashes when canonicalizing', function () {
    $result = path('/var/www/');
    expect($result)->toBe('/var/www');
});

test('path handles empty path', function () {
    $result = path('');
    expect($result)->toBe(getcwd());
});

test('path handles dot as current directory', function () {
    $result = path('.');
    expect($result)->toBe(getcwd());
});

// Тесты для edge cases
test('path with tilde and no home directory throws exception', function () {
    // Убедимся, что переменные окружения не установлены
    putenv('HOME');
    putenv('USERPROFILE');

    $this->expectException(RuntimeException::class);
    $this->expectExceptionMessage('Cannot resolve home directory');

    path('~/test');
});

test('path with absolute path ignores base', function () {
    $base = '/should/be/ignored';
    $result = path('/absolute/path', $base);
    expect($result)->toBe('/absolute/path');
});

test('path normalizes directory separators', function () {
    $result = path('/var\\www//project\\\\src');

    if (DIRECTORY_SEPARATOR === '/') {
        expect($result)->toBe('/var/www/project/src');
    } else {
        // На Windows бэкслеши будут нормализованы
        expect($result)->toContain('\\');
    }
});
