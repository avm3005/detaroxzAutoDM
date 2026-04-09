param([Parameter(Mandatory=$true)][ValidateSet("Light", "Dark")][string]$Theme)
$val = if ($Theme -eq "Light") { 1 } else { 0 }
$reg = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $reg -Name AppsUseLightTheme -Value $val -Force
Set-ItemProperty -Path $reg -Name SystemUsesLightTheme -Value $val -Force

$code = '[DllImport("user32.dll",CharSet=CharSet.Auto)]public static extern IntPtr SendMessageTimeout(IntPtr h,uint m,IntPtr w,string l,uint f,uint t,out IntPtr r);'
if (-not ("Win32.ThemeRefresher" -as [type])) { Add-Type -MemberDefinition $code -Name "ThemeRefresher" -Namespace "Win32" }

$res = [IntPtr]::Zero
[Win32.ThemeRefresher]::SendMessageTimeout([IntPtr]0xFFFF, 0x001A, [IntPtr]0, "ImmersiveColorSet", 2, 2000, [ref]$res) | Out-Null
exit 0
