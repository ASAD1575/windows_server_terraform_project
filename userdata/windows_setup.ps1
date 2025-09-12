# Enable WinRM and configure the firewall to allow inbound connections
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*"
Enable-PSRemoting -Force
New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Protocol TCP -Action Allow -LocalPort 5985
New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Protocol TCP -Action Allow -LocalPort 5986

# Define a function for handling installation with error handling and cleanup
function Install-Browser {
    param (
        [string]$installerUrl,
        [string]$installerPath,
        [string]$installerArgs
    )

    try {
        # Download the installer
        Write-Host "Downloading installer from: $installerUrl"
        Invoke-WebRequest $installerUrl -OutFile $installerPath -ErrorAction Stop
        Write-Host "Installer downloaded successfully."

        # Install the browser
        Write-Host "Installing the browser..."
        Start-Process $installerPath -ArgumentList $installerArgs -Wait -ErrorAction Stop
        Write-Host "Installation completed successfully."
    }
    catch {
        Write-Host "Error during installation: $_"
    }
    finally {
        # Cleanup: Remove the installer after installation
        if (Test-Path $installerPath) {
            Write-Host "Cleaning up: Removing installer."
            Remove-Item $installerPath -Force
        }
    }
}

# Install Chrome
$chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$chromeInstallerPath = "C:\Windows\Temp\chrome_installer.exe"
Install-Browser -installerUrl $chromeInstallerUrl -installerPath $chromeInstallerPath -installerArgs "/silent /install"

# Install Firefox
$firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
$firefoxInstallerPath = "C:\Windows\Temp\firefox_installer.exe"
Install-Browser -installerUrl $firefoxInstallerUrl -installerPath $firefoxInstallerPath -installerArgs "-ms"

# Install Edge
$edgeInstallerUrl = "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/EdgeInstaller.exe"
$edgeInstallerPath = "C:\Windows\Temp\edge_installer.exe"
Install-Browser -installerUrl $edgeInstallerUrl -installerPath $edgeInstallerPath -installerArgs "/silent /install"

# Add Browsers to Startup
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
try {
    Write-Host "Adding browsers to startup."

    # Ensure Chrome exists before adding to startup
    if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
        Copy-Item "C:\Program Files\Google\Chrome\Application\chrome.exe" "$startupFolder\chrome.lnk" -Force
        Write-Host "Chrome added to startup."
    }
    else {
        Write-Host "Chrome was not found. Skipping..."
    }

    # Ensure Firefox exists before adding to startup
    if (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") {
        Copy-Item "C:\Program Files\Mozilla Firefox\firefox.exe" "$startupFolder\firefox.lnk" -Force
        Write-Host "Firefox added to startup."
    }
    else {
        Write-Host "Firefox was not found. Skipping..."
    }

    # Ensure Edge exists before adding to startup
    if (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
        Copy-Item "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "$startupFolder\edge.lnk" -Force
        Write-Host "Edge added to startup."
    }
    else {
        Write-Host "Edge was not found. Skipping..."
    }

    Write-Host "Browsers added to startup successfully."
}
catch {
    Write-Host "Error adding browsers to startup: $_"
}

# Mark the installation as complete by creating a flag file
$flagFilePath = "C:\Windows\Temp\install_complete.flag"
New-Item -Path $flagFilePath -ItemType "File" -Force
Write-Host "Installation complete flag created at: $flagFilePath"
