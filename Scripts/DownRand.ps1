'DOWNLOADS VIDEOS IN .WAV FORMAT TO FILE DIRECTORY RAND_ORD_DL AND ADDS 4 RANDOM NUMBERS IN FRONT OF EACH FILE AS WELL AS RAND TAG 
IGNORES ANY FILE WITHOUT .WAV EXTENSION
INPUT: URL OF VIDEO OR PLAYLIST TO DOWNLOAD
'

#URLs to downlaod as input
param (
    [string]$MediaURL,
    [string]$AdURL
    )


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

#Download Playlist in Current Directory    
yt-dlp -x --audio-format wav "$($URL)"

$files = Get-ChildItem -File

foreach($file in $files){
'
Goes through every File in Directory and rename the file to have random numbers in front
'

    #Skip file if RNDA in file name
    if($file.Name -match "RNDA"){
        Write-Output "RNDA Match found for file with name:'n $($file.Name)'n 'nWill not touch file"
   }

   #Give 4 digit number to beginning of file in order to effectively randomize storage
   #Gets rid of spacing to help later code, also appends RAND to help later identify file
   else{
        Write-Output "Appending Random Number and RAND in front of file as well as deleting spacing 'n$($file.name)"
        $randomNum = Get-Random -Minimum 1000 -Maximum 9999
        $newFileName = "$($randomNum)RNDA$($file.Name)"

        #Gets rid of all non-normal characters in order to not bug out 3rd party tools
        $newFileName = $newFileName -replace " ", "_"

        #Gets rid of ending brackets part of file in order to not bug out 3rd party tools
        $newFileName = $newFileName -replace "\[[^\]]*\]"
        $newFileName = $newFileName -replace "[^A-Za-z0-9._]", ""
        $file | Rename-Item -NewName $newFileName

        #If string in index 3 is either 8 or 9 then creates a radio host introduction
        if($newFileName[3] -match '[89]'){
            cd ..
            ./LLama3InOut.ps1 -filename $newFileName
            cd Rand_Ord_DL
        }

        #Converts .wav file to a standard format to ensure proper concatenation later
        $newerFileName = $newFileName.Substring(0, 8) + "s" + $newFileName.Substring(8)
        ffmpeg -i $newFileName -ar 44100 -ac 2 -sample_fmt s16 $newerFileName
        rm $newFilename
   }
}
cd ..
Write-Output "Files downloaded and randomized sort`n`n"

#Runs Script that Merges Files
.\WavMerge.ps1
