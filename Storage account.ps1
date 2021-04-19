# Connect to Azure
Connect-AzureRmAccount

# Static Values for Resource Group and Storage Account Names
$resourceGroup = "uzoma"
$storageAccountName = "uzomanwokojerem"

# Get a reference to the storage account and the context
$storageAccount = Get-AzureRmStorageAccount `
-ResourceGroupName $resourceGroup `
-Name $storageAccountName
$ctx = $storageAccount.Context

# Get All Blob Containers
$AllContainers = Get-AzureStorageContainer -Context $ctx
$AllContainersCount = $AllContainers.Count
Write-Host "We found '$($AllContainersCount)' containers. Processing the modified date for each one"

# Zero counters
$TotalContainers = 0

# Loop to go over each container
Foreach ($Container in $AllContainers){
$TotalContainers = $TotalContainers + 1
Write-Host "Processing Container '$($TotalContainers)'/'$($AllContainersCount)'"

# Search for the last modified date using PS Get-date function then output this to a file.
Get-AzureStorageBlob -Container $Container.Name -Context $ctx | Where-Object{$_.LastModified.DateTime -gt ((Get-Date).Date).AddDays(-30)} | Out-File -FilePath .\30days.txt
Get-AzureStorageBlob -Container $Container.Name -Context $ctx | Where-Object{$_.LastModified.DateTime -gt ((Get-Date).Date).AddDays(-90)} | Out-File -FilePath .\90days.txt
}