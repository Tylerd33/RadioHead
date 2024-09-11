Write-OutPut "Welcome to the URL library, this can be used to store URLs of important videos/audios that you would like to use later"
$UserInput1 = ""
$UserInput2 = ""
if(Test-Path -Path MediaLib.txt){
    Write-Output "MediaLib exists, using existing MediaLib.txt"
}
else{
    Write-OutPut "MediaLib.txt doesn't exist, creating"
    New-Item -ItemType "directory" MediaLib
}

#Write to .txt file loop
while($UserInput1 -ne "done"){
    $UserInput1 = Read-Host "Enter URL only or done if finished: "
    $UserInput2 = Read-Host "Enter Content of URL only"
    if($UserInput1 -ne "" -and $UserInput1 -ne "done"){
        $UserInput1 = "$($UserInput1) $($UserInput2)"
        Write-OutPut $UserInput1 >> MediaLib.txt
    }
} 