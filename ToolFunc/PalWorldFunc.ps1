$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
#Nhập cài đặt:
try {
  Import-Module -Name ".\ToolConfig\PalWorldConfig.psm1"
}
catch {
  Write-Host "Không thể tải tiệp cấu hình máy chủ."
  Exit
}
Write-Host "Công Cụ Tự Động Tạo, Khởi Chạy Và Cập Nhật Máy Chủ PalWorld Của Hoàng Đức" -ForegroundColor "Green" -BackgroundColor "Black"
Start-Sleep -Seconds 2
#SteamCMD:
$ThisLocation = Get-Location
$SteamCMD = ".\$($Config.SteamCMDFolder)\steamcmd.exe"
if (!(Test-Path -Path $SteamCMD -ErrorAction SilentlyContinue)){
	Write-Host "Tải SteamCMD......." -ForegroundColor "Green" -BackgroundColor "Black"
	$null = New-Item -Path ".\downloads" -ItemType "directory" -ErrorAction SilentlyContinue
	while (!(Test-Path ".\downloads")){}
	$null = Invoke-WebRequest "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile ".\downloads\steamcmd.zip"
	$null = Expand-Archive -Path ".\downloads\steamcmd.zip" -DestinationPath (Split-Path -Path $SteamCMD) -Force
	while (!(Test-Path -Path $SteamCMD -ErrorAction SilentlyContinue)){}
	#Cleanup
	$null = Remove-Item -Path ".\downloads" -Recurse -Force -ErrorAction SilentlyContinue
	Start-Process $SteamCMD -ArgumentList "+quit" -Wait -NoNewWindow
}
#MCRCON:
$MCRCON = ".\$($Config.RCONFolder)\mcrcon.exe"
if (!(Test-Path -Path $MCRCON -ErrorAction SilentlyContinue)){
	Write-Host "Tải RCON......." -ForegroundColor "Green" -BackgroundColor "Black"
	$null = New-Item -Path ".\downloads" -ItemType "directory" -ErrorAction SilentlyContinue
	while (!(Test-Path ".\downloads")){}
	$null = Invoke-WebRequest "https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-windows-x86-64.zip" -OutFile ".\downloads\mcrcon.zip"
	$null = Expand-Archive -Path ".\downloads\mcrcon.zip" -DestinationPath (Split-Path -Path $MCRCON) -Force
	while (!(Test-Path -Path $MCRCON -ErrorAction SilentlyContinue)){}
	#Cleanup
	$null = Remove-Item -Path ".\downloads" -Recurse -Force -ErrorAction SilentlyContinue
}
#Server:
$ExternalIP = (Invoke-WebRequest -uri "https://api.ipify.org/").Content.Trim()
$InternalIP = (
	Get-NetIPConfiguration | Where-Object { (($null -ne $_.IPv4DefaultGateway) -and ($_.NetAdapter.Status -ne "Disconnected")) }
).IPv4Address.IPAddress
$MsgServerStarted = $false
$CheckedConnect = $false
$MsgCheckConnect = $false
$MsgInternalSuccess = $false
$MsgExternalSuccess = $false
$MsgExternalError = $false
$backuped = $false
$TimeOutCount = 0
$ServerProcess = ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Binaries\Win64\PalServer-Win64-Test-Cmd.exe"
$ServerSettingPath = ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
$ServerVer = ".\$($Config.ServerFolder)\$($Server.SeverPath)\ServerVer.json"
$ServerLog = ".\$($Config.ServerFolder)\$($Server.SeverPath)\ServerLog.txt"
$ServerProcessInfo = New-Object System.Diagnostics.ProcessStartInfo($ServerProcess)
$ServerProcessInfo.RedirectStandardError = $true
$ServerProcessInfo.RedirectStandardOutput = $true
$ServerProcessInfo.UseShellExecute = $false
$ServerProcessInfo.Arguments = "-port=$($Server.GamePort) -queryport=$($Server.QueryPort) -log -nosteam -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS EpicApp=PalServer"
if(!(Test-Path -Path $ServerProcess -ErrorAction SilentlyContinue)){
	if (!(Test-Path ".\$($Config.ServerFolder)")){
		$null = New-Item -itemType Directory -Path ".\" -Name $Config.ServerFolder -ErrorAction SilentlyContinue
	}
	while (!(Test-Path ".\$($Config.ServerFolder)")){}
	if (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)")){
		$null = New-Item -itemType Directory -Path ".\$($Config.ServerFolder)" -Name $Server.SeverPath -ErrorAction SilentlyContinue
	}
	while(!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)")){}
	$Time = Get-Date -UFormat "%H:%M"
	Write-Host "[$Time]: Tiến hành cài đặt máy chủ ""$($Server.SessionName)""..." -ForegroundColor "Green" -BackgroundColor "Black"
	$ArgumentList = "+force_install_dir ../$($Config.ServerFolder)/$($Server.SeverPath) +login anonymous +app_update 2394010 validate +quit"
	Start-Process $SteamCMD -ArgumentList $ArgumentList -Wait -NoNewWindow
	if (!(Test-Path -Path $ServerVer -ErrorAction SilentlyContinue)){
		$null = New-Item -Path $ServerVer -ItemType File -ErrorAction SilentlyContinue
	}
	while (!(Test-Path -Path $ServerVer -ErrorAction SilentlyContinue)){}
	$ServerOnlineVer = (Invoke-WebRequest -uri "https://api.steamcmd.net/v1/info/2394010").Content
	$ServerOnlineVer | Out-File -FilePath $ServerVer
}
while(!(Test-Path -Path $ServerProcess -ErrorAction SilentlyContinue)){}
if (!(Test-Path -Path $ServerLog -ErrorAction SilentlyContinue)){
	$null = New-Item -Path $ServerLog -ItemType File -ErrorAction SilentlyContinue
}
while (!(Test-Path -Path $ServerLog -ErrorAction SilentlyContinue)){}
Clear-Content $ServerLog -ErrorAction SilentlyContinue
$StartCheckVer = Get-Date
$StartCheckBackup = Get-Date
While($true){
	Start-Sleep -Seconds 1
	if($Server.UpdateOnStart -eq "True"){
		$Time = Get-Date -UFormat "%H:%M"
		$Message = "[$Time]: Tiến hành kiểm tra/cập nhật phiên bản cho máy chủ ""$($Server.SessionName)""!"
		Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
		Write-Log -LogPath $ServerLog -LogString $Message
		$ArgumentList = "+force_install_dir ../$($Config.ServerFolder)/$($Server.SeverPath) +login anonymous +app_update 2394010 validate +quit"
		Start-Process $SteamCMD -ArgumentList $ArgumentList -Wait -NoNewWindow
		if (!(Test-Path -Path $ServerVer -ErrorAction SilentlyContinue)){
			$null = New-Item -Path $ServerVer -ItemType File -ErrorAction SilentlyContinue
		}
		while (!(Test-Path -Path $ServerVer -ErrorAction SilentlyContinue)){}
		$ServerOnlineVer = (Invoke-WebRequest -uri "https://api.steamcmd.net/v1/info/2394010").Content
		$ServerOnlineVer | Out-File -FilePath $ServerVer
	}
	$Message = "[$Time]: Tiến hành cập nhật cài đặt cho máy chủ ""$($Server.SessionName)""!"
	Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
	Write-Log -LogPath $ServerLog -LogString $Message
	$ServerSetting = @()
	$ServerSetting += "
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(Difficulty=$($Server.Difficulty),DayTimeSpeedRate=$($Server.DayTimeSpeedRate),NightTimeSpeedRate=$($Server.NightTimeSpeedRate),ExpRate=$($Server.ExpRate),PalCaptureRate=$($Server.PalCaptureRate),PalSpawnNumRate=$($Server.PalSpawnNumRate),PalDamageRateAttack=$($Server.PalDamageRateAttack),PalDamageRateDefense=$($Server.PalDamageRateDefense),PlayerDamageRateAttack=$($Server.PlayerDamageRateAttack),PlayerDamageRateDefense=$($Server.PlayerDamageRateDefense),PlayerStomachDecreaceRate=$($Server.PlayerStomachDecreaceRate),PlayerStaminaDecreaceRate=$($Server.PlayerStaminaDecreaceRate),PlayerAutoHPRegeneRate=$($Server.PlayerAutoHPRegeneRate),PlayerAutoHpRegeneRateInSleep=$($Server.PlayerAutoHpRegeneRateInSleep),PalStomachDecreaceRate=$($Server.PalStomachDecreaceRate),PalStaminaDecreaceRate=$($Server.PalStaminaDecreaceRate),PalAutoHPRegeneRate=$($Server.PalAutoHPRegeneRate),PalAutoHpRegeneRateInSleep=$($Server.PalAutoHpRegeneRateInSleep),BuildObjectDamageRate=$($Server.BuildObjectDamageRate),BuildObjectDeteriorationDamageRate=$($Server.BuildObjectDeteriorationDamageRate),CollectionDropRate=$($Server.CollectionDropRate),CollectionObjectHpRate=$($Server.CollectionObjectHpRate),CollectionObjectRespawnSpeedRate=$($Server.CollectionObjectRespawnSpeedRate),EnemyDropItemRate=$($Server.EnemyDropItemRate),DeathPenalty=$($Server.DeathPenalty),bEnablePlayerToPlayerDamage=$($Server.bEnablePlayerToPlayerDamage),bEnableFriendlyFire=$($Server.bEnableFriendlyFire),bEnableInvaderEnemy=$($Server.bEnableInvaderEnemy),bActiveUNKO=$($Server.bActiveUNKO),bEnableAimAssistPad=$($Server.bEnableAimAssistPad),bEnableAimAssistKeyboard=$($Server.bEnableAimAssistKeyboard),DropItemMaxNum=$($Server.DropItemMaxNum),DropItemMaxNum_UNKO=$($Server.DropItemMaxNum_UNKO),BaseCampMaxNum=$($Server.BaseCampMaxNum),BaseCampWorkerMaxNum=$($Server.BaseCampWorkerMaxNum),DropItemAliveMaxHours=$($Server.DropItemAliveMaxHours),bAutoResetGuildNoOnlinePlayers=$($Server.bAutoResetGuildNoOnlinePlayers),AutoResetGuildTimeNoOnlinePlayers=$($Server.AutoResetGuildTimeNoOnlinePlayers),GuildPlayerMaxNum=$($Server.GuildPlayerMaxNum),PalEggDefaultHatchingTime=$($Server.PalEggDefaultHatchingTime),WorkSpeedRate=$($Server.WorkSpeedRate),bIsMultiplay=$($Server.bIsMultiplay),bIsPvP=$($Server.bIsPvP),bCanPickupOtherGuildDeathPenaltyDrop=bIsPvP=$($Server.bCanPickupOtherGuildDeathPenaltyDrop),bEnableNonLoginPenalty=$($Server.bEnableNonLoginPenalty),bEnableFastTravel=$($Server.bEnableFastTravel),bIsStartLocationSelectByMap=$($Server.bIsStartLocationSelectByMap),bExistPlayerAfterLogout=$($Server.bExistPlayerAfterLogout),bEnableDefenseOtherGuildPlayer=$($Server.bEnableDefenseOtherGuildPlayer),CoopPlayerMaxNum=$($Server.CoopPlayerMaxNum),ServerPlayerMaxNum=$($Server.MaxPlayers),ServerName=""$($Server.SessionName)"",ServerDescription=""$($Server.ServerDescription)"",AdminPassword=""$($Server.AdminPassword)"",ServerPassword=""$($Server.ServerPassword)"",PublicPort=$($Server.GamePort),PublicIP=""$($Server.PublicIP)"",RCONEnabled=$($Server.RCONEnabled),RCONPort=$($Server.RCONPort),Region=""$($Server.Region)"",bUseAuth=$($Server.bUseAuth),BanListURL=""https://api.palworldgame.com/api/banlist.txt"")"
	if(!(Test-Path -Path $ServerSettingPath -ErrorAction SilentlyContinue)){
		if (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved")){
			$null = New-Item -itemType Directory -Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal" -Name "Saved" -ErrorAction SilentlyContinue
		}
		while (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal")){}
		if (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config")){
			$null = New-Item -itemType Directory -Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved" -Name "Config" -ErrorAction SilentlyContinue
		}
		while (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config")){}
		if (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config\WindowsServer")){
			$null = New-Item -itemType Directory -Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config" -Name "WindowsServer" -ErrorAction SilentlyContinue
		}
		while (!(Test-Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\Config\WindowsServer")){}
		$null = New-Item -Path $ServerSettingPath -ItemType File -ErrorAction SilentlyContinue
	}
	while (!(Test-Path -Path $ServerSettingPath -ErrorAction SilentlyContinue)){}
	$ServerSetting | Out-File -FilePath $ServerSettingPath
	$ServerRunning = New-Object System.Diagnostics.Process
	$ServerRunning.StartInfo = $ServerProcessInfo
	$ServerRunning.Start() | Out-Null
	While(!$ServerRunning.HasExited){
		Start-Sleep -Seconds 1
		$Time = Get-Date -UFormat "%H:%M"
		if(!$MsgServerStarted){
			$Message = "[$Time]: Khởi động máy chủ ""$($Server.SessionName)"" thành công!"
			Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
			Write-Log -LogPath $ServerLog -LogString $Message
			$MsgServerStarted = $true
		}
		While(!$CheckedConnect){
			Start-Sleep -Seconds 1
			$Time = Get-Date -UFormat "%H:%M"
			if(!$MsgCheckConnect){
				$Message = "[$Time]: Kiểm tra kết nối của máy chủ ""$($Server.SessionName)"":"
				Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
				Write-Log -LogPath $ServerLog -LogString $Message
				$MsgCheckConnect = $true
			}
			$TestInternal = CheckUDP -IP $Server.ManagementIP -Port $Server.GamePort
			if($TestInternal){
				if(!$MsgInternalSuccess){
					$Message = "[$Time]: Kiểm tra kết nối nội bộ với máy chủ ""$($Server.SessionName)"" thành công!"
					Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
					Write-Log -LogPath $ServerLog -LogString $Message
					$TimeOutCount = 0
					$MsgInternalSuccess = $true
				}
				$TestExternal = CheckUDP -IP $ExternalIP -Port $Server.GamePort
				if($TestExternal){
					if(!$MsgExternalSuccess){
						$IPConnect = $ExternalIP + ":" + $Server.GamePort
						if($Server.PublicIP -ne ""){
							$IPConnect = $Server.PublicIP + ":" + $Server.GamePort
						}
						$Message = "[$Time]: Kiểm tra kết nối trực tuyến với máy chủ ""$($Server.SessionName)"" thành công!"
						Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
						Write-Log -LogPath $ServerLog -LogString $Message
						$Message = "[$Time]: Mọi người có thể tham gia máy chủ ""$($Server.SessionName)"" thông qua IP: ""$IPConnect""!"
						Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
						$TimeOutCount = 0
						$MsgExternalSuccess = $true
						$CheckedConnect = $true
					}
				}else{
					if(!$MsgExternalError){
						$TimeOutCount = $TimeOutCount + 1
						if($TimeOutCount -eq 10){
							$Message = "[$Time]: Kiểm tra kết nối trực tuyến với máy chủ ""$($Server.SessionName)"" thất bại!"
							Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
							Write-Log -LogPath $ServerLog -LogString $Message
							$Message = "[$Time]: Hiện tại máy chủ ""$($Server.SessionName)"" chỉ có thể chơi thông qua mạng nội bộ(Mạng LAN)! Nếu bạn muốn mọi người có thể kết nối với máy chủ ""$($Server.SessionName)"" thông qua internet, Bạn cần phải mở port $($Server.GamePort)(UDP) cho IP nội bộ $InternalIP"
							Write-Host $Message -ForegroundColor "Yellow" -BackgroundColor "Black"
							$TimeOutCount = 0
							$MsgExternalError = $true
							$CheckedConnect = $true
						}
					}
				}
			}else{
				$TimeOutCount = $TimeOutCount + 1
				if($TimeOutCount -eq 10){
					$Message = "[$Time]: Đã có lỗi xảy ra! Không thể kết nối với máy chủ ""$($Server.SessionName)""!"
					Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
					Write-Log -LogPath $ServerLog -LogString $Message
					$TimeOutCount = 0
					$CheckedConnect = $false
				}
			}
		}
		$TimerCheckVer = Get-Date
		if($TimerCheckVer -ge $StartCheckVer.AddMinutes($Server.CheckVerTime)){
			$Message = "[$Time]: Tiến hành kiểm tra cập nhật cho máy chủ ""$($Server.SessionName)"" theo chu kỳ $($Server.CheckVerTime) phút/lần:"
			Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
			Write-Log -LogPath $ServerLog -LogString $Message
			$LocalVerData = Get-Content $ServerVer | ConvertFrom-Json
			$LocalVer = $LocalVerData.data."2394010".depots.branches.public.buildid
			$OnlineVerData = (Invoke-WebRequest -uri "https://api.steamcmd.net/v1/info/2394010").Content | ConvertFrom-Json
			$OnlineVer = $OnlineVerData.data."2394010".depots.branches.public.buildid
			if($LocalVer -eq $OnlineVer){
				$Message = "[$Time]: Máy chủ ""$($Server.SessionName)"" đang ở phiên bản mới nhất!"
				Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
				Write-Log -LogPath $ServerLog -LogString $Message
			}else{
				$Message = "[$Time]: Máy chủ ""$($Server.SessionName)"" đã lỗi thời, cần được cập nhật!"
				Write-Host $Message -ForegroundColor "Yellow" -BackgroundColor "Black"
				Write-Log -LogPath $ServerLog -LogString $Message
				$NeedRestart = $Server.CheckVerTime + 15
				While($TimerCheckVer -le $StartCheckVer.AddMinutes($NeedRestart)){
					$TimeToMsg = $StartCheckVer.AddMinutes($NeedRestart).ToString("HH:mm")
					foreach ($MsgTime in $Server.MsgBeforRestart){
						$TimeCheck = (Get-Date).AddMinutes($MsgTime).ToString("HH:mm")
						if($TimeCheck -eq $TimeToMsg){
							if(!$MsgBeforUpdateRestartSend){
								$TestRCONConnection = CheckTCP -IP $Server.ManagementIP -Port $Server.RCONPort
								if($TestRCONConnection){
									$Message = "[$Time]: Gửi thông báo khởi động lại trước $MsgTime phút đến người chơi trên máy chủ ""$($Server.SessionName)""!"
									Write-Host $Message -ForegroundColor "Yellow" -BackgroundColor "Black"
									Write-Log -LogPath $ServerLog -LogString $Message
									$MsgSendToServer = "The_server_will_restart_in_" + [string]$MsgTime + "_minutes!"
									$MsgServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONMsgCMD) $MsgSendToServer`"" -Wait -PassThru -NoNewWindow
									$TimeOutCount = 0
									$MsgBeforUpdateRestartSend = $true
								}else{
									$TimeOutCount = $TimeOutCount + 1
									if($TimeOutCount -eq 10){
										$Message = "[$Time]: Đã có lỗi xảy ra! Không thể kết nối RCON với máy chủ ""$($Server.SessionName)""!"
										Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
										Write-Log -LogPath $ServerLog -LogString $Message
										$TimeOutCount = 0
									}
								}
							}
						}else{
							$MsgBeforUpdateRestartSend = $false
						}
					}
				}
				$TestRCONConnection = CheckTCP -IP $Server.ManagementIP -Port $Server.RCONPort
				if($TestRCONConnection){
					if(!$MsgRestart){
						$Message = "[$Time]: Tiến hành lưu dữ liệu máy chủ ""$($Server.SessionName)""!"
						Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
						Write-Log -LogPath $ServerLog -LogString $Message
						$SaveServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONSaveCMD)`"" -Wait -PassThru -NoNewWindow
						Start-Sleep -Seconds 60
						$Message = "[$Time]: Tiến hành khởi động lại máy chủ ""$($Server.SessionName)""!"
						Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
						Write-Log -LogPath $ServerLog -LogString $Message
						$ExitServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONExitCMD)`"" -Wait -PassThru -NoNewWindow
						$TimeOutCount = 0
						$MsgRestart = $true
						$StartCheckVer = Get-Date
					}
				}else{
					$TimeOutCount = $TimeOutCount + 1
					if($TimeOutCount -eq 10){
						$Message = "[$Time]: Đã có lỗi xảy ra! Không thể kết nối RCON với máy chủ ""$($Server.SessionName)""!"
						Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
						Write-Log -LogPath $ServerLog -LogString $Message
						$TimeOutCount = 0
					}
				}
			}
			$StartCheckVer = Get-Date
		}
		if($TimerCheckVer -ge $StartCheckBackup.AddMinutes($Server.BackupTime)){
			if(!$backuped){
				$backupfilename = (Get-Date).toString("dd-MM-yyyy-HH-mm")
				$backupPath = ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\SaveGames\" + $backupfilename + ".zip"
				$Message = "[$Time]: Tiến hành sao lưu dữ liệu máy chủ ""$($Server.SessionName)""!"
				Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
				Write-Log -LogPath $ServerLog -LogString $Message
				$null = Compress-Archive -Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\SaveGames\0" -DestinationPath $backupPath -Force
				$null = Get-ChildItem –Path ".\$($Config.ServerFolder)\$($Server.SeverPath)\Pal\Saved\SaveGames\" -Recurse -File -Include *.zip | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-$Server.DeleteOlderThanXDays))} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
				$StartCheckBackup = Get-Date
				$backuped = $true
			}
		}else{
			$backuped = $false
		}
		foreach ($RestartTime in $Server.RestartTime){
			if($Time -eq $RestartTime){
				if(!$RestartedOnDay){
					$TestRCONConnection = CheckTCP -IP $Server.ManagementIP -Port $Server.RCONPort
					if($TestRCONConnection){
						if(!$MsgRestart){
							$Message = "[$Time]: Tiến hành lưu dữ liệu máy chủ ""$($Server.SessionName)""!"
							Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
							Write-Log -LogPath $ServerLog -LogString $Message
							$SaveServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONSaveCMD)`"" -Wait -PassThru -NoNewWindow
							Start-Sleep -Seconds 60
							$Message = "[$Time]: Tiến hành khởi động lại máy chủ ""$($Server.SessionName)""!"
							Write-Host $Message -ForegroundColor "Green" -BackgroundColor "Black"
							Write-Log -LogPath $ServerLog -LogString $Message
							$ExitServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONExitCMD)`"" -Wait -PassThru -NoNewWindow
							$TimeOutCount = 0
							$MsgRestart = $true
							$RestartedOnDay = $true
						}
					}else{
						$TimeOutCount = $TimeOutCount + 1
						if($TimeOutCount -eq 10){
							$Message = "[$Time]: Đã có lỗi xảy ra! Không thể kết nối RCON với máy chủ ""$($Server.SessionName)""!"
							Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
							Write-Log -LogPath $ServerLog -LogString $Message
							$TimeOutCount = 0
						}
					}
				}
			}else{
				$MsgRestart = $false
				$RestartedOnDay = $false
				foreach ($MsgTime in $Server.MsgBeforRestart){
					$TimeCheck = (Get-Date).AddMinutes($MsgTime).ToString("HH:mm")
					if($TimeCheck -eq $RestartTime){
						if(!$MsgBeforRestartSend){
							$TestRCONConnection = CheckTCP -IP $Server.ManagementIP -Port $Server.RCONPort
							if($TestRCONConnection){
								$Message = "[$Time]: Gửi thông báo khởi động lại trước $MsgTime phút đến người chơi trên máy chủ ""$($Server.SessionName)""!"
								Write-Host $Message -ForegroundColor "Yellow" -BackgroundColor "Black"
								Write-Log -LogPath $ServerLog -LogString $Message
								$MsgSendToServer = "The_server_will_restart_in_" + [string]$MsgTime + "_minutes!"
								$MsgServer = Start-Process $MCRCON -ArgumentList "-c -H $($Server.ManagementIP) -P $($Server.RCONPort) -p $($Server.AdminPassword) `"$($Config.RCONMsgCMD) $MsgSendToServer`"" -Wait -PassThru -NoNewWindow
								$TimeOutCount = 0
								$MsgBeforRestartSend = $true
							}else{
								$TimeOutCount = $TimeOutCount + 1
								if($TimeOutCount -eq 10){
									$Message = "[$Time]: Đã có lỗi xảy ra! Không thể kết nối RCON với máy chủ ""$($Server.SessionName)""!"
									Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
									Write-Log -LogPath $ServerLog -LogString $Message
									$TimeOutCount = 0
								}
							}
						}
					}else{
						$MsgBeforRestartSend = $false
					}
				}
			}
		}
	}
	$Message = "[$Time]: Đã tắt máy chủ ""$($Server.SessionName)""!"
	Write-Host $Message -ForegroundColor "Red" -BackgroundColor "Black"
	Write-Log -LogPath $ServerLog -LogString $Message
	$MsgServerStarted = $false
	$CheckedConnect = $false
	$MsgCheckConnect = $false
	$MsgInternalSuccess = $false
	$MsgExternalSuccess = $false
	$MsgExternalError = $false
}