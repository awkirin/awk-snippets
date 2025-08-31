@echo off
setlocal enabledelayedexpansion

set "output_file=file_sizes.csv"
set "input_dir=input"
set "output_dir=output"

echo "Filename";"Input Size (MB)";"Output Size (MB)";"Size Difference (MB)";"Status" > "%output_file%"

if not exist "%input_dir%" (
    echo Error: Directory "%input_dir%" does not exist!
    goto :end
)

if not exist "%output_dir%" (
    echo Error: Directory "%output_dir%" does not exist!
    goto :end
)

echo Processing files...
for %%f in ("%input_dir%\*.*") do (
    set "filename=%%~nf"
    set "ext=%%~xf"
    set "fullname=!filename!!ext!"
    
    for %%i in ("%%f") do set "input_size_bytes=%%~zi"
    
    rem Convert input size to MB with decimal places
    set /a "input_int=!input_size_bytes! / 1048576"
    set /a "input_frac=!input_size_bytes! * 1000 / 1048576 - !input_int! * 1000"
    set "input_size_mb=!input_int!.!input_frac!"
    
    if exist "%output_dir%\!fullname!" (
        for %%o in ("%output_dir%\!fullname!") do set "output_size_bytes=%%~zo"
        
        rem Convert output size to MB with decimal places
        set /a "output_int=!output_size_bytes! / 1048576"
        set /a "output_frac=!output_size_bytes! * 1000 / 1048576 - !output_int! * 1000"
        set "output_size_mb=!output_int!.!output_frac!"
        
        rem Calculate difference
        set /a "size_diff_bytes=!output_size_bytes!-!input_size_bytes!"
        set /a "diff_int=!size_diff_bytes! / 1048576"
        set /a "diff_frac=!size_diff_bytes! * 1000 / 1048576 - !diff_int! * 1000"
        if !diff_frac! lss 0 set /a "diff_frac=!diff_frac! * -1"
        if !size_diff_bytes! lss 0 set "diff_sign=-" else set "diff_sign="
        set "size_diff_mb=!diff_sign!!diff_int!.!diff_frac!"
        
        set "status=OK"
        
        echo "!fullname!";!input_size_mb!;!output_size_mb!;!size_diff_mb!;"!status!" >> "%output_file%"
    ) else (
        set "output_size_mb=N/A"
        set "size_diff_mb=N/A"
        set "status=MISSING"
        
        echo "!fullname!";!input_size_mb!;"!output_size_mb!";"!size_diff_mb!";"!status!" >> "%output_file%"
    )
)

echo.
echo Comparison completed!
echo Results saved to: %output_file%
echo Sizes are displayed in megabytes (MB) with decimal precision
echo.
echo CSV file uses semicolon delimiter for better Excel compatibility.

:end
pause
