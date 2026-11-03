# Install IIS Web Server and Management Tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Create Custom Application Pool
Import-Module WebAdministration
$appPoolName = "SyscoAppPool"
if (!(Test-Path "IIS:\AppPools\$appPoolName")) {
    New-WebAppPool -Name $appPoolName
    Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value "v4.0"
}

# Set Web Root Directory
$webRoot = "C:\inetpub\wwwroot"

# Create Custom HTML Landing Page
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sysco LABS - Cloud Services Platform</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: #1e293b; border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); text-align: center; max-width: 500px; border: 1px solid #334155; }
        h1 { color: #38bdf8; font-size: 2rem; margin-bottom: 10px; }
        p { color: #94a3b8; font-size: 1.1rem; line-height: 1.6; }
        .status { display: inline-block; padding: 8px 16px; background-color: #10b981; color: white; border-radius: 20px; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Sysco LABS Cloud Platform</h1>
        <p>Automated Enterprise Windows Infrastructure running on AWS EC2 via Terraform & GitHub Actions.</p>
        <div class="status">&#10004; IIS Server Active</div>
    </div>
</body>
</html>
"@

Set-Content -Path "$webRoot\index.html" -Value $htmlContent -Force