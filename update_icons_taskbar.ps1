
<#PSScriptInfo

.VERSION 1.2

.GUID 7891e8ce-78f1-4b38-adcb-e6a43cc6d3b9

.AUTHOR Taylor Monacelli

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#> 





<# 

.DESCRIPTION 
Update Taskbar for apps I have installed

#> 

Param()


<#
usage: 
Set-ExecutionPolicy Unrestricted
# insall chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
powershell.exe -executionpolicy bypass -noninteractive -noprofile -noninteractive -command "(new-object system.net.webclient).downloadstring('https://raw.githubusercontent.com/TaylorMonacelli/my_windows_pinning/master/update_icons_taskbar.ps1') | iex"
#>

<#
copy //tsclient/tmp/doit.ps1 .; . .\doit.ps1
#>

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

if(!(Test-Path PinTo10v2.exe) -and !(Get-Command PinTo10v2 -ea 0)) { 
    if(!(test-path "${env:ProgramFiles}\PinTo10v2\bin")){
        mkdir -force "${env:ProgramFiles}\PinTo10v2\bin"
	}
    (new-object System.Net.WebClient).DownloadFile(
		'https://github.com/TaylorMonacelli/PinTo10/raw/master/Binary/PinTo10v2.exe',
		"${env:ProgramFiles}\PinTo10v2\bin\PinTo10v2.exe"
	)
	Uninstall-BinFile PinTo10v2
	Install-BinFile PinTo10v2 "${env:ProgramFiles}\PinTo10v2\bin\PinTo10v2.exe"
}

if($TBDIR -eq $null){
    $d=[Environment]::GetFolderPath("MyDocuments") + '\TaskbarShortcuts'
    Set-Variable TBDIR -option Constant -value $d
}

# Check if PinTo10v2 runs on this machine
$output = PinTo10v2 /pintb C:\Windows\system32\cmd.exe
if($output -like 'I only work on windows 7 & 10 - Exiting...')
{
	Write-Warning "$output"
}

##############################

# Just remove from taskbar

# Windows Media Player
PinTo10v2 /unpintb "${env:SYSTEMDRIVE}\Program*\Windows Media Player\wmplayer.exe" | Out-Null

# Add to taskbar

