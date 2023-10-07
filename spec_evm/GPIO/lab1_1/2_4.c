#include "MDR32F9Qx_port.h"// подключение заголовочного файла библиотеки

#include "MDR32F9Qx_rst_clk.h" // подключение заголовочного файла библиотеки


static PORT_InitTypeDef PortInit;

void Delay(int del){
	for(int i = 0; i < del; i++);
}

void LedPinConfig(void){
	PortInit.PORT_Pin = PORT_Pin_0;
	PortInit.PORT_OE = PORT_OE_OUT;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;
	PORT_Init(MDR_PORTB, &PortInit);
}


int main(void){
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB, ENABLE);
	LedPinConfig();
	int T = 1000;//ПЕриод
	int w = 100; //Длина импульса
	while(1){
		MDR_PORTB->RXTX |= 0x01;
		Delay(w);
		MDR_PORTB->RXTX &=~0x01;
		Delay(T-w);
	}
}
