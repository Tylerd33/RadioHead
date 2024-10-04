#Takes input of user file name and outputs an introduction to the song
#Outputs into .txt file for now, should output directly to tts later

param(
    [string]$filename
)


rm -Recurse TTSMerge
New-Item -Itemtype Directory TTSMerge

#OriginalFIleName
$ogfilename = $filename

#Test Variables, only use if testing

#Two files, both are identifiable by the ai
#$testfilename = "6804RNDAOlivia_Rodrigo_so_american_(Official_Lyric_Video)"
$testfilename = "6282RNDABillie_Eilish_-_No_Time_To_Die_(Official_Music_Video)_[BboMpayJomw]"
$testfilename = $testfilename -replace "[0-9*]RNDA", ""


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
#Clean file name
$filename = $filename -replace "[0-9*]RNDA", ""


#For some reason this always prints out "failed to get console mode for stdout: The handle is invalid." so I will have to delete this line every time, could not find more direct solution
#ollama run llama3:8b "I will input a file name which starts with 4 numbers and RNDA, ignore this. Identify the song first. Then give an intro to the song while acting like a relaxed late night radio host. You may mention the song but do not mention the file name I will give you. Also make sure to ease into and out of the intro. If it is hard to identify the song from the file name, then only output FALSE: $($filename)" > TempRadioHostText.txt
#ollama run llama3:8b "
ollama run llama3.1:8b "Imagine you are a relaxed late-night radio host. Your task is to introduce a song based on its filename, which will be in the format Artist_Name_-Song_Title(Official_Video). For example, if given Billie_Eilish_-No_Time_To_Die(Official_Music_Video), your introduction should sound natural and engaging, without using any pauses or instructions like pauses or fade out. Instead, focus on creating a smooth narrative that highlights the song’s themes and sets the mood for listeners. Avoid any placeholder phrases such as '[insert music]' or '[transition]'. Your response should be a complete, flowing introduction to the song without interruptions or unnecessary directions. Here’s the filename you will use: $($filename). DO NOT MENTION THE EXACT FILE NAME" > TempRadioHostText.txt
#ollama run llama3:8b "Identify what song $($filename) is referring to but do not output this part. Now pretend to be a late night radio host for Radiohead, giving an intro, a quick fun fact, or backstory related to the previously identified song. In the beggining give a radio host intro and at the end give a radio host outro. Use strictly formal text, you may also use .... Do not include any placeholder text like [pauses]. " > TempRadioHostText.txt
#Removes first 3 lines as they are non-existent errors
$txtlines = Get-Content TempRadioHostText.txt
$txtlines = $txtlines | Select-Object -Skip 1
$txtlines = $txtlines -replace "[`"`']", ""
$txtlines | Set-Content TempRadioHostText.txt
$txtlines = Get-Content TempRadioHostText.txt -Raw


#Calls  11LabsTTS.py with $txtlines as input where $txtlines is the radiohost string that will be converted to an ai voice
python ..\ElevenLabsIntegration\11LabsTTS.py $txtlines




#Converts .wav file to a standard format to ensure proper concatenation later
ffmpeg -i ./TTSMerge/TTS.wav -ar 44100 -ac 2 -sample_fmt s16 ./TTSMerge/TTSF.wav
rm ./TTSMerge/TTS.wav



#Moves TTS to Rand_Ord_DL to be merged later by Wavmerge.ps1
#Names TTS to name of other file except adds a 1 before the last letter so it it right in front of the song it will be introducing
$ogfilename = $ogfilename.Substring(0, 8) + "1" + $ogfilename.Substring(8)
Rename-Item -Path ./TTSMerge/TTSF.wav -NewName $ogfilename
Move-Item -Path ./TTSMerge/$ogfilename -Destination ./Rand_Ord_DL

#Example file name
#6282RNDABillie_Eilish_-_No_Time_To_Die_(Official_Music_Video)_[BboMpayJomw]

#If filename matches test file name then assume script is being tested
if($filename -eq $testfilename){
    cat TempRadioHostText.txt
}
