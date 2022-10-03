@echo off& CD /D %~DP0
>NUL 2>&1 reg.exe query "HKU\S-1-5-19" || (
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
    ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
    "%TEMP%\Getadmin.vbs"
    DEL /f /q "%TEMP%\Getadmin.vbs" 2>NUL
    Exit /b
)
title 通用的软件删除工具
setlocal EnableDelayedExpansion
rem 下方输入软件目录名，不支持带空格路径
set appname=inotepad
 
echo 反注册%appname% dll
cd /d %appdata%\%appname%\ 2>nul
if %errorlevel%==0 (
 for /r %%i in (*.dll) do (
  findstr /c:"DllRegisterServer" "%%i" >nul
  if !errorlevel! neq 1 (
   regsvr32 /s /u "%%i"
  )
 )
)
 
cd /d %ProgramFiles% (x86)\%appname% 2>nul
if %errorlevel%==0 (
 for /r %%i in (*.dll) do (
  findstr /c:"DllRegisterServer" "%%i" >nul
  if !errorlevel! neq 1 (
   regsvr32 /s /u "%%i"
  )
 )
)
 
cd /d %ProgramFiles%\%appname% 2>nul
if %errorlevel%==0 (
 for /r %%i in (*.dll) do (
  findstr /c:"DllRegisterServer" "%%i" >nul
  if !errorlevel! neq 1 (
   regsvr32 /s /u "%%i"
  )
 )
)
cd /d %~dp0
echo 结束%appname%相关进程
wmic process where "(ExecutablePath like '%%%appname%%%')" call Terminate
echo.
echo 重命名%appname%目录为%appname%_bak
ren "%appdata%\%appname%" %appname%_bak 2>nul
ren "%ProgramFiles%\%appname%" %appname%_bak 2>nul
ren "%ProgramFiles% (x86)\%appname%" %appname%_bak 2>nul
echo. 
echo 结束资源管理器进程explorer.exe释放%appname%运行中的dll
taskkill /f /im explorer.exe
echo.
echo 删除%appname%_bak目录
rd /s /q "%appdata%\%appname%_bak" 2>nul
rd /s /q "%ProgramFiles%\%appname%_bak" 2>nul
rd /s /q "%ProgramFiles% (x86)\%appname%_bak" 2>nul
echo.
echo 重启资源管理器
start explorer.exe
echo.
echo 如果资源管理器没启动，白屏或黑屏，可以手动按组合键ctrl+alt+delete打开任务管理器。
echo 打开任务管理器后，点文件，弹出菜单第一个运行新任务，输入explorer.exe打开或重启电脑。
echo.
pause