<#
usage: 
powershell.exe -executionpolicy bypass -noninteractive -noprofile -noninteractive -command "(new-object system.net.webclient).downloadstring('https://raw.githubusercontent.com/TaylorMonacelli/my_windows_pinning/master/doit.ps1') | iex"
#>

<#
copy //tsclient/tmp/doit.ps1 .; . .\doit.ps1
#>

$list = @()

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

Remove-Item Alias:\wget -Force -EA 0
if(!(test-path wget.exe)){
	(new-object System.Net.WebClient).DownloadFile('http://installer-bin.streambox.com/wget.exe', 'wget.exe')
}

./wget --quiet --timestamping --no-check-certificate https://github.com/TaylorMonacelli/PinTo10/raw/master/Binary/PinTo10v2.exe

if($TBDIR -eq $null){
	$d=[Environment]::GetFolderPath("MyDocuments") + '\TaskbarShortcuts'
	Set-Variable TBDIR -option Constant -value $d
}

##############################

./PinTo10v2 /unpintb "$env:SystemRoot\System32\shutdown.exe" | out-null

$ridir="$TBDIR\Reboot Immediately"
mkdir -force $ridir | out-null
$icofile="$ridir\Windows-Restart.ico"
$scfile="$ridir\Reboot Immediately.lnk"
./wget --quiet --timestamping --no-check-certificate --directory-prefix $ridir https://github.com/TaylorMonacelli/my_windows_pinning/raw/master/Windows-Restart.ico
Install-ChocolateyShortcut `
  -ShortcutFilePath $scfile `
  -TargetPath "$env:SystemRoot\System32\shutdown.exe" `
  -Arguments '-t 2 -r -f -c "Rebooting now"' `
  -IconLocation $icofile `
  -Description "Restart machine now" `
  -WindowStyle 7 `
  -RunAsAdmin


$ridir="$TBDIR\PowerOff Immediately"
mkdir -force $ridir | out-null
$icofile="$ridir\power_off.ico"
$scfile="$ridir\PowerOff Immediately.lnk"
./wget --quiet --timestamping --no-check-certificate --directory-prefix $ridir https://github.com/TaylorMonacelli/my_windows_pinning/raw/master/power_off.ico
Install-ChocolateyShortcut `
  -ShortcutFilePath $scfile `
  -TargetPath "$env:SystemRoot\System32\shutdown.exe" `
  -Arguments '-t 120 -s -f -c "Powering off in 2 minutes"' `
  -IconLocation $icofile `
  -Description "Power Off in 2 minutes" `
  -WindowStyle 7 `
  -RunAsAdmin `
  -PinToTaskbar

./PinTo10v2 /pintb $scfile | out-null

# Just remove from taskbar

# Windows Media Player
./PinTo10v2 /unpintb "${env:SYSTEMDRIVE}\Program*\Windows Media Player\wmplayer.exe" | out-null

# Add to taskbar

$list += @(
	@{
		"desc" = "Powershell";
		"glob" = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
		"ShortcutFilePath" = "$TBDIR\Powershell.lnk"
		"Arguments" = '-NoExit -Command "cd $env:USERPROFILE"'
		"WorkingDirectory" = "$env:USERPROFILE"
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
		"desc" = "Internet Explorer"
		"glob" = "${env:SYSTEMDRIVE}\Program Files\Internet Explorer\iexplore.exe"
		"ShortcutFilePath" = "$TBDIR\IE.lnk"
	}
	,@{
		"desc" = "Internet Explorer"
		"glob" = "${env:SYSTEMDRIVE}\Program Files (x86)\Internet Explorer\iexplore.exe"
		"ShortcutFilePath" = "$TBDIR\IE.lnk"
	}
	,@{
		"desc" = "Windows Embedded Developer Update"
		"glob" = "${env:SYSTEMDRIVE}\Program*\Windows Embedded Developer Update*\Toolset\Embedded Tools\Wedu.exe"
		"ShortcutFilePath" = "$TBDIR\WEDU.lnk"
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
		"desc" = "Opera"
		"glob" = "${env:SYSTEMDRIVE}\Pro*\Opera\launcher.exe"
		"ShortcutFilePath" = "$TBDIR\Opera.lnk"
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
		"desc" = "Microsft Edge"
		"glob" = "${env:SYSTEMROOT}\SystemApps\Microsoft.MicrosoftEdge*\MicrosoftEdge.exe"
		"ShortcutFilePath" = "$TBDIR\Microsft Edge.lnk"
		"WorkingDirectory" = "$env:SYSTEMROOT"
	}
	,@{
		"desc" = "WinDirStat"
		"glob" = "${env:SYSTEMDRIVE}\Program*\WinDirStat\windirstat.exe"
		"ShortcutFilePath" = "$TBDIR\WinDirStat.lnk"
	}
)

# Remove all first
foreach($h in $list)
{
	# expand glob to file that possibly exists
	$file_path = gci $h.get_item("glob") -ea 0 | select -exp fullname

	if($file_path -eq $null) {
		continue
	}

	# unpin first so we can run muliple times without creating
	# duplicates
	./PinTo10v2 /unpintb "$file_path" | out-null
}

foreach($h in $list)
{
	# expand glob to file that possibly exists
	$file_path = gci $h.get_item("glob") -ea 0 | select -exp fullname

	if($file_path -eq $null) {
		continue
	}

	Install-ChocolateyShortcut `
	  -ShortcutFilePath $h.get_item("ShortcutFilePath") `
	  -TargetPath "$file_path" `
	  -RunAsAdmin `
	  -Arguments $h.get_item("Arguments") `
	  -WorkingDirectory $h.get_item("WorkingDirectory")

	./PinTo10v2 /pintb $h.get_item("ShortcutFilePath") | out-null

}
