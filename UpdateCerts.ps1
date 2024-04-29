try {
    # Specify the path where you want to create the directory and SST file
    $certificateDirectoryPath = "C:\PS"
    $sstFilePath = "$directoryPath\roots.sst"

    # Check if the directory exists; if not, create it
    if (-not (Test-Path -PathType Container $certificateDirectoryPath)) {
        Write-Output ("Directory doesn't exist, creating now")
        New-Item -ItemType Directory -Path $certificateDirectoryPath
    }

    # Delete the existing SST file if it exists
    if (Test-Path -Path $sstFilePath) {
        Write-Output ("Old certs exist, deleting the certs")
        Remove-Item -Path $sstFilePath
    }

    # Generate the SST file containing root certificates from Windows Update
    certutil.exe -generateSSTFromWU $sstFilePath

    # Install certificates from the SST file if sst was downloaded from internet
    if (!Test-Path -Path $sstFilePath) {
        Write-Output ("roots.sst downloaded successfully, Import cert started")
        $sstStore = Get-ChildItem -Path $sstFilePath
        $sstStore | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
    }
    else {
        Write-Output ("Entering else block")
        Copy-Item -Path "\\INGBTCPIC6VWF69\PackageFetcherTestShare\roots.sst" -Destination $sstFilePath
        if (Test-Path -Path $sstFilePath) {
            Write-Output ("roots.sst downloaded successfully, Import cert started")
            $sstStore = Get-ChildItem -Path $sstFilePath
            $sstStore | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
            # Copy the SST file to your build server
        }
    }
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
