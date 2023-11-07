#include "MDR32F9Qx_port.h"			//?????????? ?????? ? ???????
#include "MDR32F9Qx_rst_clk.h"	//?????????? ?????? ? ??????? ????????????
#include "mlt_lcd.h"						//?????????? ?????? ? ????????
#include "font.h"
#include "stdio.h"
#include "lcdstring.h"

uint8_t width = 16;
uint8_t height = 8;

struct ButtonStatus {
	int UP;
	int DOWN;
	int SELECT
};
static struct ButtonStatus pressedButtons = {0,0,0};

int selectedMenuItem = 0;

void Delay(uint32_t wait)
{
	for (int i=0;i<wait;i++);
}

//????????? ????????????? ?????
PORT_InitTypeDef PortStruct;
PORT_InitTypeDef PortInit;

void LCDPins (void) //????????? ????????????? ??????? ?? ??? ?????? ? LCD
{ //??? ????? ???????? ? ?????? PORT ? ????????? ???????
	//????? DB5:DB0 - PA5:PA0 ?? ????????? ???? ??? ???????? ? ????????
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1|PORT_Pin_2|PORT_Pin_3|PORT_Pin_4|PORT_Pin_5;
	PortStruct.PORT_OE = PORT_OE_IN;
	PortStruct.PORT_FUNC = PORT_FUNC_PORT;
	PortStruct.PORT_SPEED = PORT_SPEED_SLOW;
	PortStruct.PORT_MODE = PORT_MODE_DIGITAL;
	PORT_Init(MDR_PORTA,&PortStruct);
	//????? DB7:DB6 - PF3:PF2 ?? ????????? ???? ??? ???????? ? ????????
	PortStruct.PORT_Pin = PORT_Pin_2|PORT_Pin_3;
	PORT_Init(MDR_PORTF,&PortStruct);
	//????? E1 - PB7, E2 - PB8,RES - PB9, R/~W - PB10 ?????
	PortStruct.PORT_OE = PORT_OE_OUT;
	PortStruct.PORT_Pin = PORT_Pin_7|PORT_Pin_8|PORT_Pin_9|PORT_Pin_10;
	PORT_Init(MDR_PORTB,&PortStruct);
	//????? A0 - PC0, E - PC1 ?????
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1;
	PORT_Init(MDR_PORTC,&PortStruct);
}

void CPUinit (void)				//????????? ????????????? ???????? ????????? ?????????? ??? ??????????
{
	//????????? ???????? ???????????????? ??????????
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//?????? ?????????, ?????? ???? ?????, ?? ??????? ? ????????? ?????????
	while (RST_CLK_HSEstatus()!=SUCCESS);
	//????????? ?????? PLL
	RST_CLK_CPU_PLLcmd(ENABLE);
	// ????????? ??????? ?????????? ?????????? ? 10 ???
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul6);
	//?????? ????????? PLL, ???? ?????, ?? ??????? ? ????????? ????????? 
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);	
	//???????????? ?? ??????? ?????????????? PLL
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkPrescaler(RST_CLK_CPUclkDIV1);
	//???????????? ?? ???????? ?????? CPU_C3
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
}

void PCLKinit(void)														//????????? ???????????? ??????
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA,ENABLE);	//????????? ???????????? PORTA
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB,ENABLE);	//????????? ???????????? PORTB
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC,ENABLE);	//????????? ???????????? PORTC
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTF,ENABLE);	//????????? ???????????? PORTF
}

void LCDStart(void)							//????????? ??????? ???????
{
	uint8_t status;								//?????????? ??? ??????? ????????? ????
	LcdInit(); //????????? ??????? ????????????, ???????? ?????????? ????????
	do 
	{
		status = ReadStatus(1);//?????? ????????? ??????? ????
	}while ((status&0x80)!=0x00); //???? ?? ????? ????? ????????? ?????????
	do
	{
				status = ReadStatus(2);//?????? ????????? ??????? ????
		}while((status&0x80)!=0x00); //???? ?? ????? ????? ????????? ?????????
	DispOn (1);										//????????? ???? 1
	DispOn (2);										//????????? ???? 2	
	LcdClearChip(1);							//??????? ???? 1
	LcdClearChip(2);							//??????? ???? 2
}

void PrintRight(char *x, int size, int strnum){
	char result[width];
	for(int i = width - size; i < width; i++){
		result[i] = x[i];
	}
	PrintString(result, strnum);
}



