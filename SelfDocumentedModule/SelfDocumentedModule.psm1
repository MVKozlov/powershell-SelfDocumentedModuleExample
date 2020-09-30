Set-StrictMode -Version Latest

$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

#region Load Public Functions
Try {
    Get-ChildItem "$PSModuleRoot\Public" -Filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object {
        $Function = Split-Path $_ -Leaf
        Write-Verbose "Loading $Function"
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function, $_.Exception.Message)
    Continue
}
#endregion Load Public Functions

#region Load Private Functions
Try {
    Get-ChildItem "$PSModuleRoot\Private" -Filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object {
        $Function = Split-Path $_ -Leaf
        Write-Verbose "Loading $Function"
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function, $_.Exception.Message)
    Continue
}
#endregion Load Private Functions
