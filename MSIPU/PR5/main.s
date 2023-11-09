 ;PR_5
	area reset, data, readonly
	area stack, noinit, readwrite
	space 0x400
stack_top
	area program,code,readonly
	dcd stack_top
	dcd start
	entry
start
;	bl pp1
cykle ;bl pp5
	;bl pp3
	;b cykle
	bl pp4
	;bl pp5
	b cykle
pp1 ldr r0, =0x4002001c ;Выбираем базовый адрес MDR_RST_CLK->PER_CLOCK(Тактирование)
	ldr r1, =0x0aa40010 ;RST_CLK, BKP, PORTE, PORTC, PORTA, ADC
	str r1, [r0]
	ldr r0, =0x400a8000; Базовый адрес PORTA
	mov r1, #0xff ;Все 16 бит
	str r1, [r0,#0x04];OE (Выход)
	str r1, [r0,#0x0c];ANALOG(Цифра)
	movw r1, #0x5555 ;1 через 1 для параметров с более чем двумя вариантами
	str r1, [r0,#0x18];PD медленный
	ldr r1, =0x400c8000 ;PORTE
	mov r2, #0x01 ;pin0
	str r2, [r1, #0x04] ;oe выход pin0
	mov r2, #0x0a ;
	str r2, [r1, #0x0c];ANALOG pin1 and pin3 -digital
	mov r2, #0x44 
	str r2, [r1, #0x18]; pin1 and pin 3 slow
	ldr r2, =0x40090000;ЦАП
	mov r3, #0x08;
	str r3, [r2] ;ВКЛЫЧ DAC2
	bx lr
	
pp2 add r3, #1
	sub r4, #1
	ldr r5, [r1] ;Счит RXTX PORTE
	ands r6, r5, #0x02 ;считывание кнопки pin1
	streq r3, [r2,#0x08];если не нажата
	streq r3, [r0] ;
	strne r4, [r2,#0x08];если нажата
	strne r4, [r0]
	bx lr
pp3 ldr r7, =tab ;0x0800007C ;Адрес таблицы
	add r8, #0x02 ;Смещение для каждого нового
	and r8, #0x1f ;Чтобы не уйти за пределы таблицы 32 байта
	add r9, r7, r8 ;Адрес чтения
	ldrh r10, [r9] ;Чтение
	str r10, [r0] ;port A rxtx
	str r10, [r2,#0x08] ;DAC2 data ЦАП
	bx lr
pp4
	ldr r0, =0x4002001c ;Выбираем базовый адрес MDR_RST_CLK->PER_CLOCK(Тактирование)
	ldr r1, =0x200010 ;RST_CLK, PORTA
	str r1, [r0]
	ldr r0, =0x400a8000; Базовый адрес PORTA
	mov r1, #0xff ;Все 16 бит
	str r1, [r0,#0x04];OE (Выход)
	str r1, [r0,#0x0c];ANALOG(Цифра)
	movw r1, #0x5555 ;1 через 1 для параметров с более чем двумя вариантами
	str r1, [r0,#0x18];PD медленный
	mov r2, 0xfffffffc
m1  str r2, [r0] ;Запись в А
	cmps r3, #0 ;r3 - направление
	addeq r2, #1
	subne r2, #1
	cmps r2, #0
	eoreq r3, 0x01 ;Инвертация направления
	b m1
	bx lr
pp5 ldr r7, =tab2 ;0x0800007C ;Адрес таблицы
	add r8, #0x02 ;Смещение для каждого нового
	and r8, #0x1f ;Чтобы не уйти за пределы таблицы 32 байта
	add r9, r7, r8 ;Адрес чтения
	ldrh r10, [r9] ;Чтение
	str r10, [r0] ;port A rxtx
	str r10, [r2,#0x08] ;DAC2 data ЦАП
	bx lr ;период и точки те же самые
tab dcw 1000,1382,1708,1924
	dcw 2000,1924,1708,1382
	dcw 1000,618,292,76
	dcw 0,76,292,618
tab2 dcw 1000,1038,1146,1308
	dcw 1500,1691,1853,1961
	dcw 2000,1961,1853,1691
	dcw 1500,1308,1146,1038
	end