@echo off
setlocal enabledelayedexpansion

set "input_dir=."       & rem Папка с исходными файлами
set "output_dir=output" & rem Подпапка для результатов
set "crf=28"            & rem Уровень сжатия (18-30, меньше=качественнее)
set "max_size=1280"     & rem 1280 Максимальный размер по ширине/высоте

mkdir "%output_dir%" 2>nul

for %%i in ("%input_dir%\*.*") do (
    ffmpeg -i "%%i" ^
    -vf "scale='if(gt(iw,ih),min(iw,%max_size%),-1)':'if(gt(ih,iw),min(ih,%max_size%),-1)',format=yuv420p" ^
    -crf %crf% ^
	-y ^
    "%output_dir%\%%~ni.mp4"
)
echo Конвертация завершена!
pause