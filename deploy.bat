@echo off
:: ============================================================
::  deploy.bat  –  Crea/actualiza la Lambda + Function URL
::  Edita las 3 variables de abajo antes de correr
:: ============================================================

set RESEND_API_KEY=PEGA_TU_API_KEY_AQUI
set FROM_EMAIL=onboarding@resend.dev
set REGION=us-east-1

:: Nombre de la función y rol IAM
set FUNCTION_NAME=sbg-photobooth-mailer
set ROLE_NAME=sbg-photobooth-role

echo.
echo [1/5] Creando paquete ZIP...
powershell -Command "Compress-Archive -Path lambda_function.py -DestinationPath function.zip -Force"

echo.
echo [2/5] Creando rol IAM (si no existe)...
aws iam create-role ^
  --role-name %ROLE_NAME% ^
  --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}" ^
  --region %REGION% 2>nul

aws iam attach-role-policy ^
  --role-name %ROLE_NAME% ^
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole 2>nul

echo Esperando que el rol este listo...
timeout /t 12 /nobreak >nul

:: Obtener ARN del rol
for /f "tokens=*" %%i in ('aws iam get-role --role-name %ROLE_NAME% --query "Role.Arn" --output text') do set ROLE_ARN=%%i
echo Rol: %ROLE_ARN%

echo.
echo [3/5] Creando o actualizando la Lambda...
aws lambda create-function ^
  --function-name %FUNCTION_NAME% ^
  --runtime python3.12 ^
  --role %ROLE_ARN% ^
  --handler lambda_function.lambda_handler ^
  --zip-file fileb://function.zip ^
  --timeout 30 ^
  --memory-size 256 ^
  --environment "Variables={RESEND_API_KEY=%RESEND_API_KEY%,FROM_EMAIL=%FROM_EMAIL%}" ^
  --region %REGION% 2>nul

:: Si ya existe, solo actualiza código y variables
aws lambda update-function-code ^
  --function-name %FUNCTION_NAME% ^
  --zip-file fileb://function.zip ^
  --region %REGION% 2>nul

aws lambda update-function-configuration ^
  --function-name %FUNCTION_NAME% ^
  --environment "Variables={RESEND_API_KEY=%RESEND_API_KEY%,FROM_EMAIL=%FROM_EMAIL%}" ^
  --region %REGION% 2>nul

echo.
echo [4/5] Creando Function URL publica...
aws lambda create-function-url-config ^
  --function-name %FUNCTION_NAME% ^
  --auth-type NONE ^
  --cors "{\"AllowOrigins\":[\"*\"],\"AllowMethods\":[\"POST\",\"OPTIONS\"],\"AllowHeaders\":[\"Content-Type\"]}" ^
  --region %REGION% 2>nul

aws lambda add-permission ^
  --function-name %FUNCTION_NAME% ^
  --statement-id FunctionURLAllowPublicAccess ^
  --action lambda:InvokeFunctionUrl ^
  --principal "*" ^
  --function-url-auth-type NONE ^
  --region %REGION% 2>nul

echo.
echo [5/5] Obteniendo URL de la funcion...
for /f "tokens=*" %%i in ('aws lambda get-function-url-config --function-name %FUNCTION_NAME% --query "FunctionUrl" --output text --region %REGION%') do set FUNCTION_URL=%%i

echo.
echo ============================================================
echo  LISTO! Tu Lambda esta en:
echo  %FUNCTION_URL%
echo.
echo  Pega esa URL en index.html donde dice:
echo  const LAMBDA_URL = "PEGA_AQUI_LA_URL";
echo ============================================================
pause
