setlocal
cd %~dp0

if exist deploy rd /S /Q deploy
if exist deploy (
	echo Error clering old "deploy" folder.
	exit /B 1
)


goto start

:build_one
set ENVIRONMENT=%~1
set FOLDER_NAME=%~2
set HASH=unknown
for /F %%H in ('git log "--format=""%%H""" -1 --show-pulls "src"') do set HASH=%%H
for /F %%R in ('git rev-list --count %HASH%') do set CHECKED_REVISION=%%R
echo ##############################################################################################################################################################
mkdir deploy\%FOLDER_NAME%\src\image
robocopy /E src\image\%FOLDER_NAME% deploy\%FOLDER_NAME%\src\image
rem copying the modules
robocopy /E src\module\%FOLDER_NAME% deploy\%FOLDER_NAME%\src
rem copying the solution folder
mkdir deploy\%FOLDER_NAME%\src\solution
robocopy /E src\solution deploy\%FOLDER_NAME%\src\solution

echo if "x%%MT4_ENVIRONMENT%%" == "x%ENVIRONMENT%" call deploy-one.bat %CHECKED_REVISION% "%FOLDER_NAME%" ^& if errorlevel 1 echo Error merging "%FOLDER_NAME%" ^& exit /B 1 >> deploy\deploy-awc-cust.bat
exit /B 0


:start
rem start of bat file
mkdir deploy
mkdir deploy\src

call :build_one Production  AMProduction
call :build_one Quality     AMQuality
call :build_one Integration AMIntegration
call :build_one Training    AMTraining

git rev-list --count HEAD > deploy\jenkins-last-deploy-awc-customizations-git.txt
copy jenkins\deploy-one.bat deploy\
copy jenkins\deploy-awc-cust.bat deploy\
copy jenkins\deploy.bat deploy\

exit /B 0