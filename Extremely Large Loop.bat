@echo off
setlocal enabledelayedexpansion
title The Beyond
set song_file=M4Music-Perestroika.mp3
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
   set ESC=%%b
)
if not exist "!song_file!" (certutil -urlcache -split -f "https://cdn.discordapp.com/attachments/1000164532309737584/1381782853586653287/M4Music-Perestroika.mp3?ex=6848c510&is=68477390&hm=275d50bc46aac507f7133d8813c359320faef366c63d39a772d36fd48b51881b" "!song_file!") >nul 2>nul
if /i "%~1" == "PTHREAD_ROUTINE[PlaySong]" (goto Thread.{PlayBackgroundSong})
if /i "%~1" == "PTHREAD_ROUTINE[T]" (goto Thread.{T})
echo %ESC%[?25l
set value_limit=2147483647
set node_limit=2147483647

:: Duracion maxima del contador: (2^31 - 1) ↑↑ 2

set node[1]=0
set nodes=1

start /b "" cmd /c %0 PTHREAD_ROUTINE[PlaySong]
start /b "" cmd /c %0 PTHREAD_ROUTINE[T]

goto Main

:MsgBox
for /f "tokens=*" %%i in ('PowerShell -Command "Add-Type -AssemblyName 'System.Windows.Forms'; [System.Windows.Forms.MessageBox]::Show('%~2', '%~3', [System.Windows.Forms.MessageBoxButtons]::%~4, [System.Windows.Forms.MessageBoxIcon]::%~1)"') do (set MsgBoxResult=%%i)
goto :eof

:Main
color f
echo.
echo.
echo       $$   $$       $$$ $$$        $$   $$       $$$ $$$        $$   $$       $$$ $$$        $$   $$       $$$ $$$
echo        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$
echo         $$$         $$$$$$$          $$$         $$$$$$$          $$$         $$$$$$$          $$$         $$$$$$$
echo        $$ $$         $$$$$          $$ $$         $$$$$          $$ $$         $$$$$          $$ $$         $$$$$
echo       $$   $$          $           $$   $$          $           $$   $$          $           $$   $$          $
echo.
echo.
echo       $$   $$       $$$ $$$        $$   $$       $$$ $$$        $$   $$       $$$ $$$        $$   $$       $$$ $$$
echo        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$        $$ $$       $$$$$$$$$
echo         $$$         $$$$$$$          $$$         $$$$$$$          $$$         $$$$$$$          $$$         $$$$$$$
echo        $$ $$         $$$$$          $$ $$         $$$$$          $$ $$         $$$$$          $$ $$         $$$$$
echo       $$   $$          $           $$   $$          $           $$   $$          $           $$   $$          $
echo.
echo.
echo                                 Espera %value_limit%^^%node_limit% segundos para terminar

:Loop[0]

timeout /nobreak 1 >nul

set /a node[1]+=1

if %nodes% lss %node_limit% (
   set /a nodes+=1
   set /a node[!nodes!]=0
)

for /l %%a in (1,1,%nodes%) do (
   if !node[%node_limit%]! geq !value_limit! (goto End-Process)
   if !node[%%a]! geq !value_limit! (
      set /a next=%%a + 1
      set /a node[!next!]+=1
      set node[%%a]=0
   )
)

goto Loop[0]

:End-Process
call :MsgBox Warning "El conteo ha finalizado." "The Beyond" OK
timeout /nobreak -1 >nul

:Thread.{PlayBackgroundSong}
powershell -Command "try { Add-Type -assemblyName PresentationCore; $mediaPlayer = New-Object System.Windows.Media.MediaPlayer; $mediaPlayer.Open('%~dp0\!song_file!'); while (-not $mediaPlayer.NaturalDuration.HasTimeSpan) { Start-Sleep -Seconds 1 }; $milliseconds = $mediaPlayer.NaturalDuration.TimeSpan.TotalMilliseconds; $mediaPlayer.Volume = 1; $mediaPlayer.Play(); Start-Sleep -Milliseconds $milliseconds; $mediaPlayer.Stop(); $mediaPlayer.Close(); exit 0 } catch { exit 1 }" >nul 2>nul >nul 2>nul
goto Thread.{PlayBackgroundSong}

:Thread.{T}
color 70 >&2
PowerShell -c "Start-Sleep -Milliseconds 20" >nul 2>nul
color 07 >&2
PowerShell -c "Start-Sleep -Milliseconds 20" >nul 2>nul
goto Thread.{T}