<?php

return [
    'binaries' => env('FFMPEG_BINARIES', 'ffmpeg'),
    'threads' => 12,   // set to false to disable the default 'threads' filter
    'video' => [
        // cpu:libx264 | gpu nvidia:h264_nvenc
        'codec' => env('FFMPEG_VIDEO_CODEC', 'libx264'),
        'quality' => env('FFMPEG_VIDEO_QUALITY', 40),
        'output_extension' => env('FFMPEG_VIDEO_OUTPUT_EXTENSION', 'mp4'),
    ],
];
