
_int0_rutin:

;MyProject.mbas,7 :: 		sub procedure int0_rutin() iv IVT_ADDR_INT0 ics ICS_OFF
;MyProject.mbas,8 :: 		end sub
L_end_int0_rutin:
	RETI
; end of _int0_rutin

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27

;MyProject.mbas,11 :: 		main:
L_end_main:
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
