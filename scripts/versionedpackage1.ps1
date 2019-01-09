$cluster1Languages = @("en-GB","fr-FR","el-GR","es-ES","fr-BE","hu-HU","it-IT","nl-BE","nl-NL","pt-PT","sv-SE")

$cluster2Languages = 
@("pl-PL",
"tr-TR",
"en-PH",
"de-DE",
"ja-JP",
"ru-RU",
"en-CA",
"en-US",
"fr-CA",
"ar-SA",
"en-IN",
"en-SA",
"kk-KZ",
"ru-KZ")

$layoutLanguages = @("en")

$currentVersion = 1;

$props = @{
    Parameters = @(
        @{Name="startItem"; Title="Start Item"; Tooltip="Choose the item from which to start."; Editor = "droptree" }        
    )
    Title = "Package Creation"
    Description = "This module will create packages for languages defined in the script."
    Width = 800
    Height = 500
    ShowHints = $true
}
if((Read-Variable @props) -eq "ok") {

		foreach($currentLanguage in $layoutLanguages) {
		
		New-UsingBlock (New-Object Sitecore.Globalization.LanguageSwitcher($currentLanguage)) {

			  # Create package
			  $package = new-package "Alignment Packages from $($startItem.Name) $($currentLanguage)" ;

			  # Set package metadata
			  $package.Sources.Clear();
			  $package.Metadata.Author = "Adarsh";
			  $package.Metadata.Publisher = "PIO";
			  $package.Metadata.Version = $currentVersion;
			  $package.Metadata.Readme = "Versioned Package Starting at $($startItem.Paths.Path) for $($currentLanguage) language";
					   
			  $currentPath = $startItem.Paths.Path;			  
			 
			  # Add contnet/home to the package
			  $source = Get-Item -Path master:$currentPath -Language $currentLanguage |
			  New-ItemSource -Name $startItem.Name -InstallMode Merge -MergeMode Merge -SkipVersions 
			  $package.Sources.Add($source);
				 
			  # Save package
			  Export-Package -Project $package -Path "$($package.Name)-$($currentVersion).zip" -Zip
			  Write-Host "$($package.Name) created";
			  $currentVersion++;

			}
		}
}

Write-Host "Completed";

