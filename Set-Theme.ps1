param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Light", "Dark")]
    [string]$Theme
)

# 1. Instantly set the registry keys
$val = if ($Theme -eq "Light") { 1 } else { 0 }
$reg = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $reg -Name AppsUseLightTheme -Value $val -Force
Set-ItemProperty -Path $reg -Name SystemUsesLightTheme -Value $val -Force

# 2. Compile the UI refresher (only if it hasn't been compiled yet in this session)
$code = '[DllImport("user32.dll",CharSet=CharSet.Auto)]public static extern IntPtr SendMessageTimeout(IntPtr h,uint m,IntPtr w,string l,uint f,uint t,out IntPtr r);'
if (-not ("Win32.ThemeRefresher" -as [type])) { Add-Type -MemberDefinition $code -Name "ThemeRefresher" -Namespace "Win32" }

# 3. Broadcast the seamless refresh command to all open windows
$res = [IntPtr]::Zero
[Win32.ThemeRefresher]::SendMessageTimeout([IntPtr]0xFFFF, 0x001A, [IntPtr]0, "ImmersiveColorSet", 2, 2000, [ref]$res) | Out-Null

# 4. Force a clean exit to signal Task Scheduler it is done
exit 0
