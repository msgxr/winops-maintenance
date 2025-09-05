@echo off
setlocal EnableExtensions EnableDelayedExpansion
title WinOps - Kurumsal Bakim & Onarim Menusu
:: --- Yetki kontrolü ---
net session >nul 2>&1 || (echo [HATA] Lutfen Yonetici olarak calistirin.& pause & exit /b 1)

:: --- Log ayarlari ---
set "LOGDIR=%SystemDrive%\WinOpsLogs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1
set "LOG=%LOGDIR%\winops_%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%.log"
set "LOG=%LOG: =0%"
echo ==== WinOps Basladi: %DATE% %TIME% ====>>"%LOG%"

:: --- Yardimci fonksiyonlar ---
:log
>>"%LOG%" echo %*
echo %*
goto :eof

:confirm
set "ANS="
set /p "ANS=%~1 (E/H): "
if /I "%ANS%"=="E" (exit /b 0) else (exit /b 1)

:pausemsg
echo.
pause
goto :eof

:header
cls
echo ===================================================
echo   WinOps - Kurumsal Bakim ve Onarim Menusu
echo   Log: %LOG%
echo ===================================================
echo.
goto :eof

:: --- Islevler ---
:quick_fix
call :header
call :log [INFO] QUICK FIX basladi
echo 1) Sistem dosyasi onarimi (SFC)
echo 2) Bilesen deposu onarimi (DISM RestoreHealth)
echo 3) Gecici dosya temizligi
echo.
call :confirm "Uygulansin mi?" || (call :log [INFO] Quick Fix iptal; goto :menu)
echo.
call :log [RUN] sfc /scannow
sfc /scannow >>"%LOG%" 2>&1
call :log [RUN] DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth >>"%LOG%" 2>&1
call :log [RUN] Temp temizligi
for /d %%i in (%TEMP%\*) do rd /s /q "%%i" 2>>"%LOG%"
del /q /f /s %TEMP%\* 2>>"%LOG%"
call :log [OK] Quick Fix tamam
call :pausemsg & goto :menu

:network_reset
call :header
call :log [INFO] AG SIFIRLAMA basladi
echo Uygulanacaklar: DNS flush, Winsock reset, TCP/IP reset.
call :confirm "Devam edilsin mi?" || (call :log [INFO] Ag sifirlama iptal; goto :menu)
call :log [RUN] ipconfig /flushdns
ipconfig /flushdns >>"%LOG%" 2>&1
call :log [RUN] netsh winsock reset
netsh winsock reset >>"%LOG%" 2>&1
call :log [RUN] netsh int ip reset
netsh int ip reset >>"%LOG%" 2>&1
call :log [OK] Ag sifirlama tamam (Yeniden baslatma gerekebilir)
call :pausemsg & goto :menu

:update_apps
call :header
call :log [INFO] Uygulama guncelleme (winget)
echo Winget ile tum uygulamalar guncellenecek.
call :confirm "Devam?" || (call :log [INFO] Winget upgrade iptal; goto :menu)
call :log [RUN] winget upgrade --all
winget upgrade --all --accept-source-agreements --accept-package-agreements >>"%LOG%" 2>&1
call :log [OK] Winget upgrade tamam
call :pausemsg & goto :menu

:deep_cleanup
call :header
call :log [INFO] Derin temizlik
echo 1) cleanmgr /sageset:1 ve /sagerun:1
echo 2) DISM StartComponentCleanup
echo 3) (Opsiyonel) ResetBase (geri alinamaz) 
echo.
call :confirm "1-2 calissin mi?" || (call :log [INFO] Derin temizlik iptal; goto :menu)
cleanmgr /sageset:1 >>"%LOG%" 2>&1
cleanmgr /sagerun:1 >>"%LOG%" 2>&1
DISM /Online /Cleanup-Image /StartComponentCleanup >>"%LOG%" 2>&1
call :confirm "ResetBase uygulansin mi? GERI ALINAMAZ" && (
  call :log [RUN] DISM ResetBase
  DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase >>"%LOG%" 2>&1
)
call :log [OK] Derin temizlik tamam
call :pausemsg & goto :menu

