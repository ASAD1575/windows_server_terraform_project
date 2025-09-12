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

# Add Browsers to Startup (Registry Method)
try {
    Write-Host "Adding browsers to startup via registry."

    if (Test-Path "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") {
        reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Chrome /t REG_SZ /d "`"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`"" /f
        Write-Host "Chrome added to startup."
    }

    if (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") {
        reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Firefox /t REG_SZ /d "`"C:\Program Files\Mozilla Firefox\firefox.exe`"" /f
        Write-Host "Firefox added to startup."
    }

    if (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
        reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Edge /t REG_SZ /d "`"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`"" /f
        Write-Host "Edge added to startup."
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
