#include "MDR32F9Qx_port.h" //подключение библиотеки работы с портами
#include "MDR32F9Qx_rst_clk.h" //подключение библиотеки контроллера тактовых сигналов
static PORT_InitTypeDef PortInit; //стуктура инициализации порта
static 	RST_CLK_FreqTypeDef freqStats;

void portSetUp(){
	PortInit.PORT_Pin = PORT_Pin_All;
	PortInit.PORT_OE = PORT_OE_OUT;
	PortInit.PORT_FUNC = PORT_FUNC_PORT;//порт в режиме стандартной функции
	PortInit.PORT_MODE = PORT_MODE_DIGITAL;//цифровой режим порта
	PortInit.PORT_SPEED = PORT_SPEED_SLOW;//скорость перехода сигнала от
	PORT_Init(MDR_PORTA, &PortInit);
}
void CPUCLKConfig(void) //настройка тактирования ЦПУ
{
	RST_CLK_CPUclkPrescaler(RST_CLK_CPUclkDIV8);
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
	
	
	//RST_CLK_CPUclkPrescaler(RST_CLK_CPUclkDIV4);
	//RST_CLK_CPUclkSelection(RST_CLK_CPUclkHSI);
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
	
	


	
	countToPortA(5);
	
	
	
	CPUCLKConfig(); //переключение тактового генератора

	countToPortA(5);
	
	uint32_t count = 0;
	while(1){
		
		PORT_Write(MDR_PORTA, count++);
		count = 0;
	}
	
}