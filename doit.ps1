<#
usage: 
powershell.exe -executionpolicy bypass -noninteractive -noprofile -noninteractive -command "(new-object system.net.webclient).downloadstring('https://raw.githubusercontent.com/TaylorMonacelli/my_windows_pinning/master/doit.ps1') | iex"
#>

<#
copy //tsclient/tmp/doit.ps1 .; . .\doit.ps1
#>

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

Remove-Item Alias:\wget -Force -EA 0
if(!(test-path wget.exe)){
	(new-object System.Net.WebClient).DownloadFile('http://installer-bin.streambox.com/wget.exe', 'wget.exe')
}

./wget --quiet --timestamping --no-check-certificate https://github.com/TaylorMonacelli/PinTo10/raw/master/Binary/PinTo10v2.exe

$d=[Environment]::GetFolderPath("MyDocuments") + '\TaskbarShortcuts'
if($TBDIR -eq $null){
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

##############################

# Powershell

./PinTo10v2 /unpintb "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" | out-null

Install-ChocolateyShortcut `
  -ShortcutFilePath "${TBDIR}\Powershell.lnk" `
  -TargetPath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" `
  -RunAsAdmin `
  -PinToTaskbar

##############################

# Windows Media Player
# C:\Program Files\Windows Media Player\wmplayer.exe

./PinTo10v2 /unpintb "C:\Program Files\Windows Media Player\wmplayer.exe" | out-null

##############################

# RubyMine
# C:\Program Files\JetBrains\RubyMine 2016.2.3\bin\rubymine.exe

$mypath1 = gci "${env:ProgramFiles}\JetBrains\RubyMine*\bin\rubymine.exe" -ea 0 | select -exp fullname
./PinTo10v2 /unpintb "$mypath1" | out-null
$mypath2 = gci "${env:ProgramFiles(x86)}\JetBrains\RubyMine*\bin\rubymine.exe" -ea 0 | select -exp fullname
./PinTo10v2 /unpintb "$mypath2" | out-null

if(($mypath1 -ne $null) -and (test-path "$mypath1"))
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\RubyMine.lnk" `
	  -TargetPath "$mypath1" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(($mypath2 -ne $null) -and (test-path "$mypath2"))
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\RubyMine.lnk" `
	  -TargetPath "$mypath2" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Microsoft Deployment Toolkit
# C:\Program Files\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc" | out-null

if(test-path "${env:ProgramFiles}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Microsoft Deplyment Toolkit.lnk" `
	  -TargetPath "${env:ProgramFiles}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Microsoft Deplyment Toolkit.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Microsoft Deployment Toolkit\Bin\DeploymentWorkbench.msc" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Microsoft Visual Studio
# C:\Program Files\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" | out-null

if(test-path "${env:ProgramFiles}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Microsoft Visual Studio.lnk" `
	  -TargetPath "${env:ProgramFiles}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Microsoft Visual Studio.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Vim
# "C:\Program Files\vim\vim80\gvim.exe"

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\vim\vim80\gvim.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\vim\vim80\gvim.exe" | out-null

if(test-path "${env:ProgramFiles}\vim\vim80\gvim.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Vim.lnk" `
	  -TargetPath "${env:ProgramFiles}\vim\vim80\gvim.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\vim\vim80\gvim.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Vim.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\vim\vim80\gvim.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Google Chrome
# C:\Program Files\Google\Chrome\Application\chrome.exe

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe" | out-null

if(test-path "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Chrome.lnk" `
	  -TargetPath "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Crhome.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Microsoft Image Configuration Editor
# 

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe" | out-null

if(test-path "${env:ProgramFiles}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Chrome.lnk" `
	  -TargetPath "${env:ProgramFiles}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\Crhome.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Windows Embedded Standard 7\Tools\Image Configuration Editor\ice.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Windows Embedded Developer Update

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe" | out-null

if(test-path "${env:ProgramFiles}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\WEDU.lnk" `
	  -TargetPath "${env:ProgramFiles}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\WEDU.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Windows Embedded Developer Update 1.2\Toolset\Embedded Tools\Wedu.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

##############################

# Internet Explorer
# "C:\Program Files\Internet Explorer\iexplore.exe"

./PinTo10v2 /unpintb "${env:ProgramFiles(x86)}\Internet Explorer\iexplore.exe" | out-null
./PinTo10v2 /unpintb "${env:ProgramFiles}\Internet Explorer\iexplore.exe" | out-null

if(test-path "${env:ProgramFiles}\Internet Explorer\iexplore.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\IE.lnk" `
	  -TargetPath "${env:ProgramFiles}\Internet Explorer\iexplore.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}

if(test-path "${env:ProgramFiles(x86)}\Internet Explorer\iexplore.exe")
{
	Install-ChocolateyShortcut `
	  -ShortcutFilePath "${TBDIR}\IE.lnk" `
	  -TargetPath "${env:ProgramFiles(x86)}\Internet Explorer\iexplore.exe" `
	  -RunAsAdmin `
	  -PinToTaskbar
}
