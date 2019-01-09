Set-Location master:

$props = @{
    Parameters = @(
        @{Name="startItem"; Title="Start Item"; Tooltip="Choose the item from which to execute the update."; Editor = "droptree" },
        @{Name="lang"; Title="Select New Language"; Tooltip="Choose the Language Item."; Editor = "droptree"},
		@{Name="existingLang"; Title="Select Existing Language of item"; Tooltip="Choose the Language Item."; Editor = "droptree"},
		@{Name="processSubItems"; Title="Process Sub Items"; Value=$false ;Tooltip="Select to process sub items."}
    )
    Title = "Add language versions"
    Description = "This module will add version to all items under selected node./!\"
    Width = 800
    Height = 500
    ShowHints = $true
}

if((Read-Variable @props) -eq "ok") 
{
    Write-Host "Adding Version to  all items starting from $($startItem.Paths.Path)."
    Write-Host "================================================"
    
    $pathItem = $startItem.Paths.Path
	$newLang = $lang.Name
	$oldLang = $existingLang.Name
	

	
	$startItemPath = "master:"+$startItem.Paths.Path
    
	Add-ItemVersion -Path $startItemPath -Language $oldLang -TargetLanguage $newLang -IfExist Skip
    
    if($processSubItems){
	Get-ChildItem -ID $startItem.ID -Language $oldLang -Recurse | ForEach-Object {
	
		$itemPath = "master:" + $_.Paths.Path		
	    Add-ItemVersion -Path $itemPath -Language $oldLang -TargetLanguage $newLang -IfExist Skip
		
	}    
    }
    
    Show-Alert -Title "Finished!"
}