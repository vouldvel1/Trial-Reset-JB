@echo off
setlocal enabledelayedexpansion

:: Приветствие
echo [35m=============================================[0m
echo.
echo [35mWelcome to JetBrains Product Cleaner![0m
echo.
echo [35m=============================================[0m
echo.
echo Choose a product to clean:
echo.
echo [1] WebStorm
echo [2] IntelliJ IDEA
echo [3] CLion
echo [4] Rider
echo [5] GoLand
echo [6] PhpStorm
echo [7] ReSharper
echo [8] PyCharm
echo [9] All
echo.
set /p choice=Enter your choice (1-9): 

:: Сопоставление продуктов
set "products[1]=webstorm"
set "products[2]=idea"
set "products[3]=clion"
set "products[4]=rider"
set "products[5]=goland"
set "products[6]=phpstorm"
set "products[7]=resharper"
set "products[8]=pycharm"

if "%choice%"=="9" (
    set "selectedProducts=WebStorm IntelliJ CLion Rider GoLand PhpStorm ReSharper PyCharm"
) else (
    set "selectedProducts=!products[%choice%]!"
)

if not defined selectedProducts (
    echo Invalid choice. Exiting.
    pause
    exit /b
)

:: Закрытие процессов
for %%p in (!selectedProducts!) do (
    echo [34mClosing %%p processes...[0m
    taskkill /F /IM %%p64.exe > nul 2>&1
    timeout /t 2 >nul
)

:: Определение продукта
set productList=
set /a index=0
for %%I in (WebStorm IntelliJIdea CLion Rider GoLand PhpStorm Resharper PyCharm) do (
    set /a index+=1
    if "!choice!"=="!index!" set productList=%%I
)

if "!choice!"=="9" (
    set productList=WebStorm IntelliJ CLion Rider GoLand PhpStorm Resharper PyCharm
)

if not defined productList (
    echo Invalid choice. Exiting.
    pause
    exit /b
)

echo [34mCleaning selected products: %productList%[0m

:: Удаление данных
for %%I in (%productList%) do (
    echo [33mDeleting %%I files...[0m
    for /d %%a in ("%USERPROFILE%\.%%I*") do (
        rd /s /q "%%a\config\eval" 2> nul
        del /q "%%a\config\options\other.xml" 2> nul
    )
    
	for /d %%b in ("%APPDATA%\JetBrains\*%%I*") do (
            echo Deleting folder
        	rd /s /q "%%b" 2> nul
    )
    
    rmdir /s /q "%USERPROFILE%\Library\Preferences\.java\.userPrefs" 2> nul
)

:: Удаление глобальных настроек JetBrains
if "!choice!"=="9" (
    echo [33mRemoving global JetBrains settings...[0m
    rmdir /s /q "%APPDATA%\JetBrains" 2> nul
    rmdir /s /q "%USERPROFILE%\Library\Preferences\.java\.userPrefs" 2> nul
)

echo [32mCleanup complete.[0m
pause
