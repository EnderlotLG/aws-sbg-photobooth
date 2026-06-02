# ── CONFIG ────────────────────────────────────────────────────
$RESEND_API_KEY  = "re_4Di6pMnK_E7UMmXACUGX1SWwL5GAwXEE3"
$FROM_EMAIL      = "onboarding@resend.dev"
$REGION          = "us-east-1"
$FUNCTION_NAME   = "sbg-photobooth-mailer"
$ROLE_ARN        = "arn:aws:iam::128458831723:role/sbg-photobooth-role"
$SRC             = "C:\Users\fdogs\OneDrive\Desktop\Kiro Proyects\Kiosko\lambda\lambda_function.py"
$WORK_DIR        = "C:\sbg_deploy"
$ZIP_PATH        = "$WORK_DIR\function.zip"
# ──────────────────────────────────────────────────────────────

Write-Host "`n[1/4] Copiando y creando ZIP..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $WORK_DIR -Force | Out-Null
Copy-Item $SRC "$WORK_DIR\lambda_function.py" -Force

if (Test-Path $ZIP_PATH) { Remove-Item $ZIP_PATH -Force }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($ZIP_PATH, 'Create')
$null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
    $zip, "$WORK_DIR\lambda_function.py", "lambda_function.py")
$zip.Dispose()

$size = (Get-Item $ZIP_PATH).Length
Write-Host "ZIP creado: $size bytes" -ForegroundColor Green

Write-Host "`n[2/4] Creando Lambda..." -ForegroundColor Cyan
$envVars = "Variables={RESEND_API_KEY=$RESEND_API_KEY,FROM_EMAIL=$FROM_EMAIL}"
aws lambda create-function `
    --function-name $FUNCTION_NAME `
    --runtime python3.12 `
    --role $ROLE_ARN `
    --handler lambda_function.lambda_handler `
    --zip-file "fileb://$ZIP_PATH" `
    --timeout 30 `
    --memory-size 256 `
    --environment $envVars `
    --region $REGION

Write-Host "`n[3/4] Esperando 6s y creando Function URL..." -ForegroundColor Cyan
Start-Sleep -Seconds 6

aws lambda add-permission `
    --function-name $FUNCTION_NAME `
    --statement-id FunctionURLAllowPublicAccess `
    --action lambda:InvokeFunctionUrl `
    --principal "*" `
    --function-url-auth-type NONE `
    --region $REGION

$corsJson = '{"AllowOrigins":["*"],"AllowMethods":["POST","OPTIONS"],"AllowHeaders":["Content-Type"]}'
$corsFile = "$WORK_DIR\cors.json"
[System.IO.File]::WriteAllText($corsFile, $corsJson, [System.Text.Encoding]::ASCII)

aws lambda create-function-url-config `
    --function-name $FUNCTION_NAME `
    --auth-type NONE `
    --cors "file://$corsFile" `
    --region $REGION

Write-Host "`n[4/4] Obteniendo URL..." -ForegroundColor Cyan
$url = aws lambda get-function-url-config `
    --function-name $FUNCTION_NAME `
    --query "FunctionUrl" `
    --output text `
    --region $REGION

Write-Host "`n============================================" -ForegroundColor Magenta
Write-Host "LAMBDA URL: $url" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Magenta
