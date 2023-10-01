#include "MDR32F9Qx_port.h"// подключение заголовочного файла библиотеки

#include "MDR32F9Qx_rst_clk.h" // подключение заголовочного файла библиотеки

static PORT_InitTypeDef PortInit;

void Delay(int del){
	for(int i = 0; i < del; i++);
}

void LedPinConfig(void){
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
	PortInit.PORT_Pin = PORT_Pin_2;
	
	PortInit.PORT_OE = PORT_OE_IN;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PortInit.PORT_PULL_DOWN = PORT_PULL_DOWN_OFF;
	PortInit.PORT_PULL_UP = PORT_PULL_UP_ON;
	PortInit.PORT_GFEN = PORT_GFEN_ON;
	PORT_Init(MDR_PORTC, &PortInit);
	PortInit.PORT_Pin = PORT_Pin_6;
	PORT_Init(MDR_PORTB, &PortInit);
}

int main (void)//
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);//включить тактирование
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB, ENABLE);
	LedPinConfig();
	ButtonsPinCfg();
	int isPressedSelect = 0;
	int isPressedRight = 0;
	int T = 100000;//ПЕриод
	int w = 10000; //Длина импульса
	int step = 3000; //Шаг изменения;
	int counter = 0;
	while(1){
		//MDR_PORTA->RXTX |= 0x01;
		//Delay(w);
		//MDR_PORTA->RXTX &=~0x01;
		//Delay(T-w);
		if(counter < w){
			MDR_PORTA->RXTX |= 0x01;
		} else {
			MDR_PORTA->RXTX &=~0x01;
		}
		if(counter == T) counter = 0;
		
		
		if(!PORT_ReadInputDataBit(MDR_PORTC, PORT_Pin_2)){
			if(isPressedSelect == 0){
				if(w <= (T - step)) w+=step;
				isPressedSelect = 1;
			}
		} else {
			isPressedSelect = 0;
		}
		
		if(!PORT_ReadInputDataBit(MDR_PORTB, PORT_Pin_6)){
			if(isPressedRight == 0){
				if(w >= step) w-=step;
				isPressedRight = 1;
			}
		} else {
			isPressedRight = 0;
		}
		counter++;
	}


}