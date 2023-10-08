#include "MDR32F9Qx_port.h" //подключение библиотеки работы с портами
#include "MDR32F9Qx_rst_clk.h" //подключение библиотеки контроллера тактовых сигналов
static PORT_InitTypeDef PortInit; //стуктура инициализации порта
static uint32_t PLL = RST_CLK_CPU_PLLmul8;
static uint32_t DIV = RST_CLK_CPU_PLLsrcHSEdiv1;

struct ButtonStatus {
	int UP =0;
	int DOWN = 0;
	int LEFT = 0;
	int RIGHT = 0;
}

static ButtonStatus pressedButtons;

void portSetUp(){
	PortInit.PORT_Pin = PORT_Pin_All;
	PortInit.PORT_OE = PORT_OE_OUT;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PORT_Init(MDR_PORTA, &PortInit);
}

void updatePLLConfig(void){
	RST_CLK_CPU_PLLconfig( DIV, PLL);
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);
}


void pressRight(void){
	if(PLL < RST_CLK_CPU_PLLmul16)
		PLL++;
	updatePLLConfig();
}

void pressLeft(void){
	if(PLL > RST_CLK_CPU_PLLmul1)
		PLL--;
	updatePLLConfig();
}

void pressUp(void){
	if(DIV < RST_CLK_CPU_PLLsrcHSEdiv2)
		DIV++;
	updatePLLConfig();
}

void pressDown(void){
	if(DIV > RST_CLK_CPU_PLLsrcHSIdiv1)
		DIV--;
	updatePLLConfig();
}





void CPUCLKConfig(void) //настройка тактирования ЦПУ
{
	RST_CLK_WarmDeInit();
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//запрос состояния, только если готов, то переход к следующим действиям
	while (RST_CLK_HSEstatus()!=SUCCESS);
	RST_CLK_CPU_PLLcmd(ENABLE);
	RST_CLK_CPU_PLLconfig(DIV, PLL);
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
	
}

void ButtonsPinCfg(void){
	PORT_StructInit(&PortInit);
	PortInit.PORT_Pin = (PORT_Pin_5 | PORT_Pin_6);
	
	PortInit.PORT_OE = PORT_OE_IN;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PortInit.PORT_PULL_DOWN = PORT_PULL_DOWN_OFF;
	PortInit.PORT_PULL_UP = PORT_PULL_UP_ON;
	PortInit.PORT_GFEN = PORT_GFEN_ON;
	PORT_Init(MDR_PORTB, &PortInit);
	PortInit.PORT_Pin = (PORT_Pin_1 | PORT_Pin_3);
	PORT_Init(MDR_PORTE, &PortInit);
}



int isLeftPressed(){
	return !PORT_ReadInputDataBit(MDR_PORTE, PORT_Pin_3)
}
int isRightPressed(){
	return !PORT_ReadInputDataBit(MDR_PORTB, PORT_Pin_6)
}
int isUpPressed(){
	return !PORT_ReadInputDataBit(MDR_PORTB, PORT_Pin_5)
}
int isDownPressed(){
	return !PORT_ReadInputDataBit(MDR_PORTE, PORT_Pin_1)
}
int main (void) //основная процедура
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA, ENABLE);//разрешение тактирования PORTA	
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB, ENABLE);
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTE, ENABLE);
	portSetUp(); //инициализация вывода 		
	CPUCLKConfig(); //переключение тактового генератора
	uint32_t count = 0;
	
	while(1){
		PORT_Write(MDR_PORTA, count++);
		count = 0;
		
		if(isLeftPressed()){
			if(pressedButtons.LEFT == 0){
				pressLeft();
				pressedButtons.LEFT == 1;
			}
		} else {
			pressedButtons.LEFT == 0;
		}	
		if(isRightPressed()){
			if(pressedButtons.RIGHT == 0){
				pressRight();
				pressedButtons.RIGHT == 1;
			}
		} else {
			pressedButtons.RIGHT == 0;
		}	
		if(isDownPressed()){
			if(pressedButtons.DOWN == 0){
				pressDown();
				pressedButtons.DOWN == 1;
			}
		} else {
			pressedButtons.DOWN == 0;
		}	
		if(isUpPressed()){
			if(pressedButtons.UP == 0){
				pressUp();
				pressedButtons.UP == 1;
			}
		} else {
			pressedButtons.UP == 0;
		}	
		
	}
	
}
