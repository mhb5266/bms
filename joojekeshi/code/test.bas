
   $regfile = "m32def.dat"
   $crystal = 8000000
   $hwstack = 80
   $swstack = 100
   $framesize = 100
   $baud = 9600
Configs:
   'Config Timer1 = Timer , Prescale = 8
   'Enable Interrupts
   'Enable Timer1
   'On Timer1 T1rutin
   Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
   Config Lcd = 16x2
   Config Portb.1 = Output
Defines:
   Dim A As Byte

Subs:
Declare Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
'Dht_put Alias Portb.0                                       'Sensor pins
'Dht_get Alias Pinb.0
'Dht_io_set Alias Ddrb.0
Dim Temperature As String * 6 , Humidity As String * 5
Dim Temp As Single , Hum As Single , B As Byte

Dht_put Alias Portb.0
Dht_get Alias Pinb.0
Dht_io_set Alias Ddrb.0
Dim Temp_dht22 As String * 5 '12,2°C
Dim Humi_dht22 As String * 4 '23,3 %
Dim Aktuali_zeit_Temperatur as Word
Declare Sub Get_DHT22()
Set Dht_io_set
Set Dht_put


Startup:
   Stop Timer1
   Lcd "HI"
   Wait 3
   Cls

Main:
   Do
     'Wait 1
      '(
      B = Dht_read(hum , Temp)
      If B = 0 Then
      Print "error read sensor dht"
      Else
        Humidity = Fusing(hum , "#.#") + "%"
        Temperature = Fusing(temp , "#.#") + "C"
        'Home
        'Lcd Temperature ; " `c"
        'Lowerline
        'Lcd Humidity ; " %"
        Print "Temp=" ; Temperature ; "    ";
        Print "Hum=" ; Humidity
        Print "type sensor : dht" ; Str(b)
      End If
')

  if Aktuali_zeit_Temperatur >= 10000 then
    Aktuali_zeit_temperatur = 0
    Call Get_dht22()
    'Call Text(1 , Temp_dht22 +"°C" , Grun , Reset_ja)
    'Call Text(2 , Humi_dht22 +"%" , Rot , Reset_ja)
    Else
    Incr Aktuali_zeit_Temperatur
  End If

        Wait 3
        Toggle Portb.1
   Loop


