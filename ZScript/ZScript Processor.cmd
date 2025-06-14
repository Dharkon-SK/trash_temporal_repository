@echo off
setlocal enabledelayedexpansion
set ZSCRIPT_PROCESSOR=%~f0
title %ZSCRIPT_PROCESSOR%
if exist "%~dp0\ADZP 20 Complex.sys" (
rundll32 "%~dp0\ADZP 20 Complex.sys"
set ValidateZScript=1
) else (
set ValidateZScript=0
)

for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set ZScript[System{ESC}]=%%b
)

set ShutdownPrivilege=0

whoami /groups | find "S-1-16-12288" >nul
if not errorlevel 1 (set ExecutionPrivilege=administrator) else (set ExecutionPrivilege=user)

if exist "%~1" (call :ProcessFile "%~1")
color f

:Starting
echo Procesador de lenguaje ZScript [Version 3.75]
echo Aplicacion creada por Dharkon SK.
:Start
echo.
set /p input="[COMANDO] >>> "
call :Process %input%
goto Start

:ProcessFile
set ValidateZScript=0
set ZSC_FILE_PATH=%~f1
set ZSC_FILE_NAME=%~nx1
set ZSC_WORK_RUTE=%~dp1
title !ZSC_FILE_PATH!
for /f "usebackq delims=" %%a in ("!ZSC_FILE_PATH!") do (call :Process %%a)
exit

