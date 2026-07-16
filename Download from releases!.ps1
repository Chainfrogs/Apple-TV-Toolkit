Clear-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "          SCANNING LOCAL NETWORK FOR APPLE TVS     " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Start scanning with a progress bar in the background
$Percent = 0
$Devices = @()
$ScanScript = [scriptblock]{ python -W ignore -m pyatv.scripts.atvremote scan }
$PowerShell = [powershell]::Create().AddScript($ScanScript)
$AsyncResult = $PowerShell.BeginInvoke()

for ($i = 0; $i -lt 20; $i++) {
    if ($AsyncResult.IsCompleted) { break }
    $Percent += 5
    Write-Progress -Activity "Searching Local Network..." -Status "Scanning for Apple TVs... ($Percent%)" -PercentComplete $Percent
    Start-Sleep -Milliseconds 200
}
Write-Progress -Activity "Searching Local Network..." -Completed

# Fetch the raw text lines cleanly and cast them directly to plain strings
$ScanResult = $PowerShell.EndInvoke($AsyncResult) | ForEach-Object { "$_".ToString() }
$PowerShell.Dispose()

# Safe string parsing that completely avoids the $Matches Hashtable bug
if ($ScanResult) {
    $TempName = ""
    foreach ($Line in $ScanResult) {
        $CleanLine = $Line.Trim()
        
        if ($CleanLine.StartsWith("Name:")) {
            $TempName = $CleanLine.Replace("Name:", "").Split(',').Trim()
        }
        if ($CleanLine.StartsWith("Address:")) {
            $TempIP = $CleanLine.Replace("Address:", "").Trim()
            if ($TempName -and $TempIP) {
                $Devices += [PSCustomObject]@{ Name = $TempName; IP = $TempIP }
                $TempName = ""
            }
        }
    }
}

# Device Selection Menu
$IP = ""
if ($Devices.Count -eq 0) {
    Write-Host "No Apple TVs discovered automatically on your network." -ForegroundColor Yellow
    Write-Host ""
    $IP = Read-Host "Please enter Apple TV IP manually (e.g., 192.168.1.24)"
} else {
    Write-Host "Found the following Apple TVs on your network:" -ForegroundColor Green
    for ($i = 0; $i -lt $Devices.Count; $i++) {
        Write-Host "  $($i + 1)) $($Devices[$i].Name) ($($Devices[$i].IP))"
    }
    Write-Host "  $($Devices.Count + 1)) Enter IP manually..."
    Write-Host ""
    $DeviceChoice = Read-Host "Select a device (1-$($Devices.Count + 1))"
    if ($DeviceChoice -eq ($Devices.Count + 1) -or [string]::IsNullOrEmpty($DeviceChoice)) {
        $IP = Read-Host "Enter IP manually"
    } else {
        $IP = $Devices[[int]$DeviceChoice - 1].IP
    }
}

if ([string]::IsNullOrEmpty($IP)) { Write-Host "No IP provided. Exiting..." -ForegroundColor Red; Start-Sleep -Seconds 2; exit }

# STARTING THE LYNRASK BACKGROUND STREAM FOR THE ENTIRE SCRIPT
$psi = New-Object System.Diagnostics.ProcessStartInfo -Property @{
    FileName = "python"; Arguments = "-W ignore -m pyatv.scripts.atvremote --address $IP cli"
    RedirectStandardInput = $true; RedirectStandardOutput = $true; UseShellExecute = $false; CreateNoWindow = $true
}
$proc = [System.Diagnostics.Process]::Start($psi)
Start-Sleep -Milliseconds 800

function Run-FastCmd ($Cmd) {
    $proc.StandardInput.WriteLine($Cmd)
}

