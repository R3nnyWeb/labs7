#include "MDR32F9Qx_port.h"
#include "MDR32F9Qx_uart.h"
#include "MDR32F9Qx_rst_clk.h"

const uint8_t LED_ZERO = PORT_Pin_0;

void LedConfig (void) 
{
	PORT_InitTypeDef PortInit;
	PortInit.PORT_Pin = PORT_Pin_0; 
	PortInit.PORT_FUNC = PORT_FUNC_PORT; 
	PortInit.PORT_MODE = PORT_MODE_DIGITAL; 
	PortInit.PORT_OE = PORT_OE_OUT; 
	PortInit.PORT_SPEED = PORT_SPEED_SLOW; 
	PORT_Init(MDR_PORTC, &PortInit); 
}

void CLK_Config(){
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);
	while (RST_CLK_HSEstatus()!=SUCCESS);
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul8);
	RST_CLK_CPU_PLLcmd(ENABLE);
	
	while (RST_CLK_CPU_PLLstatus()!=SUCCESS);
	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
}

void IntConfig(){
	__enable_irq();
	NVIC_EnableIRQ(SysTick_IRQn);
	SysTick_Config(8000000);
}

void UART_Config(){
	UART_BRGInit(MDR_UART1, UART_HCLKdiv1);
	UART_InitTypeDef UConf;
	UConf.UART_BaudRate = 115200;
	UConf.UART_FIFOMode = UART_FIFO_ON;
	UConf.UART_StopBits = UART_StopBits1;
	UConf.UART_WordLength = UART_WordLength8b;
	UConf.UART_Parity = UART_Parity_No;
	UConf.UART_HardwareFlowControl = UART_HardwareFlowControl_TXE;
	UConf.UART_FIFOMode = UART_FIFO_OFF;
	UART_Init(MDR_UART1, &UConf);
	UART_Cmd(MDR_UART1, ENABLE);
	UART_ITConfig(MDR_UART1, UART_IT_RX, ENABLE);
	
	PORT_InitTypeDef PortInit;
	PortInit.PORT_Pin = (PORT_Pin_6 | PORT_Pin_7); //rx tx
	PortInit.PORT_FUNC = PORT_FUNC_OVERRID; 
	PortInit.PORT_MODE = PORT_MODE_DIGITAL; 
	PortInit.PORT_OE = PORT_OE_OUT; 
	PortInit.PORT_SPEED = PORT_SPEED_SLOW; 
	PORT_Init(MDR_PORTA, &PortInit); 
}

void changeLedStatus(uint8_t led){
	if(PORT_ReadInputDataBit(MDR_PORTC, led)){
		PORT_ResetBits(MDR_PORTC, led);
	} else {
		PORT_SetBits(MDR_PORTC, led);
	}
}

void SysTick_Handler(void){
	changeLedStatus(LED_ZERO);
	while (UART_GetFlagStatus(MDR_UART1, UART_FLAG_TXFE)==RESET);
	for(uint16_t i = 200; i < 280; i += 10){
			UART_SendData(MDR_UART1, 202); //11001010
	}

}

int main(){
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA, ENABLE);
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTC, ENABLE);
	RST_CLK_PCLKcmd(RST_CLK_PCLK_UART1, ENABLE);
	
	while(1){}
}