#include "MDR32F9Qx_port.h" //подключение библиотеки работы с портами
#include "MDR32F9Qx_rst_clk.h" //подключение библиотеки контроллера тактовых сигналов
static PORT_InitTypeDef PortInit; //стуктура инициализации порта
static 	RST_CLK_FreqTypeDef freqStats;
static uint32_t PLL = RST_CLK_CPU_PLLmul8;
static uint32_t DIV = RST_CLK_CPU_PLLsrcHSEdiv1;

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


void pressRight(){
	if(PLL < RST_CLK_CPU_PLLmul16)
		PLL++;
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
void countToPortA(int repeats){
	uint32_t count = 0;
	for(int i = 0; i < repeats; i++){ 
			while(count <= 255){  
				PORT_Write(MDR_PORTA, count++);
			}
			count = 0;
		}
}
	
int main (void) //основная процедура
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA, ENABLE);//разрешение тактирования PORTA	
	portSetUp(); //инициализация вывода 
	
	RST_CLK_GetClocksFreq(&freqStats);
	
	countToPortA(10);
		
	CPUCLKConfig(); //переключение тактового генератора
	
	RST_CLK_GetClocksFreq(&freqStats);

	countToPortA(10);
	
	uint32_t count = 0;
	while(1){
		
		PORT_Write(MDR_PORTA, count++);
		count = 0;
	}
	
}