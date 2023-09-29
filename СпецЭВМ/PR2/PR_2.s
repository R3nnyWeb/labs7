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
	 bl pp1
	;bl pp2
	; bl pp3
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
	bx lr
	end