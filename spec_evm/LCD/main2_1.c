#include "MDR32F9Qx_port.h"			//?????????? ?????? ? ???????
#include "MDR32F9Qx_rst_clk.h"	//?????????? ?????? ? ??????? ????????????
#include "mlt_lcd.h"						//?????????? ?????? ? ????????
#include "font.h"
#include "stdio.h"
#include "lcdstring.h"

uint8_t width = 16;
uint8_t height = 8;

void Delay(uint32_t wait)
{
	for (int i=0;i<wait;i++);
}

//структура инициализации порта
PORT_InitTypeDef PortStruct;

void LCDPins (void) //процедура инициализации выводов МК для работы с LCD
{ //все линии цифровые в режиме PORT с медленным фронтом
	//линии DB5:DB0 - PA5:PA0 по умолчанию ввод без подтяжек и фильтров
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1|PORT_Pin_2|PORT_Pin_3|PORT_Pin_4|PORT_Pin_5;
	PortStruct.PORT_OE = PORT_OE_IN;
	PortStruct.PORT_FUNC = PORT_FUNC_PORT;
	PortStruct.PORT_SPEED = PORT_SPEED_SLOW;
	PortStruct.PORT_MODE = PORT_MODE_DIGITAL;
	PORT_Init(MDR_PORTA,&PortStruct);
	//линии DB7:DB6 - PF3:PF2 по умолчанию ввод без подтяжек и фильтров
	PortStruct.PORT_Pin = PORT_Pin_2|PORT_Pin_3;
	PORT_Init(MDR_PORTF,&PortStruct);
	//линии E1 - PB7, E2 - PB8,RES - PB9, R/~W - PB10 вывод
	PortStruct.PORT_OE = PORT_OE_OUT;
	PortStruct.PORT_Pin = PORT_Pin_7|PORT_Pin_8|PORT_Pin_9|PORT_Pin_10;
	PORT_Init(MDR_PORTB,&PortStruct);
	//Линии A0 - PC0, E - PC1 вывод
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1;
	PORT_Init(MDR_PORTC,&PortStruct);
}

void CPUinit (void)				//процедура инициализации внешнего тактового генератора для процессора
{
	//включение внешнего высокочастотного генератора
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//запрос состояния, только если готов, то переход к следующим действиям
	while (RST_CLK_HSEstatus()!=SUCCESS);
	//включение модуля PLL
	RST_CLK_CPU_PLLcmd(ENABLE);
	// умножение частоты кварцевого генератора в 10 раз
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul6);
	//запрос состояния PLL, если готов, то переход к следующим действиям 
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);	
	//переключение на частоту сформированную PLL
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkPrescaler(RST_CLK_CPUclkDIV1);
	//переключение на тактовый сигнал CPU_C3
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
}

void PCLKinit(void)														//процедура тактирования портов
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA,ENABLE);	//включение тактирования PORTA
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB,ENABLE);	//включение тактирования PORTB
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC,ENABLE);	//включение тактирования PORTC
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTF,ENABLE);	//включение тактирования PORTF
}

void LCDStart(void)							//процедура запуска дисплея
{
	uint8_t status;								//переменная для анализа состояния чипа
	LcdInit(); //установка сигнала перезагрузки, ожидание завершения операции
	do 
	{
		status = ReadStatus(1);//чтение состояния первого чипа
	}while ((status&0x80)!=0x00); //пока не готов снова прочитать состояние
	do
	{
				status = ReadStatus(2);//чтение состояния второго чипа
		}while((status&0x80)!=0x00); //пока не готов снова прочитать состояние
	DispOn (1);										//включение чипа 1
	DispOn (2);										//включение чипа 2	
	LcdClearChip(1);							//очистка чипа 1
	LcdClearChip(2);							//очистка чипа 2
}

void PrintRight(char *x, int size, int strnum){
	char result[width];
	for(int i = width - size; i < width; i++){
		result[i] = x[i];
	}
	PrintString(result, strnum);
}
int main (void)		//точка входа в программу
{
	CPUinit();			//настройка тактирования процессора
	PCLKinit();			//включние тактовых сигналов
	LCDPins();			//инициализация выводов
	LCDStart();			//запуск LCD
	LcdClearChip (1);
	LcdClearChip (2);
	LcdPutImage(icon_mil,0,0,1,1);
	LcdPutChar (cyr_R, 11,0);
	LcdPutChar (cyr_G, 12,0);
	LcdPutChar (cyr_R, 13,0);
	LcdPutChar (cyr_T, 14,0);
	LcdPutChar (cyr_U, 15,0);
	uint8_t *group[3] = {{dig_0},{dig_4},{dig_5}};
	LcdScrollString (group, 2, 3, 8);
	
	char stroka[11];
	sprintf(stroka, "$s %d","Бригада", 4);
	PrintRight(stroka,11,7);

	
	

	
	while(1)				//бесконечный цикл
		{
		

		}
}
