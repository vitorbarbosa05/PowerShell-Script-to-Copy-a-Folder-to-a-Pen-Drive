# Verifies if Pen Drive if connected (or if folder exists)
if(Test-Path -Path "D:\")
{
    try
    {
        $folder = Get-Date -Format Copia-"dd-MM-yyyy" # Create folder name with current date
        $sourceFolder = "$env:USERPROFILE\Desktop"
        $destinationFolder = "D:\Copias\"
        if (-not (Test-Path -Path $destinationFolder))
        {
            New-Item -ItemType Directory -Path "$destinationFolder" -ErrorAction Stop
        }

        # Get all files (recursively)
        $files = Get-ChildItem -Path $sourceFolder -Recurse
        $total = $files.Count
        $count = 0

        New-Item -ItemType Directory -Path "$destinationFolder$folder" -ErrorAction Stop # Create folder in the Pen Drive (or any other folder)

        foreach ($file in $files) 
        {
            $relativePath = $file.FullName.Substring($sourceFolder.Length)
            $targetPath   = Join-Path $destinationFolder$folder $relativePath

            # Copy the file
            Copy-Item -Path $file.FullName -Destination $targetPath -Force
            $count++
            $percent = ($count / $total) * 100

            Write-Progress -Activity "Copying files..." `
                        -Status "Copying $($file.Name) ($count of $total)" `
                        -PercentComplete $percent
        }
        Write-Progress -Activity "Copying files..." -Completed -Status "Sucesso!"
    }
    catch
    {
        Write-Host "Erro ao copiar dados!" -ForegroundColor red -BackgroundColor white
    }
} 
else 
{
    Write-Host "Disco não conectado!" -ForegroundColor red -BackgroundColor white # Error message
}