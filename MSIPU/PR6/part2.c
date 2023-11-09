	cmp r3, #0x00
	bne m2
	bx lr
pp3	ldr rO, = func1 ;baza X(n) 
	mov rl, #0 				;undex n 
	ldr,= 0x20000040	;baza Y(k)
	mov r3, #0 				;undex k 
	mov r4, #0 				;x(n) 
	mov r5, #0				;x(n-l)
	mov r6, #0 				;x(nl2)
	mov r7, #0				;x(n-3)
m3 sub r8, r7 			;s:=s-x(n-3)
	mov R7, r6				;nev x(n-3)
	mov R6, r5				;nev x(n-2)
	mov R5, r4				;nev x(n-l)             
	ldrsb r4,[rO,rl]	;nev x(n) 
	add r8, r4 				;s:=s+ y(n)
	mov r9, r8, asr # 2 ;r8= s/4
	strb r9 [r2, r3]		;write y(n+l) 
	add r1, #1				;n =n + 1
	add r1, #0x0f
	add r3, #1				;k:= k+1
	ands r3, #0x01f 
	cmp r3, #0x00
	bne m3 
	bx lr
func1
	deb 120,120,120,120
	deb 120,120,120,120
	deb 20,20,20,20
	deb 20,20,20,20 
func2
	deb 120,120,20,20
	deb 120,120,20,20
	deb 120,120,20,20
	deb 120,120,20,20 
func3
	deb 0,38,71,92
	deb 100,92,71,38
	deb 0,-38,-71,-92
	deb -100,-92,-71,-38 
func4
	deb 0,100,0,-100
	deb 0,100,0,-100
	deb 0,100,0,-100
	deb 0,100,0,-100
end