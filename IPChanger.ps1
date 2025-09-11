# Self-Elevating PowerShell Script Template

# Check if running as admin
function Test-Admin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (Test-Admin)) {
    # Run this script with admin privileges
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

# Script is running as Admin here
Write-Host "Running as Administrator..." -ForegroundColor Green

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
          [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    Pause
    exit
}

# Revert to DHCP Function
function Revert-ToDHCP {
    try {
        Write-Host "Reverting adapter to DHCP..." -ForegroundColor Green
        $iface = $adapter | Get-NetIPInterface -AddressFamily IPv4
        $iface | Set-NetIPInterface -Dhcp Enabled
        $iface | Set-DnsClientServerAddress -ResetServerAddresses
        $adapter | Restart-NetAdapter
        Write-Host "Adapter reverted to DHCP." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to revert to DHCP: $_" -ForegroundColor Red
    }
}

# Get all network adapters without filtering status
$adapters = Get-NetAdapter | Where-Object { $_.Status -ne "Not Present" }

if ($adapters.Count -eq 0) {
    Write-Host "No network adapters found. Please check your adapter status." -ForegroundColor Red
    exit
}

# List adapters for selection with status
for ($i=0; $i -lt $adapters.Count; $i++) {
    Write-Host "${i}: $($adapters[$i].Name) - Status: $($adapters[$i].Status)"
}

$sel = Read-Host "Select the adapter by number" 
$adapter = $adapters[$sel]
$exit = $false
while (-not $exit) {
    Write-Host "`nChoose an option:"
    Write-Host "1. Set Static IP"
    Write-Host "2. Revert to DHCP"
    Write-Host "3. Exit"
    $choice = Read-Host "Enter choice number"
    switch ($choice) {
        "1" {
            $IP = Read-Host -Prompt "Enter Static IP Address"
            $MaskBits = Read-Host -Prompt "Enter Prefix Length (e.g. 24)"
            $Gateway = Read-Host -Prompt "Enter Gateway IP (e.g. 192.168.1.1)"
            $DNS = Read-Host -Prompt "Enter DNS servers (comma-separated e.g. 8.8.8.8, 1.1.1.1)"
            $DNSlist = $DNS -split ','
            # Remove old config
            $adapter | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false
            $adapter | Remove-NetRoute -AddressFamily IPv4 -Confirm:$false
            $adapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IP -PrefixLength $MaskBits -DefaultGateway $Gateway
            $adapter | Set-DnsClientServerAddress -ServerAddresses $DNSlist
            Write-Host "Static IP applied."
        }
        "2" {
            $iface = $adapter | Get-NetIPInterface -AddressFamily IPv4
            $iface | Set-NetIPInterface -DHCP Enabled
            $iface | Set-DnsClientServerAddress -ResetServerAddresses
            $adapter | Restart-NetAdapter
            Write-Host "Adapter reverted to DHCP." -ForegroundColor Green
        }
        "3" {
            Revert-ToDHCP
            $exit = $true
            Write-Host "Exiting script." -ForegroundColor Green
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
        }
    }
}

# Register event to run cleanup at PowerShell termination
$null = Register-EngineEvent PowerShell.Exiting -Action { Revert-ToDHCP }

Write-Host "`nScript execution complete. Press Enter to close application." -ForegroundColor Green
Read-Host
