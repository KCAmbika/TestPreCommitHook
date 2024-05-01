param (
    [string]$sstFilePath
)


try {
    # Specify the path where you want to create the directory and SST file
    $certificateDirectoryPath = $sstFilePath
    $certFilePath = "$certificateDirectoryPath\roots.sst"

    # Check if the directory exists; if not, create it
    if (-not (Test-Path -PathType Container $certificateDirectoryPath)) {
        Write-Output ("Directory doesn't exist, creating now")
        New-Item -ItemType Directory -Path $certificateDirectoryPath
    }

    # Delete the existing SST file if it exists
    #if (Test-Path -Path $certFilePath) {
    #    Write-Output ("Old certs exist, deleting the certs")
    #    Remove-Item -Path $certFilePath
    #}

    # Generate the SST file containing root certificates from Windows Update
    certutil.exe -generateSSTFromWU $certFilePath

    
}
catch [System.Exception] {
    $errorMessage = ($_.Exception.Message + " " + $error[0].InvocationInfo.PositionMessage)
    Write-Output ("catch block")
    # Log("Fatal error occurred while running the script.")
    # Log("Error:" + $errorMessage)
    exit 1
}
finally {
    Write-Output ("Command completed")
}
