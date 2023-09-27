;PR_1
	area stack, noinit, readwrite
	space 0x400
stack_top
	area reset, data, readonly
	area program,code,readonly
	dcd stack_top
	dcd start
	entry
start
	;bl pp1
	;bl pp2
	;bl pp3
	;bl pp4
	bl pp5
	b start
pp1
	movs r0, #0
	moveq r1, #32
	movne r1, #150
	movs r2, #-1
	movs r3, #255
	movw r5, #0xcdef
	movt r5, #0x89ab
	ldr r6, = 0xfedcba98
	mov r4, r0
	adds r4, r1
	add r4, r2
	movs r7, r4, lsr # 2
	add r8, r4, #25
	add r9, r7, r4
	add r10, r4, r7, lsr #2
	push {r4}
	push {r5-r7}
	pop {r1, r0}
	pop {r3, r2}
	mov r0, #0x20000000
	str r5, [r0],#4
	str r6, [r0],#4
	str r7, [r0],#4
	ldr r8, [r0,#-4]!
	ldr r9, [r0,#-4]!
	ldr r10, [r0,#-4]!
	bx lr
pp2
	ldr r0, = 0x12345678
	rbit r1, r0
	rev r2, r0
	rev16 r3, r0
	revsh r4, r0
	bx lr
pp3
	ldr r0, = 0x20000010
	mov r1, #0x2D
	mov r2, #0x30C
	mov r3, #0x2D
	mov r4, #0x15
	str r1, [r0],#4
	str r2, [r0],#4
	str r3, [r0],#4
	str r4, [r0],#4
	push{r1-r4}
	pop{r9}
	pop{r9}
	pop{r8}
	pop{r7}
	bx lr
pp4
	ldr r0, = 0x03
	rrx r1, r0
	rrxs r2, r1
	rrxs r3, r2
	bx lr
pp5
	mov r0, #9
	mov r10, #1
	lsr r1, r0, r10
	lsr r2, r0, #2
	lsrs r3, r0, r10
	lsrs r4, r0, #2
	bx lr
endd








