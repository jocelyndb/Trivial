shader_type canvas_item;

uniform int spread = 4;

void vertex() {
	// Called for every vertex the material is visible on.
}

const vec4 buttonGreen = vec4(0, .706, .537, 1);

void fragment() {
	//COLOR = vec4(1,0.8,1,1);
	COLOR = buttonGreen;
	COLOR.rgb *= (sin(0.5*TIME + UV.x * 18.0 * PI) + 2.0 + (cos(0.25 * TIME + UV.y * 18.0 * PI))) / 3.0;
	COLOR *= 3.0;
	COLOR = round(COLOR);
	COLOR /= 3.0;
	COLOR.rgb *= sin(pow(abs(UV.x - 0.5), 4)* 1.0 * PI);
	COLOR.a = 1.0;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
