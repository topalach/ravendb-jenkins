param($ServerUrl="")

Start-Process -FilePath ".\Raven.Server.exe" -ArgumentList "--ServerUrl=$ServerUrl --RunInMemory=true --Non-interactive" -NoNewWindow