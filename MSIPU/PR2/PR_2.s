; PR_2
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
	 ;bl pp3
	; bl pp4
	 ;bl pp5
	 ;bl pp6
	  ;bl pp7

	;bl pp8
	bl pp9
	b start
pp1
	ldr r0, =0x12345678
	movw r1, #0xffff
	mov r2, r1, ror #16
	mov r3, #0x05
	tsts r3, #1
	andne r4, r0, r1
	andeq r4, r0, r2
	tsts r3, #2
	orrne r5, r0, r1
	orreq r5, r0, r2
	tsts r3, #4
	eorne r6, r0, r1
	eoreq r6, r0, r2
	and r7, r0,#0xff
	and r8, r0,#0xff00
	lsr r8, r8, #8
	and r9, r0, #0xff0000
	lsr r9 ,r9, #16
	and r10, r0, #0xff000000
	lsr r10,r10, #24
	bx lr
pp2
	mov r0, #0x20000000
	mov r1, #0x22000000
	mov r2, #0
	mov r3, #1
	str r2, [r0]
	str r3, [r1]
	str r3, [r1,#0x04]
	str r3, [r1,#0x08]
	str r3, [r1,#0x0c]
	ldr r5, [r1,#0x08]
	ldr r6, [r0]
	mov r7, #0x0a
	str r7, [r0,#0x03]
	str r2, [r1,#0x64]
	str r2, [r1,#0x6c]
	ldr r8, [r0,#0x03]
	bx lr
pp3
	mov r0, #-45
	mov r1, #780
	mov r2, #45
	mov r3, #21
	lsl r5, r0, #4
	lsl r6, r1, #4
	lsl r7, r2, #4
	lsl r8, r3, #4
	asr r5, r0, #4
	asr r6, r1, #4
	asr r7, r2, #4
	asr r8, r3, #4
	lsr r5, r0, #4
	lsr r6, r1, #4
	lsr r7, r2, #4
	lsr r8, r3, #4
	ror r5, r0, #4
	ror r6, r1, #4
	ror r7, r2, #4
	ror r8, r3, #4
	rrxs r5, r0
	rrxs r6, r2
	rrxs r7, r3
	rrxs r8, r4
	bx lr
pp4
	mov r0, #-45
	mov r1, #780
	mov r2, #45
	mov r3, #21
	add r0, r1
	add r0,r2
	add r0,r3
	mov r0, #-45
	eor r0, r1
	eor r0,r2
	eor r0,r3
	eor r0,r4
pp5
	mov r0, #0x05
	mov r1, #0x16
	mov r2, #0x27
	mov r3, #0x38
	;r2 = r3 r0 r1 r2
	orr r12, r3, lsl #24
	orr r12, r0, lsl #16
	orr r12, r1, lsl #8
	orr r12, r2
pp6 
	mov r0, #1
	rrxs r0,r0
pp7
	mov r0, #100
	asr r0, #1 ;Деление на 2
	mov r0, r0, asl #2 ;Умножение на 4
	asr r0, #3 ;Деление на 8
pp8
	mov r0, #100
	mov r1, #-1
	tsts r0, #1 ;0
	tsts r0, #4	;1
	cmps r0, r0 
	ands r5,r0, #1 ;0
	ands r5,r0, #4 ;1
	cmps r1, #0 ;На отрицательность
	orrs r1,r1 ;На отрицательность
	tsts r0, #1
pp9
	mov r0, #0x15
	mov r1, #0x15
	rors r2,r0, #1
	rors r3,r2, #1
	rrxs r4, r1
	rrxs r5,r4
	bx lr
	end