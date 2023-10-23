	;PR_4
	area stack, noinit, readwrite
	space 0x400
stack_top
	area reset, data, readonly
		area program,code,readonly
	dcd stack_top
	dcd start
	entry
start
	; bl pp1
	 ;bl pp2
	; bl pp3
	bl pp4 ;Array create
	bl pp5 ;Avg
m 	b 	m
pp1
	mov r0, #0x20000000
	ldr r1, = 0x20000010
	mov r2, #16
	mov r3, #0
	mov r4, #7
	mov r5, #9
m1
	strb r4, [r0], #1
	strb r5, [r1], #1
	add r3, #1
	add r4, #5
	mov r5, r3
	add r5, #-3
	mul r5, r5
	subs r2, #1
	bne m1
	bx lr
pp2
	ldr r1, = 0x20000020
	mov r2, #16
	mov r4, #1
	mov r5, #1
	strb r4, [r1], #1
	strb r5, [r1], #1
m2 add r4, r5
	strb r4, [r1], #1
	add r5, r4
	strb r5, [r1],#1
	subs r2, #2
	bpl m2
	bx lr
pp3
	mov r0, #0x20000000
	mov r1, #32
	mov r2, #0
	mov r3, #0
m3 ldrb r5, [r0],#1
	cmps r5, #20
	addls r2, #1
	cmps r5, #40
	addls r3, #1
	subs r1, #1
	bpl m3
	sub r4, r3, r2
	strb r2, [r0],#1
	strb r3, [r0],#1
	strb r4, [r0],#1
	bx lr
pp4 ;Create array
	mov r0, #0x20000000
	mov r1, #0 ;counter
m4 	
	mul r2, r1,r1 ;n^2
	mul r2,r1 ;n^3
	lsl r2, #1 ;2*n^2
	add r2, r1 ; 2*n^2 + n
	add r2, #1
	strb r2, [r0], #1
	add r1, #1
	cmps r1, #16
	bmi m4
	bx lr
pp5 ;avg
	mov r0, #0x20000000
	mov r1, #0 ;counter
m5	
	ldrb r5, [r0],#1
	add r3, r5
	add r1, #1
	cmps r1, #16
	bmi m5
	lsr r3, #4
	strb r3, [r0]
	bx lr
end