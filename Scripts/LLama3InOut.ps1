#Takes input of user file name and outputs an introduction to the song
#Outputs into .txt file for now, should output directly to tts later

param(
    [string]$filename
)

#Test Variables, only use if testing

#Two files, both are identifiable by the ai
$testfilename = "6804RNDAOlivia_Rodrigo_so_american_(Official_Lyric_Video)"
#$testfilename = "6282RNDABillie_Eilish_-_No_Time_To_Die_(Official_Music_Video)_[BboMpayJomw]"



#Only used if no input given
if(Test-Path variable:$filename){
    $filename = $testfilename
    Write-Output "No filename paramter found, using test filename parameter and printing TempRadioHostText.txt to console when done"
}

if(Test-Path "TempRadioHostText.txt"){
}
else{
    New-Item TempRadioHostText.txt
}
#For some reason this always prints out "failed to get console mode for stdout: The handle is invalid." so I will have to delete this line every time, could not find more direct solution
ollama run llama3:8b "I will input a file name which starts with 4n numbers and RNDA, ignore this. Identify the song first. Then give an intro to the song while acting like a relaxed late night radio host. You may mention the song but do not mention the file name I will give you. Also make sure to ease into and out of the intro. If it is hard to identify the song from the file name, then only output FALSE: $($filename)" > TempRadioHostText.txt

#Removes first 3 lines as they are non-existent errors
$txtlines = Get-Content TempRadioHostText.txt
$txtlines = $txtlines | Where-Object { $_ -ne $txtlines[0] -and $_ -ne $txtlines[1] -and $_ -ne $txtlines[2] }
$txtlines | Set-Content TempRadioHostText.txt



#Example file name
#6282RNDABillie_Eilish_-_No_Time_To_Die_(Official_Music_Video)_[BboMpayJomw]

#If filename matches test file name then assume script is being tested
if($filename -eq $testfilename){
    cat TempRadioHostText.txt
}