T1rutin:
Return
'(
Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
         Local Number_dht As Byte , Byte_dht As Byte
         Local Hum_msb As Byte , Hum_lsb As Byte , Temp_msb As Byte , Temp_lsb As Byte , Check_sum As Byte
         Set Dht_io_set                                     'bus is output
         Reset Dht_put : Waitms 1                           'bus=0
         Set Dht_put : Waitus 40                            'bus=1
         Reset Dht_io_set : Waitus 40                       'bus is input
         If Dht_get = 1 Then                                'not DHT22?
            Goto Dht11_check                                'try DHT11
         Else
            Waitus 80
            If Dht_get = 0 Then
               Dht_read = 0                                 'DHT22 not response!!!
               Exit Function
            Else
               Dht_read = 22                                'really DHT22
               Goto Read_dht_data
            End If
         End If
         Dht11_check:
         Set Dht_io_set                                     'bus is output
         Reset Dht_put : Waitms 20                          'bus=0
         Set Dht_put : Waitus 40                            'bus=1
         Reset Dht_io_set : Waitus 40                       'bus is input
         If Dht_get = 1 Then
            Dht_read = 0                                    'DHT11 not response!!!
            Exit Function
         End If
         Waitus 80
         If Dht_get = 0 Then
             Dht_read = 0                                   'DHT11 not response!!!
            Exit Function
         Else
            Dht_read = 11                                   'really DHT11
         End If
         Read_dht_data:
         Bitwait Dht_get , Reset                            'wait for transmission
         For Number_dht = 1 To 5
            For Byte_dht = 7 To 0 Step -1
               Bitwait Dht_get , Set
               Waitus 35
               If Dht_get = 1 Then
               Select Case Number_dht
               Case 1 : Hum_msb.byte_dht = 1
               Case 2 : Hum_lsb.byte_dht = 1
               Case 3 : Temp_msb.byte_dht = 1
               Case 4 : Temp_lsb.byte_dht = 1
               Case 5 : Check_sum.byte_dht = 1
               End Select
                  Bitwait Dht_get , Reset
               Else
               Select Case Number_dht
               Case 1 : Hum_msb.byte_dht = 0
               Case 2 : Hum_lsb.byte_dht = 0
               Case 3 : Temp_msb.byte_dht = 0
               Case 4 : Temp_lsb.byte_dht = 0
               Case 5 : Check_sum.byte_dht = 0
               End Select
               End If
            Next
         Next
         Set Dht_io_set : Set Dht_put
         If Dht_read = 22 Then                              'CRC check
            Byte_dht = Hum_msb + Hum_lsb
            Byte_dht = Byte_dht + Temp_msb
            Byte_dht = Byte_dht + Temp_lsb
         Else
            Byte_dht = Hum_msb + Temp_msb
         End If
         If Byte_dht <> Check_sum Then
         Dht_read = 0                                       'CRC error!!!
         Else
            If Dht_read = 22 Then
               Dht_hum = Hum_msb * 256
               Dht_hum = Dht_hum + Hum_lsb
               Dht_hum = Dht_hum / 10
               Dht_temp = Temp_msb * 256
               Dht_temp = Dht_temp + Temp_lsb
               Dht_temp = Dht_temp / 10
               If Temp_msb.7 = 1 Then
               Dht_temp = Dht_temp * -1
               End If
            Elseif Dht_read = 11 Then
               Dht_temp = Temp_msb
               Dht_hum = Hum_msb
            End If
         End If
End Function
')


Do



  Loop
  Sub Get_DHT22()
    Local Chksum As Byte
    Local Crc As Byte
    Local Mybyte As Byte
    Local Sensor_data As String * 40
    Local Count As Byte
    Local T As Word
    Local H As Word
    Local T_String As String *4
    Local H_String As String *4
    Local Data_temp As String * 16
    Count = 0
    Sensor_data = ""
    Dht_io_set = 1
    Dht_put = 0
    Waitms 1
    Dht_put = 1
    Waitus 20
    Dht_io_set = 0
    Waitus 40
    If Dht_get = 1 Then
        Temp_dht22 = "Err1"
        Humi_dht22 = "Err1"
        Exit Sub
    End If
    Waitus 80
    If Dht_get = 0 Then
        Temp_dht22 = "Err2"
        Humi_dht22 = "Err2"
        Exit Sub
    End If
    While Dht_get = 1 : Wend
    Do
        While Dht_get = 0 : Wend
        Waitus 30
        If Dht_get = 1 Then
                Sensor_data = Sensor_data + "1"
                While Dht_get = 1 : Wend
                Else
                Sensor_data = Sensor_data + "0"
        End If
        Incr Count
    Loop Until Count = 40
    Dht_io_set = 1
    Dht_put = 1
    Data_temp = Left(sensor_data , 16)
    H = Binval(Data_temp)
    H_String =Str (H)
    Data_temp = Mid(sensor_data , 17 , 16)
    T = Binval(Data_temp)
    T_String =Str (T)
    Data_temp = Right(sensor_data , 8)
    Crc = Binval(Data_temp)
    Chksum = Low(H ) + High(H )
    Chksum = Chksum + Low(T)
    Chksum = Chksum + High(T)
    If Chksum = Crc Then
        Temp_dht22 = Format(t_string , "#.#")
        Humi_dht22 = Format(H_String , "#.#")
        Else
        Temp_dht22 = "Err3"
        Humi_dht22 = "Err3"
    End If
  End Sub