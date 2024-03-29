# How to copy files over rdp when no drives are mapped
# and copying files through the clipboard is disabled.

function Clipboard-Send-File {
    param (
            [Parameter(Mandatory)]
            [System.IO.Fileinfo]$FilePath
    )
        $bytes = Get-Content -Path $FilePath -Encoding Byte -ReadCount 0
        $encoded = [Convert]::ToBase64String($bytes)
        $encoded | clip
}

function Clipboard-Recv-File {
    param(
            [Parameter(Mandatory)]
            [System.IO.Fileinfo]$FilePath
    )
        $FilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
        $encoded = Get-Clipboard
        $unencoded = [Convert]::FromBase64String($encoded)
        [io.file]::WriteAllBytes([io.path]::GetFullPath($FilePath), $unencoded)
}
