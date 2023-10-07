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
int main (void)//
{
RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);//включить тактирование

LedPinCfg();//выполнение функции инициализации порта
//бесконечный цикл
PORT_SetBits(MDR_PORTC, PORT_Pin_0);//установить единицу в 0 бит порта C

}