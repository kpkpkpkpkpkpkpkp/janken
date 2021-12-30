
Copy-Item -Force ".\*.lua" -Destination ".\game" 
Copy-Item -Force ".\res\*" -Destination ".\game\res" -Recurse

$compress = @{
  Path = ".\game\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\love\janken.zip"
}
Compress-Archive -Force @compress

Move-Item -Force .\love\janken.zip .\love\janken.love
cmd /c copy /b .\love\love.exe+.\love\janken.love .\love\janken.exe

