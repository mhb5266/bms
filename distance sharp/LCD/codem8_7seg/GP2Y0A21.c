
#include "GP2Y0A21.h"
#include "math.h"

signed short ir_distance_calculate_cm(ir_distance_sensor sensor,
	unsigned short adc_value)
{
	if (adc_value + sensor.b <= 0)
	{
		return -1;
	}
 
	return 200-(sensor.a / (adc_value + sensor.b) - sensor.k);
}

float calculate_distance(unsigned short adc_value)
{
float x;
float y;
float ans;
x = adc_value; /* A/D data = Voltage V*/
y = -1.2027;
ans = pow(x, y); /* ans = x^(-1.2027) */
ans=200-(27.22 * ans);

return (ans);
}