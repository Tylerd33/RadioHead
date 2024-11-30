param (
    [string[]]$MediaURL,
    [string[]]$AdURL,
    [bool]$AdShuffle
    )
#URLs to downlaod as input
#AdShuffle True if User wants to shuffle ads
'
DOWNLOADS VIDEOS IN .WAV FORMAT TO FILE DIRECTORY RAND_ORD_DL AND ADDS 4 RANDOM NUMBERS IN FRONT OF EACH FILE AS WELL AS RAND TAG 
IGNORES ANY FILE WITHOUT .WAV EXTENSION
INPUT: URL OF VIDEO OR PLAYLIST TO DOWNLOAD
'

#Create directory to store merge if not exist, otherwise clears directory
if(Test-Path -Path Rand_Ord_DL){
    Write-Output "Rand_Ord_DL Path exists... deleting and recreating"
    rm -Recurse Rand_Ord_DL
    New-Item -Itemtype "directory" Rand_Ord_DL
}

else{
    Write-Output "Rand_Ord_DL Path does not exist, creating..."
    New-Item -Itemtype "directory" Rand_Ord_DL
}

#Go to directory with downloaded media
cd Rand_Ord_DL

#
if($AdShuffle){
    Write-Output "Shuffling Media"
    .\..\OrganizedDownloader -URLList $MediaURL -FileType "Media" -AdShuffle $True
}
else{
    #Downloads ad videos numbered 1 - 1000
    #Only Works with individual Media (Not Playlists)
    $MediaCountD = .\..\OrganizedDownloader -URLList $MediaURL -FileType "Media" -AdShuffle $False | Select-Object -Last 1
}

.\..\OrganizedDownloader -URLList $AdURL -FileType "Ad" -AdShuffle $True -LastMediaCount $MediaCountD

#LEGACY(OLD)
#Download Playlist in Current Directory    
#yt-dlp -x --audio-format wav "$($URL)"

#$files = Get-ChildItem -File

#LEGACY CODE(OLD)

cd ..
Write-Output "Files downloaded and randomized sort`n`n"

#Runs Script that Merges Files
.\WavMerge.ps1
