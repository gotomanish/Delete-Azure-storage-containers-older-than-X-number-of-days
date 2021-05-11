#authenticate the user
Connect-AzAccount

$resourceGroup = "YourResourceGroupName"
$storageAccountName = "YourStorageAccountName"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
  

#create Storage context              
                
$ctx = $storageAccount.Context

$listOfContainers = Get-AzStorageContainer -Context $ctx

##Change the number of days based on your need. Currently it will fetch the container which are older than 90 days
$FinallistOfContainersToDelete = $listOfContainers | Where-Object{$_.LastModified -lt (get-date).AddDays(-90)}

#this is optional filter based on the name. You can use either based on LastModified as above or this one based on name
$filterContainerforName = $listOfContainers | Where-Object{$_.Name -like "*test*"}

##Write-Host "Filtered Containers based on Name"
##$filterCOntainerforName | select Name


Write-Host "Filtered Containers based on LastModifiedDate"
$FinallistOfContainersToDelete | select Name


#Delete the containers
 Write-Host "Deleting containers"
$FinallistOfContainersToDelete | Remove-AzStorageContainer -Context $ctx 