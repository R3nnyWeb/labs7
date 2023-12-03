#include "MDR32F9Qx_port.h"// ??????????? ????????????? ????? ??????????
#include "MDR32F9Qx_rst_clk.h" // ??????????? ????????????? ????? ??????????
#include "MDR32Fx.h"
#include "MDR32F9Qx_bkp.h"
#include "time.h"
#include "lcdstring.h"
#include "mlt_lcd.h"
#include "font.h"
#include "stdio.h"

static PORT_InitTypeDef LedInit; 
static PORT_InitTypeDef InputInit;
//????????? ????????????? ?????
PORT_InitTypeDef PortStruct;

const int delay = 8000000;
const uint8_t LED_ZERO = PORT_Pin_0;
const uint8_t LED_ONE = PORT_Pin_1;

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

void setPixels(uint8_t x, uint8_t y, uint8_t data){
	uint8_t chip = (x / 64) + 1;      // ?????????? ????? ???? ?? ?????? ?????????? x
  uint8_t page = y / 8;             // ?????????? ????? ???????? ?? ?????? ?????????? y
  uint8_t address = x % 64;         // ?????????? ????? (???????) ?? ?????? ?????????? x
	
	SetPage(chip,page);
	SetAdress(chip, address);
	ReadData(chip);
	
	uint8_t mask = 1 << (y % 8);
	uint8_t cellData = ReadData(chip);
	if (data) {
        cellData |= mask;  // ????????? ???? ? 1
    } else {
        cellData &= ~mask;  // ????? ???? ? 0
    }
	SetPage(chip,page);
	SetAdress(chip, address);
    // ?????????? ??????????? ???????? ??????? ? ??????
    WriteData(chip, cellData);
}

void LedConfig (void) //????????? ?????????????
{
	LedInit.PORT_Pin = (PORT_Pin_0 | PORT_Pin_1); //????? 0
	LedInit.PORT_FUNC = PORT_FUNC_PORT; //????? ????
	LedInit.PORT_MODE = PORT_MODE_DIGITAL; //????????
	LedInit.PORT_OE = PORT_OE_OUT; //?????? ?? ?????
	LedInit.PORT_SPEED = PORT_SPEED_SLOW; //????????? ?????
	PORT_Init(MDR_PORTC, &LedInit); //????????????? ??????????
}

void TimeConfig(void){
	RST_CLK_PCLKcmd (RST_CLK_PCLK_BKP,ENABLE);
	PORT_InitTypeDef Port_struct;
	Port_struct.PORT_Pin = PORT_Pin_6;
	Port_struct.PORT_OE = PORT_OE_IN;
	Port_struct.PORT_MODE= PORT_MODE_ANALOG;
	PORT_Init(MDR_PORTE, &Port_struct);
	RST_CLK_LSEconfig(RST_CLK_LSE_ON);
	while (RST_CLK_LSEstatus()!=SUCCESS);
	BKP_RTC_WaitForUpdate();
	BKP_RTCclkSource(BKP_RTC_LSIclk);
	BKP_RTC_WaitForUpdate();
	BKP_RTC_SetPrescaler(32768);
	BKP_RTC_WaitForUpdate();
	BKP_RTC_Enable(ENABLE);
	
	BKP_RTC_SetAlarm(uint32_t AlarmValue);
	
	BKP_RTC_ITConfig(BKP_RTC_IT_ALRF, ENABLE);
}

void CPU_Config(){
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//?????? ?????????, ?????? ???? ?????, ?? ??????? ? ????????? ?????????
	while (RST_CLK_HSEstatus()!=SUCCESS);
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul1);
	RST_CLK_CPU_PLLcmd(ENABLE);
	
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
}

void changeLedStatus(uint8_t led){
	if(PORT_ReadInputDataBit(MDR_PORTC, led)){
		PORT_ResetBits(MDR_PORTC, led);
	} else {
		PORT_SetBits(MDR_PORTC, led);
	}
}

void IntConfig(){
	NVIC_EnableIRQ(SysTick_IRQn);
	SysTick_Config(8000000);
	__enable_irq();
}

void  SysTick_Handler(void){
	struct tm *tmstrct;
	time_t time;
	char stroka[16];
	MDR_PORTC->RXTX^=0x2;
	time  = BKP_RTC_GetCounter();
	tmstrct = localtime(&time);
	//output string
	strftime(stroka,16,"%H,%M,%S",tmstrct);
	PrintString(stroka,7);
}

int main(){
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA,ENABLE);	//????????? ???????????? PORTA
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB,ENABLE);	//????????? ???????????? PORTB
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC,ENABLE);	//????????? ???????????? PORTC
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTF,ENABLE);	//????????? ???????????? PORTF

	
	CPU_Config();
	LedConfig();
	LCDPins();			//????????????? ???????
	LCDStart();
	TimeConfig();
	IntConfig();
	
	uint8_t *brigada[9] = {{cyr_B},{cyr_r} ,{cyr_i},{cyr_g}, {cyr_a},{cyr_d},{cyr_a},{sym_sp}, {dig_4}};
	LcdScrollString (brigada, 0, 9, 8);

	uint32_t count = 0;
	while(1){

	}
	
}