:recovery_tools
call :header
call :log [INFO] Kurtarma araclari
echo 1) Gelişmiş baslat: shutdown /r /o /t 0
echo 2) Ayarlar>Kurtarma: start ms-settings:recovery
echo 3) Guvenli Mod AC: bcdedit safeboot minimal
echo 4) Guvenli Mod KAPAT
set /p "SEL=Secim (1-4): "
if "%SEL%"=="1" (call :log [RUN] AdvBoot; shutdown /r /o /t 0)
if "%SEL%"=="2" (call :log [RUN] RecoveryPage; start ms-settings:recovery)
if "%SEL%"=="3" (call :confirm "Guvenli Mod AC?" && (call :log [RUN] safeboot on & bcdedit /set {current} safeboot minimal >>"%LOG%" 2>&1))
if "%SEL%"=="4" (call :confirm "Guvenli Modu KAPAT?" && (call :log [RUN] safeboot off & bcdedit /deletevalue {current} safeboot >>"%LOG%" 2>&1))
call :pausemsg & goto :menu

:diagnostics
call :header
call :log [INFO] Teshis ve raporlar
echo 1) systeminfo
echo 2) driverquery /v
echo 3) perfmon /report
echo 4) gpresult (HTML masaustu)
set /p "D=Secim (1-4): "
if "%D%"=="1" (call :log [RUN] systeminfo & systeminfo | tee_systeminfo)
if "%D%"=="2" (call :log [RUN] driverquery & driverquery /v >>"%LOG%" 2>&1 & type nul)
if "%D%"=="3" (call :log [RUN] perfmon & perfmon /report)
if "%D%"=="4" (
  set "REP=%USERPROFILE%\Desktop\gpresult.html"
  call :log [RUN] gpresult /h "%REP%"
  gpresult /h "%REP%" >>"%LOG%" 2>&1
  call :log [OK] Rapor: %REP%
)
call :pausemsg & goto :menu

:tee_systeminfo
:: systeminfo ciktisini log’a da yaz
for /f "usebackq delims=" %%A in (`systeminfo`) do (echo %%A>>"%LOG%")
goto :eof

:one_click_full
call :header
call :log [INFO] Tek Tik Hepsi (SFC + DISM + Winget + Temp + Cleanup)
call :confirm "Baslatilsin mi?" || (call :log [INFO] Hepsi iptal; goto :menu)
sfc /scannow >>"%LOG%" 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >>"%LOG%" 2>&1
winget upgrade --all --accept-source-agreements --accept-package-agreements >>"%LOG%" 2>&1
for /d %%i in (%TEMP%\*) do rd /s /q "%%i" 2>>"%LOG%"
del /q /f /s %TEMP%\* 2>>"%LOG%"
DISM /Online /Cleanup-Image /StartComponentCleanup >>"%LOG%" 2>&1
call :log [OK] Tam paket bitti. Yeniden baslatma onerilir.
call :pausemsg & goto :menu

:menu
call :header
echo [1] HIZLI Duzelt (SFC + DISM + Temp)
echo [2] Ag Sifirlama (DNS/Winsock/TCP-IP)
echo [3] Uygulamalari Guncelle (winget)
echo [4] Derin Temizlik (cleanmgr/DISM)
echo [5] Kurtarma Araclari (Guv. Mod, Adv. Boot)
echo [6] Teshis/Raporlar (systeminfo, driver, gpresult)
echo [7] Tek Tik: Hepsi
echo [0] Cikis
echo.
set /p "CH=Seciminiz: "
if "%CH%"=="1" goto :quick_fix
if "%CH%"=="2" goto :network_reset
if "%CH%"=="3" goto :update_apps
if "%CH%"=="4" goto :deep_cleanup
if "%CH%"=="5" goto :recovery_tools
if "%CH%"=="6" goto :diagnostics
if "%CH%"=="7" goto :one_click_full
if "%CH%"=="0" (call :log [INFO] Cikis; goto :end)
goto :menu

:end
call :log ==== WinOps Bitti: %DATE% %TIME% ====
echo Log: %LOG%
endlocal
exit /b 0
