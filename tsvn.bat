@rem TortoiseSVN command line client wrapper
@rem
@rem This is a wrapper around the 'tortoiseproc' executable. The invocation is
@rem compatible to the 'svn' command line client.

@echo off
setlocal

rem No arguments given on command line -> print usage and quit
if "%1" == "" (
	echo usage: %0 ^<command^> [PATH...]
	echo TortoiseSVN command-line client wrapper.
	echo.
	echo Available subcommands:
	echo    blame (praise, annotate, ann^)
	echo    diff (di^)
	echo    help (?, h^)
	echo    list (ls^)
	echo    log
	echo    proplist (plist, pl^)
	echo    status (stat, st^)
	exit /B 0
)

rem command mapping for tortoiseproc
if "%1" == "blame"       set TORTOISECMD=blame
if "%1" == "praise"      set TORTOISECMD=blame
if "%1" == "annotate"    set TORTOISECMD=blame
if "%1" == "ann"         set TORTOISECMD=blame

if "%1" == "diff"        set TORTOISECMD=diff
if "%1" == "di"          set TORTOISECMD=diff

if "%1" == "help"        set TORTOISECMD=help
if "%1" == "?"           set TORTOISECMD=help
if "%1" == "h"           set TORTOISECMD=help

if "%1" == "list"        set TORTOISECMD=repobrowser
if "%1" == "ls"          set TORTOISECMD=repobrowser

if "%1" == "log"         set TORTOISECMD=log

if "%1" == "proplist"    set TORTOISECMD=properties
if "%1" == "plist"       set TORTOISECMD=properties
if "%1" == "pl"          set TORTOISECMD=properties

if "%1" == "status"      set TORTOISECMD=repostatus
if "%1" == "stat"        set TORTOISECMD=repostatus
if "%1" == "st"          set TORTOISECMD=repostatus

rem Unknown subcommand -> abort
if "%TORTOISECMD%" == "" (
	echo Unknown subcommand: '%1'
	echo Type '%0' for usage.
	exit /B 1
)

rem Shift away %1 (tsvn.bat subcommand) for parameter parsing
shift

rem Parse parameters
:parse
if "%1" == "" goto endparse

rem Concatenate path names using the asterisk character '*' as path separator
set TORTOISEPATH=%TORTOISEPATH%%1*

shift
goto parse
:endparse

rem Adapt path parameter for tortoiseproc
if "%TORTOISEPATH%" == "" (
	rem No path parameter given on command line -> use the current directory '.' as default
	set TORTOISEPATH=.
) else (
	rem Remove trailing asterisk
	set TORTOISEPATH=%TORTOISEPATH:~0,-1%
)

echo on
start tortoiseproc /command:%TORTOISECMD% /path:"%TORTOISEPATH%"
