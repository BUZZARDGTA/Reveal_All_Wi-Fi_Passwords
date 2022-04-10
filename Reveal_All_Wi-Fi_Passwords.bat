::------------------------------------------------------------------------------
:: NAME
::     Reveal_All_Wi-Fi_Passwords.bat - Reveal All Wi-Fi Passwords
::
:: DESCRIPTION
::     This batch script reveal all Wi-Fi passwords saved in your computer.
::
:: AUTHOR
::     IB_U_Z_Z_A_R_Dl
::
:: CREDITS
::     @Grub4K - Parsing algorithm improvement idea.
::     @Agam - Testing the script on a different computer language region.
::
::     A project created in the "server.bat" Discord: https://discord.gg/GSVrHag
::------------------------------------------------------------------------------
@echo off

setlocal EnableDelayedExpansion

echo:
echo DISCLAIMER: This is NOT a cracking tool.
echo You must have been connected to some Wi-Fi SSID in the past if you want this script to work.
echo:
for %%A in (start_algo SSID password found_password ai_netsh_space) do (
    if defined %%A (
        set %%A=
    )
)
for /f "delims=" %%A in ('2^>nul netsh wlan show profiles') do (
    set "current_line=%%A"
    if "!current_line:~0,1!"=="-" (
        set "current_line=!current_line:~0,-1!"
        if defined current_line (
            call :CHECK_DASH_ONLY current_line && (
                if not defined start_algo (
                    set start_algo=1
                )
            )
        )
    ) else (
        if defined start_algo (
            for /f "tokens=1*delims=:" %%B in ("!current_line!") do (
                if not "%%C"=="" (
                    set "SSID=%%C"
                    >nul 2>&1 netsh wlan show profile "!SSID!" key^=clear || (
                        if not defined ai_netsh_space (
                            set "ai_netsh_space=!SSID:~0,1!"
                        )
                        set "SSID=!SSID:~1!"
                        if defined SSID (
                            >nul 2>&1 netsh wlan show profile "!SSID!" key^=clear || (
                                set SSID=
                            )
                        )
                    )
                    if defined SSID (
                        for %%D in (current_line memory) do (
                            if defined %%D (
                                set %%D=
                            )
                        )
                        set dashline_cn=0
                        for /f "tokens=1*delims=:" %%D in ('2^>nul netsh wlan show profile "!SSID!" key^=clear') do (
                            if "%%E"=="" (
                                set twodots_cn=0
                                set "current_line=%%D%%E"
                                if "!current_line:~0,1!"=="-" (
                                    set "current_line=!current_line:~0,-1!"
                                    if defined current_line (
                                        call :CHECK_DASH_ONLY current_line
                                        if !errorlevel!==0 (
                                            set /a dashline_cn+=1
                                            if !dashline_cn!==4 (
                                                if defined memory (
                                                    if "!memory:~0,1!"=="!ai_netsh_space!" (
                                                        set "password=!memory:~1!"
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            ) else (
                                set /a twodots_cn+=1
                                if !dashline_cn!==3 (
                                    if !twodots_cn! gtr 4 (
                                        set "memory=%%E"
                                    )
                                )
                            )
                        )
                        if defined password (
                            if !dashline_cn!==4 (
                                if !twodots_cn! gtr 4 (
                                    if not defined found_password (
                                        set found_password=1
                                    )
                                    <nul set /p="SSID:!SSID! Password:!password!"
                                    echo:
                                    for %%D in (SSID password dashline_cn twodots_cn) do (
                                        set %%D=
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)
if not defined found_password (
    echo Sorry the script couldn't find your Wi-Fi passwords ... :^(
)

echo:
<nul set /p=Press {ANY KEY} to exit ...
>nul pause
exit /b 0

:CHECK_DASH_ONLY
for /f "delims=-" %%A in ("!%1!") do (
    exit /b 1
)
exit /b 0