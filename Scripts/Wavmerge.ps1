'
Merges all files and create output files, folders, and info file
'

Write-Output "Starting .wav file merge"

#Moves all files to RAND_ORD_DL
cd RAND_ORD_DL
# Get all .wav files from all subdirectories of the current directory
$wavFiles = Get-ChildItem -Path . -Recurse -Filter "*.wav" -File
# Move each .wav file to the current directory
foreach ($file in $wavFiles) {
    Move-Item -Path $file.FullName -Destination . -Force
}
Write-Host "All .wav files have been moved to the current directory."
cd ..

$files = Get-ChildItem  -Recurse -Filter *.wav Rand_Ord_DL
$OriginPath = Get-Location

#Create ."C:\Users\BigMa\RadioHead\Scripts\Rand_Ord_DL\5283RNDAOlivia_Rodrigo_-_The_Making_of_'obsessed'_(Vevo_Footnotes)_[Udte0tu7IZw].wav" file if needed, otherwise clear file
if(Test-Path -Path Wav_Merge_File_Names.txt){
    Write-Output "Wav_Merge_File_Names.txt found, clearing file..."
    Clear-Content -Path Wav_Merge_File_Names.txt
    Write-Output "File Cleared"
}

else{
    Write-Output "Wav_Merge_File_Names.txt not found, creating file...`n`n"
    New-Item "Wav_Merge_File_Names.txt"
}



Write-Output "Writing to Wav_Merge_File_Names.txt"

foreach($file in $files){
    '
    Goes through every file in RAND_ORD_DL and adds to "Wav_Merge_File_Names.txt" in order use ffmpeg to merge all files
    '


    #If file is of format .wav then add name to txt file
    if($file.Name -match ".wav"){
        Write-Output "File below added to Wav_Merge_File_Names.txt 'n$($File.FullName)"
        Add-Content Wav_Merge_File_Names.txt "file '$($file.FullName)'"
        #Write-Output "file 'Rand_Ord_DL/$($file.Name)'" >> Wav_Merge_File_Names.txt
    }
    else{
        Write-Output "file below does not match file extension, not including in merge `n$($File.Name)"
    }
}


$ScriptPath = Get-Location
Write-Output "Creating directory layout / info file"

#Creates directory layout using time to organize folders
cd ..
if(Test-Path -Path CustomRadios){
    cd CustomRadios

    }
else{
    Write-Output "CustomRadios directory does not exist, creating..."
    New-Item -Itemtype "directory" CustomRadios
    cd CustomRadios
}
if(Test-Path -Path $(Get-Date -format "yyyy")){
    cd $(Get-Date -format "yyyy")

    }
else{
    Write-Output "Current year directory does not exist, creating..."
    New-Item -Itemtype "directory" $(Get-Date -format "yyyy")
    cd $(Get-Date -format "yyyy")
}
if(Test-Path -Path $(Get-Date -format "MM")){
    cd $(Get-Date -format "MM")

    }
else{
    Write-Output "Current Month directory does not exist, creating..."
    New-Item -Itemtype "directory" $(Get-Date -format "MM")
    cd $(Get-Date -format "MM")
}

$CurrentTime = $(Get-Date -Format "MM_dd_yyyy_HH.mm")
New-Item -Itemtype "directory" $CurrentTime
cd $CurrentTime

#Creates info file using all current files
New-Item info.txt
foreach($file in $files){
    Add-Content "info.txt" $file.Name
}

Write-OutPut "Attempting final merge"

#Concatenates All file and places in correct folder
ffmpeg -f concat -safe 0 -i $ScriptPath/Wav_Merge_File_Names.txt -c copy RadioOut.wav
cd $OriginPath