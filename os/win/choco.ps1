#choco install tor --source="C:\Users\awkirin\YandexDisk\projects\ansible\win\chocolatey\tor" -y

#choco install jetbrainstoolbox -y --proxy="http://localhost:9080"

#choco install tor-browser -y --proxy="http://localhost:9080"

#choco install gimp -y --proxy="http://localhost:9080"

#choco install php -y --version=7.4.33
#choco install php -y --version=8.0.30
#choco install php -y --version=8.1.31
#choco install php -y --version=8.2.27
#choco install php -y --version=8.3.15
#choco upgrade php -y

#choco install googlechrome -y
#choco install firefox -y

#choco install vlc -y
#choco install notepadplusplus -y
#choco install git -y
#choco install vscode -y


function InstallToolWordpress {
    # Задаем переменные
    $download_url = "https://wordpress.org/latest.zip"
    $local_path = "C:\tools\wordpress.zip"
    $extract_path = "C:\tools"

    $folderPath = "C:\tools\wordpress"
    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse -Force
    }

    # Скачиваем архив
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($download_url, $local_path)

    # Распаковываем архив
    Expand-Archive -Force -Path $local_path -DestinationPath $extract_path

    # Удаляем архив
    Remove-Item $local_path
}
#InstallToolWordpress

function InstallToolTranslumo {
    # Задаем переменные
    $download_url = "https://github.com/Danily07/Translumo/releases/download/v.0.9.6/Translumo-v.0.9.6.zip"
    $local_path = "C:\tools\translumo.zip"
    $extract_path = "C:\tools\translumo"

    $folderPath = "C:\tools\translumo"
    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse -Force
    }

    # Скачиваем архив
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($download_url, $local_path)

    # Распаковываем архив
    Expand-Archive -Force -Path $local_path -DestinationPath $extract_path

    # Удаляем архив
    Remove-Item $local_path
}
#InstallToolTranslumo


composer global require wp-cli/wp-cli-bundle
