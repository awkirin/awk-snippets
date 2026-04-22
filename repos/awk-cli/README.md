# Install / Update
## OSX
```bash
  mkdir -p ~/bin && curl -L https://github.com/awkirin/awk-awkwrap/releases/download/latest/awkwrap -o ~/bin/awkwrap && chmod +x ~/bin/awkwrap
```
## win
```powershel
$binPath = "$env:USERPROFILE\bin"

# Создать папку если не существует
if (!(Test-Path $binPath)) {
    New-Item -ItemType Directory -Path $binPath
}

# Скачать файл
$url = "https://github.com/awkirin/awk-awkwrap/releases/download/latest/awkwrap"
$output = "$binPath\awkwrap.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "Файл успешно скачан: $output" -ForegroundColor Green
} catch {
    Write-Host "Ошибка при скачивании: $_" -ForegroundColor Red
}
```

Qqqq
```bash

  composer global config repositories.awk-awkwrap vcs https://github.com/awkirin/awk-awkwrap
  composer global require awkirin/awkwrap:dev-dev -W

  awkwrap completion zsh > "${HOME}/.oh-my-zsh/custom/completion-awkwrap.zsh" && rm -f ${HOME}/.zcompdump* | true && exec zsh
    
```

install dev
```bash
  echo 'alias awkwrap="'${PWD}'/awkwrap"' > "${HOME}/.oh-my-zsh/custom/dev-awkwrap.zsh"
```
