Set stream = CreateObject("ADODB.Stream")
' 74 1F 48 8D 15 31 35 03 00 48 63 C8 48 C1 E1 04 48 03 CA 8B D0 48 89 4F 60 48 8B CF E8 25 02 00 00
find2 = Chr(116)&Chr(31)&Chr(72)&ChrW(141)&Chr(21)&Chr(49)&Chr(53)&Chr(3)&Chr(0)&Chr(72)&Chr(99)&ChrW(200)&Chr(72)&ChrW(193)&ChrW(225)&Chr(4)&Chr(72)&Chr(3)&ChrW(202)&Chr(139)&ChrW(208)&Chr(72)&Chr(137)&Chr(79)&Chr(96)&Chr(72)&Chr(139)&ChrW(207)&ChrW(232)&Chr(37)&Chr(2)&Chr(0)&Chr(0)
stream.Open
stream.Type = 2
stream.Charset = "Windows-1252"
stream.LoadFromFile WScript.Arguments(0)
data = stream.ReadText
stream.Close
If InStr(data, find2) > 0 Then
	data = Replace(data, find2, ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144))
	replaced = True
End If
if replaced Then
	stream.Open
	stream.Type = 2
	stream.Charset = "Windows-1252"
	stream.WriteText data
	stream.SaveToFile WScript.Arguments(1), 2
	stream.Close
	result = True
End If
if result Then
	WScript.Echo "Операция замены выполнена."
Else
	WScript.Echo "Ошибка операции."
End If
Set stream = Nothing
