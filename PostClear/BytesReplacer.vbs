Set stream = CreateObject("ADODB.Stream")
' 74 1F 48 63 D0 48 8D 0D 91 E4 02 00 48 C1 E2 04 48 03 D1 48 8B CF 48 89 57 60 8B D0 E8 28 02 00 00
find = Chr(116)&Chr(31)&Chr(72)&Chr(99)&ChrW(208)&Chr(72)&ChrW(141)&Chr(13)&Chr(145)&ChrW(228)&Chr(2)&Chr(0)&Chr(72)&ChrW(193)&ChrW(226)&Chr(4)&Chr(72)&Chr(3)&ChrW(209)&Chr(72)&Chr(139)&ChrW(207)&Chr(72)&Chr(137)&Chr(87)&Chr(96)&Chr(139)&ChrW(208)&ChrW(232)&Chr(40)&Chr(2)&Chr(0)&Chr(0)
stream.Open
stream.Type = 2
stream.Charset = "Windows-1252"
stream.LoadFromFile WScript.Arguments(0)
data = stream.ReadText
stream.Close
If InStr(data, find) > 0 Then
	data = Replace(data, find, ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144)&ChrW(144))
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
