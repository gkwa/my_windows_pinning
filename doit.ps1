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

$ridir="${TBDIR}\Reboot Immediately"
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
  -RunAsAdmin `
  -PinToTaskbar

# Just remove from taskbar

# Windows Media Player
./PinTo10v2 /unpintb "${env:SYSTEMDRIVE}\Program*\Windows Media Player\wmplayer.exe" | out-null

# Add to taskbar

$list += @(
	@{
		"desc" = "Powershell";
		"glob" = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe";
		"ShortcutFilePath" = "${TBDIR}\Powershell.lnk";
		"WorkingDirectory" = $env:USERPROFILE
	}
	,@{
		"desc" = "RubyMine";
		"glob" = "${env:SYSTEMDRIVE}\Program*\JetBrains\RubyMine*\bin\rubymine.exe";
		"ShortcutFilePath" = "${TBDIR}\RubyMine.lnk"
	}
	,@{
		"desc" = "Microsoft Deployment Toolkit";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc";
		"ShortcutFilePath" = "${TBDIR}\Microsoft Deplyment Toolkit.lnk"
	}
	,@{
		"desc" = "Microsoft Visual Studio";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Microsoft Visual Studio*\Common*\IDE\devenv.exe";
		"ShortcutFilePath" = "${TBDIR}\Microsoft Visual Studio.lnk"
	}
	,@{
		"desc" = "Vim";
		"glob" = "${env:SYSTEMDRIVE}\Program*\vim\vim8*\gvim.exe";
		"ShortcutFilePath" = "${TBDIR}\Vim.lnk"
	}
	,@{
		"desc" = "Google Chrome";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Google\Chrome\Application\chrome.exe"
		"ShortcutFilePath" = "${TBDIR}\Chrome.lnk"
	}
	,@{
		"desc" = "Microsoft Image Configuration Editor";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Windows Embedded Standard*\Tools\Image Configuration Editor\ice.exe";
		"ShortcutFilePath" = "${TBDIR}\Ice.lnk"
	}
	,@{
		"desc" = "Internet Explorer";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Internet Explorer\iexplore.exe";
		"ShortcutFilePath" = "${TBDIR}\IE.lnk"
	}
	,@{
		"desc" = "Windows Embedded Developer Update";
		"glob" = "${env:SYSTEMDRIVE}\Program*\Windows Embedded Developer Update*\Toolset\Embedded Tools\Wedu.exe";
		"ShortcutFilePath" = "${TBDIR}\WEDU.lnk"
	}
)

foreach($h in $list)
{
	# expand glob to file that possibly exists
	$file_path = gci $h.get_item("glob") -ea 0 | select -exp fullname

	if($file_path -eq $null) {
		continue
	}

	./PinTo10v2 /unpintb "$file_path" | out-null

	Install-ChocolateyShortcut `
	  -ShortcutFilePath $h.get_item("ShortcutFilePath") `
	  -TargetPath "$file_path" `
	  -RunAsAdmin `
	  -WorkingDirectory $h.get_item("WorkingDirectory") `
	  -PinToTaskbar
}
