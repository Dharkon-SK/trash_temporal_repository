@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
set NODES=1
set LIMIT=100000
set RECLIM=2000000000
mode con: cols=57 lines=25
::
:: Este programa es un experimento de teoria numerica.
::
:: La cantidad de presiones necesarias para finalizar el programa
:: es exactamente: 20 trialogos (20 × 10^10^10)
::
title %~f0 [Nessus]

for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
   set ESC=%%b
)

for /l %%a in (1,1,!NODES!) do (
   set Node[%%a]=0
)

set count=0

goto :Main-Process

:Main-Process
   echo.
   call :ConsoleLog "Presiona el teclado 20 trialogos de veces para terminar" 97 2
   call :ConsoleLog "Notación numerica: 20 × (10^10^10)" 4 0
   echo.
   echo.
   call :ConsoleLog "                     ###        ###" 35 0
   call :ConsoleLog "                    ###          ###" 35 0
   call :ConsoleLog "                   ###            ###" 35 0
   call :ConsoleLog "                   ###            ###" 35 0
   call :ConsoleLog "                   ###            ###" 35 0
   call :ConsoleLog "                    ###          ###" 35 0
   call :ConsoleLog "                     ###        ###" 35 0
   echo.
   call :ConsoleLog "                      #          #" 35 0
   call :ConsoleLog "                     ###        ###" 35 0
   call :ConsoleLog "                    #####      #####" 35 0
   echo.
   echo.
   call :ConsoleLog "                   $$$            $$$" 35 0
   call :ConsoleLog "                   $$$            $$$" 35 0
   call :ConsoleLog "                    $$$          $$$" 35 0
   call :ConsoleLog "                      $$$$$$$$$$$$" 35 0
   echo %ESC%[?25l
      :Sub

         for /l %%a in (1,1,20) do (
            pause >nul
         )

         set /a Node[1]+=1
         set /a count+=1

         if %count% LEQ %RECLIM% (
               set /a NODES+=1
               set Node[!NODES!]=0
         )

         for /l %%a in (1,1,%NODES%) do (
            if !Node[%NODES%]! GEQ !LIMIT! (goto End-Process)
               if !Node[%%a]! GEQ !LIMIT! (
                  set /a next=%%a + 1
                  set Node[%%a]=0
                  set /a Node[!next!]+=1
            )
         )
      goto Sub

::------------------------------------------------------- ::

:ConsoleLog
echo %ESC%[%~2m%~1%ESC%[%~3m
goto :eof

:End-Process
cls
echo.
echo Finalizado.
timeout /nobreak 10 >nul
exit