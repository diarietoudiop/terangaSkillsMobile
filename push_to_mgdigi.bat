@echo off
echo === Configuration du nouveau depot distant ===
git remote add mgdigi https://github.com/mgdigi/terangaSkillsMobile.git >nul 2>&1
if %errorlevel% neq 0 (
    git remote set-url mgdigi https://github.com/mgdigi/terangaSkillsMobile.git
)

echo.
echo === Creation de la nouvelle branche ===
set /p branch_name="Entrez le nom de la nouvelle branche (ex: correction-mode-sombre) : "

if "%branch_name%"=="" (
    echo Erreur : Le nom de la branche ne peut pas etre vide.
    pause
    exit /b 1
)

git checkout -b %branch_name%

echo.
echo === Envoi du code sur la branche '%branch_name%' de mgdigi ===
git push mgdigi %branch_name%

echo.
echo Termine !
pause
