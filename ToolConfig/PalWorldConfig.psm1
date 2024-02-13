#Cài đặt chung:
$Config = @{
	#Thư mục chứa toàn bộ máy chủ
	ServerFolder = "Pal_Server_Data"
	#Thư mục chứa SteamCMD
	SteamCMDFolder = "SteamCMD"
	#Thư mục chứa mcrcon
	RCONFolder = "McRCON"
	#Lệnh gửi tin nhắn đến máy chủ:
	RCONMsgCMD = "Broadcast"
	#Lệnh lưu dữ liệu máy chủ:
	RCONSaveCMD = "Save"
	#Lệnh thoát máy chủ:
	RCONExitCMD = "DoExit"
}
#$Config = New-Object -TypeName PsObject -Property $ConfigDetails

#Cài đặt server:
$Server = @{
	#Thư mục chứa máy chủ
	SeverPath = "Pal_Server_1"
	#Bật/Tắt cập nhật máy chủ mỗi khi khởi động: "True"/"False"
	UpdateOnStart = "True"
	#IP Local
	ManagementIP = "127.0.0.1"
	#Thời gian máy chủ sẽ khởi động lại trong ngày:
	RestartTime = @("05:00", "18:00")
	#Khoảng thời gian(phút) thông báo cho người chơi trước khi máy chủ khởi động lại
	MsgBeforRestart = @(15, 10, 5, 4, 3, 2, 1)
	#Chu kỳ(phút) kiểm tra phiên bản máy chủ khi đang chạy, nếu có cập nhật thì tiến hành khởi động lại và cập nhật(Yêu cầu UpdateOnStart = "True")
	CheckVerTime = 15
	#Chu kỳ(phút) sao lưu máy chủ một lần
	BackupTime = 30
	#Xóa tệp sao lưu cũ hơn x ngày:
	DeleteOlderThanXDays = 2
	#Tên máy chủ:
	SessionName = "Hoàng Đức Test Server"
	#Thông tin máy chủ:
	ServerDescription="Đây là máy chủ thử nghiệm tính năng của công cụ tự động tạo, khởi chạy và cập nhật máy chủ PalWorld của Hoàng Đức."
	#Mật khẩu máy chủ:
	ServerPassword=""
	#Mật khẩu quản trị:
	AdminPassword="123456"
	#Số người chơi tối đa:
	MaxPlayers = "32"
	#Cổng công cộng cho máy chủ Palworld.
	GamePort = "8211"
	#Cổng ngang hàng,
	QueryPort = "27015"
	#Bật tắt Remote Console (RCON) để quản trị máy chủ.
	RCONEnabled = "True"
	#Cổng giao tiếp Remote Console (RCON).
	RCONPort = "25575"
	#Đặt số lượng người chơi hợp tác tối đa trong một phiên.
	CoopPlayerMaxNum="4"
	#IP:Đặt địa chỉ IP công cộng cho máy chủ Palworld.
	PublicIP=""
	#Khu vực:
	Region=""
	#Bật tắt xác thực máy chủ.
	bUseAuth="True"
	#Độ khó:
	Difficulty="None"
	#Tốc độ thời gian ban ngày trong trò chơi:
	DayTimeSpeedRate="1.000000"
	#Tốc độ thời gian ban đêm trong trò chơi:
	NightTimeSpeedRate="1.000000"
	#Tỉ lệ kinh nghiệm:
	ExpRate="1.000000"
	#Tỉ lệ bắt pal: 2 <=> Tỉ lệ bắt thành công gấp đôi.
	PalCaptureRate="1.000000"
	#Tần suất pal xuất hiện trên bản đồ:
	PalSpawnNumRate="1.00000"
	#Sát thương của pal:
	PalDamageRateAttack="1.000000"
	#Tỉ lệ chống chịu sát thương của pal:
	PalDamageRateDefense="1.000000"
	#Sát thương người chơi:
	PlayerDamageRateAttack="1.000000"
	#Tỉ lệ chống chịu sát thương của người chơi:
	PlayerDamageRateDefense="1.000000"
	#Tỉ lệ đói của người chơi:
	PlayerStomachDecreaceRate="1.000000"
	#Tốc độ giảm thể lực của người chơi khi dùng sức:
	PlayerStaminaDecreaceRate="1.000000"
	#Tốc đồ hồi máu của người chơi:
	PlayerAutoHPRegeneRate="1.000000"
	#Tốc đồ hồi máu của người chơi khi ngủ:
	PlayerAutoHpRegeneRateInSleep="1.000000"
	#Tỉ lệ đói của pal:
	PalStomachDecreaceRate="1.000000"
	#Tốc độ giảm thể lực của pal khi dùng sức:
	PalStaminaDecreaceRate="1.000000"
	#Tốc đồ hồi máu của pal:
	PalAutoHPRegeneRate="1.000000"
	#Tốc đồ hồi máu của pal khi ngủ:
	PalAutoHpRegeneRateInSleep="1.000000"
	#Xác định mức sát thương(theo hệ số nhân) các vật phẩm được xây phải nhận khi bị tấn công.
	BuildObjectDamageRate="1.000000"
	#Xác định mức sát thương(theo hệ số nhân) các vật phẩm được xây phải nhận một cách tự nhiên theo thời gian
	BuildObjectDeteriorationDamageRate="1.000000"
	#Tỉ lệ rơi các vật phẩm có thể thu thập theo hệ số nhân.
	CollectionDropRate="1.000000"
	#Tỉ lệ theo hệ số nhân về HP của các vật phẩm có thể thu thập,đập được. -> 2 <=> gấp đôi giá trị HP
	CollectionObjectHpRate="1.000000"
	#Tốc độ hồi sinh theo hệ số nhân của các tài nguyên như cây, đá...-> Ví dụ = 2 <=> hồi sinh nhanh gấp đôi.
	CollectionObjectRespawnSpeedRate="1.000000"
	#Tỷ lệ rơi đồ theo hệ số nhân của kẻ thù -> Ví dụ = 2 <=> tỉ lệ rời đồ gấp đôi.
	EnemyDropItemRate="1.000000"
	#Vật phẩm rơi sau khi chết:
	#None = Không rơi đồ
	#Item = Chỉ vật phẩm
	#ItemAndEquipment = Items in Bag/Equipped drop
	#All = Rơi toàn bộ đồ + pal
	DeathPenalty="All"
	#Kích hoạt hoặc vô hiệu hóa sát thương giữa người chơi với người chơi.
	bEnablePlayerToPlayerDamage="False"
	#Bật hoặc tắt sát thương bạn bè.
	bEnableFriendlyFire="False"
	#Kích hoạt hoặc vô hiệu hóa kẻ thù xâm lược.
	bEnableInvaderEnemy="True"
	#Kích hoạt hoặc hủy kích hoạt UNKO (Kẻ tấn công về đêm không xác định).
	bActiveUNKO="False"
	#Bật hoặc tắt tính năng hỗ trợ ngắm cho tay cầm
	bEnableAimAssistPad="True"
	#Bật hoặc tắt tính năng hỗ trợ ngắm cho bàn phím.
	bEnableAimAssistKeyboard="False"
	#Số lượng vật phẩm rơi tối đa trong trò chơi.
	DropItemMaxNum="3000"
	#Số lượng vật phẩm UNKO tối đa rơi ra trong trò chơi.
	DropItemMaxNum_UNKO="100"
	#Số lượng căn cứ tối đa có thể xây dựng.
	BaseCampMaxNum="128"
	#Số lượng công nhân tối đa trong một căn cứ.
	BaseCampWorkerMaxNum="15"
	#Thời gian tối đa các vật phẩm tồn tại sau khi bị rơi.
	DropItemAliveMaxHours="1.000000"
	#Tự động thiết lập lại bang hội không có người chơi trực tuyến.
	bAutoResetGuildNoOnlinePlayers="False"
	#Thời gian các bang hội không có người chơi trực tuyến sẽ tự động thiết lập lại.
	AutoResetGuildTimeNoOnlinePlayers="72.000000"
	#Số người chơi tối đa trong bang hội:
	GuildPlayerMaxNum="20"
	#Thời gian nở mặc định cho trứng Pal.
	PalEggDefaultHatchingTime="72.000000"
	#Điều chỉnh tốc độ làm việc tổng thể trong trò chơi.
	WorkSpeedRate="1.000000"
	#Bật tắt chế độ nhiều người chơi:
	bIsMultiplay="True"
	#Bật tắt chế độ PVP:
	bIsPvP="False"
	#Cho phép hoặc vô hiệu hóa việc nhặt các vật phẩm rơi từ người chết của các bang hội khác.
	bCanPickupOtherGuildDeathPenaltyDrop="False"
	#Kích hoạt hoặc vô hiệu hóa các hình phạt không đăng nhập.
	bEnableNonLoginPenalty="True"
	#Bật tắt tính năng di chuyển nhanh:
	bEnableFastTravel="True"
	#Bật tắt lựa chọn vị trí bắt đầu trên bản đồ:
	bIsStartLocationSelectByMap="True"
	#Cho phép hoặc vô hiệu hóa sự tồn tại của người chơi sau khi đăng xuất.
	bExistPlayerAfterLogout="False"
	#Cho phép hoặc vô hiệu hóa khả năng phòng thủ của những người chơi khác trong bang hội.
	bEnableDefenseOtherGuildPlayer="False"
}

