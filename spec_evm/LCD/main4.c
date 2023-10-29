#include "MDR32F9Qx_port.h"			//?????????? ?????? ? ???????
#include "MDR32F9Qx_rst_clk.h"	//?????????? ?????? ? ??????? ????????????
#include "mlt_lcd.h"						//?????????? ?????? ? ????????
#include "math.h"
//????????? ????????????? ?????
PORT_InitTypeDef PortStruct;

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




void setPixel(uint8_t x, uint8_t y, uint8_t data){
	int chip;
	uint8_t chip = (x / 64) + 1;      // ?????????? ????? ???? ?? ?????? ?????????? x
  uint8_t page = y / 8;             // ?????????? ????? ???????? ?? ?????? ?????????? y
  uint8_t address = x % 64;         // ?????????? ????? (???????) ?? ?????? ?????????? x
	
	SetPage(chip,page);
	SetAdress(chip, adress);
	
	uint8_t mask = 1 << (y % 8);
	uint8_t cellData = ReadData(chip);
	if (data) {
        cellData |= mask;  // ????????? ???? ? 1
    } else {
        cellData &= ~mask;  // ????? ???? ? 0
    }

    // ?????????? ??????????? ???????? ??????? ? ??????
    WriteData(chip, cellData);
}

void LCDCoords(){
	uint16_t width = 128;
	uint16_t height = 64;
	for(int x = 0; x < width; x++{
		setPixel(x, height/2 -1, 1);
	}
	for(int y = 0; y < height; y++{
		setPixel(x, width/2 -1, 1);
	}
}

void LCDCoords(){
	for(int x = 0; x < width; x++{
		int y = -(30*sin(x*3.14/32)) + 31;
		
	}
}
int main (void)		//????? ????? ? ?????????	
{
	CPUinit();			//????????? ???????????? ??????????
	PCLKinit();			//???????? ???????? ????????
	LCDPins();			//????????????? ???????
	LCDStart();			//?????? LCD
	LCDCoords();
	LCDFunc();
	while(1)				//??????????? ????
		{
			
		}
}
