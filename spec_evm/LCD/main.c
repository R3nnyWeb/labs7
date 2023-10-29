#include "MDR32F9Qx_port.h"			//библиотека работы с портами
#include "MDR32F9Qx_rst_clk.h"	//библиотека работы с модулем тактирования
#include "mlt_lcd.h"						//библиотека работы с дисплеем

//структура инициализации порта
PORT_InitTypeDef PortStruct;

void LCDPins (void) //процедура инициализации выводов МК для работы с LCD
{ //все линии цифровые в режиме PORT с медленным фронтом
	//линии DB5:DB0 - PA5:PA0 по умолчанию ввод без подтяжек и фильтров
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1|PORT_Pin_2|PORT_Pin_3|PORT_Pin_4|PORT_Pin_5;
	PortStruct.PORT_OE = PORT_OE_IN;
	PortStruct.PORT_FUNC = PORT_FUNC_PORT;
	PortStruct.PORT_SPEED = PORT_SPEED_SLOW;
	PortStruct.PORT_MODE = PORT_MODE_DIGITAL;
	PORT_Init(MDR_PORTA,&PortStruct);
	//линии DB7:DB6 - PF3:PF2 по умолчанию ввод без подтяжек и фильтров
	PortStruct.PORT_Pin = PORT_Pin_2|PORT_Pin_3;
	PORT_Init(MDR_PORTF,&PortStruct);
	//линии E1 - PB7, E2 - PB8,RES - PB9, R/~W - PB10 вывод
	PortStruct.PORT_OE = PORT_OE_OUT;
	PortStruct.PORT_Pin = PORT_Pin_7|PORT_Pin_8|PORT_Pin_9|PORT_Pin_10;
	PORT_Init(MDR_PORTB,&PortStruct);
	//Линии A0 - PC0, E - PC1 вывод
	PortStruct.PORT_Pin = PORT_Pin_0|PORT_Pin_1;
	PORT_Init(MDR_PORTC,&PortStruct);
}

void CPUinit (void)				//процедура инициализации внешнего тактового генератора для процессора
{
	//включение внешнего высокочастотного генератора
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	//запрос состояния, только если готов, то переход к следующим действиям
	while (RST_CLK_HSEstatus()!=SUCCESS);
	//включение модуля PLL
	RST_CLK_CPU_PLLcmd(ENABLE);
	// умножение частоты кварцевого генератора в 10 раз
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul6);
	//запрос состояния PLL, если готов, то переход к следующим действиям 
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);	
	//переключение на частоту сформированную PLL
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkPrescaler(RST_CLK_CPUclkDIV1);
	//переключение на тактовый сигнал CPU_C3
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
}

void PCLKinit(void)														//процедура тактирования портов
{
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA,ENABLE);	//включение тактирования PORTA
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB,ENABLE);	//включение тактирования PORTB
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC,ENABLE);	//включение тактирования PORTC
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTF,ENABLE);	//включение тактирования PORTF
}

void LCDStart(void)							//процедура запуска дисплея
{
	uint8_t status;								//переменная для анализа состояния чипа
	LcdInit(); //установка сигнала перезагрузки, ожидание завершения операции
	do 
	{
		status = ReadStatus(1);//чтение состояния первого чипа
	}while ((status&0x80)!=0x00); //пока не готов снова прочитать состояние
	do
	{
				status = ReadStatus(2);//чтение состояния второго чипа
		}while((status&0x80)!=0x00); //пока не готов снова прочитать состояние
	DispOn (1);										//включение чипа 1
	DispOn (2);										//включение чипа 2	
	LcdClearChip(1);							//очистка чипа 1
	LcdClearChip(2);							//очистка чипа 2
}


void LCDTestPrint(void)
{
	SetPage(1,2);					//установить 2 страницу 1-ого чипа
	SetAdress(1,9);				//установить адрес - 9, для 1-ого чипа, (2 страницы)
	WriteData (1,0x20);		//вывод на экран точки с положением 0x20 (по адресу 5), 2 страница, чип 1)
	SetPage(2,3);					//установить 3 страницу 2-ого чипа
	SetAdress(2,0);				//установить адрес - 0, для 2-ого чипа, (3 страницы)
	for (int i=0;i<7;i++)	//перебор комбинаций от 0 до 7
		{
			WriteData(2,i);		//вывод на экран точки с положением i, адрес увеличивается на 1 после выполнения каждой команды
		}
	SetPage(2,4);					//установить 4 страницу 2-ого чипа
	SetAdress(2,0);				//установить адрес - 0, для 2-ого чипа, (4 страницы)
	for (int i=0;i<63;i++)	//перебор комбинаций от 0 до 63
		{
			WriteData(2,i);		//вывод на экран точки с положением i, адрес увеличивается на 1 после выполнения каждой команды
		}
}

void setPixel(uint8_t x, uint8_t y, uint8_t data){
	int chip;
	uint8_t chip = (x / 64) + 1;      // Определяем номер чипа на основе координаты x
  uint8_t page = y / 8;             // Определяем номер страницы на основе координаты y
  uint8_t address = x % 64;         // Определяем адрес (колонку) на основе координаты x
	
	SetPage(chip,page);
	SetAdress(chip, adress);
	
	uint8_t mask = 1 << (y % 8);
	uint8_t cellData = ReadData(chip);
	if (data) {
        cellData |= mask;  // Установка бита в 1
    } else {
        cellData &= ~mask;  // Сброс бита в 0
    }

    // Записываем обновленное значение обратно в ячейку
    WriteData(chip, cellData);
}

int main (void)		//точка входа в программу	
{
	CPUinit();			//настройка тактирования процессора
	PCLKinit();			//включние тактовых сигналов
	LCDPins();			//инициализация выводов
	LCDStart();			//запуск LCD
	LCDTestPrint();	//вывод тестовых значений на экран
	while(1)				//бесконечный цикл
		{

		}
}
