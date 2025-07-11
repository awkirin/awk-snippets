$host.ui.RawUI.WindowTitle = "Установка PHP - НЕ ЗАКРЫВАТЬ"
[Console]::TreatControlCAsInput = $true

# Проверка и запрос прав администратора
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
}

$phpVersions = @(
    "7.4.33",
    "8.0.30",
    "8.1.31",
    "8.2.27",
    "8.3.15"
)

foreach ($version in $phpVersions) {
    Write-Host "Установка PHP версии $version..."
    choco install php --version $version -y
}

choco upgrade php -y

Write-Host "Установка всех версий PHP завершена."