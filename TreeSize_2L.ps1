# Define the root directory
$rootDir = "C:\"

# Display in Human format
function DisplayInBytes($num) 
{
    $suffix = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $index = 0

    if($num -eq $null){
        ""
    }
    else{
        while ($num -gt 1kb) 
        {
            $num = $num / 1kb
            $index++
        } 

        "{0:N1} {1}" -f $num, $suffix[$index]
    }
}


# Function to calculate folder size
function Get-FolderSize {
    param (
        [string]$folderPath
    )
    $folderSize = (Get-ChildItem -Path $folderPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    return $folderSize
}

# Function to get folder sizes up to 2 levels deep
function Get-FolderSizesUpToLevel2 {
    param (
        [string]$rootPath
    )
    #$rootPath.Replace('\','\\')
    $matchPath = $rootPath.Replace('\','\\') + "[^\\]+(\\[^\\]+)?$"
    $matchPath = "^" + $matchPath

    $folders = Get-ChildItem -Path $rootPath -Directory -Recurse  -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match $matchPath } 
    foreach ($folder in $folders) {
        $size = Get-FolderSize -folderPath $folder.FullName
        [PSCustomObject]@{
            FolderPath = $folder.FullName
            SizeInBytes = DisplayInBytes($size)
        }
    }
}

# Execute the function and display the results
Get-FolderSizesUpToLevel2 -rootPath $rootDir | Format-Table -AutoSize | Out-String