# --- MAIN MENU (DOWNWARDS LAYER) ---
do {
    Clear-Host
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "    APPLE TV LYNRAST PRO CONTROL PANEL ($IP)       " -ForegroundColor Cyan
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "  1) Pause playback"
    Write-Host "  2) Resume playback (Play)"
    Write-Host "  3) HARD HYPER FREEZE LOOP"
    Write-Host "  4) Type text (Input hijack)"
    Write-Host "  5) Stream audio file (AirPlay Cast)"
    Write-Host "  6) Start Screensaver"
    Write-Host "  7) Volume UP (+)"
    Write-Host "  8) Volume DOWN (-)"
    Write-Host "  9) Mute / Unmute audio"
    Write-Host "  10) Check currently playing (Status)"
    Write-Host "  11) Go to Home Screen"
    Write-Host "  12) Open App Switcher (Double Home)"
    Write-Host "  13) AUTOMATIC APP NAVIGATOR (Macros)"
    Write-Host "  14) INSTANT REMOTE MODE (Arrow Keys)"
    Write-Host "  15) Turn OFF Apple TV (Suspend)"
    Write-Host "  16) Exit / Change Apple TV"
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host ""
    $Choice = Read-Host "Select an option (1-16)"

    switch ($Choice) {
        "1"  { Run-FastCmd "pause" }
        "2"  { Run-FastCmd "play" }
        "3"  {
            Clear-Host
            Write-Host "===================================================" -ForegroundColor Red
            Write-Host "         !!! HARD HYPER FREEZE ACTIVE !!!          " -ForegroundColor Red
            Write-Host "===================================================" -ForegroundColor Red
            Write-Host " Sending pause command every 100ms... COMPLETE LOCK" -ForegroundColor Yellow
            Write-Host " Hold [CTRL + C] to cancel and exit." -ForegroundColor White
            Write-Host "===================================================" -ForegroundColor Red
            while ($true) {
                $proc.StandardInput.WriteLine("pause")
                Start-Sleep -Milliseconds 100
            }
        }
        "4"  {
            Clear-Host
            $T = Read-Host "Enter text to send"
            Run-FastCmd "set_position=`"$T`""
        }
        "5"  { 
            Run-FastCmd "cast=`"https://apple.com`"" 
        }
        "6"  { Run-FastCmd "screensaver" }
        "7"  { Run-FastCmd "volume_up" }
        "8"  { Run-FastCmd "volume_down" }
        "9"  { Run-FastCmd "mute" }
        "10" {
            Run-FastCmd "playing"
            Start-Sleep -Milliseconds 300
            Write-Host "`nPress ENTER to return to menu..."
            Read-Host
        }
        "11" { Run-FastCmd "home" }
        "12" { 
            Run-FastCmd "home"
            Start-Sleep -Milliseconds 100
            Run-FastCmd "home"
        }
        "13" {
            Clear-Host
            Write-Host "===================================================" -ForegroundColor Cyan
            Write-Host "              AUTOMATIC APP NAVIGATOR              " -ForegroundColor Cyan
            Write-Host "===================================================" -ForegroundColor Cyan
            Write-Host "  1) Navigate to App 1 (1 Right, Select)"
            Write-Host "  2) Navigate to App 2 (2 Right, Select)"
            Write-Host "  3) Navigate to App 3 (1 Down, Select)"
            Write-Host "===================================================" -ForegroundColor Cyan
            $AppChoice = Read-Host "Select app layout option"
            Clear-Host
            Run-FastCmd "home"; Run-FastCmd "top"; Run-FastCmd "left"
            if ($AppChoice -eq "1") { Run-FastCmd "right"; Run-FastCmd "select" }
            if ($AppChoice -eq "2") { Run-FastCmd "right"; Run-FastCmd "right"; Run-FastCmd "select" }
            if ($AppChoice -eq "3") { Run-FastCmd "down"; Run-FastCmd "select" }
        }
        "14" {
            Clear-Host
            Write-Host "===================================================" -ForegroundColor Green
            Write-Host "          INSTANT KEYBOARD REMOTE MODE ACTIVE      " -ForegroundColor Green
            Write-Host "===================================================" -ForegroundColor Green
            Write-Host " [ARROW KEYS] = Move Selection      [ENTER]    = Select"
            Write-Host " [BACKSPACE]  = Back / Menu         [H]        = Home Screen"
            Write-Host " [ESCAPE]     = Exit Remote Mode and go back to Menu"
            Write-Host "===================================================" -ForegroundColor Green
            
            $Active = $true
            while ($Active) {
                if ([Console]::KeyAvailable) {
                    $K = [Console]::ReadKey($true).Key.ToString()
                    switch ($K) {
                        "UpArrow"    { $proc.StandardInput.WriteLine("up") }
                        "DownArrow"  { $proc.StandardInput.WriteLine("down") }
                        "LeftArrow"  { $proc.StandardInput.WriteLine("left") }
                        "RightArrow" { $proc.StandardInput.WriteLine("right") }
                        "Enter"      { $proc.StandardInput.WriteLine("select") }
                        "Backspace"  { $proc.StandardInput.WriteLine("menu") }
                        "Backup"     { $proc.StandardInput.WriteLine("menu") }
                        "H"          { $proc.StandardInput.WriteLine("home") }
                        "Escape"     { $Active = $false }
                    }
                }
                Start-Sleep -Milliseconds 20
            }
        }
        "15" { Run-FastCmd "suspend" }
    }
} while ($Choice -ne "16")

$proc.StandardInput.WriteLine("exit")
$proc.Close()
