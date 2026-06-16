# Verifies if Pen Drive if connected (or if folder exists)
$deviceId = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} |  %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_.deviceid}
if($null -ne $deviceId)
{
    try
    {
        $folder = Get-Date -Format Copia-"dd-MM-yyyy" # Create folder name with current date
        $sourceFolder = "$env:USERPROFILE\Desktop"
        $destinationFolder = "$deviceId\Copias\"
        New-Item -ItemType Directory -Path "$destinationFolder$folder" -ErrorAction Stop # Create folder in the Pen Drive (or any other folder)
        Copy-Item -Path "$sourceFolder\*" -Destination "$destinationFolder$folder" -Recurse -ErrorAction Stop # Copies everything in the source folder to the destination one 
        Write-Host "Sucesso!" -ForegroundColor green
    }
    catch
    {
        Write-Host "Erro ao copiar dados!" -ForegroundColor red -BackgroundColor white
    }
} 
else 
{
    Write-Host "Nenhuma PEN USB detectada!" -ForegroundColor red -BackgroundColor white # Error message
}