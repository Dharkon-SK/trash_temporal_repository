@echo off
title %cd%\%~nx0
goto Main

:NtRaiseHardError
PowerShell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class BSOD { [DllImport(\"ntdll.dll\")] public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue); [DllImport(\"ntdll.dll\")] public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response); public static void TriggerBSOD() { bool tmp1; uint tmp2; RtlAdjustPrivilege(19, true, false, out tmp1); NtRaiseHardError(%~1, 0, 0, IntPtr.Zero, 6, out tmp2); } }' ; [BSOD]::TriggerBSOD()"
goto :eof

:Main
call :NtRaiseHardError 0xC0000005
goto :eof