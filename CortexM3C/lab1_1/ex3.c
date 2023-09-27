#include "MDR32F9Qx_port.h"// подключение заголовочного файла библиотеки

#include "MDR32F9Qx_rst_clk.h" // подключение заголовочного файла библиотеки

static PORT_InitTypeDef PortInit; //объявление переменной типа структура

void portSetUp(){
	PortInit.PORT_Pin = PORT_Pin_All;
	PortInit.PORT_OE = PORT_OE_OUT;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PORT_Init(MDR_PORTA, &PortInit);
}

int main (void){
RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);
	portSetUp();
	uint32_t count = 0;
	while(1){
		PORT_Write(MDR_PORTA, count++);
	}
}
