	area stack, noinit, readwrite
	space 0x400
stack_top
	area reset, data, readonly
	dcd stack_top
	dcd start
	area program, code, readonly
	entry
start
	ldr r0, = func4; base func
	mov r1, #0 ; index n
	ldr r2, = gs ;base gs
	mov r6, #0x20000000 ; base out
	mov r4, #0 ;faza fi
	mov r5, #1 ;k-num garmoniciki
k 	mov r3, r4 ;m = fi
	mov r9, #0
	mov r10, #0
	mov r11, #0 ;accums
m	ldrsb r7, [r0, r1] ;func(n)
	ldrsb r8, [r2, r3] ;gs(m)
	smull r10, r9, r7, r8
	add r11, r10
	add r3, r5 ;m = m+k
	and r3, #0x0f
	add r1, #1
	ands r1, #0x0f
	cmps r1, 0x00
	bne m
	asr r11, #10
	str r11, [r6], #4
	eors r4, #0x4
	bne k
	add r5, #1
	cmps r5, #5
	bne k
bc	b bc
gs dcb 0,49,91,118
	dcb 127,118,81,49
	dcb 0,-49,-91,-118
	dcb -127,-118,-81,-49
func1 dcb 0,38,71,92
	dcb 100,92,71,38
	dcb 0,-38,-71,-92
	dcb -100,-92,-71,-38
func2 dcb 100,92,71,38
	dcb 0,-38,-71,-92
	dcb -100,-92,-71,-38
	dcb 0,38,71,92
func3 dcb 0,71,100,71	
	dcb 0,-71,-100,-71
	dcb 0,71,100,71
	dcb 0,-71,-100,-71
func4 dcb 10,10,10,10	
	dcb 10,10,10,10
	dcb -10,-10,-10,-10
	dcb -10,-10,-10,-10
	END	