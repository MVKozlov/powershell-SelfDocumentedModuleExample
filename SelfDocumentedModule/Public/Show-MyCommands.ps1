<#
    .SYNOPSIS
        Показать список всех команд модуля с возможностью выбора
#>
function Show-MyCommands {
    Add-Type -AssemblyName PresentationFramework

    #Build the GUI
    [xml]$xaml = @"
    <Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Initial Window" WindowStartupLocation = "CenterScreen"
        SizeToContent = "WidthAndHeight" ShowInTaskbar = "True" Background = "lightgray"> 
        <ScrollViewer VerticalScrollBarVisibility="Auto">
          <StackPanel >
            <ListBox Name="CommandList" >
                <ListBox.ItemTemplate >
                    <HierarchicalDataTemplate >
                        <CheckBox ToolTip="{Binding Tooltip}" Content="{Binding Path=Name}" IsChecked="{Binding IsChecked}" />
                    </HierarchicalDataTemplate>
                </ListBox.ItemTemplate>
            </ListBox>
          <StackPanel Orientation="Horizontal">
        <Button ToolTip="Click to submit your information" 
                Height="20" Width="50" Name="Submit">Запуск</Button>
        <Button ToolTip="Click to cancel" 
                Height="20" Width="50" Name="Reset">Отмена</Button>
          </StackPanel>
          </StackPanel>
        </ScrollViewer >
    </Window>
"@
  
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)

    #Connect to Controls
    $Window=[Windows.Markup.XamlReader]::Load( $reader )

    $AvailableCommands = @(
        Get-Command -Module $MyInvocation.MyCommand.ModuleName |
            ForEach-Object {
                $help = Get-Help $_.Name
                [PSCustomObject]@{
                    Name = $_.Name
                    IsChecked = $false
                    ToolTip = $help.Synopsis
                }
            }
    )

    $CommandList = $Window.FindName('CommandList')
    $CommandList.ItemsSource = $AvailableCommands
    $submit = $Window.FindName('Submit')
    $submit.Add_Click({
        $Window.DialogResult = $true
    })
    $reset = $Window.FindName('Reset')
    $reset.Add_Click({
        $Window.DialogResult = $false
    })

    $Window.Showdialog() | Out-Null
    if ($Window.DialogResult) {
        $AvailableCommands
    }
}
