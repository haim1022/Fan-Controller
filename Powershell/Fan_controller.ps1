#Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

Add-Type -AssemblyName System.Windows.Forms

#System tray properties
    #Systray icon
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\sethc.exe")
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "Fan controller"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true
    #Menu items
        #exit_Item
$exit_Item = New-Object System.Windows.Forms.MenuItem
$exit_Item.Text = "Exit"
    #Menu items actions
        #exit_Item
$exit_Item.add_Click({
    $Main_Tool_Icon.Visible = $false
    Stop-Process -name "Fan_controller_base"
    Stop-Process $pid
    })

#Build context menu
$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.ContextMenu = $contextmenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($about_Item)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($exit_Item)
 
#Use a Garbage colection to reduce Memory RAM
[System.GC]::Collect()

start ".\Fan_controller_Base.exe"

#Create an application context for it to all run within
#This helps with responsiveness, especially when clicking Exit
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)