$regfile="m8def.dat"
$crystal=8000000



dim t1 as word
dim t2 as word
dim t3 as word
dim test as byte
dim a as byte
dim i as byte

config portd.0=INPUT
config portd.1=INPUT
config portd.5=INPUT

in1 alias pind.0
in2 alias pind.1
in3 alias pind.5

led3 alias portc.5
led2 alias portc.4
led1 alias portc.3

config portc.5=OUTPUT
config portc.4=OUTPUT
config portc.3=output

relay3 alias portc.2
relay2 alias portc.1
relay1 alias portc.0

config portc.2=OUTPUT
config portc.1=OUTPUT
config portc.0=OUTPUT

const timeout=600

enable interrupts
enable timer0
on timer0 t0rutin
config timer0=timer,prescale=1024
stop timer0

set led1
set led2
set led3
wait 5
reset led1
reset led2
reset led3

set led1
set relay1

wait 2

set led2
set relay2

wait 2

set led3
set relay3

wait 2

reset led1
reset relay1

wait 2

reset led2
reset relay2

wait 2

reset led3
reset relay3

wait 2
start timer0
main:

do

     if in1=1 then
        waitms 200
        if in1=1 and relay1=0 then
           set relay1
           set led1
           t1=timeout
        end if
     end if

     if in2=1 and relay2=0 then
        waitms 200
        if in2=1 then
           set relay2
           set led2
           t2=timeout
        end if
     end if

     if in3=1 and relay3=0 then
        waitms 200
        if in3=1 then
           set relay3
           set led3
           t3=timeout
        end if
     end if

loop

t0rutin:
        incr test

        a=test mod 10
        '(
        if a=0 then
           if t1=0 and t2=0 and t3=0 then
              incr i
              if i=1 then toggle led1
              if i=2 then toggle led2
              if i=3 then
                 toggle led3
                 i=0
              end if
           end if
        end if
  ')

        if a=0 then
           if relay1=1 and in1=1 then reset led1
           if relay2=1 and in2=1 then reset led2
           if relay3=1 and in3=1 then reset led3
        end if

        if test=30 then
           test=0

           if t1>0 then
              decr t1
              set led1
              if t1=0 then
                 reset led1
                 reset relay1
              end if
           end if
           if t2>0 then
              decr t2
              set led2
              if t2=0 then
                 reset led2
                 reset relay2
              end if
           end if
           if t3>0 then
              decr t3
              set led3
              if t3=0 then
                 reset led3
                 reset relay3
              end if
           end if

        end if

return



end
