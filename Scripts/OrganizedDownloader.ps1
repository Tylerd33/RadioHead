# Should start in RAND_ORD_DL directory

# Filetype example: Media, Ad, Music...
param(
    [string[]]$URLList,
    [string]$FileType,
    [bool]$AdShuffle,
    [int]$LastMediaCount = 0
)
Set-PSBreakpoint -Script "../OrganizedDownloader.ps1" -Line 47
# Creates Directory and goes to it
New-Item -ItemType "directory" -Name $FileType
cd $FileType

# Saves path to Media
$MediaPath = (pwd).Path

# Creates Temp Directory and goes t
New-Item -ItemType "directory" -Name "Temp"
cd Temp

if($AdShuffle){
    
}
else{
    # Each file 4 numbers in front which represent the order number starting from 0 and going to 1000
    $current1 = 0
    $current2 = 0
    $current3 = 0
    $current4 = 0
}
if(-not $AdShuffle){
    $MediaCount = 0
}
else{
    $AdCount = 0
}


$CurrentPath = (pwd).Path

# Download Each Media File and numbers each
foreach ($URL in $URLList) {


    if($AdShuffle){
        $AdCount += 1
    }
    else{
        $MediaCount += 1
        $current1 += 1
        if ($current1 -eq 10) {
            $current1 = 0
            $current2 += 1
        }
        if ($current2 -eq 10) {
            $current2 = 0
            $current3 += 1
        }
        if ($current3 -eq 10) {
            $current3 = 0
            $current4 += 1
        }
        if ($current4 -eq 10) {
            Write-Output "ERROR: OVER 1000 FILES EXCEEDED (UNSUPPORTED), MAY BE ISSUES WITH ORDERING"
        }
    }
    

    # Downloads Audio File to Temp Directory and then renames and moves it to the Media directory
    yt-dlp -x --audio-format wav "$URL"
    $OriginalAudioFile = Get-ChildItem -File
    foreach ($file in $OriginalAudioFile) {
    '
    Renames each file and moves to parent folder (non-temp folder)
    '   
        if($AdShuffle){
            $newFileName = $file.name
        }
        else{
            $newFileName = "$current4$current3$current2$($current1)_$($FileType)_$($file.Name)"
        }

        #Gets rid of all non-normal characters in order to not bug out 3rd party tools
        $newFileName = $newFileName -replace " ", "_"

        #Gets rid of ending brackets part of file in order to not bug out 3rd party tools
        $newFileName = $newFileName -replace "\[[^\]]*\]"
        $newFileName = $newFileName -replace "[^A-Za-z0-9._]", ""
        
        $file | Rename-Item -NewName $newFileName
        

        #Converts .wav file to a standard format to ensure proper concatenation later
        $newerFileName = $newFileName.Substring(0, 10) + "s" + $newFileName.Substring(10)
        ffmpeg -i $newFileName -ar 44100 -ac 2 -sample_fmt s16 $newerFileName
        rm $newFilename

        #Moves to Parent folder
        Move-Item -Path "$CurrentPath/$newerFileName" -Destination "$MediaPath"
    }
}

if($AdShuffle){
    #Renames file name to account for ordering
    $current1 = 0
    $current2 = 0
    $current3 = 0
    $current4 = 0
    $files = Get-ChildItem -Path $MediaPath -Filter "*.wav" -File
    foreach($file in $files){
        $current1 += [int]($LastMediaCount / $AdCount)
        Write-Output "LastMediaCount: $LastMediaCount"
        Write-Output "AdCount: $AdCount"
        Write-Output "Current1: $current1"


        if ($current1 -eq 10) {
            $current1 = 0
            $current2 += 1
        }
        if ($current2 -eq 10) {
            $current2 = 0
            $current3 += 1
        }
        if ($current3 -eq 10) {
            $current3 = 0
            $current4 += 1
        }
        if ($current4 -eq 10) {
            Write-Output "ERROR: OVER 1000 FILES EXCEEDED (UNSUPPORTED), MAY BE ISSUES WITH ORDERING"
        }
        $newFileName = "$current4$current3$current2$($current1)0_$($FileType)_$($file.Name)"
        $file | Rename-Item -NewName $newFileName
    }
}
cd ..
cd ..
if(-not $AdShuffle){
    Write-Output $MediaCount
}
