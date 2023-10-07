#include "MDR32F9Qx_port.h"// подключение заголовочного файла библиотеки

#include "MDR32F9Qx_rst_clk.h" // подключение заголовочного файла библиотеки

static PORT_InitTypeDef PortInit;


void LedPinCfg (void) //описание процедуры инициализации порта
{
//инициализация порта осуществляется через структуру типа PORT_InitTypeDef
PortInit.PORT_Pin = (PORT_Pin_0);//выбор вывода порта, в данном случае

PortInit.PORT_OE = PORT_OE_OUT;//порт для вывода информации
PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от

PORT_Init(MDR_PORTC, &PortInit);//инициализация порта
}

void ButtonsPinCfg(void){
	PORT_StructInit(&PortInit);
	PortInit.PORT_Pin = PORT_Pin_3;
	
	PortInit.PORT_OE = PORT_OE_IN;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PortInit.PORT_PULL_DOWN = PORT_PULL_DOWN_OFF;
	PortInit.PORT_PULL_UP = PORT_PULL_UP_ON;
	PortInit.PORT_GFEN = PORT_GFEN_ON;
	PORT_Init(MDR_PORTE, &PortInit);

}

int main (void)//
{
RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);//включить тактирование
RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTE, ENABLE);
LedPinCfg();//выполнение функции инициализации порта
ButtonsPinCfg();
int isOn = 0;
int isPressed = 0;
//бесконечный цикл
while(1){
	if(isOn == 1){
		PORT_SetBits(MDR_PORTC, PORT_Pin_0);
	} else {
		PORT_ResetBits(MDR_PORTC, PORT_Pin_0);
	}
	if(!PORT_ReadInputDataBit(MDR_PORTE, PORT_Pin_3)){
		if(isPressed == 0){
			isOn = !isOn;
			isPressed = 1;
		}
	} else {
		isPressed = 0;
	}
}


}