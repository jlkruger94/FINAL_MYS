#include "xparameters.h"
#include "xgpio.h"
#include "fir_ip.h"
#include "xil_printf.h"
#include "sleep.h"

int main (void) 
{
    XGpio dip, push;
    int psb_check, dip_check;

    xil_printf("-- Inicio del programa --\r\n");

    // Inicializar perif�ricos GPIO
    XGpio_Initialize(&dip, XPAR_SWITCHES_DEVICE_ID);
    XGpio_SetDataDirection(&dip, 1, 0xFFFFFFFF);  // switches como entrada

    XGpio_Initialize(&push, XPAR_BUTTONS_DEVICE_ID);
    XGpio_SetDataDirection(&push, 1, 0xFFFFFFFF); // botones como entrada

    while (1)
    {
        psb_check = XGpio_DiscreteRead(&push, 1);
        dip_check = XGpio_DiscreteRead(&dip, 1);   // leo switches

        xil_printf("Botones: 0x%x | Switches (PASO NCO): 0x%x\r\n", psb_check, dip_check);

        unsigned int paso_w = (dip_check << 4) + psb_check;

        // Escribe el valor le�do al registro 0 del IP FIR (PASO_W)
        FIR_IP_mWriteReg(XPAR_FIR_IP_0_S00_AXI_BASEADDR, FIR_IP_S00_AXI_SLV_REG0_OFFSET, paso_w);

        sleep(1);
    }

    return 0;
}