void ButtonsPinCfg(void){
	PORT_StructInit(&PortInit);
	PortInit.PORT_Pin = (PORT_Pin_5);
	
	PortInit.PORT_OE = PORT_OE_IN;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//???? ? ?????? ??????????? ???????
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//???????? ????? ?????
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//???????? ???????? ??????? ??
	PortInit.PORT_PULL_DOWN = PORT_PULL_DOWN_OFF;
	PortInit.PORT_PULL_UP = PORT_PULL_UP_ON;
	PortInit.PORT_GFEN = PORT_GFEN_ON;
	PORT_Init(MDR_PORTB, &PortInit);
	PortInit.PORT_Pin = (PORT_Pin_1);
	PORT_Init(MDR_PORTE, &PortInit);
}

int isUpPressed(){
	return PORT_ReadInputDataBit(MDR_PORTB, PORT_Pin_5);
}
int isDownPressed(){
	return PORT_ReadInputDataBit(MDR_PORTE, PORT_Pin_1);
}

void changeTask(){
	if(selectedMenuItem == 0){
		LcdPutChar(sym_sp,6,2);
		LcdPutChar(cursor,7,1);
	} else {
		LcdPutChar(sym_sp,6,1);
		LcdPutChar(cursor,7,2);
	}
}

void SetUpOutput(){
		PortStruct.PORT_Pin = PORT_Pin_5 | PORT_Pin_6;
	PortStruct.PORT_OE = PORT_OE_OUT;
	PortStruct.PORT_FUNC = PORT_FUNC_PORT;
	PortStruct.PORT_SPEED = PORT_SPEED_SLOW;
	PortStruct.PORT_MODE = PORT_MODE_DIGITAL;
	PORT_Init(MDR_PORTA,&PortStruct);
}

void pressUp(){
	selectedMenuItem = (selectedMenuItem + 1)%2;
	changeTask();
}	

void pressDown(){
	selectedMenuItem = (selectedMenuItem -1 + 2)%2;
	changeTask();
}	

void executeTask(){
	uint32_t pin;
	if(selectedMenuItem == 1)
		pin = PORT_Pin_6;
	else pin = PORT_Pin_7;
	uint8_t data = PORT_ReadInputDataBit(MDR_PORTA, pin);
	
	int str = 2 + selectedMenuItem;
	
	LcdPutChar (lat_L, 0,str);
	LcdPutChar (lat_D, 1,str);
	LcdPutChar (dig_1, 2,str);
	Delay(1000 * selectedMenuItem);
	PORT_WriteBit(MDR_PORTA, pin, data ^ 0x1);
	LcdPutChar (lat_D, 0,str);
	LcdPutChar (lat_N, 1,str);
	LcdPutChar (dig_1, 2,str);
}

int main (void)		//????? ????? ? ?????????
{
	CPUinit();			//????????? ???????????? ??????????
	PCLKinit();			//???????? ???????? ????????
	LCDPins();			//????????????? ???????
	LCDStart();			//?????? LCD
	LcdClearChip (1);
	LcdClearChip (2);
	ButtonsPinCfg();
	SetUpOutput();
	
	char stroka[11];
	sprintf(stroka, "$s %d","Brigada", 4);
	PrintRight(stroka,11,6);
	char fio1[11];
	sprintf(fio1, "$s","Vashkulatov");
	PrintRight(fio1,11,7);
	char fio2[6];
	sprintf(fio2, "$s","Anohin");
	PrintRight(fio2,6,8);

	char model[16];
	sprintf(model, "   %s   ", "MK1986BE92");
	PrintString(model,1);
	
	for(int i = 1; i <= 2; i++){
		LcdPutChar (cyr_Z, 0,i);
		LcdPutChar (cyr_a, 1,i);
		LcdPutChar (cyr_d, 2,i);
		LcdPutChar (cyr_a, 3,i);
		LcdPutChar (cyr_ch, 4,i);
		LcdPutChar (cyr_a, 5,i);
		LcdPutChar(sym_sp,6,i);
		if(i == 1) LcdPutChar(cursor,7,i);
	}

	
	while(1)				//??????????? ????
		{
			if(isDownPressed()){
			if(pressedButtons.DOWN == 0){
				pressDown();
				pressedButtons.DOWN = 1;
			}
		} else {
			pressedButtons.DOWN = 0;
		}	
		if(isUpPressed()){
			if(pressedButtons.UP == 0){
				pressUp();
				pressedButtons.UP = 1;
			}
		} else {
			pressedButtons.UP = 0;
		}	

		}
}