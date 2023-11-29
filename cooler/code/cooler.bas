$regfile="m16def.dat"
$crystal=11059200



defines:
dim i as byte
dim j as byte
dim k as word:k=65535
dim t as byte
const shift_delay=30
dim strr as string*4:strr="1"
dim stri(4) as string*1
dim num(4) as byte

declare sub lookupp

configs:
        shcp alias portc.0:config portc.0=OUTPUT
        ds alias portc.1:config portc.1=OUTPUT
        stcp alias portc.2:config portc.2=OUTPUT
        clr alias portc.3:config portc.3=OUTPUT
        pg alias portc.4:config portc.4=OUTPUT
        config portd=OUTPUT


main:

   do
     portd=i
     'strr=str(i)
     strr="Abcd"
     strr=format(strr,"0000")
     for j=1 to 4
        stri(j)=mid(strr,j,1)
     next
     strr=stri(4)
     'strr="0"
     lookupp

     k=k+14
     'For J = 1 To 12 ' 8 bits per byte to process
         Shiftout ds , shcp , k , 3 , 12 , Shift_delay
     'Next J
     set stcp
     waitus 50
     reset stcp
     waitms 10
     reset clr
     waitus 10
     set clr

     strr=stri(3)
     lookupp
     k=k+13
     'For J = 1 To 12 ' 8 bits per byte to process
         Shiftout ds , shcp , k , 3 , 12 , Shift_delay
     'Next J
     set stcp
     waitus 50
     reset stcp
     waitms 10
     reset clr
     waitus 10
     set clr
     strr=stri(2)
     lookupp
     k=k+11
     'For J = 1 To 12 ' 8 bits per byte to process
         Shiftout ds , shcp , k ,3 , 12 , Shift_delay
     'Next J
     set stcp
     waitus 50
     reset stcp
     waitms 10
     reset clr
     waitus 10
     set clr
     strr=stri(1)
     lookupp
     k=k+7
     'For J = 1 To 12 ' 8 bits per byte to process
         Shiftout ds , shcp , k , 3 , 12 , Shift_delay
     'Next J
     set stcp
     waitus 50
     reset stcp
     waitms 10
     reset clr
     waitus 10
     set clr

     incr t
     if t=25 then
        t=0
        incr i
        'if i>9 then i=0
     end if

    '(
     wait 1
     incr i
     if i>9 then i=0
     toggle portc.4
      ')
   loop






end

sub lookupp

    select case strr
           case "0"
                 k=&b111111000000
           case "1"
                 k=&b011000000000
           case "2"
                 k=&b110110100000
           case "3"
                 k=&b111100100000
           case "4"
                 k=&b011001100000
           case "5"
                 k=&b101101100000
           case "6"
                 k=&b101111100000
           case "7"
                 k=&b111000000000

           case "8"
                 k=&b111111100000
           case "9"
                 k=&b111101100000

           case "A"
                 k=&b111011100000
           case "b"
                 k=&b001111100000
           case "c"
                 k=&b100111000000
           case "d"
                 k=&b011110100000
           case "E"
                 k=&b100111100000
           case "F"
                 k=&b011100000000
           case "p"
                 k=&b110011100000
           case "q"
                 k=&b111001100000
           case else
                 k=&b000000000000




    end select

end sub