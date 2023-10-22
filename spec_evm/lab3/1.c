#include "MDR32F9Qx_port.h" //подключение библиотеки работы с портами
#include "MDR32F9Qx_rst_clk.h" //подключение библиотеки контроллера

static PORT_InitTypeDef PortInit; //стуктура инициализации порта
void Delay(int del) //процедура задржки del - кол-во циклов
{
for (int i=0; i<del; i++); //1 цикл – n тактов процессора
}
void LedConfig (void) //Процедура инициализации
{
PortInit.PORT_Pin = PORT_Pin_0; //вывод 0
PortInit.PORT_FUNC = PORT_FUNC_PORT; //режим порт
PortInit.PORT_MODE = PORT_MODE_DIGITAL; //цифровой
PortInit.PORT_OE = PORT_OE_OUT; //сигнал на вывод
PortInit.PORT_SPEED = PORT_SPEED_SLOW; //медленный фронт
PORT_Init(MDR_PORTC, &PortInit); //инициализация параметров
}
void CPUCLKConfig(void) //настройка тактирования ЦПУ
{
RST_CLK_HSEconfig(RST_CLK_HSE_ON); //включение внешнего
//высокочастотного генератора
while (RST_CLK_HSEstatus()!=SUCCESS); //запрос состояния,
RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv2,RST_CLK_CPU_PLLmul1);
//только если готов, то переход к следующим действиям
RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);//переключение на CPU_C3
}
int main (void) //основная процедура
{
RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);//разрешение тактирования PORTC
LedConfig(); //инициализация вывода светодиода
for(int i = 0; i < 5; i++){
Delay(1000000); //задержка
PORT_SetBits(MDR_PORTC, PORT_Pin_0); //включение светодиода
Delay(1000000); //задержка
PORT_ResetBits(MDR_PORTC, PORT_Pin_0); 
}

CPUCLKConfig(); //переключение тактового генератора

while(1) //бесконечный цикл
{
Delay(1000000); //задержка
PORT_SetBits(MDR_PORTC, PORT_Pin_0); //включение светодиода
Delay(1000000); //задержка
PORT_ResetBits(MDR_PORTC, PORT_Pin_0); //выключение светодиода
}
}