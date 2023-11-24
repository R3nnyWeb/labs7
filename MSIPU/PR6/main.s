 ;PR_6
	area reset, data, readonly
	area stack, noinit, readwrite
	space 0x400
stack_top
	area program,code,readonly
	dcd stack_top
	dcd start
	entry
start
	bl pp1
;	bl pp2
; 	bl pp3
m	b m
pp1
	ldr r0, = func3 ;baza X(k)
	mov r1, #0 ;index l
	mov r2, #0x20000000 ;baza Y(n)
	mov r3, #0 ; index n
	mov r6, #0 ;y(n)
m1
	ldrsb r5, [r0,r1] ; x(n)
	sub r7, r5, r6 ; (x(n) - y(n))
	add r8, r6, r7, asr #2 ; y(n + 1)
	strb r8, [r2,r3] ;write y(n + 1)
	mov r6, r8 ;new y(n)
	add r1, #1 ;k = k + 1
	and r1, #0x0f ; cout mod 16
	add r3, #1 ; n++
	ands r3, #0x01f ; cout mod 32
	cmp r3, #0x00
	bne m1
	bx lr
pp2 
	ldr r0, =func5 ; baza X(k)
	mov r1, #0 ;index k
	ldr r2, = 0x20000020 ;baza Y(n)
	mov r3, #0 ;index n
	mov r5, #0 ; x(n)
	mov r6, #0 ;y(n+1)
m2 	ldrsb r7, [r0,r1] ;x(n+1)
	mov r8, r7 ; r8= x(n+1)
	sub r8, r5 ;-x(n)
	add r8, r6 ; +(y(n))
	sub r8, r6, asr #2 ;r8 = (y(n+1))
	strb r8, [r2,r3] ;write y(n+1)
	mov r5, r7 ; new x(n)
	mov r6, r8 ; new y(n)
	add r1, #1 ;k = k + 1
	and r1, #0x0f
	add r3, #1 ;n++
	ands r3, #0x01f
	cmp r3, #0x00
	bne m2
	bx lr
pp3	ldr r0, = func5 ;baza X(n) 
	mov r1, #0 				;undex n 
	ldr r2,= 0x20000040	;baza Y(k)
	mov r3, #0 				;undex k 
	mov r4, #0 				;x(n) 
	mov r5, #0				;x(n-l)
	mov r6, #0 				;x(nl2)
	mov r7, #0				;x(n-3)
m3 sub r8, r7 			;s:=s-x(n-3)
	mov R7, r6				;nev x(n-3)
	mov R6, r5				;nev x(n-2)
	mov R5, r4				;nev x(n-l)             
	ldrsb r4,[r0,r1]	;nev x(n) 
	add r8, r4 				;s:=s+ y(n)
	mov r9, r8, asr # 2 ;r8= s/4
	strb r9, [r2, r3]		;write y(n+l) 
	add r1, #1				;n =n + 1
	and r1, #0x0f
	add r3, #1				;k:= k+1
	ands r3, #0x01f 
	cmp r3, #0x00
	bne m3 
	bx lr
func1
	dcb 120,120,120,120
	dcb 120,120,120,120
	dcb 20,20,20,20
	dcb 20,20,20,20 
func2
	dcb 120,120,20,20
	dcb 120,120,20,20
	dcb 120,120,20,20
	dcb 120,120,20,20 
func3
	dcb 0,38,71,92
	dcb 100,92,71,38
	dcb 0,-38,-71,-92
	dcb -100,-92,-71,-38 
func4
	dcb 0,100,0,-100
	dcb 0,100,0,-100
	dcb 0,100,0,-100
	dcb 0,100,0,-100
func5 
	dcb 0,71,100,71
	dcb 0,-71,-100,-71
	dcb 0,71,100,71
	dcb 0,-71,-100,-71
	end
	
