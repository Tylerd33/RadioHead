
param(
    [bool]$test = $False
)

#Paramater acts as boolean, only use if testing
'
User Interface File, used for receiving input from users. Additonally, calls all other necessary files to complete program
'

#If test parameter input exits then skip input phase, used for testing only
if($test){
    Write-OutPut "Using Test Paramaters"
    $CombinedURL = "https://www.youtube.com/watch?v=FJVFXsNzYZQ https://www.youtube.com/watch?v=QYVucud3ptc https://www.youtube.com/watch?v=ZzI9JE0i6Lc&list=PL0vfts4VzfNjdPuyk9SJDIvpsOjNgU1bs&pp=iAQB https://www.youtube.com/watch?v=RlPNh_PBZb4&pp=ygUOb2xpdmlhIHJvZHJpZ28%3D https://www.youtube.com/watch?v=X0DvM9DaZl4&pp=ygUOb2xpdmlhIHJvZHJpZ28%3D https://www.youtube.com/watch?v=Udte0tu7IZw&pp=ygUOb2xpdmlhIHJvZHJpZ28%3D"
    ./DownRand -URL $CombinedURL
}

#Gets user input, formats it and sends it to ./DownRand
else{
    #User Input for Media
    while($UserInput -ne ""){
        $UserInput = Read-Host "Enter Media URL, one at a time please. Type nothing and press enter to finish`n"
        if($UserInput -ne ""){
            $MediaURL = "$($UserInput) $($MediaURL)"  
        }
    
    }
    $InfoURL

    #User input for "ads"
    while($UserInput2 -ne ""){
        $UserInput2 = Read-Host "Enter 'ad' Content, one at a time please. Type nothing and press enter to finish`n"
        if($UserInput2 -ne ""){
            $AdURL = "$($UserInput2) $($AdURL)"
        }     
    }

    #User input for "ads"
    while($UserInput2 -notin @("shuffle","keep")){
        $UserInput2 = Read-Host "Would you like to shuffle ad order (shuffle) or keep in order (keep)`n"  
    }

    if($UserInput2 -eq "shuffle"){$Userinput2 = $True}
    if($UserInput2 -eq "keep"){$Userinput2 = $False} 

    #LEGACY(OLD)
    #Combines URLs and gets rid of extra spacing
    #$CombinedURL = "$($MediaURL)$($AdURL)"

    #Get rid of extra spacing
    if($AdURL){$AdURL = $AdURL.Trim()}
    if($AdURL){$MediaURL = $MediaURL.Trim()}

    #Output for Debugging
    Write-Output "Interface.ps1 variables (for debugging): "
    Write-Output "Ad URL: $AdURL"
    Write-Output "Media URL: $MediaURL"

    $MediaURL = $MediaURL -split " "
    $AdURL = $AdURL -split " "
    ./DownRand -AdURL $AdURL -MediaURL $MediaURL -AdShuffle $UserInput2
}