$list += @(
    @{
        "desc" = "Powershell"
        "glob" = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
        "ShortcutFilePath" = "$TBDIR\Powershell.lnk"
        "Arguments" = '-NoExit -Command "cd $env:USERPROFILE"'
        "WorkingDirectory" = "$env:USERPROFILE"
    }
    ,@{
        "desc" = "Cmd"
        "glob" = "$env:SystemRoot\System32\cmd.exe"
        "ShortcutFilePath" = "$TBDIR\Cmd.lnk"
        "Arguments" = '/k cd %USERPROFILE%'
        "Description" = "Cmd window"
        "WorkingDirectory" = "%USERPROFILE%"
    }
    ,@{
        "desc" = "Reboot Immediately"
        "glob" = "$env:SystemRoot\System32\shutdown.exe"
        "ShortcutFilePath" = "$TBDIR\Reboot Immediately\Reboot Immediately.lnk"
        "Arguments" = '-t 2 -r -f -c "Rebooting now"'
        "WorkingDirectory" = "$env:USERPROFILE"
        "WindowStyle" = 7
        "Description" = "Restart machine now"
        "IconLocation" = "$TBDIR\Reboot Immediately\Windows-Restart.ico"
        "IconSourceURL" = "https://github.com/TaylorMonacelli/my_windows_pinning/raw/master/Windows-Restart.ico"
    }
    ,@{
        "desc" = "Wireshark"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Wireshark\Wireshark.exe"
        "ShortcutFilePath" = "$TBDIR\Wireshark.lnk"
    }
    ,@{
        "desc" = "RubyMine"
        "glob" = "${env:SYSTEMDRIVE}\Program*\JetBrains\RubyMine*\bin\rubymine.exe"
        "ShortcutFilePath" = "$TBDIR\RubyMine.lnk"
    }
    ,@{
        "desc" = "Microsoft Deployment Toolkit"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc"
        "ShortcutFilePath" = "$TBDIR\Microsoft Deplyment Toolkit.lnk"
    }
    ,@{
        "desc" = "Microsoft Visual Studio"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Microsoft Visual Studio*\Common*\IDE\devenv.exe"
        "ShortcutFilePath" = "$TBDIR\Microsoft Visual Studio.lnk"
    }
    ,@{
        "desc" = "Microsoft Visual Studio Code"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Microsoft VS Code\Code.exe"
        "ShortcutFilePath" = "$TBDIR\Microsoft Visual Studio Code.lnk"
    }
    ,@{
        "desc" = "Vim"
        "glob" = "${env:SYSTEMDRIVE}\Program*\vim\vim8*\gvim.exe"
        "ShortcutFilePath" = "$TBDIR\Vim.lnk"
    }
    ,@{
        "desc" = "Microsoft Image Configuration Editor"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Windows Embedded Standard*\Tools\Image Configuration Editor\ice.exe"
        "ShortcutFilePath" = "$TBDIR\Ice.lnk"
    }
    ,@{
        "desc" = "Windows Embedded Developer Update"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Windows Embedded Developer Update*\Toolset\Embedded Tools\Wedu.exe"
        "ShortcutFilePath" = "$TBDIR\WEDU.lnk"
    }
    ,@{
        "desc" = "Docker"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Docker\Docker\Docker for Windows.exe"
        "ShortcutFilePath" = "$TBDIR\Docker.lnk"
    }
    ,@{
        "desc" = "Putty"
        "glob" = "${env:SYSTEMDRIVE}\chocolatey\bin\PUTTY.EXE"
        "ShortcutFilePath" = "$TBDIR\Putty.lnk"
    }
    ,@{
        "desc" = "MySQL Workbench"
        "glob" = "${env:SYSTEMDRIVE}\Program*\MySQL\MySQL Workbench*\MySQLWorkbench.exe"
        "ShortcutFilePath" = "$TBDIR\MySQL Workbench.lnk"
    }
    ,@{
        "desc" = "TCP Optimizer"
        "glob" = "${env:SYSTEMDRIVE}\ProgramData\chocolatey\bin\TCPOptimizer.exe"
        "ShortcutFilePath" = "$TBDIR\TCP Optimizer.lnk"
    }
    ,@{
        "desc" = "Virtualbox"
        "glob" = "${env:SYSTEMDRIVE}\Pro*\Oracle\VirtualBox\VirtualBox.exe"
        "ShortcutFilePath" = "$TBDIR\VirtualBox.lnk"
    }
    ,@{
        "desc" = "Disk Speed Test"
        "glob" = "${env:SYSTEMDRIVE}\Pro*\Blackmagic Design\Disk Speed Test\DiskSpeedTest.exe"
        "ShortcutFilePath" = "$TBDIR\Disk Speed Test.lnk"
    }
    ,@{
        "desc" = "Disk Speed Test"
        "glob" = "${env:SYSTEMROOT}\System32\SnippingTool.exe"
        "ShortcutFilePath" = "$TBDIR\Snipping Tool.lnk"
    }
    ,@{
        "desc" = "Google Chrome"
        "glob" = "${env:SYSTEMDRIVE}\Program*\Google\Chrome\Application\chrome.exe"
        "ShortcutFilePath" = "$TBDIR\Chrome.lnk"
    }
    ,@{
        "desc" = "Opera"
        "glob" = "${env:SYSTEMDRIVE}\Pro*\Mozilla*\firefox.exe"
        "ShortcutFilePath" = "$TBDIR\Firefox.lnk"
    }
    ,@{
        "desc" = "Opera"
        "glob" = "${env:SYSTEMDRIVE}\Pro*\Opera\launcher.exe"
        "ShortcutFilePath" = "$TBDIR\Opera.lnk"
    }
    ,@{
        "desc" = "Internet Explorer"
        "glob" = @{
            $false = "${env:SYSTEMDRIVE}\Program Files\Internet Explorer\iexplore.exe"
            $true = "${env:SYSTEMDRIVE}\Program Files (x86)\Internet Explorer\iexplore.exe"
        }[(test-path "${env:SYSTEMDRIVE}\Program Files (x86)\Internet Explorer\iexplore.exe")]
        "ShortcutFilePath" = "$TBDIR\IE.lnk"
    }
    ,@{
        "desc" = "WinDirStat"
        "glob" = "${env:SYSTEMDRIVE}\Program*\WinDirStat\windirstat.exe"
        "ShortcutFilePath" = "$TBDIR\WinDirStat.lnk"
    }
    ,@{
        "desc" = "Power off immediately"
        "glob" = "$env:SystemRoot\System32\shutdown.exe"
        "ShortcutFilePath" = "$TBDIR\PowerOff Immediately\PowerOff.lnk"
        "Arguments" = '-t 60 -s -f -c "Shutting down in 1 minute"'
        "WorkingDirectory" = "$env:USERPROFILE"
        "WindowStyle" = 7
        "Description" = "Power off machine in 1 minute"
        "IconLocation" = "$TBDIR\PowerOff Immediately\power_off.ico"
        "IconSourceURL" = "https://github.com/TaylorMonacelli/my_windows_pinning/raw/master/power_off.ico"
    }
)

# Remove all first
foreach($h in $list) {
    # expand glob to file that possibly exists
    $file_path = Get-ChildItem $h.get_item("glob") -ea 0 | Select-Object -exp fullname

    if($file_path -eq $null) {
        continue
    }

    # unpin first so we can run muliple times without creating
    # duplicates
    PinTo10v2 /unpintb $h.get_item("ShortcutFilePath") | Out-Null
}

foreach($h in $list) {

    $file_path = Get-ChildItem $h.get_item("glob") -ea 0 | Select-Object -exp fullname
    if(!$file_path){
        continue
    }

    if($h.ContainsKey("IconLocation")) {
        if(!(test-path $h.get_item("IconLocation"))) {
            if($h.ContainsKey("IconSourceURL")) {
                $p = Split-Path -Parent $h.get_item("IconLocation")
                mkdir -force $p | Out-Null
				(new-object System.Net.WebClient).DownloadFile(
					$h.get_item("IconSourceURL"), $h.get_item("IconLocation"))
            }
        }
    }

    $icofile = $file_path
    if($h.get_item("IconLocation")) {
        $icofile = $h.get_item("IconLocation") 
    }

    Install-ChocolateyShortcut `
      -ShortcutFilePath $h.get_item("ShortcutFilePath") `
      -TargetPath "$file_path" `
      -RunAsAdmin `
      -IconLocation $icofile `
      -Arguments $h.get_item("Arguments") `
      -WorkingDirectory $h.get_item("WorkingDirectory") `
      -PinToTaskbar

    PinTo10v2 /pintb $h.get_item("ShortcutFilePath") | Out-Null
}
