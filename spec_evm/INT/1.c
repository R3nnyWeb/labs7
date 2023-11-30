#include "MDR32F9Qx_port.h"// подключение заголовочного файла библиотеки
#include "MDR32F9Qx_rst_clk.h" // подключение заголовочного файла библиотеки
#include "MDR32Fx.h"


static PORT_InitTypeDef LedInit; 
static PORT_InitTypeDef InputInit;

const int delay = 8000000;
const uint8_t LED_ZERO = PORT_Pin_0;
const uint8_t LED_ONE = PORT_Pin_1;



void Delay(int del) //процедура задржки del - кол-во циклов
{
for (int i=0; i<del; i++); //1 цикл – n тактов процессора
}
void LedConfig (void) //Процедура инициализации
{
	LedInit.PORT_Pin = (PORT_Pin_0 | PORT_Pin_1); //вывод 0
	LedInit.PORT_FUNC = PORT_FUNC_PORT; //режим порт
	LedInit.PORT_MODE = PORT_MODE_DIGITAL; //цифровой
	LedInit.PORT_OE = PORT_OE_OUT; //сигнал на вывод
	LedInit.PORT_SPEED = PORT_SPEED_SLOW; //медленный фронт
	PORT_Init(MDR_PORTC, &LedInit); //инициализация параметров
}

void InputConfig(){
	InputInit.PORT_Pin = PORT_Pin_0;
	InputInit.PORT_FUNC = PORT_FUNC_ALTER;
	InputInit.PORT_OE = PORT_OE_IN;
	InputInit.PORT_SPEED = PORT_SPEED_FAST;
	InputInit.PORT_PULL_UP = PORT_PULL_UP_OFF;
	InputInit.PORT_PULL_DOWN = PORT_PULL_DOWN_ON;

	PORT_Init(MDR_PORTA, &InputInit);
}

void CPU_Config(){
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//запрос состояния, только если готов, то переход к следующим действиям
	while (RST_CLK_HSEstatus()!=SUCCESS);
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul6);
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
	NVIC_EnableIRQ(EXT_INT1_IRQn);
	__enable_irq();
}

void  EXT_INT1_IRQHandler(void){
	Delay(delay/5);
	changeLedStatus(LED_ZERO);
	Delay(delay/5);
	changeLedStatus(LED_ZERO);
	Delay(delay/5);
	changeLedStatus(LED_ZERO);
	Delay(delay/5);
	changeLedStatus(LED_ZERO);
		Delay(delay);
}

int main(){
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);//разрешение тактирования PORTC
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA, ENABLE);//разрешение тактирования PORTA
	
	CPU_Config();
	LedConfig();
	InputConfig();
	IntConfig();

	uint32_t count = 0;
	while(1){

		
		if(count == delay){
			changeLedStatus(LED_ONE);
			count = 0;
		}
		count++;
	}
	
}