:Process
if /i "%~1" == "@Config.Lib" (
if /i "%~2" == "-include" (
if /i "%~3" == "ADZP 20 Complex.sys" (
set ValidateZScript=1
if exist "%~dp0\ADZP 20 Complex.sys" (rundll32 "%~dp0\ADZP 20 Complex.sys") else (exit)
)
)
)
if /i "%ValidateZScript%" == "0" (exit)
if /i "%~1" == "//" (goto :eof)
if /i "%~1" == "import" (
if /i "%~2" == "MS-DOS Batch" (call :ImportBatchFunction %3 %4 %5 %6)
goto :eof
)
if /i "%~1" == "$ZScript.SleepTime" (
timeout /nobreak %~2 >nul
goto :eof
)
if /i "%~1" == "#Zwh.DefineVariable" (
if /i "%~2" == "/input" (set /p %~3="%~4"&goto :eof)
if /i "%~2" == "/a" (set /a %~3=%~4&goto :eof)
set %~2=%~3
goto :eof
)
if /i "%~1" == "$ZScript.WriteLine" (
if /i "%~2" == "" (echo.&goto :eof)
echo %~2
goto :eof
)
if /i "%~1" == "$ZScript.ShellExecute" (call :ExecuteFile "%~2" "%~3"&goto :eof)
if /i "%~1" == "#Zwh.FindDirectory" (
cd /d "%~2" >nul 2>nul
goto :eof
)
if /i "%~1" == "$ZScript.PlaySoundFile" (
if /i "%~2" == "/AudioType" (
if /i "%~3" == "Static[FILE_NAME]" (
if not exist "%~4" (goto :eof)
if /i "%~5" == "{StopDuringMedia}" (
PowerShell -Command "(New-Object Media.SoundPlayer '%~4').PlaySync()" >nul 2>nul
goto :eof
)
)
)
)
if /i "%~1" == "$ZScript.MessageBox" (
call :ShowMsgBox %~2 "%~3" "%~4" %~5
goto :eof
)
if /i "%~1" == "$ZScript.DeleteFile" (
del /f /q "%~2" >nul 2>nul
goto :eof
)
if /i "%~1" == "#Plc.AdminProcess" (
if /i "%~2" == "[KILL_PROCESS]" (
taskkill %~3 "%~4" /f >nul 2>nul
goto :eof
)
)
if /i "%~1" == "@Config.Window" (
if /i "%~2" == "ChangeColor" (color %~3)
if /i "%~2" == "HideConsole" (powershell -ep Bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class WinAPI { [DllImport(\"user32.dll\")] public static extern int ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); }'; $hwnd = [WinAPI]::GetConsoleWindow(); [WinAPI]::ShowWindow($hwnd, 0);")
if /i "%~2" == "ShowConsole" (powershell -ep Bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class WinAPI { [DllImport(\"user32.dll\")] public static extern int ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); }'; $hwnd = [WinAPI]::GetConsoleWindow(); [WinAPI]::ShowWindow($hwnd, 1);")
if /i "%~2" == "AdjustConsole" (mode con: cols=%~3 lines=%~4)
if /i "%~2" == "DefineTitle" (title %~3)
if /i "%~2" == "ClearConsole" (cls)
goto :eof
)
if /i "%~1" == "$ZScript.EncodeFile" (
if /i "%~2" == "-base64" (set encode_type=-encode)
if /i "%~2" == "-hex" (set encode_type=-encodehex)
if /i "%~2" == "-decode64" (set encode_type=-decode)
if /i "%~2" == "-decodehex" (set encode_type=-decodehex)
call :EncodeFile "%~3" "%~4"
goto :eof
)
if /i "%~1" == "$ZScript.RegEdit" (
if /i "%~2" == "-add" (reg add "%~3" /v "%~4" /t %~5 /d "%~6" /f >NUL 2>NUL)
if /i "%~2" == "-delete" (reg delete "%~3" /v "%~4" /f >NUL 2>NUL)
goto :eof
)
if /i "%~1" == "#For" (
call :ForCommand "%~2" "%~3" "%~4" "%~5" "%~6" "%~7"
goto :eof
)
if /i "%~1" == "$ZScript.CreateFile" (
call :CreateFileCommand "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8"
goto :eof
)
if /i "%~1" == "$ZScript.CreateDirectory" (
md "%~2" >NUL 2>NUL
goto :eof
)
if /i "%~1" == "$ZScript.NtRaiseHardError" (
if /i "%~2" == "-StopCode" (
if /i "%~4" == "0" (goto :eof)
if /i "%~4" == "1" (call :NtRaiseHardError %~3)
)
goto :eof
)
if /i "%~1" == "$ZScript.WriteFile" (
if /i "%~2" == "" (goto :eof)
if /i "%~2" == "-Array" (
for /f "delims=:" %%e in ('findstr /n /c:"%~3.OpenFile@{" "%ZSC_FILE_PATH%"') do (
if /i "%~5" == "#NW" (
call :WriteArray "%%e" "%~3" "%~4"
goto :eof
)
if /i "%~5" == "#OV" (
call :OverWriteArray "%%e" "%~3" "%~4"
goto :eof
)
)
)
if /i "%~4" == "#NW" (
echo %~3>>"%~2"
goto :eof
)
if /i "%~4" == "#OV" (
del /f /q "%~2" >NUL 2>NUL
echo %~3>>"%~2"
goto :eof
)
)
if /i "%~1" == "#If" (
call :IfConditional "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8"
goto :eof
)
if /i "%~1" == "$ZScript.Pause" (
pause >nul
goto :eof
)
if /i "%~1" == "$ZScript.RunDll" (
if /i "%~2" == "/Invoke" (
if not exist "%~3" (goto :eof)
if /i "%~4" == "$WINAPI" (
if /i "%~6" == "{NULL}" (
rundll32 "%~3", %~5
goto :eof
)
set zsc[dll_params]=%~6
set zsc[dll_params]=!zsc[dll_params]:'="!
rundll32 "%~3", %~5 !zsc[dll_params]!
goto :eof
) else (goto :eof)
)
rundll32 %~2
goto :eof
)
if /i "%~1" == "$ZScript.AdjustPrivilege" (call :PrivilegeElevate %2 %3 %4)
if /i "%~1" == "$ZScript.ReturnBucle" (
for /f "delims=:" %%e in ('findstr /n /c:"(%~2)" "%ZSC_FILE_PATH%"') do (
call :RepeatSequence %%e
)
goto :eof
)
if /i "%~1" == "#Plc.CallFunction" (
for /f "tokens=3,4,5,6,7" %%a in ('findstr /n /c:"void -%~2-" "%ZSC_FILE_PATH%"') do (
if /i not "%%a" == "" (set %%a=%~3)
if /i not "%%b" == "" (set %%b=%~4)
if /i not "%%c" == "" (set %%c=%~5)
if /i not "%%d" == "" (set %%d=%~6)
if /i not "%%e" == "" (set %%e=%~7)
if /i not "%%f" == "" (set %%f=%~8)
if /i not "%%g" == "" (set %%g=%~9)
)
for /f "delims=:" %%e in ('findstr /n /c:"void -%~2-" "%ZSC_FILE_PATH%"') do (call :RepeatSequenceA %%e)
goto :eof
)
if /i "%~1" == "#Plc.ShutdownWindows" (
if /i "%ShutdownPrivilege%" == "0" (goto :eof)
for /f "tokens=2 delims=[]" %%a in ('echo %~2') do (
if /i "%~3" == "-time" (
if /i "%~5" == "#comment" (shutdown -%%a -t %~4 -c "%~6" >NUL 2>NUL)
shutdown -%%a -t %~4 >NUL 2>NUL
)
shutdown -%%a >NUL 2>NUL
)
goto :eof
)
if /i "%~1" == "#Zwh.CopyFile" (
if /i "%~2" == "-c" (type "%~3" >> "%~4")
if /i "%~2" == "-b" (copy /b "%~3" "%~4" >nul 2>nul)
goto :eof
)
if /i "%~1" == "$ZScript.End" (exit)


if /i "%~1" == "!ZScriptImport[ID{%~1}]!" (

   if /i "!ZScriptImport[ESC_STR{%~1}]!" == "EscStr[Off]" (
      if /i "!ZScriptImport[Silent{%~1}]!" == "true" (
         !ZScriptImport[MS-DOS_Batch{%~1}]! %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 >nul 2>nul
      )
      if /i "!ZScriptImport[Silent{%~1}]!" == "false" (!ZScriptImport[MS-DOS_Batch{%~1}]! %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9)
   )

   if /i "!ZScriptImport[ESC_STR{%~1}]!" == "EscStr[On]" (
      if /i "!ZScriptImport[Silent{%~1}]!" == "true" (
         !ZScriptImport[MS-DOS_Batch{%~1}]! %2 %3 %4 %5 %6 %7 %8 %9 >nul 2>nul
      )
      if /i "!ZScriptImport[Silent{%~1}]!" == "false" (!ZScriptImport[MS-DOS_Batch{%~1}]! %2 %3 %4 %5 %6 %7 %8 %9)
      )
   )

goto :eof

:ExecuteFile
setlocal
set file_name=%~1
set run_params=%~2
set run_params=!run_params:'="!
set run_params=!run_params:`='!
if exist "!file_name!" (
if /i "!run_params!" == "" (start "" "!file_name!") else (start "" "!file_name!" !run_params!)
)
endlocal
goto :eof

:ImportBatchFunction
%~2 /? >nul 2>&1
if not errorlevel 9009 (
set ZScriptImport[ID{%~1}]=%~1
set ZScriptImport[MS-DOS_Batch{%~1}]=%~2
set ZScriptImport[ESC_STR{%~1}]=%~3
set ZScriptImport[Silent{%~1}]=%~4
)
goto :eof

:ForCommand
for /f "delims=:" %%e in ('findstr /n /c:"ScriptingBucle.(%~2)" "%ZSC_FILE_PATH%"') do (
set "zsc[line]=%%e"
)
if /i "%~3" == "/f" (
for /f %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/l" (
for /l %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/r" (
for /r "%~1" %%a in (%~5) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/d" (
for /d %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
goto :eof

:CreateFileCommand
if /i "%~2" == "[CREATE_NEW]" (
if not exist "%~1" (
echo off>"%~1"
)
)
if /i "%~2" == "[MODIFY_ATTRIBUTES]" (
if not exist "%~1" (
attrib %~3 %~4 %~5 %~6 %~7 "%~1" >nul 2>nul
)
)
if /i "%~2" == "[RENAME_FILE]" (
ren "%~1" "%~3" >NUL 2>NUL
)
)
if /i "%~2" == "[ZERO_BYTES]" (
if exist "%~1" (
echo off>"%~1"
)
)
goto :eof

:ShowMsgBox
for /f "tokens=*" %%i in ('PowerShell -Command "Add-Type -AssemblyName 'System.Windows.Forms'; [System.Windows.Forms.MessageBox]::Show('%~2', '%~3', [System.Windows.Forms.MessageBoxButtons]::%~4, [System.Windows.Forms.MessageBoxIcon]::%~1)"') do (set MsgBoxResult=Zsc%%i)
goto :eof

:EncodeFile
if not exist "%~1" (goto :eof)
certutil %encode_type% "%~1" "%~2" >nul 2>nul
goto :eof

:RepeatSequence
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
call :Process %%i
)
goto :eof

:RepeatSequenceA
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
if /i "%%i" == "@System.EndSub" (goto :eof)
call :Process %%i
)
goto :eof

:RepeatSequenceB
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
if /i "%%i" == "@System.EndBuc" (goto :eof)
call :Process %%i
)
goto :eof

:ImportSubProcess
set ExecutableFileName=%~1
set Params=%~2
if "!Params!" == "" rem else (set Params=!Params:'="!)
if exist "!ExecutableFileName!" (
if /i "!Params!" == "" (call "!ExecutableFileName!") else (call "!ExecutableFileName!" !Params!)
) else (goto :eof)
endlocal
goto :eof

:WriteArray
for /f "skip=%~1 delims=" %%i in (%ZSC_FILE_PATH%) do (
if /i "%%i" == "}@%~2.CloseFile" (goto :eof)
if /i "%%i" == "" (echo. >>"%~3") else (echo %%i>>"%~3")
)
goto :eof

:OverWriteArray
echo off>"%~3"
for /f "skip=%~1 delims=" %%i in (%ZSC_FILE_PATH%) do (
if /i "%%i" == "}@%~2.CloseFile" (goto :eof)
if /i "%%i" == "" (echo. >>"%~3") else (echo %%i>>"%~3")
)
goto :eof

:IfConditional
if /i "%~1" == "File.Exists" (
if exist "%~2" (
if /i "%~3" == "then" (
for /f "delims=" %%a in ("%~4") do (
set line=%%a
set line=!line:'="!
set line=!line:`='!
call :Process !line!
goto :eof
)
)
) else (goto :eof)
goto :eof
)
if /i "%~1" == "File.NoExists" (
if not exist "%~2" (
if /i "%~3" == "then" (
for /f "delims=" %%a in ("%~4") do (
set line=%%a
set line=!line:'="!
set line=!line:`='!
call :Process !line!
goto :eof
)
)
) else (goto :eof)
goto :eof
)
if /i "%~1" == "/s" (
if /i "%~2" %~3 "%~4" (
if /i "%~5" == "then" (
for /f "delims=" %%a in ("%~6") do (
set line=%%a
set line=!line:'="!
set line=!line:`='!
call :Process !line!
goto :eof
)
) else (goto :eof)
)
goto :eof
)
if /i "%~1" == "/n" (
if %~2 %~3 %~4 (
if /i "%~5" == "then" (
for /f "delims=" %%a in ("%~6") do (
set line=%%a
set line=!line:'="!
set line=!line:`='!
call :Process !line!
goto :eof
)
) else (goto :eof)
)
goto :eof
)
goto :eof

:PrivilegeElevate
if /i "%~1" == "ADMINISTRATOR_PRIVILEGE_LEVEL" (
if /i "%~2" == "0" (goto :eof)
if /i "%~2" == "1" (
whoami /groups | find "S-1-16-12288" >nul
if not errorlevel 1 (goto :eof) else (
PowerShell -ep Bypass -nol -nop -noni -c "Start-Process 'cmd.exe' -ArgumentList '/c', '%ZSC_FILE_PATH%' -Verb runAs" >nul 2>nul
goto :eof
)
)
)
if /i "%~1" == "SE_SHUTDOWN_PRIVILEGE_LEVEL" (
if /i "%~2" == "0" (goto :eof)
if /i "%~2" == "1" (set ShutdownPrivilege=1&goto :eof)
)
goto :eof

:NtRaiseHardError
if /i "%ShutdownPrivilege%" == "0" (goto :eof)
PowerShell -ep Bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class BSOD { [DllImport(\"ntdll.dll\")] public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue); [DllImport(\"ntdll.dll\")] public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response); public static void TriggerBSOD() { bool tmp1; uint tmp2; RtlAdjustPrivilege(19, true, false, out tmp1); NtRaiseHardError(%~1, 0, 0, IntPtr.Zero, 6, out tmp2); } }' ; [BSOD]::TriggerBSOD()"
goto :eof