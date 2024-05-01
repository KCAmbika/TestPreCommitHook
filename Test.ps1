param (
    [string]$sstFilePath
)

try {
    Write-Host "SstFilePath: $sstFilePath"
    if (Test-Path -Path $sstFilePath) {
	            Write-Output ("roots.sst copied successfully, Import cert started")
	            $sstStore = Get-ChildItem -Path $sstFilePath
            $sstStore | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
    }
    else{
        Write-Output ("roots.sst didn't select")
    }
}
finally {
    Write-Output ("Command completed")
}
