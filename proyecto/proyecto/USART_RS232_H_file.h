/*
 * USART_RS232_H_file.h
 * http://www.electronicwings.com
 *
 */ 


#include <avr/io.h>							/* Include AVR std. library file */
#include <math.h>

void USART_Init();				/* USART initialize function */
char USART_RxChar();						/* Data receiving function */
void USART_TxChar(char);					/* Data transmitting function */
void USART_SendString(char*);				/* Send string of USART data function */



void USART_Init(){
	UBRR0 = 103;
	UCSR0B = (1<<RXEN0) |(1<<RXCIE0)| (1<<TXEN0);
	UCSR0C = (1<<UCSZ01)| (1<<UCSZ00);
}

char USART_RxChar()									/* Data receiving function */
{
	while (!(UCSR0A & (1 << RXC0)));			/* Wait until new data receive */
	return(UDR0);									/* Get and return received data */
}

void USART_TxChar(char data)						/* Data transmitting function */
{
	UDR0 = data;										/* Write data to be transmitting in UDR */
	while (!(UCSR0A & (1<<UDRE0)));					/* Wait until data transmit and buffer get empty */
}

void USART_SendString(char *str)					/* Send string of USART data function */
{
	int i=0;
	while (str[i]!=0)
	{
		USART_TxChar(str[i]);						/* Send each char of string till the NULL */
		i++;
	}
}