@echo off
setlocal enabledelayedexpansion
title %~f0

set value_limit=2
set node_limit=402653184

set node[1]=0
set nodes=1

goto Main

:Main
color f
echo
echo Espera por ƒω(3) segundos...

:Loop[0]

for /l %%x in (1,1,402653184) do (
   timeout /nobreak 1 >nul
)

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
echo.
echo Proceso finalizado.
echo Presiona una tecla para cerrar esta ventana
pause >nul
exit