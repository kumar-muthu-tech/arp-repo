@echo off
setlocal EnableExtensions

cd /d "%~dp0.."

set "IMAGE=ap-site:latest"
set "SERVER_USER=root"
set "SERVER_HOST=203.57.85.249"
set "SERVER_PORT=22"
set "SSH_KEY=%USERPROFILE%\.ssh\id_ed25519"
set "ARCHIVE=deploy\ap-site.tar"
set "REMOTE_ARCHIVE=/tmp/ap-site.tar"

if not exist "%SSH_KEY%" (
	echo SSH key not found: %SSH_KEY%
	exit /b 1
)

where npm.cmd >nul 2>&1 || (echo npm.cmd was not found on PATH.& exit /b 1)
where podman >nul 2>&1 || (echo podman was not found on PATH.& exit /b 1)
where ssh >nul 2>&1 || (echo ssh was not found on PATH.& exit /b 1)
where scp >nul 2>&1 || (echo scp was not found on PATH.& exit /b 1)

echo 1/5 Building Astro site...
call npm.cmd run build
if errorlevel 1 exit /b 1

echo 2/5 Building Podman image...
podman compose build
if errorlevel 1 exit /b 1

echo 3/5 Saving image...
if exist "%ARCHIVE%" del /q "%ARCHIVE%"
podman save -o "%ARCHIVE%" "%IMAGE%"
if errorlevel 1 exit /b 1

echo 4/5 Copying image to Ubuntu server...
scp -P %SERVER_PORT% -i "%SSH_KEY%" "%ARCHIVE%" "%SERVER_USER%@%SERVER_HOST%:%REMOTE_ARCHIVE%"
if errorlevel 1 exit /b 1

echo 5/5 Loading and deploying on Ubuntu server...
ssh -p %SERVER_PORT% -i "%SSH_KEY%" "%SERVER_USER%@%SERVER_HOST%" "podman load -i %REMOTE_ARCHIVE%"
if errorlevel 1 exit /b 1
ssh -p %SERVER_PORT% -i "%SSH_KEY%" "%SERVER_USER%@%SERVER_HOST%" "podman rm -f ap-site 2>/dev/null || true"
ssh -p %SERVER_PORT% -i "%SSH_KEY%" "%SERVER_USER%@%SERVER_HOST%" "podman run -d --name ap-site --restart=unless-stopped -p 80:80 ap-site:latest"
if errorlevel 1 exit /b 1
ssh -p %SERVER_PORT% -i "%SSH_KEY%" "%SERVER_USER%@%SERVER_HOST%" "rm -f %REMOTE_ARCHIVE% && podman ps --filter name=ap-site"
if errorlevel 1 exit /b 1

del /q "%ARCHIVE%"
echo Deployment completed successfully.
endlocal
