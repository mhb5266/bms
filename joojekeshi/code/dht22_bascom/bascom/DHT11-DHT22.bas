$regfile = "m16def.dat"
$crystal = 8000000
$hwstack = 80
$swstack = 100
$framesize = 100
$baud = 9600

declare function dht_read( Dht_hum As Single , Dht_temp As Single) as byte


Dht_put Alias PortB.0                         'Sensor pins
Dht_get Alias PinB.0
Dht_io_set Alias DdrB.0

Dim Temperature As String * 6 , Humidity As String * 5
dim temp As Single , hum As Single , b as Byte


Do
 b=dht_read(hum,temp)
 if b=0 then
 print "error read sensor dht"
 else
   Humidity = Fusing(hum , "#.#") + "%"
   Temperature =Fusing(temp, "#.#") + "C"
   print "Temp=" ; Temperature;"    ";
   print "Hum=" ; Humidity
   print "type sensor : dht";str(b)
 end if
   wait 2
Loop
End

function dht_read(Dht_HUM As Single , Dht_TEMP As Single) as byte
Local Number_dht As Byte , Byte_dht As Byte
local hum_msb as byte , hum_lsb as byte ,temp_msb as byte ,temp_lsb as byte  ,check_sum as byte

Set Dht_io_set                                              'bus is output
Reset Dht_put : Waitms 1                                    'bus=0
Set Dht_put : Waitus 40                                     'bus=1
Reset Dht_io_set : Waitus 40                                'bus is input
If Dht_get = 1 Then                                         'not DHT22?
   Goto Dht11_check                                         'try DHT11
Else
   Waitus 80
   If Dht_get = 0 Then
      dht_read=0                                    'DHT22 not response!!!
      Exit function
   Else
      dht_read=22                                        'really DHT22
      Goto Read_dht_data
   End If
End If

Dht11_check:
Set Dht_io_set                                              'bus is output
Reset Dht_put : Waitms 20                                   'bus=0
Set Dht_put : Waitus 40                                     'bus=1
Reset Dht_io_set : Waitus 40                                'bus is input
If Dht_get = 1 Then
   dht_read=0                                       'DHT11 not response!!!
   Exit function
End If
Waitus 80
If Dht_get = 0 Then
    dht_read=0                                      'DHT11 not response!!!
   Exit function
Else
   dht_read=11                                            'really DHT11
End If

Read_dht_data:
Bitwait Dht_get , Reset                                     'wait for transmission
For Number_dht = 1 To 5
   For Byte_dht = 7 To 0 Step -1
      Bitwait Dht_get , Set
      Waitus 35
      If Dht_get = 1 Then
      select  case  number_dht
      case 1 : hum_msb.byte_dht = 1
      case 2 : hum_lsb.byte_dht = 1
      case 3 : temp_msb.byte_dht = 1
      case 4 : temp_lsb.byte_dht = 1
      case 5 : check_sum.byte_dht = 1
      end select
         Bitwait Dht_get , Reset
      Else
      select  case  number_dht
      case 1 : hum_msb.byte_dht = 0
      case 2 : hum_lsb.byte_dht = 0
      case 3 : temp_msb.byte_dht = 0
      case 4 : temp_lsb.byte_dht = 0
      case 5 : check_sum.byte_dht = 0
      end select
      End If
   Next
Next
Set Dht_io_set : Set Dht_put

If dht_read=22 Then                                       'CRC check
   Byte_dht = hum_msb + hum_lsb
   Byte_dht = Byte_dht + temp_msb
   Byte_dht = Byte_dht + temp_lsb
Else
   Byte_dht = hum_msb + temp_msb
End If

If Byte_dht <>  check_sum Then

dht_read=0                                        'CRC error!!!
Else
   If dht_read=22 Then
      Dht_HUM = hum_msb * 256
      Dht_HUM = Dht_HUM + hum_lsb
      Dht_HUM = Dht_HUM / 10

      Dht_TEMP = temp_msb * 256
      Dht_TEMP = Dht_TEMP + temp_lsb
      Dht_TEMP = Dht_TEMP / 10
      If temp_msb.7 = 1 Then
      Dht_TEMP=Dht_TEMP*-1
      End If
   Elseif dht_read=11 then
      Dht_TEMP =temp_msb
      Dht_HUM = hum_msb
   End If
End If
end function