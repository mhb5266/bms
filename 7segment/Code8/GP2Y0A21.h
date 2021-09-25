

#ifndef GP2Y0A21_H
#define GP2Y0A21_H
//
// The structure of the parameters of the IR distance sensors
//
typedef const struct
{
	const signed short a;
	const signed short b;
	const signed short k;
}
ir_distance_sensor;

//
// The object of the parameters of GP2Y0A21YK sensor
// 

//
// Converting the values of the IR distance sensor to centimeters
// Returns -1, if the conversion did not succeed
//
signed short ir_distance_calculate_cm(ir_distance_sensor sensor,
	unsigned short adc_value);
float calculate_distance(unsigned short adc_value);
#endif  /* GP2Y0A21_H */
