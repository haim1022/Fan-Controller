#Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

#Import libraries
$signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
$API = Add-Type -MemberDefinition $signature -Name 'Keypress' -Namespace API -PassThru

$fanKeyDetection = 0x78 #Detect F9 key press
$fanState = $false

Add-Type -AssemblyName System.Windows.Forms

$fanPort = new-Object System.IO.Ports.SerialPort COM5,115200,None,8,one

$fanPort.open()
while($true) {
	Start-Sleep -Milliseconds 50 #Prevent high CPU usage
    $process = @(Get-WmiObject -Class Win32_Process -Filter "Name = 'LogonUI.exe'" -ErrorAction SilentlyContinue)
    if($API::GetAsyncKeyState($fanKeyDetection) -ne 0) {
        $fanState = !$fanState
    }
    if($process.Count -eq 1 -or !$fanState) {
        $fanPort.write("0")
    }
	else {
        $fanPort.write("1")
        Write-Host "!"
    }
}
$fanPort.Close() #Port closes when the process is terminated