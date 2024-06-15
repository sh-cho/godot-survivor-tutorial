shader_type canvas_item;

uniform float progress: hint_range(0, 1);
uniform float diamondPixelSize = 10.0;
uniform bool fill_in = true;

float when_lt(float x, float y) {
	return max(sign(y - x), 0.0);
}

float when_gt(float x, float y) {
	return max(sign(x - y), 0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	
	float comparisonValue = xDistance + yDistance + UV.x + UV.y;
	float threshold = progress * 4.0;
	
	float directionFactor = float(fill_in);
	float result = mix(
		when_gt(comparisonValue, threshold),
		when_lt(comparisonValue, threshold),
		directionFactor
	);
	
	COLOR.a *= result;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
