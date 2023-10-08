; PR_3
	area stack, noinit, readwrite
	space 0x400
stack_top
	area reset, data, readonly
	dcd stack_top
	dcd start
	area program,code,readonly
	entry
start
	;bl pp1
	;bl pp2
	 bl pp3
	b start
pp1
	mov r0, #0x20000000
	mov r1, #1
	mov r2, #-1
	mov r3, #127
	mov r4, #-128
	strb r0, [r0]
	strb r1, [r0,#1]
	strb r2, [r0,#2]
	strb r3, [r0,#3]
	strb r4, [r0,#4]
	ldrsb r5, [r0,#2]
	ldrb r6, [r0,#2]
	bx lr
pp2
	ldr r8, = -2
	ldr r9, = 3
	ldr r10, =-4
	ldr r11, =5
	smull r0, r1, r8, r9
	smull r2, r3, r10, r11
	adds r4, r0, r2
	adcs r5, r1, r3
	rrx r5, r5
	rrx r4, r4
	bx lr
pp3
	mov r0, #0x20000000
	mov r1, #50
	mov r2, #-100
	mov r3, #-250
	mov r4, #100
	add r5, r1, r2
	add r5, r3
	add r5, r4
	asr r6, r5, #2
	strb r6, [r0]
	ldrsb r7, [r0]
	ldrb r8, [r0]
	bx lr
pp4
	
	bx lr
	end