$regfile = "m32def.dat"
$crystal = 11059200
$hwstack = 64
$swstack = 100
$framesize = 100
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2
Dim Maxin As String * 5
Pg Alias Porta.0 : Config Pg = Output

Config Single = Scientific , Digits = 2
Declare Sub Send_unicode(phone As String , Text As String)
Dim S(71) As Byte
Dim Sms As String * 70 At S Overlay
Dim Phone_number As String * 11
Dim Temp As Single
Temp = -10.46
Phone_number = ""
Phone_number = "09120197955"
Wait 30

Sms = ""
Sms = "Çíä íÇã ÈÇ ÈÓ˜Çã ÇÑÓÇá ÔÏå ÇÓÊ."
Call Send_unicode(phone_number , Sms )

Wait 1
Sms = ""
Sms = "ÏãÇí åæÇ"
Sms = Sms + Chr(10)
Sms = Sms + Str(temp) + " °C"
Sms = Sms + Chr(10)
Sms = Sms + "ÇÓÊ."
Call Send_unicode(phone_number , Sms )



Do
  Home
  Lcd Temp
  Wait 1
  Toggle Pg


                                                    ' THIRD Command Text Mode
Print "AT+CMGF=1"
Wait 1
Waitms 100
Inputbin Maxin
Cls
locate 2,1
Lcd Maxin
Loop

End

Sub Send_unicode(phone As String , Text As String)
Local Str_len As Byte , Index As Byte , I As Byte
Str_len = Len(text)
Print "AT+CMGF=1"
Waitms 200
Print "AT+CSCS=" ; Chr(34) ; "HEX" ; Chr(34)
Waitms 200
 Print "AT+CSMP=49,167,0,8"
 Waitms 200
Print "AT+CMGS=" ; Chr(34) ; Phone ; Chr(34)
Waitms 200

For I = 1 To Str_len
If S(i) > 127 Then
Index = Lookdown(s(i) , Ascii , 37)
If Index <> -1 Then
Index = Index - 1
If S(i) = 176 Then
Print "00" ; Hex(lookup(index , Unicode)) ;
Else
Print "06" ; Hex(lookup(index , Unicode)) ;
End If
End If
Elseif S(i) >= &H30 And S(i) <= &H39 Then
 S(i) = S(i) + &H30
Print "06" ; Hex(s(i));
Else
Print "00" ; Hex(s(i));
End If
Next
Print Chr(26)
Wait 5
Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
Waitms 200
 Print "AT+CSMP=17,167,0,16"
 Waitms 200
End Sub


Ascii:
'data "Ç" , "È" , "" , "Ê" , "Ë" , "Ì" , "" , "Í" , "Î" , "Ï" , "Ð" , "Ñ" , "Ò" , "Ž" , "Ó" , "Ô" , "Õ" , "Ö" , "Ø" , "Ù" , "Ú" , "Û" , "Ý" , "Þ" , "˜" , "˜" , "" , "á" , "ã" , "ä" , "å" , "æ" , "í" , "Â" , "¡" , "í" , "°"
Data 199 , 200 , 129 , 202 , 203 , 204 , 141 , 205 , 206 , 207 , 208 , 209 , 210 , 142 , 211 , 212 , 213 , 214 , 216 , 217 , 218 , 219 , 221 , 222 , 152 , 223 , 144 , 225 , 227 , 228 , 229 , 230 , 237 , 194 , 161 , 236 , 176

Unicode:
Data &H27 , &H28 , &H7E , &H2A , &H2B , &H2C , &H86 , &H2D , &H2E , &H2F , &H30 , &H31 , &H32 , &H98 , &H33 , &H34 , &H35 , &H36 , &H37 , &H38 , &H39 , &H3A , &H41 , &H42 , &HA9 , &H43 , &HAF , &H44 , &H45 , &H46 , &H47 , &H48 , &H4A , &H22 , &H0C , &H49 , &HB0