##################################################################
#Không được chỉnh sử khu vực này!
function CheckUDP {
	[CmdletBinding()]
	[OutputType([boolean])]
	param (
		$IP,
		$Port
	)
	$Result = $null
	$Success = $false
	$UdpClient = New-Object System.Net.Sockets.UdpClient
	$UdpClient.Client.ReceiveTimeout = 1000
	$UdpClient.Connect($IP, $Port)
	$a = new-object system.text.asciiencoding
	$byte = $a.GetBytes("$(Get-Date)")
	[void]$UdpClient.Send($byte, $byte.length)
	try
	{
		$remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any, 0)
		[string]$returndata = $a.GetString($UdpClient.Receive([ref]$remoteendpoint))
		If ($returndata)
		{
			$Success = $true
		}
	}
	catch
	{
		##############
	}
	Return $Success
}

function CheckTCP {
	[CmdletBinding()]
	[OutputType([boolean])]
	param (
		$IP,
		$Port
	)
	$Result = $null
	$Success = $false
	try
	{
		$TestConnection = Test-NetConnection -ComputerName $IP -Port $Port
		if($TestConnection.TcpTestSucceeded){
			$Success = $true
		}
	}
	catch
	{
		##############
	}
	Return $Success
}

function Write-Log {
	[CmdletBinding()]
	param (
		$LogPath,
		$LogString
	)
	$Stamp = (Get-Date).toString("dd/MM/yyyy ")
	$LogMessage = "$Stamp $LogString"
	Add-content $LogPath -value $LogMessage -Encoding utf8
}
#Xuất cài đặt:
Export-ModuleMember -Variable @("Config", "Server")
Export-ModuleMember -Function @("CheckUDP", "CheckTCP", "Write-Log")
##################################################################
