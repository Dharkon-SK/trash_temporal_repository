@echo off
set Program-Title=%cd%\%~nx0
title %Program-Title%
goto Main-Process

:Get-Screen-Params
   for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get Current%~1Resolution /value') do (set %~2=%%a)
goto :eof

:Apply-Filters
   PowerShell -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class GDI { [DllImport(\"user32.dll\")] public static extern IntPtr GetDC(IntPtr hWnd); [DllImport(\"user32.dll\")] public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC); [DllImport(\"gdi32.dll\")] public static extern IntPtr CreateSolidBrush(uint color); [DllImport(\"gdi32.dll\")] public static extern IntPtr SelectObject(IntPtr hDC, IntPtr hObj); [DllImport(\"gdi32.dll\")] public static extern bool PatBlt(IntPtr hDC, int x, int y, int width, int height, uint rop); [DllImport(\"gdi32.dll\")] public static extern bool DeleteObject(IntPtr hObj); public const uint PATINVERT = 0x005A0049; }'; $hdc = [GDI]::GetDC([IntPtr]::Zero); $color = (%R% -bor (%G% -shl 8) -bor (%B% -shl 16)); $brush = [GDI]::CreateSolidBrush($color); [GDI]::SelectObject($hdc, $brush); [GDI]::PatBlt($hdc, 0, 0, %width%, %height%, [GDI]::PATINVERT); [GDI]::DeleteObject($brush); [GDI]::ReleaseDC([IntPtr]::Zero, $hdc);" >NUL
goto :eof

:Main-Process
   set R=NULL
   set G=NULL
   set B=NULL
   call :Get-Screen-Params Horizontal width
   call :Get-Screen-Params Vertical height
   :[Bucle]
      set /a R=%random% %% 256
      set /a G=%random% %% 256
      set /a B=%random% %% 256
      call :Apply-Filters
   goto [Bucle]