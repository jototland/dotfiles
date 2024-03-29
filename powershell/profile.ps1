try { $null = gcm pshazz -ea stop; pshazz init 'default' } catch { }


$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding =
New-Object System.Text.UTF8Encoding


remove-item alias:r
function r { r.exe --no-save --no-restore -q }


function activate {
    param(
            [Parameter(Mandatory)]
            [System.IO.DirectoryInfo]
            [ValidateScript({
                if (Test-Path -Path $_\scripts\activate.ps1 -PathType Leaf) {
                return $true
                } else {
                throw "Cannot activate '$_' as a python venv"
                }
                })]
            $DirectoryPath
         )
        $current_dir = pwd
        cd $DirectoryPath
        .\scripts\activate.ps1
        cd $current_dir
}


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
